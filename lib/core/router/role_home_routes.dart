import 'package:go_router/go_router.dart';

import 'device_class_scope.dart';
import 'placeholder_homes.dart';

List<RouteBase> get roleHomeRoutes => [
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
        builder: (_, _) => const DeviceClassScope(child: DispatchHomeScreen()),
      ),
    ],
  ),
];
