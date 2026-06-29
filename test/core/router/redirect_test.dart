import 'package:flutter_test/flutter_test.dart';

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

    test('unauthenticated on protected route goes to login', () {
      expect(
        authRedirect(
          const AuthState.unauthenticated(),
          DeviceClass.desktop,
          '/idle',
        ),
        '/login',
      );
    });

    test('mfaRequired first login goes to enroll', () {
      expect(
        authRedirect(
          const AuthState.mfaRequired(
            firstLogin: true,
            mfaToken: 't',
          ),
          DeviceClass.desktop,
          '/login',
        ),
        '/mfa/enroll',
      );
    });

    test('pickMembership traps on select-workspace', () {
      expect(
        authRedirect(
          const AuthState.pickMembership([]),
          DeviceClass.desktop,
          '/select-workspace',
        ),
        isNull,
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

    test('platform_admin always routed to web handoff', () {
      expect(
        authRedirect(
          const AuthState.authenticated(role: LeoRoles.platformAdmin),
          DeviceClass.desktop,
          '/idle',
        ),
        webHandoffPath,
      );
    });
  });

  group('redirect loop safety (router AC-8)', () {
    const locations = [
      '/',
      '/login',
      '/forgot-password',
      '/reset-password',
      '/invite/accept',
      '/mfa',
      '/mfa/enroll',
      '/select-workspace',
      '/web-handoff',
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
      const AuthState.loading(),
      const AuthState.error(message: 'err'),
      const AuthState.mfaRequired(firstLogin: false, mfaToken: 't'),
      const AuthState.mfaRequired(firstLogin: true, mfaToken: 't'),
      const AuthState.pickMembership([]),
      const AuthState.authenticated(role: LeoRoles.interpreter),
      const AuthState.authenticated(
        role: LeoRoles.interpreter,
        onboardingRequired: true,
      ),
      const AuthState.authenticated(role: LeoRoles.customerUser),
      const AuthState.authenticated(role: LeoRoles.lspAdmin),
      const AuthState.authenticated(role: LeoRoles.platformAdmin),
    ];

    for (final auth in states) {
      for (final device in devices) {
        for (final loc in locations) {
          test(
            'no loop: ${auth.runtimeType} × ${device.name} × $loc',
            () {
              final settled = resolveRedirectChain(auth, device, loc);
              expect(authRedirect(auth, device, settled), isNull);
            },
          );
        }
      }
    }
  });
}
