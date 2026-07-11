import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../l10n/auth_strings.dart';
import '../notifiers/auth_notifier.dart';
import '../state/auth_state.dart';
import '../widgets/auth_form_shell.dart';
import '../widgets/auth_screen_layout.dart';
import '../widgets/mfa_code_form.dart';

class MfaScreen extends ConsumerWidget {
  const MfaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(authUiProvider);
    final mfaLoading = ui.loadingReason == AuthLoadingReason.mfa;

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
      child: MfaCodeForm(
        loading: mfaLoading,
        onSubmit: (code) =>
            ref.read(authNotifierProvider.notifier).submitMfa(code: code),
      ),
    );
  }
}

class MfaEnrollScreen extends ConsumerWidget {
  const MfaEnrollScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(authUiProvider);
    final manualKey = ui.mfaSecret ?? '';
    final mfaLoading = ui.loadingReason == AuthLoadingReason.mfa;

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
                _MfaQrCode(otpauthUrl: ui.otpauthUrl),
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
                        child: Semantics(
                          label: AuthStrings.mfaEnrollManualKeySemanticLabel,
                          child: Text(manualKey, style: LeoTypography.mono12),
                        ),
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
            loading: mfaLoading,
            submitLabel: AuthStrings.confirmEnrollment,
            onSubmit: (code) =>
                ref.read(authNotifierProvider.notifier).submitMfa(code: code),
          ),
        ],
      ),
    );
  }
}

/// Renders the server's `otpauth_url` as a real, scannable QR code. Falls
/// back to a loading indicator if the enrollment payload hasn't arrived yet
/// (it should always be present by the time this screen is reachable).
class _MfaQrCode extends StatelessWidget {
  const _MfaQrCode({required this.otpauthUrl});

  final String? otpauthUrl;

  @override
  Widget build(BuildContext context) {
    final data = otpauthUrl;
    return Semantics(
      label: AuthStrings.mfaEnrollQrSemanticLabel,
      image: true,
      child: Container(
        width: 140,
        height: 140,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(LeoRadii.md),
        ),
        child: (data == null || data.isEmpty)
            ? const Center(child: CupertinoActivityIndicator())
            : QrImageView(
                data: data,
                version: QrVersions.auto,
                backgroundColor: CupertinoColors.white,
                padding: EdgeInsets.zero,
              ),
      ),
    );
  }
}
