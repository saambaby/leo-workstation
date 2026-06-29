import '../../core/auth/leo_roles.dart';
import '../../core/device/device_class.dart';
import '../../features/auth/presentation/state/auth_state.dart';

/// Public routes reachable while signed out.
const publicRoutes = {
  '/login',
  '/forgot-password',
  '/reset-password',
  '/invite/accept',
};

/// Auth-transition + public auth screens (error state may stay here).
const authFlowRoutes = {
  '/login',
  '/forgot-password',
  '/reset-password',
  '/invite/accept',
  '/mfa',
  '/mfa/enroll',
  '/select-workspace',
};

const blockedSurfacePath = '/blocked-surface';
const webHandoffPath = '/web-handoff';

/// Canonical role→home map (INV-CLIENT-ROUTE-2).
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
    case LeoRoles.platformAdmin:
      return webHandoffPath;
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

bool _isCustomerRoute(String loc) =>
    loc == '/call' || loc.startsWith('/call/');

/// Device entitlement backstop (INV-CLIENT-DEVICE-1).
bool isRouteAllowedForDevice(String loc, String role, DeviceClass device) {
  if (device == DeviceClass.smartphone &&
      (role == LeoRoles.customerUser || role == LeoRoles.customerAdmin) &&
      _isCustomerRoute(loc)) {
    return false;
  }
  return true;
}

/// Pure redirect guard (INV-CLIENT-STATE-1). Returns a path or `null` (stay).
String? authRedirect(AuthState auth, DeviceClass device, String loc) {
  return switch (auth) {
    AuthLoading() => null,
    AuthUnauthenticated() =>
      publicRoutes.contains(loc) ? null : '/login',
    AuthError() => authFlowRoutes.contains(loc) ? null : '/login',
    AuthMfaRequired(:final firstLogin) =>
      _redirectMfa(firstLogin, loc),
    AuthPickMembership() => loc == '/select-workspace' ? null : '/select-workspace',
    AuthAuthenticated(
      :final role,
      :final onboardingRequired,
    ) =>
      _redirectAuthenticated(role, onboardingRequired, device, loc),
  };
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

  if (role == LeoRoles.platformAdmin) {
    return loc == webHandoffPath ? null : webHandoffPath;
  }

  if (onboardingRequired && !_isOnboardingPath(loc)) {
    return onboardingEntryForRole(role);
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

const _authScreens = {
  '/login',
  '/mfa',
  '/mfa/enroll',
  '/select-workspace',
};

bool _knownRoute(String loc) {
  if (publicRoutes.contains(loc) ||
      authFlowRoutes.contains(loc) ||
      loc == blockedSurfacePath ||
      loc == webHandoffPath ||
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

/// Simulates redirect chains for loop-safety tests (router AC-8).
String resolveRedirectChain(
  AuthState auth,
  DeviceClass device,
  String startLoc, {
  int maxSteps = 10,
}) {
  var loc = startLoc;
  for (var i = 0; i < maxSteps; i++) {
    final next = authRedirect(auth, device, loc);
    if (next == null) return loc;
    if (next == loc) {
      throw StateError('Redirect loop at $loc');
    }
    loc = next;
  }
  throw StateError('Redirect chain exceeded $maxSteps steps from $startLoc');
}
