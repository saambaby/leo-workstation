import 'package:freezed_annotation/freezed_annotation.dart';

import 'auth_state.dart';

part 'auth_ui_state.freezed.dart';

/// Derived UI helpers from [AuthState] — screens watch this instead of
/// pattern-matching loading/error on every build.
@freezed
class AuthUiState with _$AuthUiState {
  const factory AuthUiState({
    @Default(false) bool isLoading,
    String? errorMessage,
    AuthLoadingReason? loadingReason,
    @Default(false) bool forgotPasswordSending,
    @Default(false) bool resendCodeSending,
    String? currentTenantId,
    String? role,
    @Default(false) bool onboardingRequired,
    /// Set only on a first-time privileged login — render as a scannable QR.
    String? otpauthUrl,
    /// Manual-entry fallback for the same enrollment secret.
    String? mfaSecret,
  }) = _AuthUiState;

  factory AuthUiState.from(AuthState auth) {
    return switch (auth) {
      AuthLoading(:final reason) => AuthUiState(
        isLoading: true,
        loadingReason: reason,
      ),
      AuthError(:final message) => AuthUiState(
        isLoading: false,
        errorMessage: message,
      ),
      AuthUnauthenticated(
        :final forgotPasswordSending,
        :final resendCodeSending,
      ) =>
        AuthUiState(
          isLoading: forgotPasswordSending || resendCodeSending,
          forgotPasswordSending: forgotPasswordSending,
          resendCodeSending: resendCodeSending,
        ),
      AuthAuthenticated(
        :final tenantId,
        :final role,
        :final onboardingRequired,
      ) =>
        AuthUiState(
          isLoading: false,
          currentTenantId: tenantId,
          role: role,
          onboardingRequired: onboardingRequired,
        ),
      AuthMfaRequired(:final otpauthUrl, :final secret) => AuthUiState(
        isLoading: false,
        otpauthUrl: otpauthUrl,
        mfaSecret: secret,
      ),
    };
  }
}
