# leo-workstation — Product spec (as-built)

_Reverse-engineered 2026-06-29 via `/pineapple:ongoing`._

> **As-built ≠ target.** The client-scoped product vision lives in
> [`docs/product-spec.md`](../docs/product-spec.md); platform-wide rules in
> `../leo-api/docs/product-spec.md`. This file records only what the **code**
> currently embodies, with confidence flags for inference.

## What exists today

A Flutter scaffold (`lib/main.dart`) presenting an empty Cupertino "Workstation
shell". No personas, flows, auth, or features are implemented yet. **Confidence:
high** (verified against the single source file).

## Inferred intent (from docs + repo name + sibling backend)

| Item | Inference | Confidence |
|---|---|---|
| Product | One Flutter binary serving **three role-routed ops workstations** — interpreter, customer, dispatcher (`BD1`). | High — stated across `docs/` and `../leo-api` decision-log. |
| Out of scope | LSP back-office (reports, billing, user CRUD, onboarding) → `leo-web`; platform admin → `leo-web` (`BD7`). | High. |
| Personas | `interpreter`, `customer_user`, `sub_admin`, `lsp_admin`. | High (client-map). |
| First sellable slice | P2 MVP — on-demand Vonage video loop (request → match → connect → complete) + dispatch. | High. |
| Success metric | "First dollar" mirrors backend P2; client DoD = end-to-end desktop video. | Medium — implied, not separately stated for the client. |

## As-built invariants observed in code

Only one is directly observable in the scaffold: the app is **Cupertino-first**
(`CupertinoApp`), matching `INV-CLIENT-UI-1`. All other `INV-CLIENT-*`
([`invariants-client.md`](invariants-client.md)) are **target** rules not yet
exercised by code.

## For the real spec

See [`docs/product-spec.md`](../docs/product-spec.md) (client-scoped) and
[`docs/release-plan.md`](../docs/release-plan.md) (what ships when).
