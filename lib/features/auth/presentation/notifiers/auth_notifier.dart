import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/data/auth_repository.dart';
import '../../../../core/auth/domain/auth_entities.dart';
import '../../../../core/auth/domain/email_verification.dart';
import '../../../../core/auth/leo_roles.dart';
import '../../../../core/network/api_error.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/storage/onboarding_completion_storage.dart';
import '../../../../core/storage/token_storage.dart';
import '../../l10n/auth_strings.dart';
import '../state/auth_state.dart';

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  var _opGeneration = 0;

  @override
  AuthState build() {
    Future.microtask(restoreSession);
    return const AuthState.loading();
  }

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  bool _isStaleOp(int op) => op != _opGeneration;

  String? _pendingEmail;
  String? _pendingPassword;

  void _clearPendingCredentials() {
    _pendingEmail = null;
    _pendingPassword = null;
  }

  void setEmailVerificationPending(VerifyEmailPendingContext context) {
    state = AuthState.unauthenticated(emailVerificationPending: context);
  }

  void clearEmailVerificationPending() {
    final current = state;
    if (current is AuthUnauthenticated &&
        current.emailVerificationPending != null) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> restoreSession() async {
    final op = ++_opGeneration;
    state = const AuthState.loading(reason: AuthLoadingReason.session);
    try {
      final refresh = await ref.read(tokenStorageProvider).readRefreshToken();
      if (_isStaleOp(op)) return;
      if (refresh == null || refresh.isEmpty) {
        state = const AuthState.unauthenticated();
        return;
      }
      final session = await _repo.refreshSession(refreshToken: refresh);
      if (_isStaleOp(op)) return;
      await _applySession(session);
    } catch (_) {
      if (_isStaleOp(op)) return;
      await ref.read(tokenStorageProvider).clear();
      ref.read(currentAccessTokenProvider.notifier).state = null;
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final op = ++_opGeneration;
    state = const AuthState.loading(reason: AuthLoadingReason.login);
    try {
      final result = await _repo.login(email: email, password: password);
      if (_isStaleOp(op)) return;
      await _handleLoginResult(result, email: email, password: password);
    } catch (e) {
      if (_isStaleOp(op)) return;
      _clearPendingCredentials();
      if (e is DioException && isEmailNotVerified(e)) {
        state = AuthState.unauthenticated(
          emailVerificationPending: VerifyEmailPendingContext(
            email: email,
            source: VerifyEmailSource.login,
          ),
        );
        return;
      }
      state = AuthState.error(message: mapUserFacingError(e));
    }
  }

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
      state = AuthState.error(message: mapUserFacingError(e));
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

  Future<void> applyLoginResult(
    LoginResult result, {
    String email = '',
    bool fromEmailVerify = false,
  }) async {
    final op = ++_opGeneration;
    state = const AuthState.loading(reason: AuthLoadingReason.login);
    if (_isStaleOp(op)) return;

    if (fromEmailVerify && result is LoginMfaRequired && !result.firstLogin) {
      state = const AuthState.error(
        message:
            'Unexpected MFA state after verification. Please sign in again.',
      );
      return;
    }

    await _handleLoginResult(result, email: email, password: '');
    clearEmailVerificationPending();
  }

  Future<String?> verifyResetCode({
    required String email,
    required String code,
  }) async {
    state = const AuthState.loading(reason: AuthLoadingReason.passwordReset);
    try {
      final ticket = await _repo.verifyResetCode(email: email, code: code);
      state = const AuthState.unauthenticated();
      return ticket.resetTicket;
    } catch (e) {
      state = AuthState.error(
        message: mapUserFacingError(
          e,
          fallback: 'Invalid or expired reset code. Request a new one.',
        ),
      );
      return null;
    }
  }

  Future<bool> resetPassword({
    required String resetTicket,
    required String password,
  }) async {
    state = const AuthState.loading(reason: AuthLoadingReason.passwordReset);
    try {
      await _repo.resetPassword(resetTicket: resetTicket, password: password);
      state = const AuthState.unauthenticated();
      return true;
    } catch (e) {
      state = AuthState.error(
        message: mapUserFacingError(
          e,
          fallback: 'Invalid or expired reset session. Request a new code.',
        ),
      );
      return false;
    }
  }

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
      state = AuthState.error(message: mapUserFacingError(e));
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
      } catch (_) {}
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
        _pendingPassword = password.isEmpty ? null : password;
        state = AuthState.mfaRequired(
          firstLogin: firstLogin,
          enrollmentToken: enrollmentToken,
          otpauthUrl: otpauthUrl,
          secret: secret,
        );
    }
  }

  Future<void> _applySession(AuthSession session) async {
    if (session.claims.role == LeoRoles.platformAdmin) {
      ref.read(currentAccessTokenProvider.notifier).state = null;
      await ref.read(tokenStorageProvider).clear();
      state = AuthState.error(message: AuthStrings.platformAdminUseWeb);
      return;
    }

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
}
