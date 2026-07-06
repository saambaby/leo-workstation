import 'package:go_router/go_router.dart';

import '../../../../core/router/device_class_scope.dart';
import '../../../../core/router/route_paths.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/forgot_password_verify_screen.dart';
import '../screens/login_screen.dart';
import '../screens/mfa_screen.dart';
import '../screens/reset_password_screen.dart';
import '../screens/role_shell_screen.dart';

/// Public auth routes reachable while signed out.
const authPublicRoutes = {
  '/login',
  '/forgot-password',
  '/forgot-password/verify',
  '/reset-password',
  '/invite/accept',
};

/// MFA transition screens (error state may stay here).
const authTransitionRoutes = {
  '/mfa',
  '/mfa/enroll',
};

List<RouteBase> get authRoutes => [
  GoRoute(
    path: '/login',
    builder: (_, state) => DeviceClassScope(
      child: LoginScreen(
        passwordResetSuccess: state.uri.queryParameters['reset'] == 'success',
        emailVerifiedSuccess: state.uri.queryParameters['verified'] == 'success',
      ),
    ),
  ),
  GoRoute(
    path: '/forgot-password',
    builder: (_, _) => const DeviceClassScope(child: ForgotPasswordScreen()),
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
      child: ResetPasswordScreen(token: state.uri.queryParameters['token']),
    ),
  ),
  GoRoute(
    path: '/invite/accept',
    builder: (_, state) => DeviceClassScope(
      child: InviteAcceptScreen(token: state.uri.queryParameters['token']),
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
    path: webHandoffPath,
    builder: (_, _) => const DeviceClassScope(child: WebHandoffScreen()),
  ),
  GoRoute(
    path: blockedSurfacePath,
    builder: (_, _) => const DeviceClassScope(child: BlockedSurfaceScreen()),
  ),
];
