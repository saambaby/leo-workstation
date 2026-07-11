import '../../../../core/network/api_error.dart';
import '../state/auth_state.dart';
import 'auth_flow_host.dart';

/// Invite-accept consent + password setup.
class AuthInviteOps {
  AuthInviteOps(this._host);

  final AuthFlowHost _host;

  Future<bool> acceptInvite({
    required String token,
    required String password,
    required bool tos,
    required bool privacy,
    required bool baaAck,
  }) async {
    _host.state = const AuthState.loading(
      reason: AuthLoadingReason.inviteAccept,
    );
    try {
      await _host.repo.acceptInvite(
        token: token,
        password: password,
        tos: tos,
        privacy: privacy,
        baaAck: baaAck,
      );
      _host.state = const AuthState.unauthenticated();
      return true;
    } catch (e) {
      _host.state = AuthState.error(message: mapUserFacingError(e));
      return false;
    }
  }
}
