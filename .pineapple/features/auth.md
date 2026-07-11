# Feature: auth (client)

**Status:** Drafted · **Phase:** P1 / `v0.0.1-alpha.1` — **contract corrected 2026-06-30** against the live backend (`localhost:3000/api/v1`, verified via `/api/docs-json` + `leo-api` source) · **Owner:** client

## Summary

The single authentication path for the Flutter ops client: email/password login,
MFA challenge + first-time enrollment, session restore, logout, secure token
storage, and password-reset OTP. **Wire layer:** `lib/core/auth/` (`AuthRepository`,
`INV-CLIENT-AUTH-REPO-1`) — shared by `auth` and `onboarding` features.
**Presentation:** `features/auth/` (`AuthNotifier`, screens, `AuthState`).
The client remains a thin consumer (`INV-CLIENT-CONTRACT-1`).

## What changed from the original draft

Live-reading `leo-api/src/modules/auth/*` and the running server's swagger JSON
surfaced five contract mismatches the original draft assumed away. Each is now a
locked decision (see **Key decisions**) rather than an open question:

1. Login never returns multiple memberships to choose from — it silently picks the
   most-recently-active one. The pre-login picker is dropped.
2. No endpoint lists a user's memberships. The in-app workspace switcher is cut for
   this pass.
3. MFA verification resubmits the original `/auth/login` call with `totp_code` —
   there is no separate verify endpoint, no opaque `mfa_token`, and no backup-codes
   concept server-side.
4. `/auth/switch-tenant` requires an existing Bearer token plus `refresh_token` in
   the body (not just `tenant_id`) — but per decision 2 it has no v1 caller.
5. `/invitations/accept` requires a `consent` object the invite-accept screen never
   collected.

## User-facing behaviour

