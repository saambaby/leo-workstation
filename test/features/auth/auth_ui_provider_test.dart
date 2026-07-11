import 'package:flutter_test/flutter_test.dart';
import 'package:leo_workstation/features/auth/presentation/state/auth_state.dart';
import 'package:leo_workstation/features/auth/presentation/state/auth_ui_state.dart';

void main() {
  group('AuthUiState.from', () {
    test('loading arm sets isLoading and loadingReason', () {
      final ui = AuthUiState.from(
        const AuthState.loading(reason: AuthLoadingReason.login),
      );
      expect(ui.isLoading, isTrue);
      expect(ui.errorMessage, isNull);
      expect(ui.loadingReason, AuthLoadingReason.login);
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

    test('mfaRequired exposes enrollment payload', () {
      final ui = AuthUiState.from(
        const AuthState.mfaRequired(
          firstLogin: true,
          otpauthUrl: 'otpauth://totp/Leo:t?secret=ABC&issuer=Leo',
          secret: 'ABC',
        ),
      );
      expect(ui.isLoading, isFalse);
      expect(ui.otpauthUrl, 'otpauth://totp/Leo:t?secret=ABC&issuer=Leo');
      expect(ui.mfaSecret, 'ABC');
    });

    test('authenticated exposes current tenant and role', () {
      final ui = AuthUiState.from(
        const AuthState.authenticated(role: 'interpreter', tenantId: 't1'),
      );
      expect(ui.isLoading, isFalse);
      expect(ui.currentTenantId, 't1');
      expect(ui.role, 'interpreter');
      expect(ui.onboardingRequired, isFalse);
    });
  });
}
