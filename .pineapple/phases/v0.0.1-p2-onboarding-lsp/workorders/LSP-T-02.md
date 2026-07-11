---
task_id: LSP-T-02
phase: v0.0.1-p2-onboarding-lsp
title: "LSP signup UI: in-app card push, LSP details fields + baa_ack gate, SignupNotifier.submitLsp"
model_tier: mechanical
verification: manual
human_admin: false
depends_on:
  - LSP-T-01
owns:
  - lib/features/onboarding/presentation/screens/signup_type_screen.dart
  - lib/features/onboarding/presentation/screens/signup_details_screen.dart
  - lib/features/onboarding/presentation/notifiers/signup_notifier.dart
  - lib/features/onboarding/l10n/onboarding_strings.dart
must_not_touch:
  - lib/core/auth/domain/email_verification.dart
  - lib/core/auth/data/dto/auth_dto.dart
  - lib/core/auth/data/auth_repository.dart
  - lib/features/onboarding/presentation/routes/onboarding_routes.dart
read_list:
  - lib/core/auth/data/auth_repository.dart
  - lib/core/auth/domain/email_verification.dart
  - lib/features/onboarding/presentation/notifiers/signup_notifier.dart
  - lib/features/onboarding/presentation/screens/signup_type_screen.dart
  - lib/features/onboarding/presentation/screens/signup_details_screen.dart
  - lib/features/onboarding/l10n/onboarding_strings.dart
  - lib/features/auth/presentation/widgets/design/leo_button.dart
  - lib/features/auth/presentation/widgets/design/leo_checkbox.dart
preconditions:
  - path: lib/features/onboarding/presentation/screens/signup_type_screen.dart
    must_exist: true
    sha256: c0b454e3b40a3b56f7c1d54e7d5aba90eb543c734c45dfd2270de2e799d709b2
  - path: lib/features/onboarding/presentation/screens/signup_details_screen.dart
    must_exist: true
    sha256: b674b50f253e3b6b0395bca48d65867031599c7b6ca8d858af1d2b10e981071c
  - path: lib/features/onboarding/presentation/notifiers/signup_notifier.dart
    must_exist: true
    sha256: a9b6e772fa1b43424bf3cc22d4814aa139a6c68945f68b5b9a0ec077f1020082
  - path: lib/features/onboarding/l10n/onboarding_strings.dart
    must_exist: true
    sha256: 8844316a35c848d18b46d0d6ea6ba8c82fe4d9f25d54b8fd4b10babbeb19e2f7
  - path: lib/core/auth/data/auth_repository.dart
    must_exist: true
verify_script: .pineapple/phases/v0.0.1-p2-onboarding-lsp/workorders/LSP-T-02.verify.sh
budget: {max_minutes: 45}
commit:
  branch: "pin-{issue}/lsp-signup-ui"
  message_format: "feat(onboarding): in-app LSP signup UI + submitLsp [LSP-T-02]"
  pr_title: "feat(onboarding): in-app LSP signup card, baa_ack gate, submitLsp (LSP-T-02)"
---

## Goal

Wire the in-app LSP signup path on top of LSP-T-01's wire layer: LSP card pushes `/signup/details` with `SignupDraft(path: SignupPath.lsp)` (no `launchUrl`), details screen collects org fields + three consents with Continue disabled until all three are checked, and `SignupNotifier.submitLsp` calls `AuthRepository.signupLsp` then sets `emailVerificationPending` the same way personal/customer do. No new routes or screens. Reuses `/signup`, `/signup/details`, `/verify-email`, `/mfa/enroll`.

## Read-list

The worker reads THESE and nothing else:

