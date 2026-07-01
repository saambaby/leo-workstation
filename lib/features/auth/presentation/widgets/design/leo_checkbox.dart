import 'package:flutter/cupertino.dart';

import '../../../../../core/theme/app_theme.dart';

/// 14×14 square checkbox used on login (Remember device) and signup consent.
class LeoCheckbox extends StatelessWidget {
  const LeoCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: value,
      label: label,
      button: true,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 14,
                height: 14,
                margin: const EdgeInsets.only(top: 1),
                decoration: BoxDecoration(
                  color: value ? LeoColors.black400 : LeoColors.black600,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: value ? LeoColors.black300 : LeoColors.black400,
                  ),
                ),
                child: value
                    ? const Icon(
                        CupertinoIcons.checkmark,
                        size: 10,
                        color: LeoColors.signalWhite,
                      )
                    : null,
              ),
              const SizedBox(width: 7),
              Text(label, style: LeoTypography.checkboxLabel),
            ],
          ),
        ),
      ),
    );
  }
}
