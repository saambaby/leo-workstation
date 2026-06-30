import 'package:flutter/cupertino.dart';

import '../../../../core/theme/app_theme.dart';

class WizardStep {
  const WizardStep({
    required this.label,
    this.done = false,
    this.active = false,
  });

  final String label;
  final bool done;
  final bool active;
}

/// Display-only wizard progress (HTML `.wiz-steps`).
class LeoWizardSteps extends StatelessWidget {
  const LeoWizardSteps({super.key, required this.steps});

  final List<WizardStep> steps;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < steps.length; i++) {
      if (i > 0) {
        children.add(
          Expanded(
            child: Container(
              height: 1,
              color: LeoColors.black500,
              margin: const EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
        );
      }
      children.add(_StepItem(step: steps[i], index: i + 1));
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(children: children),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({required this.step, required this.index});

  final WizardStep step;
  final int index;

  @override
  Widget build(BuildContext context) {
    final fg = step.active || step.done
        ? LeoColors.signalWhite
        : LeoColors.black300;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: step.active
                ? LeoColors.signalWhite
                : step.done
                    ? LeoColors.signalLive.withValues(alpha: 0.2)
                    : LeoColors.black600,
            border: Border.all(
              color: step.active
                  ? LeoColors.signalWhite
                  : step.done
                      ? LeoColors.signalLive
                      : LeoColors.black500,
            ),
          ),
          child: Text(
            step.done ? '✓' : '$index',
            style: LeoTypography.mono9.copyWith(
              fontSize: 8,
              color: step.active ? LeoColors.black900 : fg,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          step.label,
          style: LeoTypography.mono9.copyWith(
            color: fg,
            fontWeight: step.active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
