import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/token_storage.dart';

/// Design tokens from the workstation design system (INV-CLIENT-UI-1).
class LeoColors {
  LeoColors._();
  static const black900 = Color(0xFF0A0A0B);
  static const black800 = Color(0xFF111114);
  static const black700 = Color(0xFF18181D);
  static const black600 = Color(0xFF1E1E25);
  static const black500 = Color(0xFF26262F);
  static const black400 = Color(0xFF32323E);
  static const black300 = Color(0xFF4A4A5A);
  static const black200 = Color(0xFF6E6E82);
  static const black100 = Color(0xFF9E9EB5);
  static const black50 = Color(0xFFC8C8D8);
  static const signalLive = Color(0xFF22C55E);
  static const signalWarn = Color(0xFFF59E0B);
  static const signalError = Color(0xFFEF4444);
  static const signalInfo = Color(0xFF94A3B8);
  static const signalWhite = Color(0xFFF8F8FA);
  // Light surface (web/customer light variant).
  static const lightBg = Color(0xFFF8F8FA);
  static const lightText = Color(0xFF0A0A0B);
}

/// Night ≠ dark: night is a separate, dimmer variant (deeper black, softer text).
enum LeoThemeMode { light, dark, night }

CupertinoThemeData themeFor(LeoThemeMode mode) {
  switch (mode) {
    case LeoThemeMode.light:
      return const CupertinoThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: LeoColors.lightBg,
        primaryColor: LeoColors.black900,
        barBackgroundColor: LeoColors.lightBg,
        textTheme: CupertinoTextThemeData(primaryColor: LeoColors.lightText),
      );
    case LeoThemeMode.dark:
      return const CupertinoThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: LeoColors.black900,
        primaryColor: LeoColors.signalWhite,
        barBackgroundColor: LeoColors.black800,
        textTheme: CupertinoTextThemeData(primaryColor: LeoColors.signalWhite),
      );
    case LeoThemeMode.night:
      return const CupertinoThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF050507),
        primaryColor: LeoColors.black50,
        barBackgroundColor: Color(0xFF050507),
        textTheme: CupertinoTextThemeData(primaryColor: LeoColors.black50),
      );
  }
}

/// App-wide, persisted theme mode. Defaults to dark (the workstation default).
final themeModeProvider =
    NotifierProvider<ThemeModeController, LeoThemeMode>(ThemeModeController.new);

class ThemeModeController extends Notifier<LeoThemeMode> {
  static const _key = 'leo.theme_mode';

  @override
  LeoThemeMode build() {
    _restore();
    return LeoThemeMode.dark;
  }

  Future<void> _restore() async {
    final v = await ref.read(flutterSecureStorageProvider).read(key: _key);
    if (v != null) {
      state = LeoThemeMode.values.firstWhere(
        (m) => m.name == v,
        orElse: () => LeoThemeMode.dark,
      );
    }
  }

  Future<void> set(LeoThemeMode mode) async {
    state = mode;
    await ref.read(flutterSecureStorageProvider).write(key: _key, value: mode.name);
  }
}
