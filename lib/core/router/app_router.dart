import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../../features/auth/presentation/routes/auth_routes.dart';
import '../../features/onboarding/presentation/routes/onboarding_routes.dart';
import '../device/device_class.dart';
import '../providers/auth_refresh_listenable.dart';
import '../shell/desktop_workstation_shell.dart';
import 'redirect.dart';
import 'role_home_routes.dart';

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
          ...authRoutes,
          ...onboardingRoutes,
          ...roleHomeRoutes,
        ],
      ),
    ],
  );
});
