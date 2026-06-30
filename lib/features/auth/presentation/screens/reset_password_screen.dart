import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../l10n/auth_strings.dart';
import '../notifiers/auth_notifier.dart';
import '../providers/auth_ui_provider.dart';
import '../widgets/auth_form_shell.dart';
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
  final _confirmPassword = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final token = widget.token;
    if (token == null || token.isEmpty) return;

    if (_password.text != _confirmPassword.text) {
      setState(() => _localError = AuthStrings.passwordMismatch);
      return;
    }

    setState(() => _localError = null);
    final ok = await ref.read(authNotifierProvider.notifier).resetPassword(
          token: token,
          password: _password.text,
        );
    if (!mounted || !ok) return;
    context.go('/login?reset=success');
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(authUiProvider);
    final error = _localError ?? ui.errorMessage;

    return AuthFormShell(
      subtitle: AuthStrings.resetSub,
      error: error,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LeoTextField(
            label: AuthStrings.newPassword,
            controller: _password,
            obscureText: true,
            bottomSpacing: 8,
          ),
          const _PasswordStrengthBar(),
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text(
              AuthStrings.passwordStrengthStrong,
              style: LeoTypography.mono9.copyWith(color: LeoColors.signalLive),
            ),
          ),
          LeoTextField(
            label: AuthStrings.confirmNewPassword,
            controller: _confirmPassword,
            obscureText: true,
            textInputAction: TextInputAction.done,
            bottomSpacing: 6,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              AuthStrings.passwordPolicyHint,
              style: LeoTypography.mono9,
            ),
          ),
          LeoButton(
            label: AuthStrings.setPasswordAndSignIn,
            fullWidth: true,
            enabled: !ui.isLoading,
            onPressed: _submit,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: LeoLink(
                label: AuthStrings.enterDifferentCode,
                onPressed: () => context.go('/forgot-password'),
              ),
            ),
          ),
          LeoNote(
            variant: LeoNoteVariant.warn,
            icon: CupertinoIcons.exclamationmark_circle,
            margin: const EdgeInsets.only(top: 14),
            child: const Text(AuthStrings.resetSessionWarn),
          ),
        ],
      ),
    );
  }
}

class _PasswordStrengthBar extends StatelessWidget {
  const _PasswordStrengthBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: List.generate(4, (i) {
          final filled = i < 3;
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
              decoration: BoxDecoration(
                color: filled ? LeoColors.signalLive : LeoColors.black600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
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
  final _name = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
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
    final ui = ref.watch(authUiProvider);

    return AuthFormShell(
      subtitle: AuthStrings.inviteSub,
      error: ui.errorMessage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LeoCard(
            backgroundColor: LeoColors.black700,
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: LeoColors.black600,
                    shape: BoxShape.circle,
                    border: Border.all(color: LeoColors.black400),
                  ),
                  child: Text('AL', style: LeoTypography.logo.copyWith(fontSize: 13)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AuthStrings.inviteOrgName,
                        style: LeoTypography.body13Medium,
                      ),
                      const SizedBox(height: 2),
                      Text.rich(
                        TextSpan(
                          style: LeoTypography.mono10,
                          children: [
                            TextSpan(text: AuthStrings.inviteRoleLabel),
                            TextSpan(
                              text: AuthStrings.inviteRoleName,
                              style: LeoTypography.mono10.copyWith(
                                color: LeoColors.signalWhite,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const LeoChip(
                  label: AuthStrings.inviteRoleChip,
                  variant: LeoChipVariant.info,
                ),
              ],
            ),
          ),
          LeoTextField(
            label: AuthStrings.yourName,
            controller: _name,
            placeholder: AuthStrings.namePlaceholder,
            bottomSpacing: 14,
          ),
          LeoTextField(
            label: AuthStrings.setPassword,
            controller: _password,
            obscureText: true,
            placeholder: AuthStrings.passwordPlaceholder,
            textInputAction: TextInputAction.done,
            bottomSpacing: 6,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              AuthStrings.invitePasswordHint,
              style: LeoTypography.mono9,
            ),
          ),
          LeoButton(
            label: AuthStrings.acceptAndJoin,
            fullWidth: true,
            enabled: !ui.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
