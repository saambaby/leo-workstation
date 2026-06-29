# leo-workstation — Product spec (client-scoped)

> **What & why** for the **Flutter ops client**. Platform-wide business rules
> (marketplace, billing, compliance) are **not** duplicated here — they live in
> `../leo-api/docs/product-spec.md` (link via [`platform-references.md`](./platform-references.md)).
> Build order: [`release-plan.md`](./release-plan.md). Roles/routes/devices:
> [`client-map.md`](./client-map.md).

---

## 1. Vision

**One Flutter binary, three ops workstations.** After login, `go_router` routes the
authenticated user to their workstation by role (BD1):

- **Interpreter** → `/idle` (accept on-demand, run live A/V)
- **Customer User** → `/call` (request on-demand, track status)
- **Dispatcher** (`sub_admin`, `lsp_admin`) → `/dispatch` (monitor queue, assign/transfer)

The app is the platform's **field + dispatch realtime surface**. Everything that is
a data grid, report, or back-office form is *not* here.

## 2. In-scope personas

| Persona | API role | Primary surface |
|---|---|---|
| Field interpreter | `interpreter` | `/idle`, `/session/:id`, `/tasks`, `/reports` |
| Enterprise requester | `customer_user` | `/call`, `/requests` |
| LSP dispatch staff | `sub_admin` | `/dispatch` (from `v0.1.0`) |
| LSP admin (wears dispatcher) | `lsp_admin` | `/dispatch` + external link to `leo-web` |

## 3. Out of scope (BD7)

LSP back-office — user CRUD, reports, rate cards, billing exports, **LSP signup +
LSP onboarding** — and platform admin all live in **`leo-web` (Next.js)**, not this
binary. Customer Admin is a web persona. The
client's only back-office touchpoint is an external "Admin dashboard" link shown to
`lsp_admin` (`INV-CLIENT-ROUTE-1`,
[`web-admin-back-office.md`](../.pineapple/features/web-admin-back-office.md)).

> **In scope, though (decided 2026-06-29):** the **full self-service flow for
> personal (interpreter) + customer** — signup, email verification, and onboarding
> (`a-signup`, `a-verify`, `o-personal`, `o-customer`) — runs natively in this app.
> Only the **LSP** path (signup + onboarding) stays on web. See
> [`onboarding.md`](../.pineapple/features/onboarding.md).

## 4. Device matrix (summary)

| Role | Desktop | Tablet | Smartphone | First shipped |
|---|---|---|---|---|
| Interpreter | Full | — | Tasks/reports read-only (no accept) | P2 |
| Customer | Full | Full | **Deferred to `v0.1.0`** | Desktop/tablet P2 |
| Sub-Admin | Full dispatch | — | Assign/reject/transfer | role from `v0.1.0` |
| LSP Admin | Dispatch + web link | — | Same as sub-admin mobile | P2 |

`DeviceClass` gates routes (`INV-CLIENT-DEVICE-1`). Full matrix + sequencing:
[`client-map.md`](./client-map.md#device-matrix--build-sequencing).

## 5. UI & accessibility

- **Cupertino-first** — `CupertinoApp` + `CupertinoThemeData` (`INV-CLIENT-UI-1`); app-wide, persisted **night mode** for all roles.
- **Deaf-first** (hard gate L3, WCAG 2.1 AA, `INV-CLIENT-A11Y-1`): semantics on every interactive element; alerts visual/vibration/push, never audio-only; signed-language sessions are video-only; Leo **Text** (not Voice) is the primary AI channel for Deaf users. Deaf-first obligations derive from platform `ps §15` (link via [`platform-references.md`](./platform-references.md)).

## 6. Security (client)

- **Token split** — refresh in `flutter_secure_storage`, access in memory (`INV-CLIENT-AUTH-1`; D6/D7).
- **Cert pinning** — pinned SHA-256 with rotation; mismatch refuses connection (`INV-CLIENT-NET-1`; D13).
- **No PHI at rest** — no patient data persisted; caches cleared on sign-off/background (`INV-CLIENT-PHI-1`).
- **Media tokens only** — A/V flows directly to Vonage/Twilio via short-lived tokens; media never transits Leo (`INV-CLIENT-MEDIA-1`).
- **Thin client** — business rules and billing live in `leo-api`; the client never meters or charges (`INV-CLIENT-CONTRACT-1`).

## 7. Platform rules (not duplicated here)

Marketplace-wide rules — matching, metering, billing finalization, RLS/tenancy,
the platform↔LSP BAA program — are owned by `leo-api`. See
`../leo-api/docs/product-spec.md` and `../leo-api/.pineapple/invariants.md` via
[`platform-references.md`](./platform-references.md).

---

*Companion: [`release-plan.md`](./release-plan.md) · [`architecture-overview.md`](./architecture-overview.md) · client invariants [`.pineapple/invariants-client.md`](../.pineapple/invariants-client.md).*
