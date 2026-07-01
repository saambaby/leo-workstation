# leo-workstation — Client Release Plan

*Phased build plan for the **Flutter ops client** — **one app, three workstations** (interpreter, customer, dispatcher), role-routed via `go_router` (BD1). Sequenced against the **same version tags** as [`../leo-api/docs/release-plan.md`](./platform-references.md); each version is a **strict superset** of the prior. Backend module/API detail lives in `leo-api`; LSP back-office UI lives in **`leo-web`** (BD7 — see [`client-map.md`](./client-map.md)).*

> **This is the implementation driver.** Anyone (human or agent) building the client reads this first, then drills into [`.pineapple/features/`](../.pineapple/features/INDEX.md) for slice detail.

> **Conventions.** `🔒` = security/a11y load-bearing. Citations resolve via [`platform-references.md`](./platform-references.md): `ps §N` → `docs/product-spec.md` (client-owned) or `../leo-api/docs/product-spec.md` (platform-wide); `arch §N` → `../leo-api/docs/architecture.md`; `BD*` → `../leo-api/docs/decision-log.md`; `INV-CLIENT-*` → [`.pineapple/invariants-client.md`](../.pineapple/invariants-client.md).

---

## Version map

| Version | Phase | Client scope | API dependency (`../leo-api`) |
|---|---|---|---|
| [`v0.0.1-alpha.1`](#v001-alpha1--p1--app-shell) | P1 | App shell — auth, router, theme, WSS | P1 auth spine |
| [`v0.0.1-alpha.2`](#v001-alpha2--no-client-release) | P1+ | **No client release** — backend-only (platform admin bootstrap CLI) | Platform admin bootstrap |
| [`v0.0.1-alpha.3`](#v001-alpha3--no-client-release-deprecated-path) | P1+ | **No client release** — superseded by alpha.4 | LSP public signup (deprecated) |
| [`v0.0.1-alpha.4`](#v001-alpha4--auth-contract--multi-membership) | P1+ | **Auth contract:** multi-membership login, tenant picker, `switch-tenant`, tenant-less token | Unified identity & signup |
| [`v0.0.1-alpha.5`](#v001-alpha5--minimal-pre-p2) | P1+ | Minimal pre-P2: `platform_admin` slug, affiliation context if needed | Interpreter affiliations |
| [`v0.0.1`](#v001--p2--mvp--first-dollar) | P2 | **MVP** — Vonage loop, customer desktop/tablet, dispatch | P2 session/matching |
| [`v0.1.0`](#v010--p3--scheduled--telephone--customer-mobile) | P3 | Scheduled + OPI + **customer smartphone** + sub_admin | P3 scheduled/telephone |
| [`v0.2.0`](#v020--p4--ops-unchanged) | P4 | Ops unchanged; read-only billing hints | P4 billing/payments |
| [`v0.4.0+`](#v040--p6--ai-surfaces) | P6 | Leo Voice landing hooks if needed | P6 AI |
| [`v1.0.0`](#v100--ga) | P8 | GA hardening | all |

**Critical path:** P1 shell → **P2 MVP loop** (request → match → Vonage → complete). The `alpha.2`–`alpha.5` tags are **auth-contract hardening on the P1 shell**; they don't block P2 feature planning, but the client must build P1 against the **alpha.4** contract from day one (see [`auth.md`](../.pineapple/features/auth.md)). Customer **smartphone explicitly not P2**.

> **Backend is ahead.** `../leo-api` has already shipped `alpha.1`–`alpha.5`; its next phase is P2 / `v0.0.1`. The client is catching up to the alpha.4 auth contract in its first real phase.

---

## `v0.0.1-alpha.1` — P1 — App shell

**Goal:** *Can every role log in, land on the correct shell, and maintain an authenticated WSS channel?*

Phase carve: [`.pineapple/phases/v0.0.1-alpha.1.md`](../.pineapple/phases/v0.0.1-alpha.1.md).

### Features (see [`features/INDEX.md`](../.pineapple/features/INDEX.md))

| Feature | Delivers |
|---|---|
| **core-shell** | `ProviderScope`, env config, Cupertino theme (light/dark/night), `DeviceClass`, cert-pinned `dio`, secure `TokenStorage`, shared chrome |
| **auth** | Login, session restore, logout, MFA enroll flow, secure token storage — **built against the alpha.4 contract** ([`auth.md`](../.pineapple/features/auth.md)) |
| **router** | `go_router` + pure redirect (auth × device × location), role homes, device gating |

> **Deferred from this tag (re-carved 2026-06-29):** **realtime** (Socket.IO `/realtime`, `notification.push`, reconnect) — the shell does not hold a WSS channel at alpha.1; spec pending, lands before/with P2. **onboarding** (signup + verify + native onboarding for personal + customer) ships at **P2** — see [`onboarding.md`](../.pineapple/features/onboarding.md).

### Screens

| Route | Roles | Device |
|---|---|---|
| `/login` | all | all |
| `/idle` | interpreter | desktop |
| `/call` | customer_user | desktop, tablet |
| `/dispatch` | lsp_admin (pilot), sub_admin (stub) | desktop |

### API dependencies (`../leo-api` P1 + alpha.4)

- `POST /auth/login` (active-tenant token, or tenant-less for 0-membership interpreter), `/auth/refresh`, `/auth/logout`, `/auth/mfa/enroll`
- `POST /auth/switch-tenant` (re-mint on tenant change)
- *(WSS auth-on-connect / `notification.push` — with the deferred **realtime** feature, not this tag.)*

### Definition of Done

- [ ] Login → role home without manual navigation
- [ ] Tokens in `flutter_secure_storage`; access in memory (`INV-CLIENT-AUTH-1`)
- [ ] `flutter analyze` clean; semantics on login + shells
- [ ] Customer routes hidden on smartphone (`DeviceClass`, `INV-CLIENT-DEVICE-1`)
- [ ] LSP Admin sees disabled or hidden "Admin dashboard" link until `leo-web` URL configured
- [ ] `platform_admin` slug only — no `superadmin` in code or docs

### Deferred

Vonage, session screens, dispatch queue data, customer mobile, full sub_admin RBAC split.

---

## `v0.0.1-alpha.2` — No client release

**Backend-only.** This backend tag adds the **platform admin bootstrap** — a CLI command (`bootstrap:platform-admin`) that provisions account-zero with zero credentials in source. It adds **no HTTP surface and no schema**.

**Client impact:** none. There is **no client release** at this tag. The platform admin is a `leo-web` persona, never a `leo-workstation` route (BD7).

### API dependencies (`../leo-api` alpha.2)

CLI only (`make bootstrap-platform-admin`); onboarding reuses existing `POST /auth/reset-password` → `/auth/login` → `/auth/mfa/enroll`. No client-facing change.

---

## `v0.0.1-alpha.3` — No client release (deprecated path)

**Backend-only, and superseded.** This backend tag added `POST /auth/lsp-signup` (public LSP self-signup). It is **hard-replaced by `POST /auth/signup`** at alpha.4 (intentional pre-release breaking change).

**Client impact:** none, and the client must **never** implement against `POST /auth/lsp-signup`. Signup is a `leo-web` surface (BD7); the client only consumes login/refresh/switch-tenant. There is **no client release** at this tag.

### API dependencies (`../leo-api` alpha.3)

`POST /auth/lsp-signup` (deprecated) + `GET/PATCH /organizations/me`. **Not consumed by the client.**

---

## `v0.0.1-alpha.4` — Auth contract — multi-membership

**Goal:** *Does the client's auth flow honor the unified identity contract — one signup surface (web), and a login that derives tenant context for accounts with **zero or many** memberships?*

This is the **load-bearing auth tag for the client.** The backend replaced `lsp-signup` with a unified `POST /auth/signup`, reworked login to mint an active-tenant token (or a tenant-less token for 0-membership interpreters), and added `POST /auth/switch-tenant`. The client builds its P1 auth against this contract from day one.

### Client work (folded into P1 auth)

| Topic | Requirement |
|---|---|
| Role slug | `platform_admin` everywhere — **not** `superadmin` |
| JWT claims | `{ sub, role, tenant_id? }` — `tenant_id` optional (tenant-less interpreters) |
| Multi-membership login | 2+ active memberships → **tenant/membership picker** before role redirect |
| Tenant-less login | 0-membership interpreter → tenant-less token → redirect to `/idle` |
| Switch tenant | `POST /auth/switch-tenant` re-mints token on LSP-context change |
| MFA | Challenged on **login and switch-tenant** for `platform_admin`, `lsp_admin`, `sub_admin` |
| New UI | `tenant_picker_screen.dart` or inline picker on the login flow |
| Deprecated | Do **not** call `POST /auth/lsp-signup` |

Detail: [`auth.md`](../.pineapple/features/auth.md).

### API dependencies (`../leo-api` alpha.4)

- `POST /auth/login` — active-tenant token; tenant-less `{ sub }` token for 0-membership users
- `POST /auth/switch-tenant` — re-mint for a held membership; non-held tenant → `404`
- **Removed:** `POST /auth/lsp-signup` (use nothing in its place client-side)
- MFA at every privileged token mint (login or switch)

### Definition of Done

- [ ] Multi-membership login → tenant picker → correct role home
- [ ] Tenant-less interpreter login → `/idle` without error
- [ ] `switch-tenant` re-mints token; MFA re-challenged for privileged roles
- [ ] JWT handling uses `platform_admin` slug (no `superadmin` in code or docs)
- [ ] All alpha.1 app-shell gates still pass

---

## `v0.0.1-alpha.5` — Minimal pre-P2

**Goal:** *Does the client carry the right vocabulary and (if needed) affiliation context ahead of P2?*

The backend added interpreter↔LSP **affiliations** (multi-LSP) and in-tenant role promotion. For the client, this is mostly **vocabulary alignment**: ensure `platform_admin` is the canonical privileged slug and that a tenant-less interpreter with multiple affiliations can log in and reach `/idle`. Affiliation **management UI** is not a client surface (LSP-side affiliation admin → `leo-web`; interpreter self-service affiliation, if surfaced at all, is post-P2).

### Client work

- Confirm tenant-less + multi-affiliation interpreter login path (already exercised by alpha.4 work).
- No new screens required for P2 readiness. Affiliation context is read-through-token only.

### API dependencies (`../leo-api` alpha.5)

- `GET /affiliations` (interpreter sees own across LSP tenants) — **read-only, optional** for the client until a surface needs it
- `PATCH /memberships/:id/role` — **not** a client surface (admin path → `leo-web`)

### Definition of Done

- [ ] A ≥2-affiliation, tenant-less interpreter logs in and lands on `/idle`
- [ ] No `superadmin` anywhere; `platform_admin` slug used for privileged routing
- [ ] All alpha.4 gates still pass

### Deferred

All affiliation/promotion management UI → `leo-web` (BD7).

---

## `v0.0.1` — P2 — MVP — first dollar

**Goal:** *Closed pilot: Customer (desktop/tablet) requests on-demand video → Interpreter accepts → live Vonage session → dispatch can monitor/assign.*

### Features

| Feature | Delivers |
|---|---|
| **interpreter-workstation** | Idle, incoming ring, accept race (409), in-session controls, Vonage |
| **customer-call** | Request form, waiting state, in-session (desktop/tablet) |
| **dispatch-portal** | Live queue, assign/transfer/reject; WSS-driven |
| **session** (shared) | `SessionRepository`, Vonage service, WSS `session.state` |
| **onboarding** | Native self-service: `a-signup` (personal\|customer) → `a-verify` → `o-personal`/`o-customer`; LSP signup/onboarding → `leo-web` ([`onboarding.md`](../.pineapple/features/onboarding.md)) |
| **core-shell** | LSP Admin → `leo-web` link + auth handoff stub |

### Screens & journeys

Documented in [`client-map.md`](./client-map.md) § MVP user journeys.

### API dependencies (`../leo-api` P2)

| Need | Endpoint / WSS |
|---|---|
| Create session | `POST /sessions` (on_demand video) |
| Accept | `POST /sessions/:id/accept` → vonage token (or `409` on lost race) |
| Start / complete / cancel | `POST /sessions/:id/start`, `/complete`, `/cancel` |
| Dispatch | session list + admin session actions |
| Realtime | `presence.update`, `request.broadcast`, `request.taken`, `session.state` |

> 🔒 **Activation gate (backend INV-BAA-1):** the backend refuses `POST /sessions` for an org without an active platform↔LSP BAA. The pilot LSP's BAA is recorded out-of-band; the client surfaces a graceful error if a session is refused.

### Device gates (this version)

Customer **smartphone blocked**; interpreter **Accept blocked on mobile** (`INV-CLIENT-DEVICE-1`). Full matrix: [`client-map.md`](./client-map.md#device-matrix--build-sequencing). P2 pilot uses `lsp_admin` for dispatch where `sub_admin` is not yet wired.

### Definition of Done

- [ ] End-to-end on-demand video on desktop (customer + interpreter)
- [ ] Dispatch queue updates live via WSS
- [ ] 409 on lost accept race — UI recovers gracefully
- [ ] Vonage reconnect on network blip (same session id)
- [ ] No PHI persisted locally; caches cleared on sign-off (`INV-CLIENT-PHI-1`)
- [ ] Cert pinning on API calls (staging) (`INV-CLIENT-NET-1`)
- [ ] **No** `/admin/users`, `/admin/reports` Flutter routes (`INV-CLIENT-ROUTE-1`)

### Parallel: `leo-web` (not this repo)

P2 shell only: layout, web login, auth handoff from workstation link, users/settings placeholders.

### Explicitly deferred

Customer smartphone, scheduled bookings, OPI, conferencing, sub_admin role split, reports UI, rate-card UI.

---

## `v0.1.0` — P3 — Scheduled + Telephone + customer mobile

**Goal:** *Full session shapes in ops client; customer on phone; Sub-Admin as distinct router role.*

### Features

| Feature | Adds |
|---|---|
| **customer-call** | Smartphone `/call`, `/requests` — **unblock `DeviceClass`** |
| **interpreter-workstation** | Scheduled tasks, availability display |
| **session** | Twilio/OPI UI, multi-party + guest join, captions track (Deaf-first) |
| **dispatch-portal** | **`sub_admin` role** in router; scheduled dispatch actions |

### API dependencies (`../leo-api` P3)

- `POST /sessions` (scheduled) · `/sessions/:id/assign` · `/transfer` · `/conference`
- `GET/POST /interpreters/:id/availability` (+ exceptions)
- Guest join via `access_codes` (guest-scoped media token; camera/mic-only)
- WSS: `session.state` extended with conferenced/guest joins

### Device matrix change

- **Customer smartphone:** ✅ enabled
- **Interpreter mobile:** read-only tasks/reports still; no accept

### Definition of Done

- [ ] Customer can request from iOS/Android
- [ ] Scheduled session appears in interpreter tasks + dispatch
- [ ] OPI session UI (Twilio leg status)
- [ ] Multi-party guest layout + captions (P3 Deaf-first gate, `INV-CLIENT-A11Y-1`)
- [ ] `sub_admin` vs `lsp_admin` routing verified

---

## `v0.2.0` — P4 — Ops unchanged

**Goal:** *Workstation stays ops-focused; money and reports move to `leo-web`.*

### Workstation

- Optional read-only billing total on session complete / interpreter reports
- No new admin CRUD in Flutter

### API dependencies (`../leo-api` P4)

Read-only consumption of finalized billing totals only. Payments, Stripe Identity/verification, BAA automation, reports, and exports are **`leo-web` + backend** surfaces — not consumed by this client.

### `leo-web` (primary P4 client work)

Reports catalog, exports, payments admin, LSP verification/BAA compliance UI — see `leo-web` plan (when repo exists).

---

## `v0.4.0` — P6 — AI surfaces

- Workstation: minimal Leo Voice entry on customer desktop if product requires
- Primary Leo Text: **`leo-web`** + embed widget

### API dependencies (`../leo-api` P6)

Leo BFF endpoints (AI is not a privileged path, platform INV-AI-1). Scope TBD when P6 is carved.

---

## `v1.0.0` — GA

- All D6/D13 client gates closed (see [`platform-references.md`](./platform-references.md) → `../leo-api/docs/release-checklists.md`)
- WCAG 2.1 AA sign-off (L3) on touched surfaces
- Pin rotation drill documented

---

## Code layout

Target `lib/` tree and cross-feature rules: [`architecture-overview.md`](./architecture-overview.md) §2–§3. As-built: [`.pineapple/code-map.md`](../.pineapple/code-map.md).

---

## Mock strategy — retired 2026-07-01

There is no mock/live toggle. The client always talks to the real `leo-api` at
`API_BASE_URL` — there is no `USE_MOCKS` flag, no `AppConfig.useMocks`, and no
`Mock*Repository` implementations (removed from `auth` and `onboarding`; see
[`features/auth.md`](../.pineapple/features/auth.md)). A running `leo-api` is
required for any client dev/demo work, including local UI iteration.

This reverses the original mock-first plan (mocks per feature, switched off per
integration milestone) — auth and onboarding were the only features that had ever
implemented mocks; no other feature (`session`, `dispatch`, `call`) had reached that
point, so nothing else needed reverting.

---

*Companion: [`client-map.md`](./client-map.md) · [`architecture-overview.md`](./architecture-overview.md) · [`product-spec.md`](./product-spec.md) · [`.pineapple/features/INDEX.md`](../.pineapple/features/INDEX.md) · [`release-checklists.md`](./release-checklists.md).*
