# leo-workstation — Phases

> Client phases track the **same version tags** as `../leo-api/docs/release-plan.md`
> (strict-superset per version). Implementation driver: [`docs/release-plan.md`](../../docs/release-plan.md).

## Current target

**P1 / `v0.0.1-alpha.1` — App shell.** core-shell + auth + router (theme, config,
`DeviceClass`, cert-pinned `dio`, secure tokens, redirect). **Realtime/WSS deferred**
(re-carved 2026-06-29). Carve: [`v0.0.1-alpha.1.md`](v0.0.1-alpha.1.md). All three
specs drafted ✅.

> **Auth dependency:** build P1 against the **alpha.4** backend auth contract from
> day one (multi-membership login + tenant picker, `switch-tenant`, `platform_admin`
> slug). The backend is already at `alpha.5`; the client is catching up to that
> contract in its first real phase. See [`features/auth.md`](../features/auth.md).

## Map

| Phase | Tag | Status | Doc |
|---|---|---|---|
| P0 | — | ✅ done (scaffold) | [`phase-0-scaffold.md`](phase-0-scaffold.md) |
| P1 | `v0.0.1-alpha.1` | 🎯 next — specs ✅ (core-shell, auth, router) | [`v0.0.1-alpha.1.md`](v0.0.1-alpha.1.md) |
| — | `v0.0.1-alpha.2/3` | n/a (no client release — backend-only) | release-plan |
| — | `v0.0.1-alpha.4` | folded into P1 auth contract | release-plan / `features/auth.md` |
| — | `v0.0.1-alpha.5` | minimal pre-P2 (`platform_admin`, affiliations if needed) | release-plan |
| (P1b) | — | **realtime** (WSS) — deferred from alpha.1; spec pending | release-plan |
| P2 | `v0.0.1` | planned (MVP) — **onboarding** ✅ specced; session/dispatch/call pending | release-plan |
| P3+ | `v0.1.0`→`v1.0.0` | planned | release-plan |

## Phase-carve note (2026-06-29)

Four-question diagnostic on the drafted scope returned **4× Yes → split**. The
`{core-shell → auth → router}` cluster is the load-bearing app-shell phase
(`v0.0.1-alpha.1`) and is *not* split further (tightly coupled). **realtime** was cut
from alpha.1 (deferred). **onboarding** is carved to **P2** with the not-yet-specced
MVP features; P2 is **not** fully carved until session/dispatch/call are specced.

## Pineapple adoption note

Adopted onto the existing repo via `/pineapple:ongoing` (2026-06-29). The code is
pre-P1 (scaffold); Phases 1–3 were reverse-engineered from the rich `docs/` layer
and the sibling backend, not from built client code. Next: run the Phase 3→4 gate
(`/pineapple:prd-readiness`), then the `/pineapple:feature-spec` loop for P1
features.