1. `lib/core/auth/data/auth_repository.dart` — confirm `signupLsp({email, password, orgName, timezone, tos, privacy, baaAck})` exists (LSP-T-01). Call it; do not reimplement wire.
2. `lib/core/auth/domain/email_verification.dart` — confirm `SignupPath.lsp` exists. Pass it into `VerifyEmailPendingContext`.
3. `lib/features/onboarding/presentation/notifiers/signup_notifier.dart` — `submitPersonal` / `submitCustomer` both funnel through `_submit(call, email, path)` which on success calls `authNotifier.setEmailVerificationPending(...)` and returns `true`. Add `submitLsp` the same way. Errors already use `mapUserFacingError(e)` — **do not add** `hasApiErrorCode` / `EMAIL_ALREADY_EXISTS` / `CONSENT_REQUIRED` branches for LSP.
4. `lib/features/onboarding/presentation/screens/signup_type_screen.dart` — `_selectedPath` returns `null` for LSP; `_continue` launches external URL for LSP. Both must change. Whole-card tap already selects `_BusinessType.lsp` via `LeoOptCard.onTap`; Continue then pushes details — keep that whole-card + Continue pattern (same as personal/customer).
5. `lib/features/onboarding/presentation/screens/signup_details_screen.dart` — today only `_isCustomer` vs personal. Extend for LSP: org name + timezone like customer; third checkbox `baa_ack`; Continue `onPressed: null` until all three consents true on LSP path.
6. `lib/features/onboarding/l10n/onboarding_strings.dart` — all new/changed copy goes here (`INV-CLIENT-I18N-1`). Update LSP-external copy to in-app wording; add BAA checkbox + LSP details subtitle strings.
7. `lib/features/auth/presentation/widgets/design/leo_button.dart` — `LeoButton` treats `enabled && onPressed != null` as active. For the LSP consent gate set `onPressed: canSubmit ? _submit : null` (and keep `enabled: !ui.isLoading`).
8. `lib/features/auth/presentation/widgets/design/leo_checkbox.dart` — full-row tap via `GestureDetector` already — reuse `LeoCheckbox` for `baa_ack` the same as tos/privacy.

## Change plan

**Dependency gate (before editing):** `grep -q signupLsp lib/core/auth/data/auth_repository.dart` and `grep -qE '^\s*lsp' lib/core/auth/domain/email_verification.dart` must succeed. If not, STOP — LSP-T-01 not merged (`preconditions-drifted`).

**1. `lib/features/onboarding/l10n/onboarding_strings.dart`**

Replace / add these constants (exact keys; wording may match below):

```dart
static const lspExternalNote =
    'LSP account signup continues in-app — org details, email verify, then MFA enroll.';
// Prefer renaming usage sites away from "external"; if the const name stays, update the string value.
// Or replace with:
static const lspInAppNote =
    'LSP account signup continues in-app — org details, email verify, then MFA enroll.';

static const pathLsp = 'LSP → dispatch (MFA required)';
static const detailsSubLsp = 'Create your LSP organization';
static const acceptBaa =
    'I acknowledge the Business Associate Agreement (BAA)';
```

- Update `pathLsp` (was `'LSP → languages + pricing (web)'`).
- Update or replace `lspExternalNote` so the type-screen note no longer says signup runs in Leo Web / browser.
- Keep `lspUrlUnset` unused is fine (or leave; do not reference it from the type screen after this task).
- **No hardcoded user-facing strings in screens** — only `OnboardingStrings.*`.

**2. `lib/features/onboarding/presentation/screens/signup_type_screen.dart`**

- Change `_selectedPath` so LSP returns `SignupPath.lsp`:

```dart
SignupPath? get _selectedPath {
  if (_top == _TopLevel.personal) return SignupPath.personal;
  if (_business == _BusinessType.customer) return SignupPath.customer;
  if (_business == _BusinessType.lsp) return SignupPath.lsp;
  return null;
}
```

- Replace `_continue` so it **never** calls `launchUrl` / reads `webAdminBaseUrl`. Entire method becomes:

```dart
void _continue() {
  final path = _selectedPath;
  if (path == null) return;
  context.push('/signup/details', extra: SignupDraft(path: path));
}
```

- Remove unused imports: `url_launcher`, `app_config.dart` (and any dialog that only existed for unset URL).
- Keep the LSP `LeoNote` under the cards, but point it at the updated in-app string (`lspInAppNote` / updated `lspExternalNote`).
- Do **not** change personal/customer card behavior.

**3. `lib/features/onboarding/presentation/notifiers/signup_notifier.dart`**

Add after `submitCustomer`:

```dart
Future<bool> submitLsp({
  required String email,
  required String password,
  required String orgName,
  required String timezone,
  required bool tos,
  required bool privacy,
  required bool baaAck,
}) async {
  return _submit(
    () => _repo.signupLsp(
      email: email,
      password: password,
      orgName: orgName,
      timezone: timezone,
      tos: tos,
      privacy: privacy,
      baaAck: baaAck,
    ),
    email,
    SignupPath.lsp,
  );
}
```

