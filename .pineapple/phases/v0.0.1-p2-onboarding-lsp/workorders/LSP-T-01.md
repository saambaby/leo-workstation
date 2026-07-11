---
task_id: LSP-T-01
phase: v0.0.1-p2-onboarding-lsp
title: "core/auth wire: signupLsp DTO + AuthRepository method + SignupPath.lsp"
model_tier: mechanical
verification: auto
human_admin: false
depends_on: []
owns:
  - lib/core/auth/domain/email_verification.dart
  - lib/core/auth/data/dto/auth_dto.dart
  - lib/core/auth/data/auth_repository.dart
  - lib/features/onboarding/presentation/routes/onboarding_routes.dart
must_not_touch:
  - lib/features/onboarding/presentation/screens/signup_type_screen.dart
  - lib/features/onboarding/presentation/screens/signup_details_screen.dart
  - lib/features/onboarding/presentation/notifiers/signup_notifier.dart
  - lib/features/onboarding/l10n/onboarding_strings.dart
read_list:
  - lib/core/auth/domain/email_verification.dart
  - lib/core/auth/data/dto/auth_dto.dart
  - lib/core/auth/data/auth_repository.dart
  - lib/core/auth/domain/signup_entities.dart
  - lib/features/onboarding/presentation/routes/onboarding_routes.dart
preconditions:
  - path: lib/core/auth/domain/email_verification.dart
    must_exist: true
    sha256: 32f2434fe541ef599cd85198e6e588623bbe961d4755a0f909a6790e3792af6a
  - path: lib/core/auth/data/dto/auth_dto.dart
    must_exist: true
    sha256: ee2481707e8ccfde3cc2bc540470247832392519891174b94e368937322425b9
  - path: lib/core/auth/data/auth_repository.dart
    must_exist: true
    sha256: 6f5a0d0a214e652b44f66bec47c58dcdf2e6e345d835955c74f50434285857dc
  - path: lib/features/onboarding/presentation/routes/onboarding_routes.dart
    must_exist: true
    sha256: a34dd24c8dce84eadd738622a8117fdd88df1b53206efdac7e781b54322cddcc
verify_script: .pineapple/phases/v0.0.1-p2-onboarding-lsp/workorders/LSP-T-01.verify.sh
budget: {max_minutes: 35}
commit:
  branch: "pin-{issue}/signup-lsp-wire"
  message_format: "feat(auth): SignupPath.lsp + signupLsp wire [LSP-T-01]"
  pr_title: "feat(auth): SignupPath.lsp + signupLsp DTO/repo (LSP-T-01)"
---

## Goal

Foundation / integration-contract owner for phase `v0.0.1-p2-onboarding-lsp`. Land the wire facts LSP-T-02 depends on: `SignupPath.lsp`, a `SignupLspRequestDto` that posts `business_type: 'lsp'` with required `consent.baa_ack`, `AuthRepository.signupLsp`, and verify-email query round-trip for `path=lsp`. No UI. Same `POST /auth/signup` endpoint as personal/customer — third variant on the existing union.

## Read-list

The worker reads THESE and nothing else:

1. `lib/core/auth/domain/email_verification.dart` — today `enum SignupPath { personal, customer }` and `verifyEmailLocation` maps only customer→`'customer'` else `'personal'`. Add `lsp` and emit `'lsp'`.
2. `lib/core/auth/data/dto/auth_dto.dart` — `ConsentDto` already has `@JsonKey(name: 'baa_ack', includeIfNull: false) bool? baaAck` (line ~11). `SignupCustomerRequestDto` is the template for a sibling LSP DTO (`account_type` default `'business'`, `business_type` default `'customer'`, fields email/password/name/timezone/consent). **Reuse `ConsentDto`; do not add a second consent type.**
3. `lib/core/auth/data/auth_repository.dart` — abstract `AuthRepository` + `ApiAuthRepository`. Mirror `signupCustomer` (lines ~220–241): same endpoint `/auth/signup`, `SignupResult.fromJson(requireJsonMap(...))`.
4. `lib/core/auth/domain/signup_entities.dart` — `SignupResult` already has `userId`, `emailVerificationRequired`, `organizationId?`, `status?`. **Do not branch on `status`.** Do not add fields unless codegen requires them.
5. `lib/features/onboarding/presentation/routes/onboarding_routes.dart` — `/verify-email` builder maps `path` query: only `'customer'` → `SignupPath.customer`, else personal. Must accept `'lsp'` → `SignupPath.lsp` so `verifyEmailLocation` round-trips (compile-discovered; was missing from taskgraph `owns`).

