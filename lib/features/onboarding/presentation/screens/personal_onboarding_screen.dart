import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/widgets/auth_screen_layout.dart';
import '../../domain/onboarding_entities.dart';
import '../../l10n/onboarding_strings.dart';
import '../notifiers/onboarding_notifier.dart';
import '../widgets/certification_list.dart';
import '../widgets/language_chip_picker.dart';
import '../widgets/leo_wizard_steps.dart';

class PersonalOnboardingScreen extends ConsumerStatefulWidget {
  const PersonalOnboardingScreen({super.key});

  @override
  ConsumerState<PersonalOnboardingScreen> createState() =>
      _PersonalOnboardingScreenState();
}

class _PersonalOnboardingScreenState
    extends ConsumerState<PersonalOnboardingScreen> {
  final _displayName = TextEditingController();
  var _timezone = OnboardingStrings.timezones.first;
  final _selectedLanguageIds = <String>{};
  final _certEntries = <InterpreterCertEntry>[];

  @override
  void dispose() {
    _displayName.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(onboardingNotifierProvider.notifier).completePersonal(
          InterpreterProfileInput(
            displayName: _displayName.text.trim(),
            timezone: _timezone,
            languageIds: _selectedLanguageIds.toList(),
            certifications: _certEntries,
          ),
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
                  label: OnboardingStrings.personalChip,
                  variant: LeoChipVariant.info,
                ),
              ],
            ),
            const LeoAuthSub(OnboardingStrings.personalWelcome),
            const LeoWizardSteps(
              steps: [
                WizardStep(label: OnboardingStrings.stepAccountType, done: true),
                WizardStep(
                  label: OnboardingStrings.stepProfile,
                  active: true,
                ),
                WizardStep(label: OnboardingStrings.stepAffiliate),
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
                    label: OnboardingStrings.displayName,
                    controller: _displayName,
                    bottomSpacing: 0,
                  ),
                ),
                const SizedBox(width: 14),
                SizedBox(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        OnboardingStrings.timezone,
                        style: LeoTypography.fieldLabel,
                      ),
                      const SizedBox(height: 6),
                      _TzButton(
                        value: _timezone,
                        onPick: (v) => setState(() => _timezone = v),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              OnboardingStrings.languagesLabel,
              style: LeoTypography.fieldLabel,
            ),
            const SizedBox(height: 8),
            LanguageChipPicker(
              languages: ui.languages,
              selectedIds: _selectedLanguageIds,
              onToggle: (id) => setState(() {
                if (_selectedLanguageIds.contains(id)) {
                  _selectedLanguageIds.remove(id);
                } else {
                  _selectedLanguageIds.add(id);
                }
              }),
              onAddFromCatalog: () => showLanguageCatalogPicker(
                context: context,
                languages: ui.languages,
                selectedIds: _selectedLanguageIds,
                onSelect: (id) => setState(() => _selectedLanguageIds.add(id)),
              ),
            ),
            const SizedBox(height: 14),
            Text.rich(
              TextSpan(
                style: LeoTypography.fieldLabel,
                children: [
                  const TextSpan(text: OnboardingStrings.certificationsLabel),
                  TextSpan(
                    text: ' ${OnboardingStrings.certificationsHint}',
                    style: LeoTypography.mono9,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            CertificationList(
              entries: _certEntries,
              onUploadProof: (i) => setState(
                () => _certEntries[i] = InterpreterCertEntry(
                  certificationId: _certEntries[i].certificationId,
                  name: _certEntries[i].name,
                  certNumber: _certEntries[i].certNumber,
                  expiresAt: _certEntries[i].expiresAt,
                  proofUploaded: true,
                ),
              ),
              onAdd: () async {
                final entry = await showCertCatalogPicker(
                  context: context,
                  certifications: ui.certifications,
                );
                if (entry != null) {
                  setState(() => _certEntries.add(entry));
                }
              },
            ),
            const LeoNote(
              variant: LeoNoteVariant.info,
              icon: CupertinoIcons.info,
              margin: EdgeInsets.only(bottom: 18),
              child: Text(OnboardingStrings.affiliationNote),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LeoLink(
                  label: OnboardingStrings.backToSignIn,
                  onPressed: () => context.go('/login'),
                ),
                LeoButton(
                  label: OnboardingStrings.nextAffiliate,
                  enabled: !ui.isLoading && _displayName.text.trim().isNotEmpty,
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

class _TzButton extends StatelessWidget {
  const _TzButton({required this.value, required this.onPick});

  final String value;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      color: LeoColors.black700,
      onPressed: () => showCupertinoModalPopup<void>(
        context: context,
        builder: (ctx) => Container(
          height: 200,
          color: LeoColors.black800,
          child: CupertinoPicker(
            itemExtent: 32,
            onSelectedItemChanged: (i) =>
                onPick(OnboardingStrings.timezones[i]),
            children: OnboardingStrings.timezones
                .map((t) => Text(t, style: LeoTypography.input))
                .toList(),
          ),
        ),
      ),
      child: Text(value, style: LeoTypography.input),
    );
  }
}
