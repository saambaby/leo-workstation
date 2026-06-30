import 'package:flutter/cupertino.dart';

import '../../../../../core/theme/app_theme.dart';

/// Tappable mono link (`.link`).
class LeoLink extends StatelessWidget {
  const LeoLink({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: onPressed,
        child: Text(label, style: LeoTypography.link),
      ),
    );
  }
}
