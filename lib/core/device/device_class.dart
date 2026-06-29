import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Device entitlement classes (INV-CLIENT-DEVICE-1). Router gates routes on this.
enum DeviceClass { desktop, tablet, smartphone }

/// Pure classifier by MediaQuery shortest-side (logical px). Documented breakpoints:
/// smartphone < 600, tablet 600..<1024, desktop >= 1024.
DeviceClass deviceClassFor(double shortestSide) {
  if (shortestSide < 600) return DeviceClass.smartphone;
  if (shortestSide < 1024) return DeviceClass.tablet;
  return DeviceClass.desktop;
}

/// Updated from `MediaQuery` by a widget near the app root; 0 until first frame.
final screenShortestSideProvider = StateProvider<double>((ref) => 0);

final deviceClassProvider = Provider<DeviceClass>(
  (ref) => deviceClassFor(ref.watch(screenShortestSideProvider)),
);
