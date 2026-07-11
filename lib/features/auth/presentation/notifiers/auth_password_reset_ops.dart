import '../../../../core/network/api_error.dart';
import '../state/auth_state.dart';
import 'auth_flow_host.dart';

/// Forgot-password, reset-code verify/resend, and password reset.
class AuthPasswordResetOps {
  AuthPasswordResetOps(this._host);

  final AuthFlowHost _host;

  /// Returns `true` when the request completed successfully (always
  /// enumeration-safe on the server — clients navigate on success only).
  Future<bool> forgotPassword({required String email}) async {
    _host.state = const AuthState.unauthenticated(forgotPasswordSending: true);
    try {
      await _host.repo.forgotPassword(email: email);
      _host.state = const AuthState.unauthenticated();
      return true;
    } catch (e) {
      _host.state = AuthState.error(message: mapUserFacingError(e));
      return false;
    }
  }

  Future<bool> resendResetCode({required String email}) async {
    _host.state = const AuthState.unauthenticated(resendCodeSending: true);
    try {
      await _host.repo.forgotPassword(email: email);
      _host.state = const AuthState.unauthenticated();
      return true;
    } catch (e) {
      _host.state = AuthState.error(message: mapUserFacingError(e));
      return false;
    }
  }

  Future<String?> verifyResetCode({
    required String email,
    required String code,
  }) async {
    _host.state = const AuthState.loading(
      reason: AuthLoadingReason.passwordReset,
    );
    try {
      final ticket = await _host.repo.verifyResetCode(
        email: email,
        code: code,
      );
      _host.state = const AuthState.unauthenticated();
      return ticket.resetTicket;
    } catch (e) {
      _host.state = AuthState.error(
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
    _host.state = const AuthState.loading(
      reason: AuthLoadingReason.passwordReset,
    );
    try {
      await _host.repo.resetPassword(
        resetTicket: resetTicket,
        password: password,
      );
      _host.state = const AuthState.unauthenticated();
      return true;
    } catch (e) {
      _host.state = AuthState.error(
        message: mapUserFacingError(
          e,
          fallback: 'Invalid or expired reset session. Request a new code.',
        ),
      );
      return false;
    }
  }
}
