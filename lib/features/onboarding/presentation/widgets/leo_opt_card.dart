import 'package:flutter/cupertino.dart';

import '../../../../core/theme/app_theme.dart';

/// Selectable option card (HTML `.opt-card`).
class LeoOptCard extends StatelessWidget {
  const LeoOptCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.icon,
    this.compact = false,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final String? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '$title, $subtitle',
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 14,
            vertical: compact ? 11 : 14,
          ),
          decoration: BoxDecoration(
            color: selected ? LeoColors.black600 : LeoColors.black700,
            borderRadius: BorderRadius.circular(LeoRadii.md),
            border: Border.all(
              color: selected ? LeoColors.black200 : LeoColors.black500,
            ),
          ),
          child: compact
              ? Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected
                            ? LeoColors.signalLive
                            : LeoColors.black400,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: LeoTypography.body13Medium),
                          Text(subtitle, style: LeoTypography.mono9),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (icon != null) ...[
                      Text(icon!, style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 8),
                    ],
                    Text(
                      title,
                      style: LeoTypography.body13Medium.copyWith(
                        fontFamily: 'Syne',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(subtitle, style: LeoTypography.mono9),
                  ],
                ),
        ),
      ),
    );
  }
}
