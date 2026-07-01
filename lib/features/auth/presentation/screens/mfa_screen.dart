import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../l10n/auth_strings.dart';
import '../notifiers/auth_notifier.dart';
import '../providers/auth_ui_provider.dart';
import '../widgets/auth_form_shell.dart';
import '../widgets/auth_screen_layout.dart';
import '../widgets/mfa_code_form.dart';

class MfaScreen extends ConsumerWidget {
  const MfaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(authUiProvider);

    return AuthFormShell(
      subtitle: AuthStrings.mfaSub,
      error: ui.errorMessage,
      header: [
        LeoNote(
          variant: LeoNoteVariant.info,
          icon: CupertinoIcons.device_phone_portrait,
          margin: const EdgeInsets.only(bottom: 6),
          child: const Text(AuthStrings.mfaInfoNote),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MfaCodeForm(
            loading: ui.isLoading,
            onSubmit: (code) =>
                ref.read(authNotifierProvider.notifier).submitMfa(code: code),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LeoLink(label: AuthStrings.useBackupCode, onPressed: () {}),
                LeoLink(label: AuthStrings.resend, onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MfaEnrollScreen extends ConsumerWidget {
  const MfaEnrollScreen({super.key});

  static const _manualKey = 'JBSW Y3DP EHPK 3PXP';
  static const _backupCodes = [
    '8F2K-9QXM',
    'P4LM-7TWZ',
    '3RJD-1VBN',
    'XK90-22HA',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(authUiProvider);

    return AuthFormShell(
      subtitle: AuthStrings.mfaEnrollSub,
      error: ui.errorMessage,
      width: AuthCardWidth.enroll,
      alignTop: true,
      header: [
        LeoNote(
          variant: LeoNoteVariant.warn,
          icon: CupertinoIcons.shield,
          margin: const EdgeInsets.only(bottom: 18),
          child: Text.rich(
            TextSpan(
              style: LeoTypography.note.copyWith(color: LeoColors.signalWarn),
              children: [
                TextSpan(text: AuthStrings.mfaEnrollRoleWarnPrefix),
                TextSpan(
                  text: 'lsp_admin',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: AuthStrings.mfaEnrollRoleWarnSuffix),
              ],
            ),
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _QrPlaceholder(),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AuthStrings.mfaEnrollStep1,
                        style: LeoTypography.fieldLabel,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AuthStrings.mfaEnrollStep1Hint,
                        style: LeoTypography.mono10,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AuthStrings.mfaEnrollManualKey,
                        style: LeoTypography.fieldLabel,
                      ),
                      const SizedBox(height: 6),
                      LeoCard(
                        backgroundColor: LeoColors.black700,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        child: Text(_manualKey, style: LeoTypography.mono12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            AuthStrings.mfaEnrollStep2,
            style: LeoTypography.fieldLabel,
          ),
          MfaCodeForm(
            loading: ui.isLoading,
            submitLabel: AuthStrings.confirmEnrollment,
            onSubmit: (code) =>
                ref.read(authNotifierProvider.notifier).submitMfa(code: code),
          ),
          LeoCard(
            backgroundColor: LeoColors.black700,
            margin: const EdgeInsets.symmetric(vertical: 14),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AuthStrings.mfaEnrollStep3,
                      style: LeoTypography.fieldLabel,
                    ),
                    LeoLink(
                      label: AuthStrings.mfaEnrollDownload,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  childAspectRatio: 3.5,
                  children: _backupCodes
                      .map(
                        (code) => Align(
                          alignment: Alignment.centerLeft,
                          child: Text(code, style: LeoTypography.mono11),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  AuthStrings.mfaEnrollBackupWarn,
                  style: LeoTypography.mono9.copyWith(
                    color: LeoColors.signalWarn,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QrPlaceholder extends StatelessWidget {
  const _QrPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(LeoRadii.md),
      ),
      child: GridView.count(
        crossAxisCount: 7,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        children: List.generate(49, (i) {
          const filled = {0, 1, 7, 8, 42, 43, 47, 48, 23, 31, 17, 40, 38, 27};
          return DecoratedBox(
            decoration: BoxDecoration(
              color: filled.contains(i) ? CupertinoColors.black : null,
            ),
          );
        }),
      ),
    );
  }
}
