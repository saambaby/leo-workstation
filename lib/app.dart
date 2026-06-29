import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/device/device_class.dart';
import 'core/theme/app_theme.dart';

/// Root app. Foundation (P1-T-01) boots a placeholder home; P1-T-05 (router)
/// swaps `home:` for `routerConfig:` (CupertinoApp.router).
class LeoApp extends ConsumerWidget {
  const LeoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return CupertinoApp(
      title: 'Leo Workstation',
      theme: themeFor(mode),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: const _FoundationHome(),
    );
  }
}

/// Temporary landing for the Foundation phase: reflects DeviceClass + lets the
/// theme be exercised. Replaced by the router's role shells in P1-T-05.
class _FoundationHome extends ConsumerWidget {
  const _FoundationHome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shortest = MediaQuery.of(context).size.shortestSide;
    // Feed MediaQuery into the DeviceClass provider once the frame is laid out.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(screenShortestSideProvider.notifier);
      if (notifier.state != shortest) notifier.state = shortest;
    });

    final deviceClass = ref.watch(deviceClassProvider);
    final mode = ref.watch(themeModeProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Leo Workstation'),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('App shell foundation'),
            const SizedBox(height: 8),
            Text('device: ${deviceClass.name} · theme: ${mode.name}'),
            const SizedBox(height: 16),
            CupertinoButton.filled(
              onPressed: () {
                final next = LeoThemeMode
                    .values[(mode.index + 1) % LeoThemeMode.values.length];
                ref.read(themeModeProvider.notifier).set(next);
              },
              child: const Text('Cycle theme'),
            ),
          ],
        ),
      ),
    );
  }
}
