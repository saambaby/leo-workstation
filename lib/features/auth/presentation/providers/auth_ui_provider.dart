import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/auth_notifier.dart';
import '../state/auth_state.dart';

/// Derived UI helpers from [AuthState] — screens watch this instead of
/// pattern-matching loading/error on every build.
class AuthUiState {
  const AuthUiState({
    required this.isLoading,
    this.errorMessage,
    this.forgotPasswordSending = false,
    this.resendCodeSending = false,
    this.currentTenantId,
    this.otpauthUrl,
    this.mfaSecret,
  });

  final bool isLoading;
  final String? errorMessage;
  final bool forgotPasswordSending;
  final bool resendCodeSending;
  final String? currentTenantId;

  /// Set only on a first-time privileged login — render as a scannable QR.
  final String? otpauthUrl;

  /// Manual-entry fallback for the same enrollment secret.
  final String? mfaSecret;

  factory AuthUiState.from(AuthState auth) {
    return switch (auth) {
      AuthLoading() => const AuthUiState(isLoading: true),
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
      AuthAuthenticated(:final tenantId) => AuthUiState(
        isLoading: false,
        currentTenantId: tenantId,
      ),
      AuthMfaRequired(:final otpauthUrl, :final secret) => AuthUiState(
        isLoading: false,
        otpauthUrl: otpauthUrl,
        mfaSecret: secret,
      ),
    };
  }
}

final authUiProvider = Provider<AuthUiState>((ref) {
  final auth = ref.watch(authNotifierProvider);
  return AuthUiState.from(auth);
});
