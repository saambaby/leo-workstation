import 'package:flutter/cupertino.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/onboarding_models.dart';

/// Multi-select language chips with catalog picker.
class LanguageChipPicker extends StatelessWidget {
  const LanguageChipPicker({
    super.key,
    required this.languages,
    required this.selectedIds,
    required this.onToggle,
    required this.onAddFromCatalog,
  });

  final List<CatalogLanguage> languages;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;
  final VoidCallback onAddFromCatalog;

  @override
  Widget build(BuildContext context) {
    final selected =
        languages.where((l) => selectedIds.contains(l.id)).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final lang in selected)
          _LanguageChip(
            label: lang.name,
            live: lang.isSigned,
            selected: true,
            onTap: () => onToggle(lang.id),
          ),
        _LanguageChip(
          label: '+ add',
          dashed: true,
          onTap: onAddFromCatalog,
        ),
      ],
    );
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({
    required this.label,
    required this.onTap,
    this.live = false,
    this.selected = false,
    this.dashed = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool live;
  final bool selected;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: selected && live
              ? LeoColors.signalLive.withValues(alpha: 0.1)
              : LeoColors.black700,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: dashed
                ? LeoColors.black400
                : live
                    ? LeoColors.signalLive.withValues(alpha: 0.3)
                    : LeoColors.black500,
            style: dashed ? BorderStyle.none : BorderStyle.solid,
          ),
        ),
        child: Text(
          selected && live ? '$label ✓' : label,
          style: LeoTypography.chip,
        ),
      ),
    );
  }
}

Future<void> showLanguageCatalogPicker({
  required BuildContext context,
  required List<CatalogLanguage> languages,
  required Set<String> selectedIds,
  required ValueChanged<String> onSelect,
}) {
  final available =
      languages.where((l) => !selectedIds.contains(l.id)).toList();

  return showCupertinoModalPopup<void>(
    context: context,
    builder: (ctx) => CupertinoActionSheet(
      title: const Text('Add language'),
      actions: [
        for (final lang in available)
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(ctx);
              onSelect(lang.id);
            },
            child: Text(lang.name),
          ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(ctx),
        child: const Text('Cancel'),
      ),
    ),
  );
}
