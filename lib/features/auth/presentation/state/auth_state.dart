import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

/// Distinguishes loading operations without changing router redirect behavior.
enum AuthLoadingReason {
  session,
  login,
  mfa,
  tenantSwitch,
  passwordReset,
  inviteAccept,
  forgotPassword,
  resendCode,
}

/// Auth→router contract (INV-CLIENT-STATE-2). Signature is frozen — router
/// consumes this union; do not add arms without updating both specs.
/// Optional fields on existing arms are UI/metadata only.
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.unauthenticated({
    @Default(false) bool forgotPasswordSending,
    @Default(false) bool resendCodeSending,
  }) = AuthUnauthenticated;

  const factory AuthState.loading({
    @Default(AuthLoadingReason.session) AuthLoadingReason reason,
  }) = AuthLoading;

  const factory AuthState.error({required String message}) = AuthError;

  const factory AuthState.mfaRequired({
    required bool firstLogin,
    String? enrollmentToken,
    String? otpauthUrl,
    String? secret,
  }) = AuthMfaRequired;

  const factory AuthState.authenticated({
    required String role,
    String? tenantId,
    @Default(false) bool onboardingRequired,
  }) = AuthAuthenticated;
}
