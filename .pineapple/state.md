# leo-workstation — As-built state

_Last updated: 2026-06-29 (Pineapple adopted via `/pineapple:ongoing`)._

> What is **actually built** in this repo right now, vs. what the docs target.
> Target architecture: [`docs/architecture-overview.md`](../docs/architecture-overview.md).
> Build order: [`docs/release-plan.md`](../docs/release-plan.md).

---

## Floor (shipped / on disk)

**Phase 0 — scaffold only.** This repo is pre-P1.

| Area | As-built |
|---|---|
| `lib/` | A single file: `main.dart` (~33 lines) — `CupertinoApp` → `WorkstationShell` placeholder (`CupertinoPageScaffold` + "Workstation shell" text). No router, no auth, no providers. |
| `pubspec.yaml` | `flutter`, `cupertino_icons`, `flutter_lints` only. **Not yet added:** `flutter_riverpod`, `go_router`, `dio`, `freezed`, `json_serializable`, `flutter_secure_storage`, `web_socket_channel`, Vonage SDK. |
| Tests | Default scaffold test dir; no feature tests. |
| Theming | Cupertino (`CupertinoApp`). The Material→Cupertino migration referenced in recent history is **done at the scaffold level**; `docs/architecture-overview.md` §theming note (which still says "current scaffold uses Material 3") is stale on that one point. |

There is **no feature code** (`lib/features/` does not exist yet). The MVVM/Riverpod
structure in the architecture doc is **target**, not as-built.

## Bridge (in flight / next)

**P1 / `v0.0.1-alpha.1` — App shell.** First real phase: `ProviderScope`, env
config, Cupertino theme, `DeviceClass`, auth (login/restore/logout/MFA + secure
token storage), `go_router` role redirect, Socket.IO `/realtime` channel.
Carve: [`phases/v0.0.1-alpha.1.md`](phases/v0.0.1-alpha.1.md).

## Platform dependency (sibling `../leo-api`)

| Backend | State |
|---|---|
| Current phase | **`v0.0.1-alpha.5` complete** — auth spine done (unified `POST /auth/signup`, multi-membership login, tenant-less token, `switch-tenant`, `platform_admin` slug, interpreter↔LSP affiliations). |
| Next backend phase | **P2 / `v0.0.1` MVP** — sessions, matching, first-dollar billing. |
| Auth contract for the client | Build P1 against the **alpha.4** contract from day one (multi-membership login + tenant picker, `switch-tenant`, `platform_admin`). Do **not** target the deprecated `POST /auth/lsp-signup` / single-membership login. |

The client is one auth-spine generation behind the backend: the backend already
shipped alpha.4/alpha.5; the client P1 must adopt that contract rather than the
original P1 auth shape.

---

## Migration status (docs restructure, 2026-06-29)

Executed `DOC-RESTRUCTURE-PLAN.md` alongside Pineapple adoption:

- ✅ `.pineapple/` stood up (this file, `config.yml`, `invariants-client.md`, `code-map.md`, `product-spec.md`, `architecture-overview.md` as-built, `phases/`, `features/`).
- ✅ `docs/platform/` deleted; replaced by [`docs/platform-references.md`](../docs/platform-references.md) (links to `../leo-api`, no copies).
- ✅ `docs/release-plan.md` rewritten with `alpha.1`–`alpha.5` sections + API-dependency blocks.
- ✅ `docs/product-spec.md` (client-scoped) created.
- ✅ Cross-refs fixed (`docs/`, `CLAUDE.md`, `.cursor/rules/`, root `README.md`).
- ⏳ Feature specs: index seeded under `.pineapple/features/`; per-feature specs authored via the `/pineapple:feature-spec` loop (Phase 4a) — only `auth.md` and `web-admin-back-office.md` stubs exist so far.

---

## Decisions (client-side)

- **2026-06-29 — Onboarding home (FINAL, supersedes the morning's first cut):** the
  workstation hosts the **full self-service flow for personal (interpreter) + customer**
  — signup (`a-signup`), email verification (`a-verify`), and onboarding (`o-personal`,
  `o-customer`). Only **LSP** signup + LSP onboarding stay in `leo-web`. *(Earlier
  same-day note had signup/verify on web with a web→native handoff; that handoff is now
  moot.)* Self-service signup is **live from the P2 closed pilot**, alongside
  invitations for admin-added members. Rejected: web→native handoff; all-onboarding-on-web;
  invitation-only pilot. Rippled through `client-map.md`, `product-spec.md`,
  `architecture-overview.md`, `release-plan.md`, `invariants-client.md`
  (`INV-CLIENT-ROUTE-1`), `web-admin-back-office.md`, `auth.md`, and the features index.
  Spec: [`features/onboarding.md`](features/onboarding.md).
- **BD7 reconciliation (de-escalated):** `../leo-api/docs/decision-log.md` line 223
  already scopes the Flutter onboarding non-goal precisely to "**LSP** onboarding
  wizards", so the client decision is **consistent**, not contradictory. BD7's
  parenthetical ("…settings, onboarding…") could be clarified upstream but needs no
  reversal.

## Open items

- **(Optional) BD7 clarification upstream** — `leo-api` decision-log BD7 parenthetical could spell out "LSP onboarding" for clarity; not contradictory, so low priority.
- **Onboarding backend deps** — confirm `interpreter-profiles` + cert proof upload (S3 presigned) timing (alpha.5 vs P2); see [`features/onboarding.md`](features/onboarding.md) open questions.
- **Onboarding success-metric numbers** — founder to set funnel-completion targets.
- `DOC-RESTRUCTURE-PLAN.md` can be archived/deleted now that the migration is merged (it was a one-shot plan).
- P1 dependency stack must be added to `pubspec.yaml` before feature work.
- Feature-spec loop: `auth`, `core-shell`, `router`, `onboarding` drafted; **`realtime` pending** — see [`features/INDEX.md`](features/INDEX.md). Then `/pineapple:cross-spec-audit`.
