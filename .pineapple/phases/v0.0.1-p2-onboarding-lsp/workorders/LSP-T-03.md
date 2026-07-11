---
task_id: LSP-T-03
phase: v0.0.1-p2-onboarding-lsp
title: "LSP signup E2E smoke: card -> details -> verify -> MFA enroll -> /dispatch"
model_tier: n/a
verification: manual
human_admin: false
depends_on:
  - LSP-T-02
owns:
  - .pineapple/phases/v0.0.1-p2-onboarding-lsp.md
must_not_touch:
  - lib/core/auth/domain/email_verification.dart
  - lib/core/auth/data/dto/auth_dto.dart
  - lib/core/auth/data/auth_repository.dart
  - lib/features/onboarding/presentation/screens/signup_type_screen.dart
  - lib/features/onboarding/presentation/screens/signup_details_screen.dart
  - lib/features/onboarding/presentation/notifiers/signup_notifier.dart
  - lib/features/onboarding/l10n/onboarding_strings.dart
  - lib/features/onboarding/presentation/routes/onboarding_routes.dart
read_list:
  - .pineapple/phases/v0.0.1-p2-onboarding-lsp.md
  - .pineapple/features/lsp-native-signup.md
preconditions:
  - path: .pineapple/phases/v0.0.1-p2-onboarding-lsp.md
    must_exist: true
    sha256: 23aacfc0f10c1f6a3736250723bd1529defc786995ffd5ca28115ddd5ece3ac1
  - path: lib/features/onboarding/presentation/notifiers/signup_notifier.dart
    must_exist: true
verify_script: .pineapple/phases/v0.0.1-p2-onboarding-lsp/workorders/LSP-T-03.verify.sh
budget: {max_minutes: 40}
commit:
  branch: "pin-{issue}/lsp-signup-e2e-smoke"
  message_format: "docs(phase): sign off LSP signup E2E smoke [LSP-T-03]"
  pr_title: "docs(phase): LSP signup E2E smoke checklist signed off (LSP-T-03)"
---

## Goal

Human verification task (not a code task). Against staging `leo-api` alpha.4+, walk the full LSP signup path — card → details → OTP verify → MFA enroll → `/dispatch` — and record pass/fail on the phase doc checklist. Confirm the client-side `baa_ack` gate, duplicate-email error path, and that `status: pending|active` has no client-visible branch. **Do not edit any `lib/` file.** If a bug is found, STOP and file it against LSP-T-01/T-02 — do not fix under this task.

## Read-list

The worker reads THESE and nothing else:

1. `.pineapple/phases/v0.0.1-p2-onboarding-lsp.md` — Done-when checklist to update after smoke.
2. `.pineapple/features/lsp-native-signup.md` — acceptance criteria AC1–AC7 and the open question that `status` has no client branch.

## Change plan

**This task owns only the phase doc.** No Dart changes.

**1. Preconditions before smoke**

- Staging app build includes LSP-T-01 + LSP-T-02 (in-app LSP card, `submitLsp` live).
- Staging `leo-api` is alpha.4+ with `POST /auth/signup` accepting `business_type: 'lsp'`.
- Have: a unique unused email, an authenticator app (real TOTP QR scan), network access to staging.

If `submitLsp` is missing or the LSP card still opens an external browser, STOP — report `preconditions-drifted` (LSP-T-02 not shipped).

**2. Manual smoke script (execute in order; record each result)**

| # | Step | Pass criteria |
|---|---|---|
| S1 | Open `/signup` → select Business → LSP card (whole card) → Continue | Lands on `/signup/details` with LSP fields; **no** external browser / `leo-web` tab |
| S2 | Leave `baa_ack` unchecked; fill other fields; attempt Create account | Button stays disabled / inert — **no** network request (confirm via proxy, Flutter network log, or API logs: zero `/auth/signup` call) |
| S3 | Check tos + privacy + baa_ack; submit with a fresh email | Navigates to `/verify-email` via redirect (not a hand-rolled push); OTP screen shows the email |
| S4 | Enter correct OTP from email | Receives MFA enrollment payload; lands on existing `/mfa/enroll` with QR (not a session yet) |
| S5 | Scan QR in authenticator app; submit valid TOTP | Session mints with role `lsp_admin`; router lands on `/dispatch` |
| S6 | Repeat signup (or a second attempt) with an email that already exists | Surfaces `409` / server `message` through the same error banner as personal/customer signup — no distinct LSP error UI |
| S7 | Observe signup response `status` (`active` or `pending`) | Confirm **no** client-visible branch (same verify-email next step either way) |

**3. Update `.pineapple/phases/v0.0.1-p2-onboarding-lsp.md`**

