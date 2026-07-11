import 'package:dio/dio.dart';

import '../../../../core/auth/domain/auth_entities.dart';
import '../../../../core/auth/domain/email_verification.dart';
import '../../../../core/network/api_error.dart';
import '../state/auth_state.dart';
import 'auth_flow_host.dart';
import 'auth_session_ops.dart';

/// Login, MFA challenge/enrollment, and email-verify login bridge.
class AuthLoginOps {
  AuthLoginOps(this._host, {required AuthSessionOps session})
    : _session = session;

  final AuthFlowHost _host;
  final AuthSessionOps _session;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final op = _host.bumpOp();
    _host.state = const AuthState.loading(reason: AuthLoadingReason.login);
    try {
      final result = await _host.repo.login(email: email, password: password);
      if (_host.isStaleOp(op)) return;
      await handleLoginResult(result, email: email, password: password);
    } catch (e) {
      if (_host.isStaleOp(op)) return;
      _host.clearPendingCredentials();
      if (e is DioException && isEmailNotVerified(e)) {
        _host.state = AuthState.unauthenticated(
          emailVerificationPending: VerifyEmailPendingContext(
            email: email,
            source: VerifyEmailSource.login,
          ),
        );
        return;
      }
      _host.state = AuthState.error(message: mapUserFacingError(e));
    }
  }

  Future<void> submitMfa({required String code}) async {
    final current = _host.state;
    if (current is! AuthMfaRequired) return;

    _host.state = const AuthState.loading(reason: AuthLoadingReason.mfa);
    try {
      if (current.firstLogin) {
        final session = await _host.repo.completeMfaEnrollment(
          enrollmentToken: current.enrollmentToken!,
          totpCode: code,
        );
        _host.clearPendingCredentials();
        await _session.applySession(session);
        return;
      }

      final email = _host.pendingEmail;
      final password = _host.pendingPassword;
      if (email == null || password == null) {
        _host.state = const AuthState.error(
          message: 'Session expired. Please log in again.',
        );
        return;
      }
      final result = await _host.repo.login(
        email: email,
        password: password,
        totpCode: code,
      );
      await handleLoginResult(result, email: email, password: password);
    } catch (e) {
      _host.clearPendingCredentials();
      _host.state = AuthState.error(message: mapUserFacingError(e));
    }
  }

  Future<void> applyLoginResult(
    LoginResult result, {
    String email = '',
    bool fromEmailVerify = false,
  }) async {
    final op = _host.bumpOp();
    _host.state = const AuthState.loading(reason: AuthLoadingReason.login);
    if (_host.isStaleOp(op)) return;

    if (fromEmailVerify && result is LoginMfaRequired && !result.firstLogin) {
      _host.state = const AuthState.error(
        message:
            'Unexpected MFA state after verification. Please sign in again.',
      );
      return;
    }

    await handleLoginResult(result, email: email, password: '');
  }

  Future<void> handleLoginResult(
    LoginResult result, {
    required String email,
    required String password,
  }) async {
    switch (result) {
      case LoginSession(:final session):
        _host.clearPendingCredentials();
        await _session.applySession(session);
      case LoginMfaRequired(
        :final firstLogin,
        :final enrollmentToken,
        :final otpauthUrl,
        :final secret,
      ):
        _host.setPendingCredentials(
          email: email,
          password: password.isEmpty ? null : password,
        );
        _host.state = AuthState.mfaRequired(
          firstLogin: firstLogin,
          enrollmentToken: enrollmentToken,
          otpauthUrl: otpauthUrl,
          secret: secret,
        );
    }
  }
}
