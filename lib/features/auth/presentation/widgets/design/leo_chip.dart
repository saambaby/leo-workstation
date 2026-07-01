import 'package:flutter/cupertino.dart';

import '../../../../../core/theme/app_theme.dart';

enum LeoChipVariant { neutral, info }

/// Mono pill chip (`.chip` / `.chip.info`).
class LeoChip extends StatelessWidget {
  const LeoChip({
    super.key,
    required this.label,
    this.variant = LeoChipVariant.neutral,
  });

  final String label;
  final LeoChipVariant variant;

  @override
  Widget build(BuildContext context) {
    final (bg, border, fg) = switch (variant) {
      LeoChipVariant.neutral => (
          LeoColors.black700,
          LeoColors.black500,
          LeoColors.black100,
        ),
      LeoChipVariant.info => (
          LeoColors.signalInfo.withValues(alpha: 0.1),
          LeoColors.signalInfo.withValues(alpha: 0.2),
          LeoColors.signalInfo,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Text(label, style: LeoTypography.chip.copyWith(color: fg)),
    );
  }
}
