import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../l10n/auth_strings.dart';
import '../notifiers/auth_notifier.dart';
import '../state/auth_state.dart';
import '../widgets/auth_form_shell.dart';
import '../widgets/auth_screen_layout.dart';
import '../widgets/otp_input_row.dart';

class ForgotPasswordVerifyScreen extends ConsumerStatefulWidget {
  const ForgotPasswordVerifyScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<ForgotPasswordVerifyScreen> createState() =>
      _ForgotPasswordVerifyScreenState();
}

class _ForgotPasswordVerifyScreenState
    extends ConsumerState<ForgotPasswordVerifyScreen> {
  var _code = '';

  Future<void> _resend() async {
    await ref
        .read(authNotifierProvider.notifier)
        .resendResetCode(email: widget.email);
  }

  Future<void> _continue([String? completed]) async {
    final code = completed ?? _code;
    if (code.length != 6) return;
    final ticket = await ref
        .read(authNotifierProvider.notifier)
        .verifyResetCode(email: widget.email, code: code);
    if (!mounted || ticket == null) return;
    context.go('/reset-password', extra: ticket);
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(authUiProvider);
    final masked = _maskEmail(widget.email);
    final verifying = ui.loadingReason == AuthLoadingReason.passwordReset;

    return AuthFormShell(
      subtitle: AuthStrings.forgotVerifySub,
      error: ui.errorMessage,
      header: [
        LeoNote(
          variant: LeoNoteVariant.info,
          icon: CupertinoIcons.mail,
          margin: const EdgeInsets.only(bottom: 14),
          child: Text.rich(
            TextSpan(
              style: LeoTypography.note,
              children: [
                TextSpan(text: AuthStrings.forgotVerifyNotePrefix),
                TextSpan(
                  text: masked,
                  style: LeoTypography.note.copyWith(
                    color: LeoColors.signalWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: AuthStrings.forgotVerifyNoteSuffix),
              ],
            ),
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AuthStrings.forgotVerifyCodeLabel,
            style: LeoTypography.fieldLabel,
          ),
          const SizedBox(height: 6),
          OtpInputRow(
            enabled: !verifying,
            onChanged: (code) => setState(() => _code = code),
            onCompleted: _continue,
          ),
          LeoButton(
            label: AuthStrings.continueToNewPassword,
            fullWidth: true,
            enabled: !verifying && _code.length == 6,
            onPressed: () => _continue(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (ui.resendCodeSending)
                  Text(
                    AuthStrings.resendingCode,
                    style: LeoTypography.mono10,
                  )
                else
                  LeoLink(
                    label: AuthStrings.resendCode,
                    onPressed: _resend,
                  ),
                LeoLink(
                  label: AuthStrings.backToSignIn,
                  onPressed: () => context.go('/login'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _maskEmail(String email) {
  final parts = email.split('@');
  if (parts.length != 2 || parts[0].isEmpty) return email;
  final local = parts[0];
  final maskedLocal = local.length <= 2
      ? '${local[0]}…'
      : '${local[0]}…${local[local.length - 1]}';
  return '$maskedLocal@${parts[1]}';
}
