import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../theme/app_theme.dart';

/// macOS window frame: reserves space for traffic lights after hiding the system
/// title bar. In-screen links (e.g. “Back to sign in”) handle auth navigation.
class DesktopWorkstationShell extends StatelessWidget {
  const DesktopWorkstationShell({super.key, required this.child});

  final Widget child;

  static bool get enabled => !kIsWeb && Platform.isMacOS;

  static const toolbarHeight = 40.0;
  static const trafficLightInset = 78.0;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: toolbarHeight,
          child: ColoredBox(color: LeoColors.black900),
        ),
        Expanded(child: child),
      ],
    );
  }
}
