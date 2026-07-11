import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/l10n/auth_strings.dart';
import '../../../auth/presentation/widgets/auth_screen_layout.dart';
import '../../../auth/presentation/widgets/otp_input_row.dart';
import '../../domain/onboarding_entities.dart';
import '../../l10n/onboarding_strings.dart';
import '../notifiers/signup_notifier.dart';
import '../widgets/leo_wizard_steps.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({
    super.key,
    required this.pendingContext,
  });

  final VerifyEmailPendingContext pendingContext;

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  var _code = '';
  var _cooldown = 0;

  Future<void> _verify(String code) async {
    if (code.length != 6) return;
    await ref.read(signupNotifierProvider.notifier).verifyEmail(
          email: widget.pendingContext.email,
          code: code,
        );
  }

  void _startCooldown() {
    setState(() => _cooldown = 42);
    Future.doWhile(() async {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _cooldown--);
      return _cooldown > 0;
    });
  }

  Future<void> _resend() async {
    if (_cooldown > 0) return;
    _startCooldown();
    await ref
        .read(signupNotifierProvider.notifier)
        .resendVerifyEmail(email: widget.pendingContext.email);
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(signupUiProvider);
    final fromSignup = widget.pendingContext.source == VerifyEmailSource.signup;
    final masked = _maskEmail(widget.pendingContext.email);

    return AuthStage(
      child: AuthCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LeoLogo(),
            LeoAuthSub(
              fromSignup
                  ? OnboardingStrings.verifySub
                  : OnboardingStrings.verifyLoginSub,
            ),
            if (fromSignup)
              const LeoWizardSteps(
                steps: [
                  WizardStep(
                    label: OnboardingStrings.stepAccountType,
                    done: true,
                  ),
                  WizardStep(label: OnboardingStrings.stepDetails, done: true),
                  WizardStep(
                    label: OnboardingStrings.stepVerifyEmail,
                    active: true,
                  ),
                ],
              ),
            if (ui.errorMessage != null) ...[
              AuthErrorBanner(message: ui.errorMessage!),
              const SizedBox(height: 16),
            ],
            LeoNote(
              variant: LeoNoteVariant.info,
              icon: CupertinoIcons.mail,
              margin: const EdgeInsets.only(bottom: 14),
              child: Text.rich(
                TextSpan(
                  style: LeoTypography.note,
                  children: [
                    const TextSpan(text: OnboardingStrings.verifyNotePrefix),
                    TextSpan(
                      text: masked,
                      style: LeoTypography.note.copyWith(
                        color: LeoColors.signalWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: OnboardingStrings.verifyNoteSuffix),
                  ],
                ),
              ),
            ),
            Text(
              OnboardingStrings.verificationCode,
              style: LeoTypography.fieldLabel,
            ),
            const SizedBox(height: 6),
            OtpInputRow(
              enabled: !ui.isLoading,
              onChanged: (c) => setState(() => _code = c),
              onCompleted: _verify,
            ),
            LeoButton(
              label: OnboardingStrings.verifyEmail,
              fullWidth: true,
              enabled: !ui.isLoading && _code.length == 6,
              onPressed: () => _verify(_code),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (ui.resendVerifySending || _cooldown > 0)
                    Text(
                      ui.resendVerifySending
                          ? AuthStrings.resendingCode
                          : '${OnboardingStrings.resendIn} 0:$_cooldown',
                      style: LeoTypography.mono10,
                    )
                  else
                    LeoLink(
                      label: OnboardingStrings.resendCode,
                      onPressed: _resend,
                    ),
                  if (fromSignup)
                    LeoLink(
                      label: OnboardingStrings.changeEmail,
                      onPressed: () => context.go('/signup'),
                    )
                  else
                    LeoLink(
                      label: OnboardingStrings.goToSignIn,
                      onPressed: () => context.go('/login'),
                    ),
                ],
              ),
            ),
          ],
        ),
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
