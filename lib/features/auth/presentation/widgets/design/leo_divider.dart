import 'package:flutter/cupertino.dart';

import '../../../../../core/theme/app_theme.dart';

/// Horizontal rule with centered label (`.divider`).
class LeoDivider extends StatelessWidget {
  const LeoDivider(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(child: _Line()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(label, style: LeoTypography.divider),
          ),
          const Expanded(child: _Line()),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: LeoColors.black600);
  }
}
