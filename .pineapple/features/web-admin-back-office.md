# Feature: web-admin-back-office — cross-repo reference

> ⚠️ **Implements in `leo-web`, not `leo-workstation`.** This file exists only so
> the client team knows where the boundary is (`BD7`, `INV-CLIENT-ROUTE-1`). No
> Flutter code is written for it in this repo.

## Why it's documented here

The LSP back-office (reports, billing, user CRUD, rate cards, **LSP signup + LSP
onboarding**, platform admin) is **out of scope** for the Flutter ops client. It ships
in the **`leo-web` (Next.js)** repo.

> **Not out of scope:** the **full self-service flow for personal (interpreter) +
> customer** — signup, email verification, and onboarding — runs in the workstation
> (decided 2026-06-29); it is its own client feature ([`onboarding.md`](onboarding.md)),
> not part of this cross-repo reference.

The only back-office touchpoint in this repo is:

- **LSP Admin** lands on the workstation `/dispatch` home, then follows an external
  **"Admin dashboard"** link to `leo-web` (no auto-redirect).
- **Sub-Admin** never sees that link (UI + API RBAC).
- Auth handoff: same JWT issuer (`leo-api`); web session via one-time exchange code
  or shared-parent-domain httpOnly cookie. The client's only job is to open the URL.

## Client obligations (the entire surface in this repo)

- A configurable `leo-web` base URL (hidden/disabled until configured).
- The dashboard link shown to `lsp_admin` only.
- No back-office routes, screens, or data layers in Flutter.

## Canonical spec

Lives in `leo-web`. Platform context:
[`docs/platform-references.md`](../../docs/platform-references.md) and
`docs/client-map.md` § Web route map.
