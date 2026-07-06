import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_provider.dart';
import '../../../../core/storage/onboarding_completion_storage.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/auth_repository.dart';
import '../../domain/auth_entities.dart';
import '../state/auth_state.dart';

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

/// Auth ViewModel (P1-T-03): sole writer of [currentAccessTokenProvider].
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    Future.microtask(restoreSession);
    return const AuthState.loading();
  }

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  /// Held only across the MFA round-trip (login → enroll/required → resubmit
  /// with a TOTP code) — the real backend has no separate verify token, so
  /// the original credentials must be resent. Never persisted or logged;
  /// cleared as soon as the round-trip resolves either way.
  String? _pendingEmail;
  String? _pendingPassword;

  void _clearPendingCredentials() {
    _pendingEmail = null;
    _pendingPassword = null;
  }

  /// Cold-start: restore from secure storage or route to unauthenticated.
  Future<void> restoreSession() async {
    state = const AuthState.loading(reason: AuthLoadingReason.session);
    try {
      final refresh = await ref.read(tokenStorageProvider).readRefreshToken();
      if (refresh == null || refresh.isEmpty) {
        state = const AuthState.unauthenticated();
        return;
      }
      final session = await _repo.refreshSession(refreshToken: refresh);
      await _applySession(session);
    } catch (_) {
      await ref.read(tokenStorageProvider).clear();
      ref.read(currentAccessTokenProvider.notifier).state = null;
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AuthState.loading(reason: AuthLoadingReason.login);
    try {
      final result = await _repo.login(email: email, password: password);
      await _handleLoginResult(result, email: email, password: password);
    } catch (e) {
      _clearPendingCredentials();
      state = AuthState.error(message: _mapError(e));
    }
  }

  /// First-time enrollment verifies via `/auth/mfa/enroll` (the enrollment
  /// token, not the credentials). An already-enrolled challenge has no
  /// separate verify endpoint — it resubmits the held credentials plus
  /// [code] to `login` instead.
  Future<void> submitMfa({required String code}) async {
    final current = state;
    if (current is! AuthMfaRequired) return;

    state = const AuthState.loading(reason: AuthLoadingReason.mfa);
    try {
      if (current.firstLogin) {
        final session = await _repo.completeMfaEnrollment(
          enrollmentToken: current.enrollmentToken!,
          totpCode: code,
        );
        _clearPendingCredentials();
        await _applySession(session);
        return;
      }

      final email = _pendingEmail;
      final password = _pendingPassword;
      if (email == null || password == null) {
        state = const AuthState.error(
          message: 'Session expired. Please log in again.',
        );
        return;
      }
      final result = await _repo.login(
        email: email,
        password: password,
        totpCode: code,
      );
      await _handleLoginResult(result, email: email, password: password);
    } catch (e) {
      _clearPendingCredentials();
      state = AuthState.error(message: _mapError(e));
    }
  }

  Future<void> forgotPassword({required String email}) async {
    state = const AuthState.unauthenticated(forgotPasswordSending: true);
    try {
      await _repo.forgotPassword(email: email);
    } finally {
      state = const AuthState.unauthenticated(forgotPasswordSending: false);
    }
  }

  Future<void> resendResetCode({required String email}) async {
    state = const AuthState.unauthenticated(resendCodeSending: true);
    try {
      await _repo.forgotPassword(email: email);
    } finally {
      state = const AuthState.unauthenticated(resendCodeSending: false);
    }
  }

  Future<bool> resetPassword({
    required String token,
    required String password,
  }) async {
    state = const AuthState.loading(reason: AuthLoadingReason.passwordReset);
    try {
      await _repo.resetPassword(token: token, password: password);
      state = const AuthState.unauthenticated();
      return true;
    } catch (e) {
      state = AuthState.error(message: _mapResetError(e));
      return false;
    }
  }

  /// Creates the membership but does not mint tokens (real-backend
  /// contract) — on success the caller logs in normally. Returns whether it
  /// succeeded so the screen can navigate to `/login`.
  Future<bool> acceptInvite({
    required String token,
    required String password,
    required bool tos,
    required bool privacy,
    required bool baaAck,
  }) async {
    state = const AuthState.loading(reason: AuthLoadingReason.inviteAccept);
    try {
      await _repo.acceptInvite(
        token: token,
        password: password,
        tos: tos,
        privacy: privacy,
        baaAck: baaAck,
      );
      state = const AuthState.unauthenticated();
      return true;
    } catch (e) {
      state = AuthState.error(message: _mapError(e));
      return false;
    }
  }

  Future<void> completeOnboarding() async {
    final current = state;
    if (current is! AuthAuthenticated) return;

    final token = ref.read(currentAccessTokenProvider);
    final sub = token != null
        ? Claims.decodeAccessToken(token)?.sub ?? current.role
        : current.role;
    await ref.read(onboardingCompletionStorageProvider).markComplete(sub);
    state = current.copyWith(onboardingRequired: false);
  }

  Future<void> logout() async {
    final refresh = await ref.read(tokenStorageProvider).readRefreshToken();
    if (refresh != null) {
      try {
        await _repo.logout(refreshToken: refresh);
      } catch (_) {
        // Best-effort server logout; always clear local state.
      }
    }
    ref.read(currentAccessTokenProvider.notifier).state = null;
    await ref.read(tokenStorageProvider).clear();
    state = const AuthState.unauthenticated();
  }

  Future<void> _handleLoginResult(
    LoginResult result, {
    required String email,
    required String password,
  }) async {
    switch (result) {
      case LoginSession(:final session):
        _clearPendingCredentials();
        await _applySession(session);
      case LoginMfaRequired(
        :final firstLogin,
        :final enrollmentToken,
        :final otpauthUrl,
        :final secret,
      ):
        _pendingEmail = email;
        _pendingPassword = password;
        state = AuthState.mfaRequired(
          firstLogin: firstLogin,
          enrollmentToken: enrollmentToken,
          otpauthUrl: otpauthUrl,
          secret: secret,
        );
    }
  }

  Future<void> _applySession(AuthSession session) async {
    ref.read(currentAccessTokenProvider.notifier).state = session.accessToken;
    await ref.read(tokenStorageProvider).saveRefreshToken(session.refreshToken);
    final locallyComplete = await ref
        .read(onboardingCompletionStorageProvider)
        .isComplete(session.claims.sub);
    final onboardingRequired =
        session.claims.onboardingRequired && !locallyComplete;
    state = AuthState.authenticated(
      role: session.claims.role,
      tenantId: session.claims.tenantId,
      onboardingRequired: onboardingRequired,
    );
  }

  String _mapError(Object error) {
    if (error is DioException) {
      final status = error.response?.statusCode;
      if (status == 401) return 'Invalid email or password';
      if (status == 404) return 'Workspace not found or no longer available';
    }
    return 'Something went wrong. Please try again.';
  }

  String _mapResetError(Object error) {
    if (error is DioException) {
      final status = error.response?.statusCode;
      if (status == 400 || status == 410) {
        return 'Invalid or expired reset code. Request a new one.';
      }
    }
    return 'Something went wrong. Please try again.';
  }
}
