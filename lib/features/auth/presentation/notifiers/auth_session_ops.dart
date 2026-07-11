import '../../../../core/auth/domain/auth_entities.dart';
import '../../../../core/auth/leo_roles.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/storage/onboarding_completion_storage.dart';
import '../../../../core/storage/token_storage.dart';
import '../../l10n/auth_strings.dart';
import '../state/auth_state.dart';
import 'auth_flow_host.dart';

/// Session restore, logout, onboarding completion, and session application.
class AuthSessionOps {
  AuthSessionOps(this._host);

  final AuthFlowHost _host;

  Future<void> restoreSession() async {
    final op = _host.bumpOp();
    _host.state = const AuthState.loading(reason: AuthLoadingReason.session);
    try {
      final refresh = await _host.ref
          .read(tokenStorageProvider)
          .readRefreshToken();
      if (_host.isStaleOp(op)) return;
      if (refresh == null || refresh.isEmpty) {
        _host.state = const AuthState.unauthenticated();
        return;
      }
      final session = await _host.repo.refreshSession(refreshToken: refresh);
      if (_host.isStaleOp(op)) return;
      await applySession(session);
    } catch (_) {
      if (_host.isStaleOp(op)) return;
      await _host.ref.read(tokenStorageProvider).clear();
      _host.ref.read(currentAccessTokenProvider.notifier).state = null;
      _host.state = const AuthState.unauthenticated();
    }
  }

  Future<void> logout() async {
    final refresh = await _host.ref
        .read(tokenStorageProvider)
        .readRefreshToken();
    if (refresh != null) {
      try {
        await _host.repo.logout(refreshToken: refresh);
      } catch (_) {}
    }
    _host.ref.read(currentAccessTokenProvider.notifier).state = null;
    await _host.ref.read(tokenStorageProvider).clear();
    _host.state = const AuthState.unauthenticated();
  }

  Future<void> completeOnboarding() async {
    final current = _host.state;
    if (current is! AuthAuthenticated) return;

    final token = _host.ref.read(currentAccessTokenProvider);
    final sub = token != null
        ? Claims.decodeAccessToken(token)?.sub ?? current.role
        : current.role;
    await _host.ref.read(onboardingCompletionStorageProvider).markComplete(sub);
    _host.state = current.copyWith(onboardingRequired: false);
  }

  Future<void> applySession(AuthSession session) async {
    if (session.claims.role == LeoRoles.platformAdmin) {
      _host.ref.read(currentAccessTokenProvider.notifier).state = null;
      await _host.ref.read(tokenStorageProvider).clear();
      _host.state = AuthState.error(message: AuthStrings.platformAdminUseWeb);
      return;
    }

    _host.ref.read(currentAccessTokenProvider.notifier).state =
        session.accessToken;
    await _host.ref
        .read(tokenStorageProvider)
        .saveRefreshToken(session.refreshToken);
    final locallyComplete = await _host.ref
        .read(onboardingCompletionStorageProvider)
        .isComplete(session.claims.sub);
    final onboardingRequired =
        session.claims.onboardingRequired && !locallyComplete;
    _host.state = AuthState.authenticated(
      role: session.claims.role,
      tenantId: session.claims.tenantId,
      onboardingRequired: onboardingRequired,
    );
  }
}
