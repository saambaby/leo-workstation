import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../l10n/auth_strings.dart';
import '../notifiers/auth_notifier.dart';
import '../widgets/auth_screen_layout.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _email = TextEditingController();
  var _submitted = false;
  var _submitting = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    await ref.read(authNotifierProvider.notifier).forgotPassword(
          email: _email.text.trim(),
        );
    if (mounted) {
      setState(() {
        _submitting = false;
        _submitted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenLayout(
      title: AuthStrings.forgotTitle,
      subtitle: _submitted ? null : AuthStrings.forgotSubtitle,
      child: _submitted
          ? const Text(
              AuthStrings.forgotSuccess,
              style: TextStyle(color: LeoColors.black100, height: 1.5),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthTextField(
                  label: AuthStrings.email,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 24),
                Semantics(
                  button: true,
                  label: AuthStrings.sendResetLink,
                  child: CupertinoButton.filled(
                    onPressed: _submitting ? null : _submit,
                    child: const Text(AuthStrings.sendResetLink),
                  ),
                ),
                CupertinoButton(
                  onPressed: () => context.pop(),
                  child: const Text('Back to sign in'),
                ),
              ],
            ),
    );
  }
}
