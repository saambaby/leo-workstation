# leo-workstation — Feature specs

> One spec per feature slice (200–800 words, authored via `/pineapple:feature-spec`).
> Status seeded by `/pineapple:ongoing` (2026-06-29) — most specs are **pending**;
> author them in the Phase 4a loop. Implementation order:
> [`docs/release-plan.md`](../../docs/release-plan.md).

| Feature | First version | Area | Spec |
|---|---|---|---|
| **core-shell** | `v0.0.1-alpha.1` | `core/`, `app.dart` | [`core-shell.md`](core-shell.md) ✅ drafted — bootstrap/config/theme/DeviceClass/dio+cert-pin/token storage/chrome |
| **auth** | `v0.0.1-alpha.1` (alpha.4 contract) | `features/auth/` presentation + `core/auth/` wire | [`auth.md`](auth.md) ✅ drafted — login/MFA/session/token storage; wire in `core/auth` |
| **otp-email-verification** | P1 signup/verify (alpha.4+) | `core/auth/` wire · `onboarding/` + `auth/` presentation | [`otp-email-verification.md`](otp-email-verification.md) ✅ drafted — 6-digit OTP verify, resend, login re-entry via `emailVerificationPending` |
| **onboarding** | P2 `v0.0.1` (signup primitives alpha.4) | `features/onboarding/` (+ `core/auth` for signup/verify wire) | [`onboarding.md`](onboarding.md) ✅ drafted — native signup+verify+onboarding for personal+customer; LSP *onboarding*→leo-web (LSP *signup* delta owned by `lsp-native-signup.md`); self-service from pilot |
| **lsp-native-signup** | P2 delta ✅ shipped 2026-07-12 (E2E deferred) | `features/onboarding/` + `core/auth` | [`lsp-native-signup.md`](lsp-native-signup.md) ✅ drafted — in-app LSP signup→OTP→MFA; admin stays leo-web |
| **realtime** | `v0.0.1-alpha.1` | `features/realtime/` | _pending_ |
| **router** | `v0.0.1-alpha.1` | `core/router/` | [`router.md`](router.md) ✅ drafted — go_router + pure redirect table (auth×device×location), role homes, device gating |
| **interpreter-workstation** | `v0.0.1` (P2) | `features/idle/`, `features/session/` | _pending_ |
| **customer-call** | `v0.0.1` (P2; mobile P3) | `features/call/`, `features/requests/` | _pending_ |
| **dispatch-portal** | `v0.0.1` (P2; `sub_admin` P3) | `features/dispatch/` | _pending_ |
| **session** (shared) | `v0.0.1` (P2) | `features/session/` | _pending_ |
| **web-admin-back-office** | P2→P4 | **`leo-web` (not this repo)** | [`web-admin-back-office.md`](web-admin-back-office.md) (cross-repo ref) |

## Next step

Cross-spec audit ✅ [`cross-spec-audit.md`](../cross-spec-audit.md) (2026-07-11).

**Start taskgraph:** `/pineapple:orchestrate v0.0.1-p2-onboarding` — see
[`phases/v0.0.1-p2-onboarding-taskgraph.md`](../phases/v0.0.1-p2-onboarding-taskgraph.md).

Remaining spec loop: `realtime`, `interpreter-workstation`, `customer-call`, `dispatch-portal`.
