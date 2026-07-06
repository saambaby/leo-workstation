import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../device/device_class.dart';

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
