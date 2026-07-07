import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/platform/email_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/widgets/auth_screen_layout.dart';
import '../../domain/onboarding_entities.dart';
import '../../l10n/onboarding_strings.dart';
import '../widgets/leo_wizard_steps.dart';

class VerifyEmailPendingScreen extends ConsumerWidget {
  const VerifyEmailPendingScreen({
    super.key,
    required this.pendingContext,
  });

  final VerifyEmailPendingContext pendingContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fromSignup = pendingContext.source == VerifyEmailSource.signup;
    final masked = _maskEmail(pendingContext.email);

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
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Icon(
                CupertinoIcons.mail_solid,
                size: 40,
                color: LeoColors.signalInfo,
              ),
            ),
            Text(
              OnboardingStrings.verifyPendingTitle,
              textAlign: TextAlign.center,
              style: LeoTypography.pageTitle,
            ),
            const SizedBox(height: 14),
            LeoNote(
              variant: LeoNoteVariant.info,
              icon: CupertinoIcons.mail,
              margin: const EdgeInsets.only(bottom: 14),
              child: Text.rich(
                TextSpan(
                  style: LeoTypography.note,
                  children: [
                    const TextSpan(text: OnboardingStrings.verifyLinkSentPrefix),
                    TextSpan(
                      text: masked,
                      style: LeoTypography.note.copyWith(
                        color: LeoColors.signalWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: OnboardingStrings.verifyLinkSentSuffix),
                  ],
                ),
              ),
            ),
            Text(
              OnboardingStrings.verifyPendingBody,
              style: LeoTypography.note,
            ),
            const SizedBox(height: 8),
            Text(
              OnboardingStrings.verifyLinkExpires,
              style: LeoTypography.mono10,
            ),
            const SizedBox(height: 20),
            LeoButton(
              label: OnboardingStrings.openEmailApp,
              fullWidth: true,
              onPressed: openEmailApp,
            ),
            const SizedBox(height: 10),
            LeoButton(
              label: OnboardingStrings.goToSignIn,
              variant: LeoButtonVariant.ghost,
              fullWidth: true,
              onPressed: () => context.go('/login'),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: LeoLink(
                  label: OnboardingStrings.wrongEmailSignup,
                  onPressed: () => context.go('/signup'),
                ),
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
