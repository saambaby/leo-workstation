import 'package:flutter/cupertino.dart';

import '../../../../../core/theme/app_theme.dart';

enum LeoButtonVariant { primary, ghost }

/// Custom auth button (`.btn.primary` / `.btn.ghost`) — no Cupertino blue.
class LeoButton extends StatelessWidget {
  const LeoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = LeoButtonVariant.primary,
    this.fullWidth = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final LeoButtonVariant variant;
  final bool fullWidth;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == LeoButtonVariant.primary;
    final active = enabled && onPressed != null;

    final background = switch ((isPrimary, active)) {
      (true, true) => LeoColors.signalWhite,
      (true, false) => LeoColors.black500,
      (false, _) => CupertinoColors.transparent,
    };
    final foreground = switch ((isPrimary, active)) {
      (true, true) => LeoColors.black900,
      (true, false) => LeoColors.black300,
      (false, true) => LeoColors.signalWhite,
      (false, false) => LeoColors.black300,
    };

    return Semantics(
      button: true,
      label: label,
      enabled: active,
      child: GestureDetector(
        onTap: active ? onPressed : null,
        child: Container(
          width: fullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(LeoRadii.md),
            border: isPrimary
                ? Border.all(
                    color: active ? LeoColors.signalWhite : LeoColors.black500,
                  )
                : Border.all(
                    color: active ? LeoColors.black500 : LeoColors.black600,
                  ),
          ),
          child: Text(
            label,
            style: LeoTypography.button.copyWith(color: foreground),
            textAlign: fullWidth ? TextAlign.center : null,
          ),
        ),
      ),
    );
  }
}
