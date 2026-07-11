# Feature: router

**Status:** Drafted · **Phase:** P1 / `v0.0.1-alpha.1` · **Owner:** client

## Summary

`go_router` configuration and the **redirect guard**: route tree, role→home mapping, and a redirect that is a **pure function of (auth state, device class, location path, route context)** via `refreshListenable`. Router consumes `AuthState` (`auth`) and `DeviceClass` (`core-shell`); it never owns auth logic (`INV-CLIENT-STATE-1`).

## User-facing behaviour

Signed-out users on protected routes → `/login`. MFA states trap on `/mfa` or `/mfa/enroll`. Authenticated users land on role homes and are bounced off auth/public signup surfaces. `platform_admin` sessions are **rejected at mint** (no in-app home, no `/web-handoff`).

## Acceptance criteria

1. `redirect` is pure over (auth, device, path, `extra`, query params) and re-runs on auth changes.
2. **PUBLIC** = `authPublicRoutes` ∪ `onboardingPublicRoutes` (composed in `redirect.dart`).
3. `mfaRequired` traps on `/mfa` or `/mfa/enroll` — no `pickMembership` / `/select-workspace`.
4. **Role→home** (`INV-CLIENT-ROUTE-2`): interpreter→`/idle`, `customer_user`+`customer_admin`→`/call`, `sub_admin`/`lsp_admin`→`/dispatch`.
5. **Authenticated on public routes** (signup/verify/login/forgot) → role home (A2).
6. **`emailVerificationPending`** on `unauthenticated` → redirect to `/verify-email?...` (A1) — no imperative `push` from login/signup.
7. **Context guards** in `redirect.dart` + `route_guards.dart` only (`INV-CLIENT-ROUTE-GUARD-1`) — verify-email, forgot-verify, reset-password, signup/details.
8. Device gating + loop-safety tests (AC-8).

## Redirect contract

`AuthState` arms (`INV-CLIENT-STATE-2`): `unauthenticated(forgotPasswordSending?, resendCodeSending?, emailVerificationPending?)` · `loading` · `error` · `mfaRequired(...)` · `authenticated(role, tenantId?, onboardingRequired)`.

| Auth state | Condition | Result |
|---|---|---|
| `unauthenticated` | `emailVerificationPending` set, path ≠ `/verify-email` | `/verify-email?email=…&source=…&path=…` |
| `unauthenticated` | context guard fails (missing `extra`/query) | fallback route |
| `unauthenticated` | path ∈ PUBLIC | `null` |
| `unauthenticated` | else | `/login` |
| `authenticated` | path ∈ PUBLIC (non-onboarding) | role home |
| `authenticated` | `onboardingRequired` && path ∉ `/onboarding/*` | onboarding entry by role |
| `authenticated` | path ∈ auth screens | role home |
| `mfaRequired` | — | `/mfa/enroll` or `/mfa` |

**PUBLIC:** `/login`, `/forgot-password`, `/forgot-password/verify`, `/reset-password`, `/invite/accept`, `/signup`, `/signup/details`, `/verify-email`.

`onboardingRequired` from JWT claim `onboarding_required` (`Claims.onboardingRequired`).

## Non-goals

`/web-handoff` (removed — `platform_admin` rejected at session mint). Auth notifiers, screen content, WSS.

## Touches

`INV-CLIENT-STATE-1/2`, `INV-CLIENT-ROUTE-2`, `INV-CLIENT-ROUTE-GUARD-1`, `INV-CLIENT-AUTH-3`, `INV-CLIENT-DEVICE-1`, `INV-CLIENT-ROUTE-1`.

## Depends on

`core-shell`, `auth` (`AuthState` only), feature route modules for registration.

## Open questions

Splash during `loading`; device breakpoints — shared with `core-shell`.