## Change plan

**1. `lib/core/auth/domain/email_verification.dart`**

Replace the enum and `verifyEmailLocation` path mapping:

```dart
enum SignupPath {
  personal,
  customer,
  lsp,
}

String verifyEmailLocation(VerifyEmailPendingContext ctx) {
  final source = ctx.source == VerifyEmailSource.login ? 'login' : 'signup';
  final path = switch (ctx.path) {
    SignupPath.customer => 'customer',
    SignupPath.lsp => 'lsp',
    SignupPath.personal => 'personal',
  };
  return '/verify-email?email=${Uri.encodeComponent(ctx.email)}&source=$source&path=$path';
}
```

Keep `VerifyEmailPendingContext` constructor and fields unchanged (its `path` type already accepts the new enum value).

**2. `lib/core/auth/data/dto/auth_dto.dart`**

Add a new freezed DTO immediately after `SignupCustomerRequestDto` (do **not** change `SignupCustomerRequestDto` defaults or fields):

```dart
@freezed
class SignupLspRequestDto with _$SignupLspRequestDto {
  const factory SignupLspRequestDto({
    @JsonKey(name: 'account_type') @Default('business') String accountType,
    @JsonKey(name: 'business_type') @Default('lsp') String businessType,
    required String email,
    required String password,
    required String name,
    required String timezone,
    required ConsentDto consent,
  }) = _SignupLspRequestDto;

  factory SignupLspRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SignupLspRequestDtoFromJson(json);
}
```

When calling it from the repository, always pass `ConsentDto(tos: …, privacy: …, baaAck: …)` with a non-null `baaAck` so `baa_ack` is present in JSON (`includeIfNull: false` omits null).

**3. `lib/core/auth/data/auth_repository.dart`**

On the abstract class, after `signupCustomer`, add:

```dart
Future<SignupResult> signupLsp({
  required String email,
  required String password,
  required String orgName,
  required String timezone,
  required bool tos,
  required bool privacy,
  required bool baaAck,
});
```

On `ApiAuthRepository`, implement by mirroring `signupCustomer`:

```dart
@override
Future<SignupResult> signupLsp({
  required String email,
  required String password,
  required String orgName,
  required String timezone,
  required bool tos,
  required bool privacy,
  required bool baaAck,
}) async {
  const endpoint = '/auth/signup';
  final response = await _dio.post<Map<String, dynamic>>(
    endpoint,
    data: SignupLspRequestDto(
      email: email,
      password: password,
      name: orgName,
      timezone: timezone,
      consent: ConsentDto(tos: tos, privacy: privacy, baaAck: baaAck),
    ).toJson(),
  );
  return SignupResult.fromJson(
    requireJsonMap(response, endpoint: endpoint),
  );
}
```

No `response.data!`, no inline maps, no `_map*` helpers (`INV-CLIENT-SERIAL-1`).

**4. `lib/features/onboarding/presentation/routes/onboarding_routes.dart`**

In the `/verify-email` builder, replace the binary path parse with:

```dart
final pathParam = state.uri.queryParameters['path'];
final path = switch (pathParam) {
  'customer' => SignupPath.customer,
  'lsp' => SignupPath.lsp,
  _ => SignupPath.personal,
};
```

**5. Codegen**

Run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Commit regenerated `auth_dto.freezed.dart` / `auth_dto.g.dart`. **Never hand-edit generated files.**

**Wire format (integration_contract):**
`POST /auth/signup` body → `{account_type:'business', business_type:'lsp', email, password, name, timezone, consent:{tos,privacy,baa_ack}}` → `201` with `email_verification_required:true` (and `status` may be `active`|`pending` — **no client branch on status**).

## Inlined context

**Phase integration_contract (verbatim, owner LSP-T-01):**
```
wire_format.signup_lsp: "POST /auth/signup {account_type:'business', business_type:'lsp', email, password, name, timezone, consent:{tos,privacy,baa_ack}} -> 201 {account_type, organization_id, user_id, status, email_verification_required:true}. baa_ack required; status may be active|pending (LSP_ACTIVATION_INTERIM_AUTO) — no client branch on it."
env: []
```

