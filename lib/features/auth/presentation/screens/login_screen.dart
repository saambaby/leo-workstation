import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../l10n/auth_strings.dart';
import '../notifiers/auth_notifier.dart';
import '../providers/auth_ui_provider.dart';
import '../widgets/auth_form_shell.dart';
import '../widgets/auth_screen_layout.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({
    super.key,
    this.passwordResetSuccess = false,
  });

  final bool passwordResetSuccess;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  var _rememberDevice = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await ref.read(authNotifierProvider.notifier).login(
          email: _email.text.trim(),
          password: _password.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(authUiProvider);

    return AuthFormShell(
      subtitle: AuthStrings.loginSub,
      error: ui.errorMessage,
      header: [
        if (widget.passwordResetSuccess)
          LeoNote(
            variant: LeoNoteVariant.info,
            icon: CupertinoIcons.checkmark_circle,
            margin: const EdgeInsets.only(bottom: 16),
            child: const Text(AuthStrings.resetSuccessLoginNote),
          ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LeoTextField(
            label: AuthStrings.email,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            bottomSpacing: 14,
          ),
          LeoTextField(
            label: AuthStrings.password,
            controller: _password,
            obscureText: true,
            textInputAction: TextInputAction.done,
            bottomSpacing: 6,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LeoCheckbox(
                  label: AuthStrings.rememberDevice,
                  value: _rememberDevice,
                  onChanged: (v) => setState(() => _rememberDevice = v),
                ),
                LeoLink(
                  label: AuthStrings.forgotPassword,
                  onPressed: () => context.push('/forgot-password'),
                ),
              ],
            ),
          ),
          LeoButton(
            label: ui.isLoading ? AuthStrings.signingIn : AuthStrings.signIn,
            fullWidth: true,
            enabled: !ui.isLoading,
            onPressed: _submit,
          ),
          LeoNote(
            variant: LeoNoteVariant.warn,
            icon: CupertinoIcons.lock,
            margin: const EdgeInsets.only(top: 14),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: AuthStrings.mfaPrivilegedWarning),
                  TextSpan(
                    text: AuthStrings.mfaPrivilegedWarningBold,
                    style: LeoTypography.note.copyWith(
                      color: LeoColors.signalWarn,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: AuthStrings.mfaPrivilegedWarningEnd),
                ],
              ),
            ),
          ),
          const LeoDivider(AuthStrings.newToLeo),
          LeoButton(
            label: AuthStrings.createAccount,
            variant: LeoButtonVariant.ghost,
            fullWidth: true,
            onPressed: () => context.push('/signup'),
          ),
        ],
      ),
    );
  }
}
