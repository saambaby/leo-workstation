# leo-workstation — Phases

> Client phases track the **same version tags** as `../leo-api/docs/release-plan.md`
> (strict-superset per version). Implementation driver: [`docs/release-plan.md`](../../docs/release-plan.md).

## Current target

**P2 onboarding primitives — `v0.0.1-p2-onboarding`.** Signup + OTP verify + personal/customer
onboarding wizards against **alpha.6 OTP backend**. Carve:
[`v0.0.1-p2-onboarding-taskgraph.md`](v0.0.1-p2-onboarding-taskgraph.md).
Cross-spec audit: [`cross-spec-audit.md`](../cross-spec-audit.md) ✅ PASS (2026-07-11).

> **Auth contract:** P1 built against the **live backend** (single-membership login, no
> picker/switcher — `auth.md` D1/D2). Wire in `lib/core/auth/` (`INV-CLIENT-AUTH-REPO-1`).
> OTP verify/reset paths match **alpha.6** (`/auth/resend-verify`, `/auth/reset-password/verify`).

## Map

| Phase | Tag | Status | Doc |
|---|---|---|---|
| P0 | — | ✅ done (scaffold) | [`phase-0-scaffold.md`](phase-0-scaffold.md) |
| P1 | `v0.0.1-alpha.1` | ✅ shipped (core-shell, auth, router) | [`v0.0.1-alpha.1.md`](v0.0.1-alpha.1.md) · taskgraph: [`v0.0.1-alpha.1-taskgraph.md`](v0.0.1-alpha.1-taskgraph.md) (revised 2026-07-11) |
| P1 (auth correction) | `v0.0.1-alpha.1-auth-live` | ✅ shipped | [`v0.0.1-alpha.1-auth-live-taskgraph.md`](v0.0.1-alpha.1-auth-live-taskgraph.md) |
| P2 (onboarding) | `v0.0.1-p2-onboarding` | **running** — orchestrated 2026-07-11 ([#23](https://github.com/saambaby/leo-workstation/issues/23)) | [`v0.0.1-p2-onboarding.md`](v0.0.1-p2-onboarding.md) · taskgraph: [`v0.0.1-p2-onboarding-taskgraph.md`](v0.0.1-p2-onboarding-taskgraph.md) |
| — | `v0.0.1-alpha.2/3` | n/a (no client release) | release-plan |
| — | `v0.0.1-alpha.4` | folded into P1 auth contract (picker cut) | `features/auth.md` |
| — | `v0.0.1-alpha.5` | minimal pre-P2 (`platform_admin`, affiliations if needed) | release-plan |
| (P1b) | — | **realtime** (WSS) — deferred; spec pending | release-plan |
| P2 | `v0.0.1` | planned (MVP) — session/dispatch/call pending | release-plan |
| P3+ | `v0.1.0`→`v1.0.0` | planned | release-plan |

## Phase-carve note (2026-06-29, updated 2026-07-11)

`{core-shell → auth → router}` shipped as P1. **Onboarding** carved to P2 with its own
taskgraph (`v0.0.1-p2-onboarding`) — signup/verify scaffold exists on disk; orchestration
targets integration + E2E smoke. **realtime** still deferred. Full P2 MVP
(session/dispatch/call) awaits feature specs.

## Pineapple adoption note

Next: `/pineapple:orchestrate v0.0.1-p2-onboarding` (after reviewing
[`cross-spec-audit.md`](../cross-spec-audit.md)).