**INV-CLIENT-SERIAL-1 — DTOs in `data/`, entity `fromJson` for responses (verbatim):**
Wire serialization is explicit and typed. **Request** bodies are `freezed` DTOs under `data/dto/` with `toJson()`. **Responses** that match domain shape use `factory Entity.fromJson` on the existing `domain/<feature>_entities.dart` class — no duplicate wire types, no private `_map*` parsers, no inline `{'snake_key': …}` maps in repositories, no `*_models.dart` filenames. Discriminated API responses (e.g. login MFA vs session) use a custom `fromJson` on the domain union. DTOs never live in `domain/` or `presentation/`. Auth wire types live in `core/auth/` (`INV-CLIENT-AUTH-REPO-1`). (arch §1 wire serialization; reference: `core/auth/`, `features/onboarding/`)

**INV-CLIENT-AUTH-REPO-1 — One shared auth wire layer in `core/auth` (verbatim):**
All `/auth/*` HTTP (login, MFA enroll, refresh, logout, forgot/reset, signup, verify-email, resend-verify, invite accept) is implemented once in `lib/core/auth/data/auth_repository.dart` with DTOs in `core/auth/data/dto/` and shared domain types in `core/auth/domain/`. Feature slices (`auth`, `onboarding`) import `authRepositoryProvider` from core; `features/auth/data/` may re-export for backward compatibility but must not duplicate wire logic. Onboarding-specific non-auth endpoints (catalog, profiles, invitations) stay in `OnboardingRepository`.

**INV-CLIENT-TEST-1 — No Flutter tests unless requested (verbatim):**
Do not add or expand unit/widget/integration tests in this repo unless the user explicitly asks. Verification for agent work is `flutter analyze` (+ `build_runner` when codegen changes). Existing tests may be kept passing but must not be extended by default. (promoted 2026-06-30)

**library_defaults:** none — no new dependencies.

## Test plan

Per `INV-CLIENT-TEST-1`, **do not add** unit/widget/integration tests.

Static assertions (encoded in the verify script):
- `SignupPath` declares `lsp`.
- `verifyEmailLocation` emits `path=lsp` for `SignupPath.lsp` (source contains `'lsp'` in the switch/map).
- `SignupLspRequestDto` exists with `@Default('lsp')` / `business_type` default `lsp`.
- Abstract + `ApiAuthRepository` both declare/implement `signupLsp`.
- `/verify-email` route builder maps `'lsp'` → `SignupPath.lsp`.
- `flutter analyze` clean on owned Dart sources.
- `build_runner` already applied (generated files present; no analyze errors on freezed parts).

## Verification

Run `bash .pineapple/phases/v0.0.1-p2-onboarding-lsp/workorders/LSP-T-01.verify.sh` and report exit codes. Green analyze + symbol greps are the gate.

## Commit plan

- Branch: `pin-{issue}/signup-lsp-wire` (`{issue}` filled by `/pineapple:issues`).
- One commit: `feat(auth): SignupPath.lsp + signupLsp wire [LSP-T-01]`.
- Include regenerated `*.freezed.dart` / `*.g.dart` for `auth_dto`.
- Open the PR titled `feat(auth): SignupPath.lsp + signupLsp DTO/repo (LSP-T-01)` and STOP — fresh reviewer merges; do not merge yourself (`coordinator_policy.merge_requires_human_approval: true`).

## Preconditions

- `SignupPath` has only `personal` and `customer` (no `lsp` yet).
- `ConsentDto.baaAck` already exists; `SignupLspRequestDto` does **not** exist yet.
- `AuthRepository` has `signupPersonal` / `signupCustomer` but **no** `signupLsp`.
- `/verify-email` path query only distinguishes customer vs personal.
- If any of the above already changed (sha256 mismatch or symbols already present), STOP and report `preconditions-drifted` — do not improvise.

## References

- `.pineapple/features/lsp-native-signup.md`
- `.pineapple/phases/v0.0.1-p2-onboarding-lsp-taskgraph.yml` (LSP-T-01)
- `.pineapple/invariants-client.md` (`INV-CLIENT-SERIAL-1`, `INV-CLIENT-AUTH-REPO-1`, `INV-CLIENT-TEST-1`)
