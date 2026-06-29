# Leo — client map

> Decisions **BD1** · **BD7**: `../leo-api/docs/decision-log.md` (via [`platform-references.md`](./platform-references.md)). Per-version scope: [`release-plan.md`](./release-plan.md).

*Which surfaces this Flutter app owns, how roles route after login, and device build sequencing. Backend contract: REST + WSS from the platform API.*

---

## One app, three ops workstations (`leo-workstation`)

**`leo-workstation` is not interpreter-only.** The repo name means *field + dispatch realtime ops* — one Flutter binary, **`go_router` role redirect** after login (BD1). Each role lands on its own ops workstation inside the same app:

| Ops workstation | Who uses it | API role(s) | Home | Also |
|---|---|---|---|---|
| **Interpreter workstation** | Field interpreters | `interpreter` | `/idle` | `/session/:id`, `/tasks`, `/reports` |
| **Customer workstation** | Enterprise requesters | `customer_user` | `/call` | `/requests` (+ `/session/:id` when live) |
| **Dispatcher workstation** | LSP dispatch staff | `sub_admin`, `lsp_admin` | `/dispatch` | LSP Admin: **link** to `leo-web` back-office (not a Flutter route) |

**Not a fourth workstation in this app:** LSP **back-office** (user CRUD, reports, rate cards, **LSP** onboarding) → **`leo-web` only** (BD7). Superadmin and Customer Admin also live on web, not in this binary.

> **Onboarding split (decided 2026-06-29):** the **full self-service flow for personal (interpreter) + customer** — signup, email verification, and onboarding (`a-signup`, `a-verify`, `o-personal`, `o-customer`) — runs **natively in this app**. Only **LSP** signup + LSP onboarding (languages/partners/pricing) stay in `leo-web`. Consistent with `leo-api` decision-log line 223 ("**LSP** onboarding wizards" is the precise Flutter non-goal). See [`onboarding.md`](../.pineapple/features/onboarding.md).

P2 closed pilot uses three **active API roles** on these surfaces: Interpreter, Customer User, and LSP Admin (who wears dispatcher + web back-office). **Sub-Admin / Dispatcher** is a distinct dispatcher role from **v0.1.0** (P3).

---

## Three platform repos (not three workstations)

The Leo **platform** has three production **client repos** — do not confuse with the three ops workstations above:

| Repo | Stack | Primary surfaces | First tag |
|---|---|---|---|
| **`leo-api`** | NestJS | REST `api/v1`, WSS `/realtime`, webhooks | P1 |
| **`leo-workstation`** | Flutter | **Three ops workstations in one app:** interpreter, customer, dispatcher (see above) | P1 shell → P2 MVP |
| **`leo-web`** | Next.js | LSP back-office, Superadmin, reports; marketing/Leo Text later | P2 shell → P4 reports |

All clients are thin: business rules and billing live in `leo-api`. Media tokens from API; A/V client ↔ Vonage/Twilio (`INV-MEDIA-1`).

---

## Role × client matrix

| Role | Workstation (Flutter) | Web (`leo-web`) | Notes |
|---|---|---|---|
| **Interpreter** | Primary — `/idle`, `/session` | — | Desktop full; mobile read-only, **no accept** |
| **Customer User** | Primary — `/call`, `/requests` | Enterprise portal later (P6+) | **Desktop/tablet P2**; **smartphone v0.1.0+** |
| **Sub-Admin** | Primary — `/dispatch` | — | Assign / reject / transfer |
| **LSP Admin** | `/dispatch` + **dashboard link** | Back-office (reports, users, settings, onboarding) | **No auto-redirect** to web |
| **Customer Admin** | — | Primary (v0.1.0+) | Enterprise settings, seats |
| **Superadmin** | — | Primary | KYB, catalog, tenants |

### LSP Admin navigation (BD7)

1. Login → workstation **`/dispatch`** (same ops home as Sub-Admin).
2. Nav/profile: **“Admin dashboard”** → opens `leo-web` in browser.
3. Sub-Admin never sees the link (UI + API RBAC).

### Auth handoff (workstation → web)

- Same JWT issuer (`leo-api`).
- Web session via one-time exchange code or shared-parent-domain httpOnly cookie (see `features/core-shell.md`).
- LSP Admin may log in on web directly at a desk.

