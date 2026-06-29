import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../l10n/auth_strings.dart';
import '../notifiers/auth_notifier.dart';
import '../state/auth_state.dart';
import '../widgets/auth_screen_layout.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

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
    final auth = ref.watch(authNotifierProvider);
    final loading = auth is AuthLoading;
    final error = auth is AuthError ? auth.message : null;

    return AuthScreenLayout(
      title: AuthStrings.signIn,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (error != null) ...[
            AuthErrorBanner(message: error),
            const SizedBox(height: 16),
          ],
          AuthTextField(
            label: AuthStrings.email,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          AuthTextField(
            label: AuthStrings.password,
            controller: _password,
            obscureText: true,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 12),
          Semantics(
            checked: _rememberDevice,
            label: AuthStrings.rememberDevice,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              alignment: Alignment.centerLeft,
              onPressed: () => setState(() => _rememberDevice = !_rememberDevice),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _rememberDevice
                        ? CupertinoIcons.checkmark_square_fill
                        : CupertinoIcons.square,
                    size: 18,
                    color: LeoColors.black100,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    AuthStrings.rememberDevice,
                    style: TextStyle(fontSize: 13, color: LeoColors.black100),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Semantics(
            button: true,
            label: AuthStrings.signIn,
            child: CupertinoButton.filled(
              onPressed: loading ? null : _submit,
              child: Text(loading ? AuthStrings.signingIn : AuthStrings.signIn),
            ),
          ),
          const SizedBox(height: 16),
          Semantics(
            button: true,
            label: AuthStrings.forgotPassword,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => context.push('/forgot-password'),
              child: const Text(
                AuthStrings.forgotPassword,
                style: TextStyle(fontSize: 13, color: LeoColors.black100),
              ),
            ),
          ),
          Semantics(
            button: true,
            label: AuthStrings.createAccount,
            child: CupertinoButton(
              padding: const EdgeInsets.only(top: 8),
              onPressed: () => context.push('/signup'),
              child: const Text(
                AuthStrings.createAccount,
                style: TextStyle(fontSize: 13, color: LeoColors.signalInfo),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
