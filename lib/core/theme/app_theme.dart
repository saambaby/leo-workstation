import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leo_workstation/core/storage/token_storage.dart';



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

/// Border radii from CSS `--r-*` tokens.
class LeoRadii {
  LeoRadii._();
  static const sm = 4.0;
  static const md = 8.0;
  static const lg = 12.0;
  static const xl = 16.0;
  static const xl2 = 24.0;
}

/// Cached text styles mapped from the HTML design system.
class LeoTypography {
  LeoTypography._();

  static TextStyle get _display => const TextStyle(fontFamily: 'Syne');
  static TextStyle get _body => const TextStyle(fontFamily: 'DM Sans');
  static TextStyle get _mono => const TextStyle(fontFamily: 'DM Mono');

  static TextStyle get logo => _display.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: LeoColors.signalWhite,
      );

  static TextStyle get logoAccent => _display.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.8,
        color: LeoColors.black300,
      );

  static TextStyle get authSub => _mono.copyWith(
        fontSize: 11,
        letterSpacing: 0.33,
        color: LeoColors.black200,
      );

  static TextStyle get button => _display.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.24,
      );

  static TextStyle get pageTitle => _display.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: LeoColors.signalWhite,
      );

  static TextStyle get fieldLabel => _body.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.22,
        color: LeoColors.black100,
      );

  static TextStyle get input => _body.copyWith(
        fontSize: 13,
        color: LeoColors.signalWhite,
      );

  static TextStyle get inputPlaceholder => _body.copyWith(
        fontSize: 13,
        color: LeoColors.black300,
      );

  static TextStyle get link => _mono.copyWith(
        fontSize: 11,
        color: LeoColors.black100,
      );

  static TextStyle get note => _body.copyWith(
        fontSize: 11,
        height: 1.5,
      );

  static TextStyle get otpCell => _mono.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: LeoColors.signalWhite,
      );

  static TextStyle get mono9 => _mono.copyWith(
        fontSize: 9,
        color: LeoColors.black300,
      );

  static TextStyle get mono10 => _mono.copyWith(
        fontSize: 10,
        color: LeoColors.black300,
      );

  static TextStyle get mono11 => _mono.copyWith(
        fontSize: 11,
        color: LeoColors.black100,
      );

  static TextStyle get mono12 => _mono.copyWith(
        fontSize: 12,
        letterSpacing: 1.2,
        color: LeoColors.signalWhite,
      );

  static TextStyle get divider => _mono.copyWith(
        fontSize: 11,
        color: LeoColors.black300,
      );

  static TextStyle get checkboxLabel => _body.copyWith(
        fontSize: 11,
        color: LeoColors.black200,
      );

  static TextStyle get chip => _mono.copyWith(
        fontSize: 10,
        color: LeoColors.black100,
      );

  static TextStyle get listRowTitle => _body.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: LeoColors.signalWhite,
      );

  static TextStyle get listRowMeta => _mono.copyWith(
        fontSize: 10,
        color: LeoColors.black300,
      );

  static TextStyle get body13Medium => _body.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: LeoColors.signalWhite,
      );

  static TextStyle get body12Medium => _body.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: LeoColors.signalWhite,
      );
}

/// Night ≠ dark: night is a separate, dimmer variant (deeper black, softer text).
enum LeoThemeMode { light, dark, night }

CupertinoThemeData themeFor(LeoThemeMode mode) {
  final body = LeoTypography.input;
  final display = LeoTypography.pageTitle;

  switch (mode) {
    case LeoThemeMode.light:
      return CupertinoThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: LeoColors.lightBg,
        primaryColor: LeoColors.black900,
        barBackgroundColor: LeoColors.lightBg,
        textTheme: CupertinoTextThemeData(
          primaryColor: LeoColors.lightText,
          textStyle: body.copyWith(color: LeoColors.lightText),
          navTitleTextStyle: display.copyWith(color: LeoColors.lightText),
          navLargeTitleTextStyle: display.copyWith(
            fontSize: 28,
            color: LeoColors.lightText,
          ),
        ),
      );
    case LeoThemeMode.dark:
      return CupertinoThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: LeoColors.black900,
        primaryColor: LeoColors.signalWhite,
        barBackgroundColor: LeoColors.black800,
        textTheme: CupertinoTextThemeData(
          primaryColor: LeoColors.signalWhite,
          textStyle: body,
          navTitleTextStyle: display,
          navLargeTitleTextStyle: display.copyWith(fontSize: 28),
        ),
      );
    case LeoThemeMode.night:
      return CupertinoThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050507),
        primaryColor: LeoColors.black50,
        barBackgroundColor: const Color(0xFF050507),
        textTheme: CupertinoTextThemeData(
          primaryColor: LeoColors.black50,
          textStyle: body.copyWith(color: LeoColors.black50),
          navTitleTextStyle: display.copyWith(color: LeoColors.black50),
          navLargeTitleTextStyle: display.copyWith(
            fontSize: 28,
            color: LeoColors.black50,
          ),
        ),
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
