import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/leo_roles.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/storage/token_storage.dart';
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
    state = const AuthState.loading();
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
    state = const AuthState.loading();
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

    state = const AuthState.loading();
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
    state = const AuthState.loading();
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
    state = const AuthState.loading();
    try {
      final result = await _repo.switchTenant(
        tenantId: tenantId,
        mfaToken: mfaCode,
      );
      await _handleLoginResult(result);
    } catch (e) {
      state = AuthState.error(message: _mapError(e));
    }
  }

  Future<void> forgotPassword({required String email}) async {
    await _repo.forgotPassword(email: email);
  }

  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final session = await _repo.resetPassword(
        token: token,
        password: password,
      );
      await _applySession(session);
    } catch (e) {
      state = AuthState.error(message: _mapError(e));
    }
  }

  Future<void> acceptInvite({
    required String token,
    required String password,
  }) async {
    state = const AuthState.loading();
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
    state = AuthState.authenticated(
      role: session.claims.role,
      tenantId: session.claims.tenantId,
      onboardingRequired: session.claims.onboardingRequired,
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
}
