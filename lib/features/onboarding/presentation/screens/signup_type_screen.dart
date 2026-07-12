import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/widgets/auth_screen_layout.dart';
import '../../domain/onboarding_entities.dart';
import '../../l10n/onboarding_strings.dart';
import '../widgets/leo_opt_card.dart';
import '../widgets/leo_wizard_steps.dart';

enum _TopLevel { personal, business }

enum _BusinessType { customer, lsp }

class SignupTypeScreen extends ConsumerStatefulWidget {
  const SignupTypeScreen({super.key});

  @override
  ConsumerState<SignupTypeScreen> createState() => _SignupTypeScreenState();
}

class _SignupTypeScreenState extends ConsumerState<SignupTypeScreen> {
  _TopLevel _top = _TopLevel.personal;
  _BusinessType _business = _BusinessType.customer;

  SignupPath? get _selectedPath {
    if (_top == _TopLevel.personal) return SignupPath.personal;
    if (_business == _BusinessType.customer) return SignupPath.customer;
    if (_business == _BusinessType.lsp) return SignupPath.lsp;
    return null;
  }

  void _continue() {
    final path = _selectedPath;
    if (path == null) return;
    context.push('/signup/details', extra: SignupDraft(path: path));
  }

  @override
  Widget build(BuildContext context) {
    return AuthStage(
      child: AuthCard(
        width: AuthCardWidth.wide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LeoLogo(),
            const LeoAuthSub(OnboardingStrings.signupSub),
            const LeoWizardSteps(
              steps: [
                WizardStep(label: OnboardingStrings.stepAccountType, active: true),
                WizardStep(label: OnboardingStrings.stepDetails),
                WizardStep(label: OnboardingStrings.stepVerifyEmail),
              ],
            ),
            Text(
              OnboardingStrings.whatDescribesYou,
              style: LeoTypography.fieldLabel,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: LeoOptCard(
                    icon: '👤',
                    title: OnboardingStrings.personalTitle,
                    subtitle: OnboardingStrings.personalSubtitle,
                    selected: _top == _TopLevel.personal,
                    onTap: () => setState(() => _top = _TopLevel.personal),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: LeoOptCard(
                    icon: '🏢',
                    title: OnboardingStrings.businessTitle,
                    subtitle: OnboardingStrings.businessSubtitle,
                    selected: _top == _TopLevel.business,
                    onTap: () => setState(() => _top = _TopLevel.business),
                  ),
                ),
              ],
            ),
            if (_top == _TopLevel.business) ...[
              const SizedBox(height: 14),
              Text.rich(
                TextSpan(
                  style: LeoTypography.fieldLabel,
                  children: [
                    const TextSpan(text: OnboardingStrings.businessSubTypeLabel),
                    TextSpan(
                      text: ' ${OnboardingStrings.businessSubTypeHint}',
                      style: LeoTypography.mono9,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: LeoOptCard(
                      title: OnboardingStrings.customerTitle,
                      subtitle: OnboardingStrings.customerSubtitle,
                      selected: _business == _BusinessType.customer,
                      compact: true,
                      onTap: () =>
                          setState(() => _business = _BusinessType.customer),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LeoOptCard(
                      title: OnboardingStrings.lspTitle,
                      subtitle: OnboardingStrings.lspSubtitle,
                      selected: _business == _BusinessType.lsp,
                      compact: true,
                      onTap: () => setState(() => _business = _BusinessType.lsp),
                    ),
                  ),
                ],
              ),
              if (_business == _BusinessType.lsp)
                const LeoNote(
                  variant: LeoNoteVariant.info,
                  icon: CupertinoIcons.globe,
                  margin: EdgeInsets.only(top: 12),
                  child: Text(OnboardingStrings.lspInAppNote),
                ),
            ],
            const SizedBox(height: 16),
            LeoCard(
              backgroundColor: LeoColors.black700,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    OnboardingStrings.resultingPath,
                    style: LeoTypography.mono9,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      LeoChip(
                        label: OnboardingStrings.pathPersonal,
                        variant: LeoChipVariant.info,
                      ),
                      LeoChip(
                        label: OnboardingStrings.pathCustomer,
                        variant: LeoChipVariant.info,
                      ),
                      LeoChip(label: OnboardingStrings.pathLsp),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LeoLink(
                  label: OnboardingStrings.backToSignIn,
                  onPressed: () => context.go('/login'),
                ),
                LeoButton(
                  label: OnboardingStrings.continueLabel,
                  onPressed: _continue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