`/login` (email, password, "remember device", "Forgot password?", "Create an
account"). On submit: a non-privileged user lands directly on their role home. A
privileged user without TOTP enrolled is routed to `/mfa/enroll` (real QR + manual
key, generated from the server's `otpauth_url`); already-enrolled privileged users go
to `/mfa` (6-digit code). A 0-membership interpreter gets a tenant-less session and
lands on `/idle`. **`platform_admin` sessions are rejected at mint** — error on
`/login`, use `leo-web` (no `/web-handoff` route). Login with unverified email sets
`emailVerificationPending` on `AuthState`; router redirects to `/verify-email` (A1 —
no screen `push`). Entry paths `/forgot-password` → `/forgot-password/verify` →
`/reset-password` (two-step OTP + `reset_ticket` extra) and `/invite/accept` (ToS/privacy/BAA
consent) also resolve here.

**Cut for this pass:** the pre-login tenant/membership picker (`/select-workspace`),
the in-app "Your workspaces" switcher, and backup codes on the MFA enroll screen —
none have backend support today (see Non-goals).

## User flow & affordances

Role redirect remains a pure function of auth state via `go_router`
`refreshListenable` (`INV-CLIENT-STATE-1`) — no imperative navigation.

- **MFA challenge round-trip.** Login with a privileged, MFA-unsatisfied account
  returns either `{ mfa_enrollment_required, enrollment_token, otpauth_url, secret }`
  (first time) or `{ mfa_required: true }` (already enrolled). Both cases route to an
  MFA screen that **resubmits the original credentials plus the TOTP code** — the
  client holds the plaintext password in volatile notifier state for this round-trip
  only (never persisted, never logged; cleared on success, failure, or navigating
  away). Enrollment renders the real `otpauth_url` as a scannable QR (new dependency,
  e.g. `qr_flutter`) plus the manual key as text; there is no backup-codes step.
- **Login picker / workspace switcher** — removed from this pass. `LoginResult` no
  longer has a `pickMembership` arm; `AuthState` drops `pickMembership` and the
  `memberships`/`membershipsLoading`/`switchingTenant`/`expandedPrivilegedTenantId`
  fields. `tenant_picker_screen.dart` and `workspace_switcher.dart` are deleted along
  with `AuthRepository.listMemberships`/`selectMembership`/`switchTenant` and the
  `/select-workspace` route.

## Acceptance criteria

1. Login persists tokens and redirects to the role home with no manual navigation; a 0-membership interpreter gets a tenant-less token (`role: interpreter`, no `tenant_id`) and lands on `/idle`.
2. A privileged role not yet TOTP-enrolled is routed to `/mfa/enroll`; submitting a valid code resubmits the held credentials + `totp_code` to `/auth/login` and completes login. An already-enrolled privileged role is routed to `/mfa` instead, same resubmit mechanism.
3. The held password is never written to disk, secure storage, or logs, and is cleared from notifier state immediately after the MFA round-trip resolves (success or failure) or if the user navigates away.
4. Refresh token is stored in `flutter_secure_storage`; access token stays in memory; logout clears both and the secure store; cold start with a stored refresh restores the session (or routes to `/login` if absent/expired/`401`).
5. `/forgot-password` always shows the same "if that email exists…" result (no account enumeration); `/forgot-password/verify` accepts OTP → `reset_ticket`; `/reset-password` consumes `reset_ticket` via route `extra` and surfaces `400`/`410` distinctly.
6. `/invite/accept` collects `tos`, `privacy`, and `baa_ack` consent (checkboxes, all required) and sends them nested under `consent` per the real DTO; a request missing any of them is never sent.
7. Login `401` unverified email sets `emailVerificationPending` — router sends user to `/verify-email?source=login` (no `?verified=success` query).
8. `platform_admin` JWT after login/refresh is rejected — tokens cleared, error shown (`AuthStrings.platformAdminUseWeb`).
9. No UI path calls `listMemberships`, `selectMembership`, `switchTenant`, or renders a multi-membership picker or backup codes.

## Wire-format contract (verified live against `localhost:3000/api/v1`)

All paths below are confirmed against `/api/docs-json` and `leo-api` source as of 2026-06-30 — not assumed.

- **`POST /auth/login`** `{ email, password, totp_code? }` →
  - `200 { access_token, refresh_token, expires_in }` on success,
  - `200 { mfa_enrollment_required: true, enrollment_token, otpauth_url, secret }` — privileged, not yet enrolled,
  - `200 { mfa_required: true }` — privileged, enrolled, no/invalid `totp_code` supplied,
  - `401` bad credentials or unverified email.
- **`POST /auth/mfa/enroll`** `{ enrollment_token, totp_code }` → `200 { access_token, refresh_token, expires_in }`. (No separate "submit MFA" endpoint — re-POST `/auth/login` with `totp_code` instead.)
- **`POST /auth/refresh`** `{ refresh_token }` → same token-pair shape. **`POST /auth/logout`** `{ refresh_token }` → `204`.
- **`POST /auth/forgot-password`** `{ email }` → always `200 { sent: true }`. **`POST /auth/reset-password/verify`** `{ email, code }` → `{ reset_ticket, expires_at }`. **`POST /auth/reset-password`** `{ reset_ticket, new_password }` → `200 { reset: true }`; `400`/`410` on invalid/expired.
- **`POST /invitations/accept`** `{ token, password, consent: { tos, privacy, baa_ack } }` → `201`, tokens not returned (caller must then log in).
- **`POST /auth/switch-tenant`** (authenticated, `Roles('auth:switch-tenant')`) `{ tenant_id, refresh_token, totp_code? }` → token pair or `{ mfa_required: true }`; `404` if the tenant isn't an actively held membership. **Defined for completeness; no v1 caller** (decision D2).
- **Access token** = JWT, claims `{ sub, role, tenant_id?, exp, iat, jti }` (unchanged from original draft — `exp`/`iat` are Unix-seconds; `tenant_id` absent for tenant-less). `onboarding_required` as a claim is still unconfirmed server-side — tracked in `onboarding.md`, not here.
- **Refresh token** = opaque string, returned once, never re-echoed, never logged (`INV-CLIENT-PHI-1`).
- **Transformation owner:** `core/auth/data/AuthRepository` (`INV-CLIENT-AUTH-REPO-1`). `features/auth/data/auth_repository.dart` re-exports core — not a second implementation.

## Key decisions (with rejected alternatives)

- **D1 — Drop the pre-login membership picker.** Login always auto-resolves to the server's chosen membership; `LoginResult.pickMembership` and `/select-workspace` are removed. *Rejected:* fetching a full membership list separately to fake a picker (no endpoint exists to back it); requesting a backend change to return multiple memberships from login (blocks this work on an upstream contract change for a UX nice-to-have).
- **D2 — Cut the in-app workspace switcher for this pass.** No endpoint lists a user's memberships, so `loadMemberships`/`switchTenant`/the workspace menu have nothing to call; ship single-membership sessions only. *Rejected:* deriving a partial list from the JWT or probing `switch-tenant` speculatively (fragile, no real data source). **Revisit when/if `leo-api` adds a self-scoped memberships-list endpoint** — flagged as a cross-repo ask, not silently worked around.
- **D3 — Rebuild MFA around login-resubmission; drop backup codes.** Match the backend's actual model (resubmit `/auth/login` or `/auth/switch-tenant` with `totp_code`; no separate verify call, no `mfa_token`). Backup codes have no server-side concept — the existing hardcoded backup-codes grid in `MfaEnrollScreen` is deleted, not just disconnected. *Rejected:* keeping the backup-codes UI dormant/flagged for a future backend ask (decided against — remove until the backend actually supports it).
- **D4 — Hold the password in volatile memory across the MFA round-trip.** The real contract requires resending `email`+`password`+`totp_code` together; the client therefore must retain the plaintext password between the initial login attempt and TOTP submission. In-memory only (notifier state), never persisted, cleared on resolution. *Rejected:* flagging this to `leo-api` as a contract issue (e.g. a short-lived pending-login token instead) — accepted as-is for v1 since it's the backend's actual, deliberate design (`auth.service.ts` `handlePrivilegedMint`).
- **D5 — Auth wire consolidated in `core/auth`.** Signup, verify-email, and resend-verify live in `AuthRepository` alongside login/MFA/reset — shared by `auth` and `onboarding` notifiers. Onboarding UI stays in `onboarding.md` / `otp-email-verification.md`. *Rejected:* duplicate DTOs in `OnboardingRepository` (drift risk).
- **D6 — `/invite/accept` must collect and send consent.** Add `tos`/`privacy`/`baa_ack` checkboxes to `InviteAcceptScreen`; the real DTO requires all three. *Rejected:* none — the endpoint 400s without it, not optional.
- **D7 — Add a QR-rendering dependency.** `MfaEnrollScreen`'s QR is currently a hardcoded fake checkerboard; render the server's `otpauth_url` for real via a new pub package (e.g. `qr_flutter`). *Rejected:* manual-key-only enrollment (shown as text today) — acceptable as a fallback affordance but not a substitute for a scannable code.

## Non-goals

Multi-tenant switching (workspace switcher, `switch-tenant` usage) — deferred to a
future pass pending a memberships-list endpoint (D2). Pre-login membership picker
(D1). Backup/recovery codes for MFA (D3) — no backend support. Signup/onboarding
(D5) — owned by [`onboarding.md`](onboarding.md), already correctly wired. No
admin/back-office routes (`INV-CLIENT-ROUTE-1`).

## Touches

`INV-CLIENT-AUTH-REPO-1` (shared wire in `core/auth`), `INV-CLIENT-AUTH-1` (token split), `INV-CLIENT-AUTH-2` (one Bearer path), `INV-CLIENT-AUTH-3` (tenant-less gating + `/idle` landing), `INV-CLIENT-AUTH-4` (sole writer of the access-token holder), `INV-CLIENT-NET-1` (cert pinning on the auth `dio`), `INV-CLIENT-STATE-1` (redirect = f(state)), `INV-CLIENT-STATE-2` (owns the `AuthState` contract — `emailVerificationPending` is router-consumed), `INV-CLIENT-ROUTE-1` (no admin routes), `INV-CLIENT-ROUTE-2` (`platform_admin` rejected at mint), `INV-CLIENT-ARCH-1`, `INV-CLIENT-CONTRACT-1`, `INV-CLIENT-PHI-1`.

## Depends on

Backend `auth-identity-tokens` (live-verified 2026-06-30 against `localhost:3000/api/v1`, superseding the `platform-references.md` pointer as the source of truth for this revision). Client `core-shell` (`dioProvider`, `appConfigProvider`, `tokenStorageProvider`, `currentAccessTokenProvider`) and `router` (consumes `AuthState`) — both ✅ drafted. New: a QR-rendering pub package (D7, unselected — propose `qr_flutter` unless the user prefers another).

## Approach

`features/auth/`: presentation only for auth flows. Wire: `lib/core/auth/` —
`AuthRepository.login` with optional `totpCode`; `verifyResetCode` +
`resetPassword(resetTicket:)`; `applyLoginResult(fromEmailVerify:)` handles post-verify
MFA (A7). `presentation/notifiers/auth_notifier.dart`: `setEmailVerificationPending` /
`clearEmailVerificationPending`; `_applySession` rejects `platform_admin`.
`presentation/state/auth_state.dart`: `unauthenticated.emailVerificationPending`.
Delete `tenant_picker_screen.dart`, `workspace_switcher.dart`, `/select-workspace`,
`/web-handoff`.

## Open questions / Out of scope

- **Memberships-list endpoint** — needed to bring back the workspace switcher (D2); not yet requested upstream. Owner: founder to file against `leo-api` if/when multi-tenant switching is prioritized.
- **`onboarding_required` JWT claim** — still unconfirmed server-side; tracked in `onboarding.md`, not blocking this spec (tenant-less/single-membership login doesn't depend on it).
- **"Remember device" semantics** — unresolved from the original draft; still open, not touched by this revision.
- **QR package choice** — `qr_flutter` proposed but not locked; confirm before implementation (D7).
