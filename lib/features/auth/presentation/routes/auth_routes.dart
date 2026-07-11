import 'package:go_router/go_router.dart';

import '../../../../core/router/device_class_scope.dart';
import '../../../../core/router/route_paths.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/forgot_password_verify_screen.dart';
import '../screens/login_screen.dart';
import '../screens/mfa_screen.dart';
import '../screens/reset_password_screen.dart';
import '../screens/role_shell_screen.dart';

const authPublicRoutes = {
  '/login',
  '/forgot-password',
  '/forgot-password/verify',
  '/reset-password',
  '/invite/accept',
};

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
      ),
    ),
  ),
  GoRoute(
    path: '/forgot-password',
    builder: (_, _) => const DeviceClassScope(child: ForgotPasswordScreen()),
    routes: [
      GoRoute(
        path: 'verify',
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
    builder: (_, state) => DeviceClassScope(
      child: ResetPasswordScreen(
        resetTicket: state.extra as String?,
      ),
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
    path: blockedSurfacePath,
    builder: (_, _) => const DeviceClassScope(child: BlockedSurfaceScreen()),
  ),
];
