import 'package:flutter/cupertino.dart';

import '../../../../../core/theme/app_theme.dart';

/// Nested dark panel (`.card` with `.card-pad`).
class LeoCard extends StatelessWidget {
  const LeoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.margin,
    this.alignment,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
        color: backgroundColor ?? LeoColors.black800,
        borderRadius: BorderRadius.circular(LeoRadii.lg),
        border: Border.all(color: LeoColors.black600),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