In the Done-when section, check off items that passed and append a short smoke log under a new subsection (create if absent):

```markdown
## E2E smoke log (LSP-T-03)

- Date: <YYYY-MM-DD>
- Staging API: <host or env name>
- Results: S1..S7 pass|fail (one line each)
- Notes: <optional; if fail, link/issue id — do not patch lib/ here>
```

Mark the Done-when boxes:

```markdown
- [x] LSP-T-01..03 acceptance criteria met
- [x] `flutter analyze` clean on touched paths
- [x] Manual E2E smoke (LSP-T-03) signed off
```

Only check these if S1–S7 all passed. If any fail, leave boxes unchecked, document the failure in the smoke log, open/note a fix issue, and still commit the log — do not mark the phase done.

## Inlined context

**Phase integration_contract (verbatim):**
```
wire_format.signup_lsp: "POST /auth/signup {account_type:'business', business_type:'lsp', email, password, name, timezone, consent:{tos,privacy,baa_ack}} -> 201 {account_type, organization_id, user_id, status, email_verification_required:true}. baa_ack required; status may be active|pending (LSP_ACTIVATION_INTERIM_AUTO) — no client branch on it."
env: []
```

**INV-CLIENT-CONSENT-1 (verbatim):**
Every consent-bearing submit (`/auth/signup`, `/invitations/accept`, and LSP signup) gates on all required consent booleans being `true` **client-side** — an incomplete or false consent object is never sent to the network, not merely rejected server-side. Consent itself stays append-only server-side (`INV-CONSENT-1`, platform); this invariant is only about when the client is allowed to fire the request. Honored by `auth.md` AC6, `onboarding.md` AC2, `lsp-native-signup.md` AC2. (promoted 2026-07-11 from cross-spec audit — invariant-promotion candidate #1)

**INV-CLIENT-ROUTE-2 — Canonical role→home map (verbatim):**
Exactly one role→home mapping: `interpreter → /idle` (incl. tenant-less), `customer_user → /call`, `customer_admin → /call`, `sub_admin → /dispatch`, `lsp_admin → /dispatch`. **`platform_admin` has no workstation home** — session mint is rejected in `AuthNotifier._applySession` with an error on `/login` (no `/web-handoff` route). `lsp_admin` reaches `leo-web` via the chrome external link only (`INV-CLIENT-ROUTE-1`).

**INV-CLIENT-NET-2 (relevant):** Show server `message`; do not invent a distinct LSP error path for `EMAIL_ALREADY_EXISTS` / `CONSENT_REQUIRED`.

**library_defaults:** n/a — no code or dependency changes.

## Test plan

This task **is** the test plan. Named checks = S1–S7 above. Assertions:

- S1: destination is in-app `/signup/details`, not external URL.
- S2: zero `/auth/signup` calls while `baa_ack` unchecked (`INV-CLIENT-CONSENT-1`).
- S3–S5: full happy path ends at `/dispatch` with `lsp_admin`.
- S6: duplicate email uses shared error UI.
- S7: no UI branch on `status`.

Failure path required: S2 (incomplete consent) and S6 (409) must be executed, not only the happy path.

## Verification

Run `bash .pineapple/phases/v0.0.1-p2-onboarding-lsp/workorders/LSP-T-03.verify.sh` after updating the phase doc. The script checks that the smoke log section exists and Done-when boxes for smoke are marked only if the log claims all S1–S7 pass. Human judgment of the live run is the real gate; the script only guards bookkeeping.

## Commit plan

- Branch: `pin-{issue}/lsp-signup-e2e-smoke`.
- One commit: `docs(phase): sign off LSP signup E2E smoke [LSP-T-03]` touching only `.pineapple/phases/v0.0.1-p2-onboarding-lsp.md`.
- Open PR and STOP — do not merge; do not touch `lib/`.

## Preconditions

- LSP-T-02 merged and available on the build under test (`submitLsp` present; type screen has no `launchUrl`).
- Phase doc exists at the pinned sha256 (or only differs by prior bookkeeping — if the Done-when section is already fully checked without a smoke log, STOP and report drift).
- Staging `leo-api` alpha.4+ reachable. If staging is unavailable, STOP and report blocker — do not invent a “code review only” pass.

## References

- `.pineapple/features/lsp-native-signup.md`
- `.pineapple/phases/v0.0.1-p2-onboarding-lsp-taskgraph.yml` (LSP-T-03)
- `.pineapple/invariants-client.md` (`INV-CLIENT-CONSENT-1`, `INV-CLIENT-ROUTE-2`, `INV-CLIENT-NET-2`)
