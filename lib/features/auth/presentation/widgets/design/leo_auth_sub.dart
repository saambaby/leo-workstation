import 'package:flutter/cupertino.dart';

import '../../../../../core/theme/app_theme.dart';

/// Mono subtitle below logo (`.auth-sub`).
class LeoAuthSub extends StatelessWidget {
  const LeoAuthSub(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 24),
      child: Text(text, style: LeoTypography.authSub),
    );
  }
}
