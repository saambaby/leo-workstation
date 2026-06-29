# leo-workstation — repository map

*This repo — Flutter realtime ops client. Platform docs **linked** (not copied) via [`platform-references.md`](./platform-references.md) → `../leo-api`.*

> **Planning:** [`release-plan.md`](./release-plan.md) · [`client-map.md`](./client-map.md) · [`../.pineapple/features/INDEX.md`](../.pineapple/features/INDEX.md)

---

## This repo

| Field | Value |
|---|---|
| **Name** | `leo-workstation` |
| **Role** | One Flutter app — **three ops workstations** (interpreter · customer · dispatcher) |
| **Not in this repo** | LSP back-office UI (web admin app), backend API |
| **First shippable tag** | P2 MVP (`v0.0.1`) after P1 shell |

---

## Surfaces owned here

| Workstation | Role(s) | Home route |
|---|---|---|
| Interpreter | `interpreter` | `/idle` |
| Customer | `customer_user` | `/call` |
| Dispatcher | `sub_admin`, `lsp_admin` | `/dispatch` |

Detail: [`client-map.md`](./client-map.md).

---

## Phase delivery (this repo)

| Phase | Tag | Delivers |
|---|---|---|
| P0 | — | Cupertino placeholder (`lib/main.dart`) ✅ |
| P1 | `v0.0.1-alpha.1` | Auth, router, theme, WSS |
| **P2** | **`v0.0.1`** | **MVP** — Vonage loop, customer desktop/tablet, dispatch |
| P3 | `v0.1.0` | Customer mobile, scheduled/OPI, sub_admin |
| P4+ | `v0.2.0+` | Ops stable; billing read-only hints |

---

## Doc ownership

| Doc | Path |
|---|---|
| Client release plan | `docs/release-plan.md` |
| Client map | `docs/client-map.md` |
| Client product spec | `docs/product-spec.md` |
| Architecture (target) | `docs/architecture-overview.md` |
| Feature specs | `.pineapple/features/` |
| Client release gates | `docs/release-checklists.md` |
| Platform references (links) | `docs/platform-references.md` |
| Pineapple state | `.pineapple/state.md` |
| Client invariants | `.pineapple/invariants-client.md` |
| Code map | `.pineapple/code-map.md` |

---

*Companion: [`README.md`](./README.md) · Pineapple: `.pineapple/config.yml`.*
