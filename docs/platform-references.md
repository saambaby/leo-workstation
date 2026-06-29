# Platform references (canonical in `leo-api`)

> Platform architecture, product rules, and version sequencing are owned by the
> **`leo-api`** backend repo (sibling: `../leo-api`). **Do not copy** those docs
> into this repo — edit upstream and link from here. This replaces the old
> `docs/platform/` copies, which drifted from the backend.

| Topic | Canonical path (sibling monorepo) |
|---|---|
| Platform architecture | `../leo-api/docs/architecture.md` |
| Platform architecture (API-scoped) | `../leo-api/docs/architecture-overview.md` |
| Platform product spec | `../leo-api/docs/product-spec.md` |
| Decision log | `../leo-api/docs/decision-log.md` |
| Backend release plan | `../leo-api/docs/release-plan.md` |
| Platform release gates | `../leo-api/docs/release-checklists.md` |
| Pre-launch checklist | `../leo-api/docs/pre-launch-checklist.md` |
| Platform invariants | `../leo-api/.pineapple/invariants.md` |
| Backend feature specs | `../leo-api/.pineapple/features/INDEX.md` |
| Client map (backend's one-page glimpse) | `../leo-api/docs/client-map.md` |

## Citation conventions

Used throughout `docs/` and `.pineapple/`:

| Shorthand | Resolve via |
|---|---|
| `arch §N` | `../leo-api/docs/architecture.md` |
| `ps §N` (platform-wide) | `../leo-api/docs/product-spec.md` |
| `ps §N` (client-owned) | `docs/product-spec.md` |
| `BD*` decisions | `../leo-api/docs/decision-log.md` |
| `D*` / `L*` gates | `../leo-api/docs/pre-launch-checklist.md` |
| `INV-*` (platform) | `../leo-api/.pineapple/invariants.md` |
| `INV-CLIENT-*` | `.pineapple/invariants-client.md` |

> **Prerequisite:** the `../leo-api` sibling must exist (monorepo layout:
> `leo/leo-api`, `leo/leo-workstation`). Treat it as **read-only** — link, don't copy.
