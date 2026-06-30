import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_verify_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/mfa_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/role_shell_screen.dart';
import '../../features/auth/presentation/screens/tenant_picker_screen.dart';
import '../../features/onboarding/domain/onboarding_models.dart';
import '../../features/onboarding/presentation/screens/customer_onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/personal_onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/signup_details_screen.dart';
import '../../features/onboarding/presentation/screens/signup_type_screen.dart';
import '../../features/onboarding/presentation/screens/verify_email_screen.dart';
import '../device/device_class.dart';
import '../providers/auth_refresh_listenable.dart';
import '../shell/desktop_workstation_shell.dart';
import 'placeholder_homes.dart';
import 'redirect.dart';

/// Keeps [deviceClassProvider] in sync with layout changes.
class DeviceClassScope extends ConsumerWidget {
  const DeviceClassScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shortest = MediaQuery.of(context).size.shortestSide;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(screenShortestSideProvider.notifier);
      if (notifier.state != shortest) notifier.state = shortest;
    });
    return child;
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(authRefreshListenableProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authNotifierProvider);
      final device = ref.read(deviceClassProvider);
      return authRedirect(auth, device, state.uri.path);
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            DesktopWorkstationShell(child: child),
        routes: [
      GoRoute(
        path: '/login',
        builder: (_, state) => DeviceClassScope(
          child: LoginScreen(
            passwordResetSuccess:
                state.uri.queryParameters['reset'] == 'success',
            emailVerifiedSuccess:
                state.uri.queryParameters['verified'] == 'success',
          ),
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (_, _) =>
            const DeviceClassScope(child: ForgotPasswordScreen()),
        routes: [
          GoRoute(
            path: 'verify',
            redirect: (_, state) {
              final email = state.extra as String? ?? '';
              if (email.isEmpty) return '/forgot-password';
              return null;
            },
            builder: (_, state) {
              final email = state.extra as String? ?? '';
              return DeviceClassScope(
                child: ForgotPasswordVerifyScreen(email: email),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/reset-password',
        redirect: (_, state) {
          final token = state.uri.queryParameters['token'];
          if (token == null || token.isEmpty) return '/forgot-password';
          return null;
        },
        builder: (_, state) => DeviceClassScope(
          child: ResetPasswordScreen(
            token: state.uri.queryParameters['token'],
          ),
        ),
      ),
      GoRoute(
        path: '/invite/accept',
        builder: (_, state) => DeviceClassScope(
          child: InviteAcceptScreen(
            token: state.uri.queryParameters['token'],
          ),
        ),
      ),
      GoRoute(
        path: '/mfa',
        builder: (_, _) => const DeviceClassScope(child: MfaScreen()),
      ),
      GoRoute(
        path: '/mfa/enroll',
        builder: (_, _) => const DeviceClassScope(child: MfaEnrollScreen()),
      ),
      GoRoute(
        path: '/select-workspace',
        builder: (_, _) =>
            const DeviceClassScope(child: TenantPickerScreen()),
      ),
      GoRoute(
        path: webHandoffPath,
        builder: (_, _) => const DeviceClassScope(child: WebHandoffScreen()),
      ),
      GoRoute(
        path: blockedSurfacePath,
        builder: (_, _) => const DeviceClassScope(child: BlockedSurfaceScreen()),
      ),
      GoRoute(
        path: '/onboarding/personal',
        builder: (_, _) => const DeviceClassScope(
          child: PersonalOnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/onboarding/customer',
        builder: (_, _) => const DeviceClassScope(
          child: CustomerOnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/signup',
        builder: (_, _) =>
            const DeviceClassScope(child: SignupTypeScreen()),
        routes: [
          GoRoute(
            path: 'details',
            redirect: (_, state) {
              if (state.extra is! SignupDraft) return '/signup';
              return null;
            },
            builder: (_, state) => DeviceClassScope(
              child: SignupDetailsScreen(
                draft: state.extra! as SignupDraft,
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/verify-email',
        redirect: (_, state) {
          final token = state.uri.queryParameters['token'];
          if (token != null && token.isNotEmpty) return null;
          if (state.extra is! SignupVerifyContext) return '/signup';
          return null;
        },
        builder: (_, state) {
          final token = state.uri.queryParameters['token'];
          final ctx = state.extra as SignupVerifyContext?;
          return DeviceClassScope(
            child: VerifyEmailScreen(
              verifyContext: ctx ??
                  const SignupVerifyContext(
                    email: '',
                    path: SignupPath.personal,
                  ),
              token: token,
            ),
          );
        },
      ),
      GoRoute(
        path: '/idle',
        builder: (_, _) => const DeviceClassScope(child: IdleHomeScreen()),
        routes: [
          GoRoute(
            path: 'requests',
            builder: (_, _) => const DeviceClassScope(child: IdleHomeScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/call',
        builder: (_, _) => const DeviceClassScope(child: CallHomeScreen()),
        routes: [
          GoRoute(
            path: 'requests',
            builder: (_, _) => const DeviceClassScope(child: CallHomeScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/dispatch',
        builder: (_, _) => const DeviceClassScope(child: DispatchHomeScreen()),
        routes: [
          GoRoute(
            path: 'active',
            builder: (_, _) =>
                const DeviceClassScope(child: DispatchHomeScreen()),
          ),
        ],
      ),
        ],
      ),
    ],
  );
});
