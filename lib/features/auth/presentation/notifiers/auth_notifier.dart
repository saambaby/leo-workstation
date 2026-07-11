import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/domain/auth_entities.dart';
import '../../../../core/auth/domain/email_verification.dart';
import '../state/auth_state.dart';
import '../state/auth_ui_state.dart';
import 'auth_flow_host.dart';
import 'auth_invite_ops.dart';
import 'auth_login_ops.dart';
import 'auth_password_reset_ops.dart';
import 'auth_session_ops.dart';

export '../state/auth_ui_state.dart';

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

/// Derived UI helpers from [AuthState] — screens watch this instead of
/// pattern-matching loading/error on every build.
final authUiProvider = Provider<AuthUiState>((ref) {
  final auth = ref.watch(authNotifierProvider);
  return AuthUiState.from(auth);
});

/// Thin coordinator over session / login / password-reset / invite flow modules.
/// Sole owner of [AuthState] for the router contract (INV-CLIENT-STATE-2).
class AuthNotifier extends Notifier<AuthState> {
  AuthFlowHost? _host;
  AuthSessionOps? _session;
  AuthLoginOps? _login;
  AuthPasswordResetOps? _passwordReset;
  AuthInviteOps? _invite;

  AuthFlowHost get _h => _host ??= AuthFlowHost(
    ref: ref,
    readState: () => state,
    writeState: (s) => state = s,
  );

  AuthSessionOps get _sessionOps => _session ??= AuthSessionOps(_h);
  AuthLoginOps get _loginOps =>
      _login ??= AuthLoginOps(_h, session: _sessionOps);
  AuthPasswordResetOps get _passwordResetOps =>
      _passwordReset ??= AuthPasswordResetOps(_h);
  AuthInviteOps get _inviteOps => _invite ??= AuthInviteOps(_h);

  @override
  AuthState build() {
    Future.microtask(restoreSession);
    return const AuthState.loading();
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

  Future<void> restoreSession() => _sessionOps.restoreSession();

  Future<void> logout() => _sessionOps.logout();

  Future<void> completeOnboarding() => _sessionOps.completeOnboarding();

  Future<void> login({
    required String email,
    required String password,
  }) => _loginOps.login(email: email, password: password);

  Future<void> submitMfa({required String code}) =>
      _loginOps.submitMfa(code: code);

  Future<void> applyLoginResult(
    LoginResult result, {
    String email = '',
    bool fromEmailVerify = false,
  }) async {
    await _loginOps.applyLoginResult(
      result,
      email: email,
      fromEmailVerify: fromEmailVerify,
    );
    clearEmailVerificationPending();
  }

  Future<bool> forgotPassword({required String email}) =>
      _passwordResetOps.forgotPassword(email: email);

  Future<bool> resendResetCode({required String email}) =>
      _passwordResetOps.resendResetCode(email: email);

  Future<String?> verifyResetCode({
    required String email,
    required String code,
  }) => _passwordResetOps.verifyResetCode(email: email, code: code);

  Future<bool> resetPassword({
    required String resetTicket,
    required String password,
  }) => _passwordResetOps.resetPassword(
    resetTicket: resetTicket,
    password: password,
  );

  Future<bool> acceptInvite({
    required String token,
    required String password,
    required bool tos,
    required bool privacy,
    required bool baaAck,
  }) => _inviteOps.acceptInvite(
    token: token,
    password: password,
    tos: tos,
    privacy: privacy,
    baaAck: baaAck,
  );
}
