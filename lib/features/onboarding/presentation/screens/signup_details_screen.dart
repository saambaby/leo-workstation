import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/widgets/auth_screen_layout.dart';
import '../../domain/onboarding_entities.dart';
import '../../l10n/onboarding_strings.dart';
import '../notifiers/signup_notifier.dart';
import '../widgets/leo_wizard_steps.dart';

class SignupDetailsScreen extends ConsumerStatefulWidget {
  const SignupDetailsScreen({super.key, required this.draft});

  final SignupDraft draft;

  @override
  ConsumerState<SignupDetailsScreen> createState() =>
      _SignupDetailsScreenState();
}

class _SignupDetailsScreenState extends ConsumerState<SignupDetailsScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _orgName = TextEditingController();
  var _timezone = OnboardingStrings.timezones.first;
  var _tos = false;
  var _privacy = false;
  var _baaAck = false;
  String? _localError;

  bool get _isCustomer => widget.draft.path == SignupPath.customer;
  bool get _isLsp => widget.draft.path == SignupPath.lsp;
  bool get _needsOrgFields => _isCustomer || _isLsp;

  bool get _consentsOk {
    if (_isLsp) return _tos && _privacy && _baaAck;
    return _tos && _privacy;
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _orgName.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_password.text != _confirm.text) {
      setState(() => _localError = OnboardingStrings.passwordMismatch);
      return;
    }
    if (!_consentsOk) {
      setState(() => _localError = OnboardingStrings.consentRequired);
      return;
    }

    setState(() => _localError = null);
    final notifier = ref.read(signupNotifierProvider.notifier);
    final ok = _isLsp
        ? await notifier.submitLsp(
            email: _email.text.trim(),
            password: _password.text,
            orgName: _orgName.text.trim(),
            timezone: _timezone,
            tos: _tos,
            privacy: _privacy,
            baaAck: _baaAck,
          )
        : _isCustomer
            ? await notifier.submitCustomer(
                email: _email.text.trim(),
                password: _password.text,
                orgName: _orgName.text.trim(),
                timezone: _timezone,
                tos: _tos,
                privacy: _privacy,
              )
            : await notifier.submitPersonal(
                email: _email.text.trim(),
                password: _password.text,
                tos: _tos,
                privacy: _privacy,
              );
    if (!mounted) return;
    if (!ok && ref.read(signupUiProvider).errorMessage == null) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(signupUiProvider);
    final error = _localError ?? ui.errorMessage;
    final subtitle = _isLsp
        ? OnboardingStrings.detailsSubLsp
        : _isCustomer
            ? OnboardingStrings.detailsSubCustomer
            : OnboardingStrings.detailsSubPersonal;

    return AuthStage(
      child: AuthCard(
        width: AuthCardWidth.wide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LeoLogo(),
            LeoAuthSub(subtitle),
            const LeoWizardSteps(
              steps: [
                WizardStep(label: OnboardingStrings.stepAccountType, done: true),
                WizardStep(label: OnboardingStrings.stepDetails, active: true),
                WizardStep(label: OnboardingStrings.stepVerifyEmail),
              ],
            ),
            if (error != null) ...[
              AuthErrorBanner(message: error),
              const SizedBox(height: 16),
            ],
            if (_needsOrgFields) ...[
              LeoTextField(
                label: OnboardingStrings.orgName,
                controller: _orgName,
                bottomSpacing: 14,
              ),
              Text(OnboardingStrings.timezone, style: LeoTypography.fieldLabel),
              const SizedBox(height: 6),
              _TimezonePicker(
                value: _timezone,
                onChanged: (v) => setState(() => _timezone = v),
              ),
              const SizedBox(height: 14),
            ],
            LeoTextField(
              label: OnboardingStrings.email,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              bottomSpacing: 14,
            ),
            LeoTextField(
              label: OnboardingStrings.password,
              controller: _password,
              obscureText: true,
              bottomSpacing: 14,
            ),
            LeoTextField(
              label: OnboardingStrings.confirmPassword,
              controller: _confirm,
              obscureText: true,
              bottomSpacing: 14,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: LeoCheckbox(
                label: OnboardingStrings.acceptTos,
                value: _tos,
                onChanged: (v) => setState(() => _tos = v),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: LeoCheckbox(
                label: OnboardingStrings.acceptPrivacy,
                value: _privacy,
                onChanged: (v) => setState(() => _privacy = v),
              ),
            ),
            if (_isLsp)
              Align(
                alignment: Alignment.centerLeft,
                child: LeoCheckbox(
                  label: OnboardingStrings.acceptBaa,
                  value: _baaAck,
                  onChanged: (v) => setState(() => _baaAck = v),
                ),
              ),
            const SizedBox(height: 16),
            LeoButton(
              label: OnboardingStrings.createAccount,
              fullWidth: true,
              enabled: !ui.isLoading,
              onPressed: (_consentsOk && !ui.isLoading) ? _submit : null,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: LeoLink(
                  label: OnboardingStrings.backToSignIn,
                  onPressed: () => context.go('/login'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimezonePicker extends StatelessWidget {
  const _TimezonePicker({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: LeoColors.black700,
        borderRadius: BorderRadius.circular(LeoRadii.md),
        border: Border.all(color: LeoColors.black500),
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(vertical: 9),
        onPressed: () => showCupertinoModalPopup<void>(
          context: context,
          builder: (ctx) => Container(
            height: 240,
            color: LeoColors.black800,
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                initialItem: OnboardingStrings.timezones.indexOf(value),
              ),
              itemExtent: 36,
              onSelectedItemChanged: (i) =>
                  onChanged(OnboardingStrings.timezones[i]),
              children: OnboardingStrings.timezones
                  .map((tz) => Center(child: Text(tz, style: LeoTypography.input)))
                  .toList(),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value, style: LeoTypography.input),
            const Icon(
              CupertinoIcons.chevron_down,
              size: 14,
              color: LeoColors.black200,
            ),
          ],
        ),
      ),
    );
  }
}
