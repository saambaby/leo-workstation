import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/auth/domain/email_verification.dart';

part 'auth_state.freezed.dart';

enum AuthLoadingReason {
  session,
  login,
  mfa,
  passwordReset,
  inviteAccept,
  forgotPassword,
  resendCode,
}

/// Auth→router contract (INV-CLIENT-STATE-2).
@freezed
sealed class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState.unauthenticated({
    @Default(false) bool forgotPasswordSending,
    @Default(false) bool resendCodeSending,
    /// Drives redirect to `/verify-email` (login-unverified or post-signup).
    VerifyEmailPendingContext? emailVerificationPending,
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