---

## Workstation route map

Each ops workstation has its own route tree; login picks one based on `role`:

```
/login                          # shared — all roles
  → role redirect:
       interpreter    → /idle       # interpreter workstation
                              (+ /session/:id, /tasks, /reports)
       customer_user  → /call        # customer workstation
                              (+ /requests)   [desktop + tablet until v0.1.0]
       sub_admin      → /dispatch    # dispatcher workstation
       lsp_admin      → /dispatch    # dispatcher workstation (+ external link → leo-web)
```

**Never in workstation:** admin reports, user CRUD, rate cards, **LSP signup / LSP onboarding**, billing exports → **`leo-web` only**. (Personal + customer signup, verification, and onboarding *are* in-app — see split note above.)

---

## Web route map (`leo-web`)

| Area | Routes | Roles | Lands |
|---|---|---|---|
| Auth | `/login`, `/auth/callback` | web roles | P2 shell |
| LSP back-office | `/dashboard`, `/users`, `/settings`, `/onboarding` | `lsp_admin` | P2 → P4 |
| Reports & billing | `/reports`, `/billing`, `/rate-cards` | `lsp_admin` | **P4** |
| Platform | `/platform/tenants`, `/platform/catalog` | `platform_admin` | P2+ |
| Marketing / embed | `/`, widget | public | P6 |

---

## Device matrix — build sequencing

Full product targets: [`product-spec.md`](./product-spec.md) §4 (client) and platform `ps §15` (via [`platform-references.md`](./platform-references.md)).

| Role | Desktop | Tablet | Smartphone | First shipped |
|---|---|---|---|---|
| **Interpreter** | Full | — | Tasks/reports read-only | P2 |
| **Customer** | Full | Full | **Deferred — not P2** | Desktop/tablet **P2**; mobile **v0.1.0+** |
| **Sub-Admin** | Full dispatch | — | Assign/reject/transfer | P2 shell; role **v0.1.0** |
| **LSP Admin** | Dispatch + web link | — | Same as sub-admin mobile | P2 |

`DeviceClass` gates routes — block customer smartphone paths until v0.1.0; block interpreter Accept on mobile.

---

## MVP user journeys (P2)

### Interpreter

`Login → /idle → WSS ring → Accept → Vonage session → End → /idle`

| Step | Screen | API / WSS |
|---|---|---|
| Login | `/login` | `POST /auth/login` |
| Idle | `/idle` | WSS connect; `presence.update` |
| Ring | overlay on idle | WSS `request.broadcast` |
| Accept | → `/session/:id` | `POST /sessions/:id/accept` |
| Live | `/session/:id` | Vonage SDK; WSS `session.state` |
| End | back to idle | `POST /sessions/:id/complete` |

### Customer (desktop/tablet)

`Login → /call → request → wait → in session → complete`

| Step | Screen | API / WSS |
|---|---|---|
| Request | `/call` | `POST /sessions` |
| Waiting | `/call` or `/requests` | WSS `session.state` |
| Live | embedded or `/session/:id` | Vonage token from session API |

### LSP Admin / dispatch (P2 pilot: `lsp_admin`)

`Login → /dispatch → monitor queue → assign/transfer`

| Step | Screen | API / WSS |
|---|---|---|
| Queue | `/dispatch` | `GET /sessions?…`; WSS updates |
| Assign | `/dispatch` | admin session actions (P2 API) |
| Back-office | **browser → leo-web** | users, rates — not Flutter |

---

## Parallel development rules

1. **Contract-first** — OpenAPI + WSS events from `leo-api` before deep UI.
2. **No duplicate admin UI** — reports/users/rates once in `leo-web`.
3. **Repository mocks** — `Mock*Repository` until endpoints land.
4. **Same phase tags** — tag `v0.0.1` when this repo’s DoD passes ([`release-checklists.md`](./release-checklists.md)).

---

## Related docs

| Doc | Path |
|---|---|
| Client release plan | [`release-plan.md`](./release-plan.md) |
| Workstation architecture | [`architecture-overview.md`](./architecture-overview.md) |
| Feature specs | [`../.pineapple/features/INDEX.md`](../.pineapple/features/INDEX.md) |
| Backend API plan | `../leo-api/docs/release-plan.md` (via [`platform-references.md`](./platform-references.md)) |
