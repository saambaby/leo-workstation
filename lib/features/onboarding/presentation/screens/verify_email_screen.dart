import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/widgets/auth_screen_layout.dart';
import '../../../auth/presentation/widgets/otp_input_row.dart';
import '../../domain/onboarding_models.dart';
import '../../l10n/onboarding_strings.dart';
import '../notifiers/signup_notifier.dart';
import '../widgets/leo_wizard_steps.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({
    super.key,
    required this.verifyContext,
    this.token,
  });

  final SignupVerifyContext verifyContext;
  final String? token;

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  var _code = '';
  var _cooldown = 0;

  @override
  void initState() {
    super.initState();
    if (widget.token != null && widget.token!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _verify(widget.token!));
    }
  }

  Future<void> _verify(String token) async {
    final ok = await ref.read(signupNotifierProvider.notifier).verifyEmail(
          token: token,
          email: widget.verifyContext.email,
        );
    if (!mounted || !ok) return;
    context.go('/login?verified=success');
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

  void _onResendTap() {
    if (_cooldown > 0) return;
    _startCooldown();
    // Backend resend endpoint not available yet — cooldown UI only.
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(signupNotifierProvider);
    final masked = _maskEmail(widget.verifyContext.email);

    return AuthStage(
      child: AuthCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LeoLogo(),
            const LeoAuthSub(OnboardingStrings.verifySub),
            const LeoWizardSteps(
              steps: [
                WizardStep(label: OnboardingStrings.stepAccountType, done: true),
                WizardStep(label: OnboardingStrings.stepDetails, done: true),
                WizardStep(
                  label: OnboardingStrings.stepVerifyEmail,
                  active: true,
                ),
              ],
            ),
            if (ui.error != null) ...[
              AuthErrorBanner(message: ui.error!),
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
              enabled: !ui.loading,
              onChanged: (c) => setState(() => _code = c),
              onCompleted: _verify,
            ),
            LeoButton(
              label: OnboardingStrings.verifyEmail,
              fullWidth: true,
              enabled: !ui.loading && _code.length == 6,
              onPressed: () => _verify(_code),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_cooldown > 0)
                    Text(
                      '${OnboardingStrings.resendIn} 0:$_cooldown',
                      style: LeoTypography.mono10,
                    )
                  else
                    LeoLink(
                      label: OnboardingStrings.resendCode,
                      onPressed: _onResendTap,
                    ),
                  LeoLink(
                    label: OnboardingStrings.changeEmail,
                    onPressed: () => context.go('/signup'),
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
