import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/notifiers/auth_notifier.dart';

/// Root app — CupertinoApp.router wired to auth redirect guard (P1-T-05).
class LeoApp extends ConsumerWidget {
  const LeoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authNotifierProvider);
    final router = ref.watch(routerProvider);
    final mode = ref.watch(themeModeProvider);

    return CupertinoApp.router(
      title: 'leo workstation',
      theme: themeFor(mode),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      routerConfig: router,
    );
  }
}
