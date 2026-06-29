import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../device/device_class.dart';

/// Bridges [authNotifierProvider] (+ device class) → GoRouter.refreshListenable.
class AuthRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final authRefreshListenableProvider = Provider<AuthRefreshNotifier>((ref) {
  final notifier = AuthRefreshNotifier();
  ref.onDispose(notifier.dispose);
  ref.listen(authNotifierProvider, (_, _) => notifier.refresh());
  ref.listen(deviceClassProvider, (_, _) => notifier.refresh());
  return notifier;
});
