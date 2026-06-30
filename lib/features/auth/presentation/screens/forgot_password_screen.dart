import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/auth_strings.dart';
import '../notifiers/auth_notifier.dart';
import '../providers/auth_ui_provider.dart';
import '../widgets/auth_form_shell.dart';
import '../widgets/auth_screen_layout.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    if (email.isEmpty) return;

    await ref.read(authNotifierProvider.notifier).forgotPassword(email: email);
    if (!mounted) return;
    context.push('/forgot-password/verify', extra: email);
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(authUiProvider);

    return AuthFormShell(
      subtitle: AuthStrings.forgotSub,
      header: [
        LeoNote(
          variant: LeoNoteVariant.info,
          icon: CupertinoIcons.mail,
          margin: const EdgeInsets.only(bottom: 16),
          child: const Text(AuthStrings.forgotInfoNote),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LeoTextField(
            label: AuthStrings.email,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            placeholder: 'you@organization.com',
            bottomSpacing: 16,
          ),
          LeoButton(
            label: AuthStrings.sendResetCode,
            fullWidth: true,
            enabled: !ui.forgotPasswordSending,
            onPressed: _submit,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: LeoLink(
                label: AuthStrings.backToSignIn,
                onPressed: () => context.pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