Do not change `_submit`, `verifyEmail`, or `resendVerifyEmail`. Do not add error-code switches. Do not `context.go` / `context.push` to `/verify-email` from the notifier or screen on success — `setEmailVerificationPending` already drives redirect (`INV-CLIENT-STATE-1`).

**4. `lib/features/onboarding/presentation/screens/signup_details_screen.dart`**

State / getters:

```dart
var _baaAck = false;

bool get _isCustomer => widget.draft.path == SignupPath.customer;
bool get _isLsp => widget.draft.path == SignupPath.lsp;
bool get _needsOrgFields => _isCustomer || _isLsp;
```

- Show org name + timezone when `_needsOrgFields` (reuse existing customer widgets; same controllers).
- Subtitle: use `detailsSubLsp` when `_isLsp`, else existing personal/customer strings.
- Add third `LeoCheckbox` when `_isLsp` only:

```dart
if (_isLsp)
  Align(
    alignment: Alignment.centerLeft,
    child: LeoCheckbox(
      label: OnboardingStrings.acceptBaa,
      value: _baaAck,
      onChanged: (v) => setState(() => _baaAck = v),
    ),
  ),
```

- Consent / Continue gate for LSP (`INV-CLIENT-CONSENT-1`):

```dart
bool get _consentsOk {
  if (_isLsp) return _tos && _privacy && _baaAck;
  return _tos && _privacy;
}
```

LeoButton for create account:

```dart
LeoButton(
  label: OnboardingStrings.createAccount,
  fullWidth: true,
  enabled: !ui.isLoading,
  onPressed: (_consentsOk && !ui.isLoading) ? _submit : null,
),
```

For personal/customer you may keep the previous pattern (button always callable, local error if consent missing) **or** apply the same `_consentsOk` disable — either is fine as long as LSP never fires the network with incomplete consent. Prefer applying `_consentsOk` for all paths for consistency.

- `_submit` body: for LSP, call `notifier.submitLsp(..., baaAck: _baaAck)` instead of personal/customer. Structure:

```dart
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
        ? await notifier.submitCustomer(...)
        : await notifier.submitPersonal(...);
```

- Keep password-mismatch local validation. Keep the existing `if (!ok && errorMessage == null) context.go('/login')` branch.
- Do **not** push `/verify-email` on success.

**Wire on success:** notifier → `setEmailVerificationPending(VerifyEmailPendingContext(email:, path: SignupPath.lsp, source: signup))` → router → `/verify-email?…&path=lsp`.

## Inlined context

**Phase integration_contract (verbatim):**
```
wire_format.signup_lsp: "POST /auth/signup {account_type:'business', business_type:'lsp', email, password, name, timezone, consent:{tos,privacy,baa_ack}} -> 201 {account_type, organization_id, user_id, status, email_verification_required:true}. baa_ack required; status may be active|pending (LSP_ACTIVATION_INTERIM_AUTO) — no client branch on it."
env: []
```

