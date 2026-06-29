import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/auth_strings.dart';
import '../notifiers/auth_notifier.dart';
import '../state/auth_state.dart';
import '../widgets/auth_screen_layout.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, this.token});

  final String? token;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await ref.read(authNotifierProvider.notifier).resetPassword(
          token: widget.token ?? '',
          password: _password.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifierProvider);
    final loading = auth is AuthLoading;
    final error = auth is AuthError ? auth.message : null;

    return AuthScreenLayout(
      title: AuthStrings.resetTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (error != null) ...[
            AuthErrorBanner(message: error),
            const SizedBox(height: 16),
          ],
          AuthTextField(
            label: AuthStrings.password,
            controller: _password,
            obscureText: true,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 24),
          Semantics(
            button: true,
            label: AuthStrings.resetPassword,
            child: CupertinoButton.filled(
              onPressed: loading ? null : _submit,
              child: const Text(AuthStrings.resetPassword),
            ),
          ),
        ],
      ),
    );
  }
}

class InviteAcceptScreen extends ConsumerStatefulWidget {
  const InviteAcceptScreen({super.key, this.token});

  final String? token;

  @override
  ConsumerState<InviteAcceptScreen> createState() => _InviteAcceptScreenState();
}

class _InviteAcceptScreenState extends ConsumerState<InviteAcceptScreen> {
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await ref.read(authNotifierProvider.notifier).acceptInvite(
          token: widget.token ?? '',
          password: _password.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifierProvider);
    final loading = auth is AuthLoading;
    final error = auth is AuthError ? auth.message : null;

    return AuthScreenLayout(
      title: AuthStrings.inviteTitle,
      subtitle: AuthStrings.inviteSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (error != null) ...[
            AuthErrorBanner(message: error),
            const SizedBox(height: 16),
          ],
          AuthTextField(
            label: AuthStrings.password,
            controller: _password,
            obscureText: true,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 24),
          Semantics(
            button: true,
            label: AuthStrings.acceptInvite,
            child: CupertinoButton.filled(
              onPressed: loading ? null : _submit,
              child: const Text(AuthStrings.acceptInvite),
            ),
          ),
        ],
      ),
    );
  }
}
