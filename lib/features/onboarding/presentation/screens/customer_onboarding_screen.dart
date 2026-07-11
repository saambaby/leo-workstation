import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/widgets/auth_screen_layout.dart';
import '../../domain/onboarding_entities.dart';
import '../../l10n/onboarding_strings.dart';
import '../notifiers/onboarding_notifier.dart';
import '../widgets/leo_wizard_steps.dart';

class CustomerOnboardingScreen extends ConsumerStatefulWidget {
  const CustomerOnboardingScreen({super.key});

  @override
  ConsumerState<CustomerOnboardingScreen> createState() =>
      _CustomerOnboardingScreenState();
}

class _InviteRow {
  _InviteRow() : email = TextEditingController();
  final TextEditingController email;
  String role = 'customer_user';
}

class _CustomerOnboardingScreenState
    extends ConsumerState<CustomerOnboardingScreen> {
  final _orgName = TextEditingController();
  final _address = TextEditingController();
  var _industry = OnboardingStrings.industries.first;
  final _rows = [_InviteRow()];

  @override
  void dispose() {
    _orgName.dispose();
    _address.dispose();
    for (final r in _rows) {
      r.email.dispose();
    }
    super.dispose();
  }

  Future<void> _finish() async {
    final invites = _rows
        .where((r) => r.email.text.trim().isNotEmpty)
        .map(
          (r) => TeamInviteInput(email: r.email.text.trim(), role: r.role),
        )
        .toList();

    await ref.read(onboardingNotifierProvider.notifier).completeCustomer(
          org: CustomerOrgInput(
            name: _orgName.text.trim(),
            industry: _industry,
            registeredAddress: _address.text.trim(),
          ),
          invites: invites,
        );
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(onboardingUiProvider);

    return AuthStage(
      child: AuthCard(
        width: AuthCardWidth.wide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const LeoLogo(),
                const LeoChip(
                  label: OnboardingStrings.customerChip,
                  variant: LeoChipVariant.info,
                ),
              ],
            ),
            const LeoAuthSub(OnboardingStrings.customerWelcome),
            const LeoWizardSteps(
              steps: [
                WizardStep(label: OnboardingStrings.stepAccountType, done: true),
                WizardStep(
                  label: OnboardingStrings.stepOrgProfile,
                  active: true,
                ),
                WizardStep(label: OnboardingStrings.stepInviteTeam),
                WizardStep(label: OnboardingStrings.stepDone),
              ],
            ),
            if (ui.errorMessage != null) ...[
              AuthErrorBanner(message: ui.errorMessage!),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                Expanded(
                  child: LeoTextField(
                    label: OnboardingStrings.orgName,
                    controller: _orgName,
                    bottomSpacing: 0,
                  ),
                ),
                const SizedBox(width: 14),
                SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        OnboardingStrings.industry,
                        style: LeoTypography.fieldLabel,
                      ),
                      const SizedBox(height: 6),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 9,
                        ),
                        color: LeoColors.black700,
                        onPressed: () => showCupertinoModalPopup<void>(
                          context: context,
                          builder: (ctx) => CupertinoActionSheet(
                            actions: [
                              for (final ind in OnboardingStrings.industries)
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    setState(() => _industry = ind);
                                    Navigator.pop(ctx);
                                  },
                                  child: Text(ind),
                                ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                          ),
                        ),
                        child: Text(_industry, style: LeoTypography.input),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text.rich(
              TextSpan(
                style: LeoTypography.fieldLabel,
                children: [
                  const TextSpan(text: OnboardingStrings.registeredAddress),
                  TextSpan(
                    text: ' ${OnboardingStrings.registeredAddressHint}',
                    style: LeoTypography.mono9,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            CupertinoTextField(
              controller: _address,
              placeholder: '200 Market St, Suite 4, San Jose, CA',
              style: LeoTypography.input,
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
              decoration: BoxDecoration(
                color: LeoColors.black700,
                borderRadius: BorderRadius.circular(LeoRadii.md),
                border: Border.all(color: LeoColors.black500),
              ),
            ),
            const SizedBox(height: 14),
            Text.rich(
              TextSpan(
                style: LeoTypography.fieldLabel,
                children: [
                  const TextSpan(text: OnboardingStrings.inviteTeam),
                  TextSpan(
                    text: ' ${OnboardingStrings.inviteTeamHint}',
                    style: LeoTypography.mono9,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < _rows.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        controller: _rows[i].email,
                        placeholder: 'email@org.com',
                        style: LeoTypography.input,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: LeoColors.black700,
                          borderRadius: BorderRadius.circular(LeoRadii.md),
                          border: Border.all(color: LeoColors.black500),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 140,
                      child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        color: LeoColors.black700,
                        onPressed: () => showCupertinoModalPopup<void>(
                          context: context,
                          builder: (ctx) => CupertinoActionSheet(
                            actions: [
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  setState(
                                    () => _rows[i].role = 'customer_user',
                                  );
                                  Navigator.pop(ctx);
                                },
                                child: const Text(
                                  OnboardingStrings.customerUserRole,
                                ),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  setState(
                                    () => _rows[i].role = 'customer_admin',
                                  );
                                  Navigator.pop(ctx);
                                },
                                child: const Text(
                                  OnboardingStrings.customerAdminRole,
                                ),
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                          ),
                        ),
                        child: Text(
                          _rows[i].role == 'customer_admin'
                              ? OnboardingStrings.customerAdminRole
                              : OnboardingStrings.customerUserRole,
                          style: LeoTypography.mono10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => setState(() => _rows.add(_InviteRow())),
                child: Text(
                  OnboardingStrings.addInviteRow,
                  style: LeoTypography.link,
                ),
              ),
            ),
            const LeoNote(
              variant: LeoNoteVariant.info,
              icon: CupertinoIcons.lock,
              margin: EdgeInsets.only(bottom: 18, top: 8),
              child: Text(OnboardingStrings.customerPortalNote),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LeoLink(
                  label: OnboardingStrings.backToSignIn,
                  onPressed: () => context.go('/login'),
                ),
                LeoButton(
                  label: OnboardingStrings.finishAndCall,
                  enabled: !ui.isLoading && _orgName.text.trim().isNotEmpty,
                  onPressed: _finish,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
