# Feature: otp-email-verification

**Status:** Drafted · **Phase:** P1 signup/verify primitives (alpha.4+) · **Owner:** client

## Summary

In-app **6-digit OTP** email verification for personal and customer signups, plus
login re-entry when the backend returns `401` / `"Email not verified"`. Wire calls
live in **`lib/core/auth/`** (`AuthRepository.verifyEmail`, `resendVerifyEmail`);
presentation is split: **onboarding** owns the verify screen + `SignupNotifier`;
**auth** owns `AuthState.emailVerificationPending` and router redirect (A1).

## User-facing behaviour

After signup or failed login (unverified), the user lands on `/verify-email` with
`email`, `source` (`signup`|`login`), and `path` (`personal`|`customer`) query
params. They enter a 6-digit code, can resend, and on success the app mints a
session via the same `LoginResult` path as login (MFA enrollment or challenge when
applicable). No magic-link handoff to `leo-web`; no `?verified=success` on login.

## Acceptance criteria

1. Signup success sets `AuthState.unauthenticated.emailVerificationPending` — router redirects to `/verify-email?...` (no imperative `push`).
2. Login `401` unverified sets the same metadata with `source=login`.
3. `POST /auth/verify-email` `{ email, code }` → `LoginResult`; success calls `AuthNotifier.applyLoginResult(fromEmailVerify: true)`.
4. Resend calls `POST /auth/resend-verify` `{ email }`; UI shows sending state via `signupUiProvider`.
5. **A7:** If verify returns `mfa_required` with `firstLogin: false`, surface error — user must sign in again (unexpected after verify). Enrollment (`firstLogin: true`) routes to `/mfa/enroll` normally.
6. Wrong-email affordance returns to signup; duplicate email on re-signup → `409`.

## Wire-format contract

- **`POST /auth/verify-email`** `{ email, code }` → same discriminated shape as login (`access_token` pair or MFA arms).
- **`POST /auth/resend-verify`** `{ email }` → `200` (no enumeration).
- **Transformation owner:** `core/auth/data/AuthRepository` (`INV-CLIENT-AUTH-REPO-1`).

## Key decisions

- **KD1 — OTP in-app, not web handoff.** *Rejected:* magic-link pending screen only (2026-07-07 interim) — restored OTP for closed-pilot self-service.
- **KD2 — Router metadata, not screen `push`.** `emailVerificationPending` on `AuthState` is router-consumed (`INV-CLIENT-STATE-2`).
- **KD3 — Shared wire in `core/auth`.** Both `auth` and `onboarding` notifiers call `authRepositoryProvider`; no duplicate DTOs in feature `data/`.

## Non-goals

LSP email verify (LSP signup stays `leo-web`). Deep-link token verify from email app (future). Admin surfaces.

## Touches

`INV-CLIENT-STATE-2`, `INV-CLIENT-AUTH-REPO-1`, `INV-CLIENT-ROUTE-GUARD-1`, `INV-CLIENT-STATE-1`, `INV-CLIENT-CONTRACT-1`.

## Depends on

`core/auth`, `auth` (`AuthNotifier`, `AuthState`), `onboarding` (`VerifyEmailScreen`, `SignupNotifier`), `router` (`redirect.dart`, `verifyEmailLocation`).

## Open questions (A8 — do not block taskgraph)

- **"Remember device"** — product semantics still open; no wire impact on verify.
- **Interpreter MFA timing** — confirm MFA is not forced for tenant-less interpreters until affiliated (org policy).
- **Production email format** — confirm OTP copy/branding with backend ops; client only renders code field.
- **Backend `interpreter-profiles`** — onboarding step after verify depends on alpha.5 timing (see `onboarding.md`).
