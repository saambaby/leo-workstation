import 'package:flutter/cupertino.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/widgets/design/leo_button.dart';
import '../../domain/onboarding_models.dart';

class CertificationList extends StatelessWidget {
  const CertificationList({
    super.key,
    required this.entries,
    required this.onUploadProof,
    required this.onAdd,
  });

  final List<InterpreterCertEntry> entries;
  final ValueChanged<int> onUploadProof;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < entries.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: LeoColors.black700,
                borderRadius: BorderRadius.circular(LeoRadii.md),
                border: Border.all(color: LeoColors.black500),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entries[i].name,
                          style: LeoTypography.body12Medium,
                        ),
                        Text(
                          entries[i].certNumber != null
                              ? 'Cert #${entries[i].certNumber}'
                              : 'optional',
                          style: LeoTypography.mono9,
                        ),
                      ],
                    ),
                  ),
                  LeoButton(
                    label: entries[i].proofUploaded ? 'Uploaded' : 'Upload proof',
                    variant: LeoButtonVariant.ghost,
                    onPressed: () => onUploadProof(i),
                  ),
                ],
              ),
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onAdd,
            child: Text('+ add', style: LeoTypography.link),
          ),
        ),
      ],
    );
  }
}

Future<InterpreterCertEntry?> showCertCatalogPicker({
  required BuildContext context,
  required List<CatalogCertification> certifications,
}) async {
  CatalogCertification? picked;
  await showCupertinoModalPopup<void>(
    context: context,
    builder: (ctx) => CupertinoActionSheet(
      title: const Text('Add certification'),
      actions: [
        for (final cert in certifications)
          CupertinoActionSheetAction(
            onPressed: () {
              picked = cert;
              Navigator.pop(ctx);
            },
            child: Text('${cert.issuer} — ${cert.name}'),
          ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(ctx),
        child: const Text('Cancel'),
      ),
    ),
  );
  if (picked == null) return null;
  return InterpreterCertEntry(
    certificationId: picked!.id,
    name: '${picked!.issuer} — ${picked!.name}',
  );
}
