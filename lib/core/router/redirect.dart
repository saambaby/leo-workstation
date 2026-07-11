import '../../core/auth/leo_roles.dart';
import '../../core/auth/domain/email_verification.dart';
import '../../core/device/device_class.dart';
import '../../features/auth/presentation/routes/auth_routes.dart';
import '../../features/auth/presentation/state/auth_state.dart';
import '../../features/onboarding/presentation/routes/onboarding_routes.dart';
import 'route_guards.dart';
import 'route_paths.dart';

export 'route_paths.dart';

const publicRoutes = {
  ...authPublicRoutes,
  ...onboardingPublicRoutes,
};

const authFlowRoutes = {
  ...publicRoutes,
  ...authTransitionRoutes,
};

String roleHome(String role) {
  switch (role) {
    case LeoRoles.interpreter:
      return '/idle';
    case LeoRoles.customerUser:
    case LeoRoles.customerAdmin:
      return '/call';
    case LeoRoles.subAdmin:
    case LeoRoles.lspAdmin:
      return '/dispatch';
    default:
      return '/login';
  }
}

String onboardingEntryForRole(String role) {
  switch (role) {
    case LeoRoles.interpreter:
      return '/onboarding/personal';
    case LeoRoles.customerUser:
    case LeoRoles.customerAdmin:
      return '/onboarding/customer';
    default:
      return '/onboarding/personal';
  }
}

bool _isOnboardingPath(String loc) => loc.startsWith('/onboarding');

bool _isCustomerRoute(String loc) => loc == '/call' || loc.startsWith('/call/');

String _routePath(String loc) => Uri.parse(loc).path;

bool isRouteAllowedForDevice(String loc, String role, DeviceClass device) {
  if (device == DeviceClass.smartphone &&
      (role == LeoRoles.customerUser || role == LeoRoles.customerAdmin) &&
      _isCustomerRoute(loc)) {
    return false;
  }
  return true;
}

String? authRedirect(
  AuthState auth,
  DeviceClass device,
  String loc, {
  Object? extra,
  Map<String, String> queryParameters = const {},
}) {
  final path = _routePath(loc);
  return switch (auth) {
    AuthLoading() => null,
    AuthUnauthenticated(:final emailVerificationPending) =>
      _redirectUnauthenticated(
        path,
        emailVerificationPending: emailVerificationPending,
        extra: extra,
        queryParameters: queryParameters,
      ),
    AuthError() => authFlowRoutes.contains(path) ? null : '/login',
    AuthMfaRequired(:final firstLogin) => _redirectMfa(firstLogin, path),
    AuthAuthenticated(:final role, :final onboardingRequired) =>
      _redirectAuthenticated(role, onboardingRequired, device, path),
  };
}

String? _redirectUnauthenticated(
  String path, {
  VerifyEmailPendingContext? emailVerificationPending,
  Object? extra,
  Map<String, String> queryParameters = const {},
}) {
  final contextGuard = guardPublicRouteContext(
    path,
    emailVerificationPending: emailVerificationPending,
    extra: extra,
    queryParameters: queryParameters,
  );
  if (contextGuard != null) return contextGuard;

  if (emailVerificationPending != null && path != '/verify-email') {
    return verifyEmailLocation(emailVerificationPending);
  }

  return publicRoutes.contains(path) ? null : '/login';
}

String? _redirectMfa(bool firstLogin, String loc) {
  final target = firstLogin ? '/mfa/enroll' : '/mfa';
  return loc == target ? null : target;
}

String? _redirectAuthenticated(
  String role,
  bool onboardingRequired,
  DeviceClass device,
  String loc,
) {
  final home = roleHome(role);

  if (onboardingRequired && !_isOnboardingPath(loc)) {
    return onboardingEntryForRole(role);
  }

  if (!onboardingRequired && _isOnboardingPath(loc)) {
    return home;
  }

  if (publicRoutes.contains(loc) && !_isOnboardingPath(loc)) {
    return home;
  }

  if (_authScreens.contains(loc)) {
    return home;
  }

  if (loc == blockedSurfacePath) {
    return isRouteAllowedForDevice(home, role, device) ? home : null;
  }

  if (!isRouteAllowedForDevice(loc, role, device)) {
    return blockedSurfacePath;
  }

  if (loc == home || _isAllowedDeepRoute(role, loc)) {
    return null;
  }

  if (loc == '/' || !_knownRoute(loc)) {
    return home;
  }

  return null;
}

const _authScreens = {'/login', '/mfa', '/mfa/enroll'};

bool _knownRoute(String loc) {
  if (publicRoutes.contains(loc) ||
      authFlowRoutes.contains(loc) ||
      loc == blockedSurfacePath ||
      _isOnboardingPath(loc)) {
    return true;
  }
  return loc == '/idle' ||
      loc.startsWith('/idle/') ||
      _isCustomerRoute(loc) ||
      loc == '/dispatch' ||
      loc.startsWith('/dispatch/');
}

bool _isAllowedDeepRoute(String role, String loc) {
  switch (role) {
    case LeoRoles.interpreter:
      return loc == '/idle' || loc.startsWith('/idle/');
    case LeoRoles.customerUser:
    case LeoRoles.customerAdmin:
      return _isCustomerRoute(loc);
    case LeoRoles.subAdmin:
    case LeoRoles.lspAdmin:
      return loc == '/dispatch' || loc.startsWith('/dispatch/');
    default:
      return false;
  }
}

String resolveRedirectChain(
  AuthState auth,
  DeviceClass device,
  String startLoc, {
  Object? extra,
  Map<String, String> queryParameters = const {},
  int maxSteps = 10,
}) {
  var loc = startLoc;
  for (var i = 0; i < maxSteps; i++) {
    final next = authRedirect(
      auth,
      device,
      loc,
      extra: extra,
      queryParameters: queryParameters,
    );
    if (next == null) return loc;
    if (next == loc) {
      throw StateError('Redirect loop at $loc');
    }
    loc = next;
  }
  throw StateError('Redirect chain exceeded $maxSteps steps from $startLoc');
}
