# leo-workstation — Feature specs

> One spec per feature slice (200–800 words, authored via `/pineapple:feature-spec`).
> Status seeded by `/pineapple:ongoing` (2026-06-29) — most specs are **pending**;
> author them in the Phase 4a loop. Implementation order:
> [`docs/release-plan.md`](../../docs/release-plan.md).

| Feature | First version | Area | Spec |
|---|---|---|---|
| **core-shell** | `v0.0.1-alpha.1` | `core/`, `app.dart` | [`core-shell.md`](core-shell.md) ✅ drafted — bootstrap/config/theme/DeviceClass/dio+cert-pin/token storage/chrome |
| **auth** | `v0.0.1-alpha.1` (alpha.4 contract) | `features/auth/` | [`auth.md`](auth.md) ✅ drafted — login/MFA/switch-tenant/multi-membership/token storage |
| **onboarding** | P2 `v0.0.1` (signup primitives alpha.4) | `features/onboarding/` | [`onboarding.md`](onboarding.md) ✅ drafted — native signup+verify+onboarding for personal+customer; LSP→leo-web; self-service from pilot |
| **realtime** | `v0.0.1-alpha.1` | `features/realtime/` | _pending_ |
| **router** | `v0.0.1-alpha.1` | `core/router/` | [`router.md`](router.md) ✅ drafted — go_router + pure redirect table (auth×device×location), role homes, device gating |
| **interpreter-workstation** | `v0.0.1` (P2) | `features/idle/`, `features/session/` | _pending_ |
| **customer-call** | `v0.0.1` (P2; mobile P3) | `features/call/`, `features/requests/` | _pending_ |
| **dispatch-portal** | `v0.0.1` (P2; `sub_admin` P3) | `features/dispatch/` | _pending_ |
| **session** (shared) | `v0.0.1` (P2) | `features/session/` | _pending_ |
| **web-admin-back-office** | P2→P4 | **`leo-web` (not this repo)** | [`web-admin-back-office.md`](web-admin-back-office.md) (cross-repo ref) |

## Next step

Run the Phase 3→4 gate (`/pineapple:prd-readiness`), then loop
`/pineapple:feature-spec` per P1 feature (core-shell, auth, realtime, router),
then `/pineapple:cross-spec-audit`.
