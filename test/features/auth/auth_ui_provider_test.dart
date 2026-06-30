import 'package:flutter_test/flutter_test.dart';
import 'package:leo_workstation/features/auth/domain/auth_models.dart';
import 'package:leo_workstation/features/auth/presentation/providers/auth_ui_provider.dart';
import 'package:leo_workstation/features/auth/presentation/state/auth_state.dart';

void main() {
  group('AuthUiState.from', () {
    test('loading arm sets isLoading', () {
      final ui = AuthUiState.from(const AuthState.loading());
      expect(ui.isLoading, isTrue);
      expect(ui.errorMessage, isNull);
    });

    test('error arm surfaces message', () {
      final ui = AuthUiState.from(const AuthState.error(message: 'bad creds'));
      expect(ui.isLoading, isFalse);
      expect(ui.errorMessage, 'bad creds');
    });

    test('unauthenticated recovery flags drive isLoading', () {
      final ui = AuthUiState.from(
        const AuthState.unauthenticated(forgotPasswordSending: true),
      );
      expect(ui.isLoading, isTrue);
      expect(ui.forgotPasswordSending, isTrue);
    });

    test('pickMembership exposes memberships list', () {
      const memberships = [
        Membership(
          tenantId: 't1',
          tenantName: 'Acme',
          role: 'interpreter',
        ),
      ];
      final ui = AuthUiState.from(const AuthState.pickMembership(memberships));
      expect(ui.pickMemberships, memberships);
      expect(ui.isLoading, isFalse);
    });

    test('authenticated workspace flags', () {
      final ui = AuthUiState.from(
        const AuthState.authenticated(
          role: 'interpreter',
          tenantId: 't1',
          switchingTenant: true,
          membershipsLoading: false,
        ),
      );
      expect(ui.isLoading, isTrue);
      expect(ui.switchingTenant, isTrue);
      expect(ui.currentTenantId, 't1');
    });
  });
}
