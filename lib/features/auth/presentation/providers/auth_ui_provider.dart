import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/auth_models.dart';
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
    this.memberships = const [],
    this.membershipsLoading = false,
    this.switchingTenant = false,
    this.expandedPrivilegedTenantId,
    this.currentTenantId,
    this.pickMemberships = const [],
  });

  final bool isLoading;
  final String? errorMessage;
  final bool forgotPasswordSending;
  final bool resendCodeSending;
  final List<Membership> memberships;
  final bool membershipsLoading;
  final bool switchingTenant;
  final String? expandedPrivilegedTenantId;
  final String? currentTenantId;
  final List<Membership> pickMemberships;

  factory AuthUiState.from(AuthState auth) {
    return switch (auth) {
      AuthLoading() => const AuthUiState(isLoading: true),
      AuthError(:final message) => AuthUiState(isLoading: false, errorMessage: message),
      AuthUnauthenticated(
        :final forgotPasswordSending,
        :final resendCodeSending,
      ) =>
        AuthUiState(
          isLoading: forgotPasswordSending || resendCodeSending,
          forgotPasswordSending: forgotPasswordSending,
          resendCodeSending: resendCodeSending,
        ),
      AuthPickMembership(:final memberships) => AuthUiState(
          isLoading: false,
          pickMemberships: memberships,
        ),
      AuthAuthenticated(
        :final tenantId,
        :final memberships,
        :final membershipsLoading,
        :final switchingTenant,
        :final expandedPrivilegedTenantId,
      ) =>
        AuthUiState(
          isLoading: membershipsLoading || switchingTenant,
          currentTenantId: tenantId,
          memberships: memberships,
          membershipsLoading: membershipsLoading,
          switchingTenant: switchingTenant,
          expandedPrivilegedTenantId: expandedPrivilegedTenantId,
        ),
      AuthMfaRequired() => const AuthUiState(isLoading: false),
    };
  }
}

final authUiProvider = Provider<AuthUiState>((ref) {
  final auth = ref.watch(authNotifierProvider);
  return AuthUiState.from(auth);
});
