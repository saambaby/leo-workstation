import 'package:flutter_test/flutter_test.dart';
import 'package:leo_workstation/core/auth/domain/email_verification.dart';
import 'package:leo_workstation/core/auth/leo_roles.dart';
import 'package:leo_workstation/core/device/device_class.dart';
import 'package:leo_workstation/core/router/redirect.dart';
import 'package:leo_workstation/features/auth/presentation/state/auth_state.dart';

void main() {
  group('authRedirect decision table', () {
    test('unauthenticated on public route stays', () {
      expect(
        authRedirect(
          const AuthState.unauthenticated(),
          DeviceClass.desktop,
          '/login',
        ),
        isNull,
      );
    });

    test('unauthenticated with verify metadata redirects to verify-email', () {
      expect(
        authRedirect(
          const AuthState.unauthenticated(
            emailVerificationPending: VerifyEmailPendingContext(
              email: 'a@b.com',
              source: VerifyEmailSource.login,
            ),
          ),
          DeviceClass.desktop,
          '/login',
        ),
        '/verify-email?email=a%40b.com&source=login&path=personal',
      );
    });

    test('unauthenticated on verify-email without context goes to login', () {
      expect(
        authRedirect(
          const AuthState.unauthenticated(),
          DeviceClass.desktop,
          '/verify-email',
        ),
        '/login',
      );
    });

    test('authenticated on signup redirects to role home', () {
      expect(
        authRedirect(
          const AuthState.authenticated(role: LeoRoles.interpreter),
          DeviceClass.desktop,
          '/signup',
        ),
        '/idle',
      );
    });

    test('authenticated without onboardingRequired exits onboarding to role home',
        () {
      expect(
        authRedirect(
          const AuthState.authenticated(role: LeoRoles.interpreter),
          DeviceClass.desktop,
          '/onboarding/personal',
        ),
        '/idle',
      );
      expect(
        authRedirect(
          const AuthState.authenticated(role: LeoRoles.customerUser),
          DeviceClass.desktop,
          '/onboarding/customer',
        ),
        '/call',
      );
    });

    test('authenticated with onboardingRequired stays on onboarding', () {
      expect(
        authRedirect(
          const AuthState.authenticated(
            role: LeoRoles.interpreter,
            onboardingRequired: true,
          ),
          DeviceClass.desktop,
          '/onboarding/personal',
        ),
        isNull,
      );
    });

    test('mfaRequired first login goes to enroll', () {
      expect(
        authRedirect(
          const AuthState.mfaRequired(firstLogin: true),
          DeviceClass.desktop,
          '/login',
        ),
        '/mfa/enroll',
      );
    });

    test('interpreter authenticated lands on idle', () {
      expect(
        authRedirect(
          const AuthState.authenticated(role: LeoRoles.interpreter),
          DeviceClass.desktop,
          '/login',
        ),
        '/idle',
      );
    });

    test('customer on smartphone blocked from call routes', () {
      expect(
        authRedirect(
          const AuthState.authenticated(role: LeoRoles.customerUser),
          DeviceClass.smartphone,
          '/call',
        ),
        blockedSurfacePath,
      );
    });
  });

  group('redirect loop safety (router AC-8)', () {
    const locations = [
      '/',
      '/login',
      '/signup',
      '/signup/details',
      '/verify-email',
      '/forgot-password',
      '/forgot-password/verify',
      '/reset-password',
      '/invite/accept',
      '/mfa',
      '/mfa/enroll',
      '/blocked-surface',
      '/idle',
      '/idle/requests',
      '/call',
      '/call/requests',
      '/dispatch',
      '/dispatch/active',
      '/onboarding/personal',
      '/onboarding/customer',
      '/unknown/path',
    ];

    const devices = DeviceClass.values;

    final states = <AuthState>[
      const AuthState.unauthenticated(),
      const AuthState.unauthenticated(
        emailVerificationPending: VerifyEmailPendingContext(
          email: 'a@b.com',
        ),
      ),
      const AuthState.loading(),
      const AuthState.error(message: 'err'),
      const AuthState.mfaRequired(firstLogin: false),
      const AuthState.mfaRequired(firstLogin: true),
      const AuthState.authenticated(role: LeoRoles.interpreter),
      const AuthState.authenticated(
        role: LeoRoles.interpreter,
        onboardingRequired: true,
      ),
      const AuthState.authenticated(role: LeoRoles.customerUser),
      const AuthState.authenticated(role: LeoRoles.lspAdmin),
    ];

    for (final auth in states) {
      for (final device in devices) {
        for (final loc in locations) {
          test('no loop: ${auth.runtimeType} × ${device.name} × $loc', () {
            final settled = resolveRedirectChain(auth, device, loc);
            expect(authRedirect(auth, device, settled), isNull);
          });
        }
      }
    }
  });
}
