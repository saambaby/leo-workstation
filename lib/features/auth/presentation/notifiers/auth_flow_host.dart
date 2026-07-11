import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/data/auth_repository.dart';
import '../state/auth_state.dart';

/// Shared mutable host for auth flow modules — owned by [AuthNotifier].
class AuthFlowHost {
  AuthFlowHost({
    required this.ref,
    required AuthState Function() readState,
    required void Function(AuthState) writeState,
  }) : _readState = readState,
       _writeState = writeState;

  final Ref ref;
  final AuthState Function() _readState;
  final void Function(AuthState) _writeState;

  AuthState get state => _readState();
  set state(AuthState value) => _writeState(value);

  AuthRepository get repo => ref.read(authRepositoryProvider);

  var opGeneration = 0;
  String? pendingEmail;
  String? pendingPassword;

  int bumpOp() => ++opGeneration;

  bool isStaleOp(int op) => op != opGeneration;

  void clearPendingCredentials() {
    pendingEmail = null;
    pendingPassword = null;
  }

  void setPendingCredentials({required String email, String? password}) {
    pendingEmail = email;
    pendingPassword = password;
  }
}
