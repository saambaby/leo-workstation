import 'package:flutter/cupertino.dart';

import '../../../../../core/theme/app_theme.dart';

enum LeoNoteVariant { info, warn }

/// Tinted callout (`.note.info` / `.note.warn`).
class LeoNote extends StatelessWidget {
  const LeoNote({
    super.key,
    required this.variant,
    required this.icon,
    required this.child,
    this.margin,
  });

  final LeoNoteVariant variant;
  final IconData icon;
  final Widget child;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final (bg, border, fg) = switch (variant) {
      LeoNoteVariant.info => (
          LeoColors.signalInfo.withValues(alpha: 0.06),
          LeoColors.signalInfo.withValues(alpha: 0.16),
          LeoColors.signalInfo,
        ),
      LeoNoteVariant.warn => (
          LeoColors.signalWarn.withValues(alpha: 0.07),
          LeoColors.signalWarn.withValues(alpha: 0.2),
          LeoColors.signalWarn,
        ),
    };

    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(LeoRadii.md),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 14, color: fg),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DefaultTextStyle(
              style: LeoTypography.note.copyWith(color: fg),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
