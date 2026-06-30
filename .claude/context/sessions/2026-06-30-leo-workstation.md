# 2026-06-30 — Auth contract correction (`/pineapple:spec`)

**Branch:** main · **Trigger:** "replace mock implementations of auth with the real one, real api is localhost:3000/api/docs"

## TL;DR

The client's `ApiAuthRepository` (already scaffolded, gated behind `USE_MOCKS=false`)
was written against an *assumed* backend contract. Read `leo-api/src/modules/auth/*`
source directly, then verified live against the running server's
`/api/docs-json` (`localhost:3000/api/v1` — initially unreachable, came up
mid-session). Found five real divergences and walked the founder through each as a
locked decision. Output: `.pineapple/features/auth.md` rewritten with the corrected
contract, a new **Key decisions (with rejected alternatives)** section (D1–D7), and
an explicit "what changed from the original draft" callout. No code changed —
implementation is the next session's work.

## What was found (source: `leo-api` read + live swagger, not assumed)

- Login (`POST /auth/login`) never returns multiple memberships to pick from — it
  silently auto-selects the most-recently-active one (`auth.service.ts:86`). The
  client's pre-login picker (`LoginResult.pickMembership`, `tenant_picker_screen.dart`,
  `/select-workspace`) has no backend counterpart.
- No endpoint lists a user's memberships at all. `GET /auth/memberships` (assumed by
  `AuthRepository.listMemberships`) doesn't exist; the only `/memberships` route is
  `PATCH /memberships/:id/role` (admin-only role promotion). The post-login
  workspace switcher (`workspace_switcher.dart`) calls `loadMemberships()` into a void.
- MFA is structurally different: real flow resubmits the *original* `/auth/login` (or
  `/auth/switch-tenant`) call with `totp_code` added — no separate `/auth/mfa` verify
  endpoint, no opaque `mfa_token`. First-privileged-login returns
  `{mfa_enrollment_required, enrollment_token, otpauth_url, secret}`; already-enrolled
  returns `{mfa_required: true}`. There is no backup-codes concept server-side, yet
  `MfaEnrollScreen` already renders a fully-built hardcoded backup-codes grid.
- `/auth/switch-tenant` requires an existing Bearer token (not `@Public()`) plus
  `refresh_token` in the body; client sent `tenant_id` + `mfa_token` only, pre-auth.
- `/invitations/accept` requires a nested `consent: {tos, privacy, baa_ack}` object;
  `InviteAcceptScreen` never collects it.
- Signup (`POST /auth/signup`) is **not** a gap — `OnboardingRepository`/
  `ApiOnboardingRepository` already calls it correctly per the live schema. It's owned
  by `onboarding.md`, not `auth.md`; confirmed this is not duplicated work.

## Decisions (full rationale + rejected alternatives in `features/auth.md`)

D1 drop pre-login picker · D2 cut workspace switcher this pass (no backend support;
flag a memberships-list endpoint as a future cross-repo ask, don't fake it
client-side) · D3 rebuild MFA around login-resubmission, delete backup-codes UI ·
D4 hold password in volatile notifier memory only across the MFA round-trip, never
persisted/logged · D5 signup explicitly out of scope (already correct, owned
elsewhere) · D6 add required consent checkboxes to invite-accept · D7 add a
QR-rendering pub dependency (`qr_flutter` proposed, not locked) so MFA enrollment
renders a real scannable code instead of the current hardcoded checkerboard
placeholder.

## Rejected approaches (and why)

- Faking the membership picker via a separately-fetched list — no endpoint backs it.
- Requesting a backend contract change to return multiple memberships from login —
  blocks this work on an upstream change for a UX nice-to-have; backend repo is
  owned upstream (`platform-references.md`).
- Keeping the backup-codes UI dormant/flagged for later — decided to delete it now
  rather than leave dead UI wired to nothing.
- Flagging the password-retention requirement back to `leo-api` as a contract issue —
  accepted as-is; it's the backend's deliberate design (`handlePrivilegedMint`).

## Next action

Dispatch implementation against the corrected `features/auth.md` (not started this
session): rewrite `auth_repository.dart` (login gains optional `totpCode`, drops
`selectMembership`/`switchTenant`/`listMemberships`), `auth_notifier.dart` (hold
pending email/password across MFA round-trip), `auth_state.dart` (drop
`pickMembership` arm + workspace fields), `mfa_screen.dart` (real QR, no backup
codes), `reset_password_screen.dart` (`InviteAcceptScreen` consent checkboxes);
delete `tenant_picker_screen.dart` + `workspace_switcher.dart` + `/select-workspace`
route; confirm and add the QR package. See `.pineapple/state.md` Open items.
