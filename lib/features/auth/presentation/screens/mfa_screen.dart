import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../l10n/auth_strings.dart';
import '../notifiers/auth_notifier.dart';
import '../state/auth_state.dart';
import '../widgets/auth_screen_layout.dart';
import '../widgets/otp_input_row.dart';

class MfaScreen extends ConsumerWidget {
  const MfaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authNotifierProvider);
    final loading = auth is AuthLoading;
    final error = auth is AuthError ? auth.message : null;

    return AuthScreenLayout(
      title: AuthStrings.mfaTitle,
      subtitle: AuthStrings.mfaSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (error != null) ...[
            AuthErrorBanner(message: error),
            const SizedBox(height: 16),
          ],
          OtpInputRow(
            enabled: !loading,
            onCompleted: (code) =>
                ref.read(authNotifierProvider.notifier).submitMfa(code: code),
          ),
          const SizedBox(height: 24),
          Semantics(
            button: true,
            label: AuthStrings.useBackupCode,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: const Text(
                AuthStrings.useBackupCode,
                style: TextStyle(fontSize: 13, color: LeoColors.black100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MfaEnrollScreen extends ConsumerWidget {
  const MfaEnrollScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authNotifierProvider);
    final loading = auth is AuthLoading;
    final error = auth is AuthError ? auth.message : null;

    return AuthScreenLayout(
      title: AuthStrings.mfaEnrollTitle,
      subtitle: AuthStrings.mfaEnrollSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (error != null) ...[
            AuthErrorBanner(message: error),
            const SizedBox(height: 16),
          ],
          Container(
            height: 160,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: LeoColors.black700,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: LeoColors.black500),
            ),
            child: const Text(
              'QR placeholder',
              style: TextStyle(color: LeoColors.black200, fontSize: 13),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'otpauth://totp/Leo:mock@leo.app?secret=MOCKSECRET',
            style: TextStyle(
              fontSize: 11,
              color: LeoColors.black200,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 24),
          OtpInputRow(
            enabled: !loading,
            onCompleted: (code) =>
                ref.read(authNotifierProvider.notifier).submitMfa(code: code),
          ),
        ],
      ),
    );
  }
}