**INV-CLIENT-CONSENT-1 — Client-side consent gate before submit (verbatim):**
Every consent-bearing submit (`/auth/signup`, `/invitations/accept`, and LSP signup) gates on all required consent booleans being `true` **client-side** — an incomplete or false consent object is never sent to the network, not merely rejected server-side. Consent itself stays append-only server-side (`INV-CONSENT-1`, platform); this invariant is only about when the client is allowed to fire the request. Honored by `auth.md` AC6, `onboarding.md` AC2, `lsp-native-signup.md` AC2. (promoted 2026-07-11 from cross-spec audit — invariant-promotion candidate #1)

**INV-CLIENT-NET-2 — Typed error envelope + safe response bodies (verbatim):**
Parse leo-api failures as `{ statusCode, message, error, code }` via `lib/core/network/api_error.dart` (mirrors platform `INV-ERROR-1`). **Show `message` in alerts/forms** — do not maintain a client code→copy map. **Branch on `code`** (`ApiErrorCode`) only when UX differs (redirect, field highlight, session teardown); never branch on `message` text. `mapUserFacingError` returns server `message` or a generic/fallback for non-envelope failures. Successful JSON bodies use `requireJsonMap` / `requireJsonList` (`api_response.dart`) — never `response.data!` into `fromJson`. (promoted 2026-07-11)

**INV-CLIENT-STATE-1 — Immutable state, navigation is a pure function of state (verbatim):**
View state is immutable (`freezed`). `go_router`'s `redirect` is keyed on auth state via `refreshListenable`; there is no imperative navigation on login/logout. (arch §3, §5)

**INV-CLIENT-STATE-3 — Centralized async state, derived UI providers (relevant clauses):**
Async and business state … is owned by the feature `Notifier` … Screens watch that provider for `isLoading`, `errorMessage` … Views never call repositories. … Session transitions … navigate via `redirect` + `AuthState`, not imperative role-home `context.go`.

**INV-CLIENT-I18N-1 — No hardcoded user-facing strings (verbatim):**
User-facing copy goes through `intl`/`flutter_localizations`; no string literals in widgets. (release-checklists)

**INV-CLIENT-TEST-1 — No Flutter tests unless requested (verbatim):**
Do not add or expand unit/widget/integration tests in this repo unless the user explicitly asks. Verification for agent work is `flutter analyze` (+ `build_runner` when codegen changes). Existing tests may be kept passing but must not be extended by default. (promoted 2026-06-30)

**library_defaults:** none — no new dependencies. Remove `url_launcher` usage from this screen only; do not remove the package from `pubspec.yaml` (other call sites may remain).

## Test plan

Per `INV-CLIENT-TEST-1`, **do not add** Flutter tests. Manual / static checks:

1. **Symbol:** `submitLsp` present on `SignupNotifier`; calls `_repo.signupLsp`.
2. **No launchUrl:** `signup_type_screen.dart` contains no `launchUrl` / `webAdminBaseUrl` / `url_launcher` import.
3. **Path push:** `_selectedPath` returns `SignupPath.lsp` for the LSP business type; `_continue` pushes `SignupDraft(path: path)`.
4. **Consent gate:** for `SignupPath.lsp`, Create-account `LeoButton` uses `onPressed: null` unless `_tos && _privacy && _baaAck` (and not loading).
5. **Copy:** `acceptBaa` / `detailsSubLsp` / updated `pathLsp` exist in `OnboardingStrings`; screens reference them — no raw `'I acknowledge…'` literals in the screen file.
6. **Errors:** no new `hasApiErrorCode` / `ApiErrorCode` branch in `signup_notifier.dart` for this task.
7. **Analyze:** `flutter analyze` clean on owned files.
8. **Manual smoke (verification: manual):** on a device/simulator with staging API available after merge — optional for this PR; full E2E is LSP-T-03. At minimum, reviewer confirms Continue stays disabled with BAA unchecked (no network) by reading the gate code if staging is unavailable.

## Verification

Run `bash .pineapple/phases/v0.0.1-p2-onboarding-lsp/workorders/LSP-T-02.verify.sh` and report exit codes. Manual consent-gate / duplicate-email UX is confirmed at LSP-T-03; this script covers static gates + analyze.

## Commit plan

- Branch: `pin-{issue}/lsp-signup-ui`.
- One commit: `feat(onboarding): in-app LSP signup UI + submitLsp [LSP-T-02]`.
- Open PR `feat(onboarding): in-app LSP signup card, baa_ack gate, submitLsp (LSP-T-02)` and STOP — do not merge.

## Preconditions

- LSP-T-01 merged: `AuthRepository.signupLsp` and `SignupPath.lsp` exist.
- Owned files match the sha256 pins above (pre-UI state: LSP still launches external URL; no `submitLsp`; no `acceptBaa`).
- If type screen already pushes in-app LSP or `submitLsp` already exists, STOP and report `preconditions-drifted`.

## References

- `.pineapple/features/lsp-native-signup.md` (AC1–AC3, AC6)
- `.pineapple/phases/v0.0.1-p2-onboarding-lsp-taskgraph.yml` (LSP-T-02)
- `.pineapple/invariants-client.md` (`INV-CLIENT-CONSENT-1`, `INV-CLIENT-NET-2`, `INV-CLIENT-STATE-1`/`3`, `INV-CLIENT-I18N-1`)
