import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/auth_models.dart';

part 'auth_state.freezed.dart';

/// Auth→router contract (INV-CLIENT-STATE-2). Signature is frozen — router
/// consumes this union; do not add arms without updating both specs.
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.error({required String message}) = AuthError;
  const factory AuthState.mfaRequired({
    required bool firstLogin,
    required String mfaToken,
  }) = AuthMfaRequired;
  const factory AuthState.pickMembership(List<Membership> memberships) =
      AuthPickMembership;
  const factory AuthState.authenticated({
    required String role,
    String? tenantId,
    @Default(false) bool onboardingRequired,
  }) = AuthAuthenticated;
}
