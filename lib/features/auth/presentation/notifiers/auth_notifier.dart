import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/leo_roles.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/storage/onboarding_completion_storage.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../onboarding/data/mock_onboarding_store.dart';
import '../../data/auth_repository.dart';
import '../../domain/auth_models.dart';
import '../state/auth_state.dart';

final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

/// Auth ViewModel (P1-T-03): sole writer of [currentAccessTokenProvider].
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    Future.microtask(restoreSession);
    return const AuthState.loading();
  }

  AuthRepository get _repo => ref.read(authRepositoryProvider);

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
      await _handleLoginResult(result);
    } catch (e) {
      state = AuthState.error(message: _mapError(e));
    }
  }

  Future<void> submitMfa({required String code}) async {
    final current = state;
    if (current is! AuthMfaRequired) return;

    state = const AuthState.loading(reason: AuthLoadingReason.mfa);
    try {
      final session = await _repo.submitMfa(
        mfaToken: current.mfaToken,
        code: code,
      );
      await _applySession(session);
    } catch (e) {
      state = AuthState.error(message: _mapError(e));
    }
  }

  Future<void> selectMembership(Membership membership) async {
    state = const AuthState.loading(reason: AuthLoadingReason.login);
    try {
      if (roleRequiresMfa(membership.role)) {
        state = const AuthState.mfaRequired(
          firstLogin: false,
          mfaToken: 'mock-membership-mfa',
        );
        return;
      }
      final session = await _repo.selectMembership(
        tenantId: membership.tenantId,
        role: membership.role,
      );
      await _applySession(session);
    } catch (e) {
      state = AuthState.error(message: _mapError(e));
    }
  }

  Future<void> switchTenant({
    required String tenantId,
    String? mfaCode,
  }) async {
    final current = state;
    if (current is! AuthAuthenticated) return;

    state = current.copyWith(
      switchingTenant: true,
      expandedPrivilegedTenantId: null,
    );
    try {
      final result = await _repo.switchTenant(
        tenantId: tenantId,
        mfaToken: mfaCode,
      );
      await _handleLoginResult(result);
      final after = state;
      if (after is AuthAuthenticated) {
        state = after.copyWith(switchingTenant: false);
      }
    } catch (e) {
      final after = state;
      if (after is AuthAuthenticated) {
        state = after.copyWith(switchingTenant: false);
      }
      state = AuthState.error(message: _mapError(e));
    }
  }

  Future<void> loadMemberships() async {
    final current = state;
    if (current is! AuthAuthenticated) return;
    if (current.membershipsLoading) return;

    state = current.copyWith(membershipsLoading: true);
    try {
      final list = await _repo.listMemberships();
      final after = state;
      if (after is AuthAuthenticated) {
        state = after.copyWith(memberships: list, membershipsLoading: false);
      }
    } catch (_) {
      final after = state;
      if (after is AuthAuthenticated) {
        state = after.copyWith(membershipsLoading: false);
      }
    }
  }

  void setExpandedPrivilegedTenant(String? tenantId) {
    final current = state;
    if (current is! AuthAuthenticated) return;

    final expanded = current.expandedPrivilegedTenantId;
    state = current.copyWith(
      expandedPrivilegedTenantId: expanded == tenantId ? null : tenantId,
    );
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

  Future<void> acceptInvite({
    required String token,
    required String password,
  }) async {
    state = const AuthState.loading(reason: AuthLoadingReason.inviteAccept);
    try {
      final session = await _repo.acceptInvite(
        token: token,
        password: password,
      );
      await _applySession(session);
    } catch (e) {
      state = AuthState.error(message: _mapError(e));
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
    MockOnboardingStore.instance.markOnboardingCompleteBySub(sub);
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

  Future<void> _handleLoginResult(LoginResult result) async {
    switch (result) {
      case LoginSession(:final session):
        await _applySession(session);
      case LoginMfaRequired(:final firstLogin, :final mfaToken):
        state = AuthState.mfaRequired(
          firstLogin: firstLogin,
          mfaToken: mfaToken,
        );
      case LoginPickMembership(:final memberships):
        state = AuthState.pickMembership(memberships);
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
