# Feature: onboarding

**Status:** Drafted (via `/pineapple:spec`, conversational) · **Phase:** signup/verify primitives = backend alpha.4 (shipped); native feature targets **P2 `v0.0.1`** (self-service live for the closed pilot) · **Owner:** client

## Summary

Native, self-service account creation and first-run setup for the **two personas the
workstation serves** — interpreters (personal) and customer orgs. The workstation
hosts the **full** flow for these two: account-type picker → signup → email
verification → onboarding (interpreter profile, or customer org + team). **LSP** signup
and LSP onboarding (languages/partners/pricing) stay in `leo-web`. The client is a thin
consumer of the backend's unified `POST /auth/signup` union (`INV-CLIENT-CONTRACT-1`);
it never writes tenancy rows itself.

## User-facing behaviour

`a-signup` offers **Personal** (interpreter) and **Customer** (business that books
interpreters). Choosing "we provide interpreters / LSP" opens the `leo-web` signup URL
externally — no native LSP signup. Personal/customer submit email + password + consent
→ `a-verify` (6-digit code or email link, resend cooldown, change-email) → onboarding:

- **Interpreter** (`o-personal`): display name + timezone; languages picked from the
  **read-only global catalog**; certifications from the catalog with optional proof
  upload (LSP verifies later). Final step hands off to **affiliation** (request an LSP)
  — the interpreter is **tenant-less** and receives no requests until an affiliation is
  `active`.
- **Customer** (`o-customer`): the signer becomes **`customer_admin`** (backend mints
  `customer_admin` for the business+customer signup); org profile (name, industry,
  registered address) + invite team (`customer_user`/`customer_admin`) → lands on
  `/call` (`customer_admin` home, `INV-CLIENT-ROUTE-2`). PHI/billing-popup field config
  is **not** here (→ `leo-web`).

Invited members (`/invite/accept`, owned by `auth`) skip signup — after accepting they
get a minimal profile step, then their role home.

## Acceptance criteria

1. The account-type picker offers **personal** and **customer** only; selecting the LSP option opens the configured `leo-web` signup URL externally (no native LSP signup transaction).
2. Personal signup calls `POST /auth/signup {account_type:'personal'}` with `consent {tos, privacy}`; success requires email verification before any login (no `organizations`/`memberships` created).
3. Customer signup calls `POST /auth/signup {account_type:'business', business_type:'customer'}` with `consent {tos, privacy}`; the customer org is created `active`; success → email verification.
4. `a-verify` accepts the code (or deep link), supports resend-with-cooldown and change-email; on success routes to the correct onboarding entry (interpreter → profile, customer → org).
5. Interpreter onboarding captures profile (name, timezone) + languages from the **read-only catalog** + certifications (optional proof upload); it completes by handing off to the **affiliation** step (owned by the `affiliations` feature); the account stays tenant-less.
6. Customer onboarding captures org profile (name, industry, registered address) + team invites via `POST /invitations` (`customer_user`/`customer_admin`); it does **not** collect PHI/billing-popup fields; completes to `/call`.
7. Invited members land (via `/invite/accept`) in a minimal profile-completion step then role home — no signup, no org creation.
8. Onboarding is **resumable** via the server-derived **`onboardingRequired`** flag on `AuthState.authenticated` (`INV-CLIENT-STATE-2`): a verified-but-not-onboarded user routed into the app is sent by `router` to the correct entry (`/onboarding/personal` or `/onboarding/customer` by role) and resumes there. Routes registered by this feature: `/signup`, `/verify-email`, `/onboarding/personal`, `/onboarding/customer`.

## User flow & affordances

- **Account-type cards** (`opt-card`): the **whole card** is the selection target (not just the radio dot); "Continue" advances. The LSP card's tap **leaves the app** (external `leo-web`), visually distinguished so users don't expect an in-app flow.
- **Language / certification chips:** the **entire chip** toggles selection; "+ add" opens a catalog picker; "Upload proof" (the button, not the row) opens the file picker.
- **Wizard step indicators** are **display-only** (progress, not navigation) — they are not tap targets, to avoid a dead affordance.

## Wire-format contract

- **`POST /auth/signup`** (`@Public()`) body: `{ account_type: 'personal'|'business', business_type?: 'customer', email, password, consent: { tos: bool, privacy: bool } }` — snake_case on the wire; the client emits only `personal` and `business+customer`. Response: `{ user_id, organization_id, status, email_verification_required: true }` where for **personal** `organization_id` and `status` are **present-as-`null`** (not omitted) — the client must handle null, not missing. Duplicate email → `409`; missing/false consent → rejected.
  > **Dual "no-tenancy" convention (D5, known):** the signup response encodes "no org" as **`organization_id: null` present**, but the access-token JWT (`auth.md`) encodes it as **`tenant_id` absent/omitted**. Two payloads, two opposite encodings — the parser for each must be written accordingly (don't assume one rule). Both are backend-owned.
- **`POST /auth/verify-email`** `{ token }` or `{ code }` → `200`; until verified, login is refused.
- **Catalog (read-only, global):** `GET /catalog/languages`, `/catalog/certifications` — `is_signed`/`is_active` are JSON **booleans**; `code` is a BCP-47-style string; client never sets ids.
- **Invitations:** `POST /invitations { email, role }` (`customer_user`|`customer_admin`).
- **Interpreter profile + cert proof upload** are backend `interpreter-profiles` surface (alpha.5/P2) — likely S3 presigned upload; **confirm availability** (Open questions).
- **Consent** is append-only server-side (backend `INV-CONSENT-1`); the client submits booleans only.
- **Transformation owner:** `OnboardingRepository`/`AuthRepository` (snake_case→camelCase entities/DTOs via `@JsonKey`), the only wire-aware layer (`INV-CLIENT-ARCH-1`).

## Key decisions (with rejected alternatives)

- **KD1 — Native full self-service for personal + customer; LSP stays web.** *Rejected:* web→native handoff (an awkward cross-app seam for exactly the personas who live in the app); all-onboarding-on-web (interpreters/customers would set up on a site they won't use).
- **KD2 — Public self-service signup live from the P2 pilot, alongside invitations.** *Rejected:* invitation-only pilot (manual admin overhead, no self-serve funnel) — invitations still exist for admin-added members.
- **KD3 — Onboarding *links to* affiliation; it does not own the lifecycle.** *Rejected:* bundling the affiliation state machine into onboarding (it's reused in settings and is multi-LSP, alpha.5).

## Success metric (draft — confirm numbers)

Self-service **funnel completion**: % of personal signups that reach a first
**affiliation request** without dropping; % of customer signups that reach a first
`/call`. Target numbers TBD by founder (Open questions).

## Non-goals

LSP signup + LSP onboarding (languages/partners/pricing) → `leo-web`. Affiliation
management lifecycle → `affiliations` feature (alpha.5); onboarding only links into it.
PHI/billing-popup field config → `leo-web`. Cert *verification* is LSP-side (web).
Platform admin. No tenancy writes in the client (`INV-CLIENT-CONTRACT-1`).

## Touches

`INV-CLIENT-ROUTE-1` (personal+customer signup/onboarding allowed in-app; **LSP** excluded) / `INV-CLIENT-ROUTE-2` (`customer_admin`/interpreter homes), `INV-CLIENT-AUTH-1/2`, `INV-CLIENT-AUTH-3` (tenant-less interpreter), `INV-CLIENT-STATE-1` / `INV-CLIENT-STATE-2` (resumable via `onboardingRequired` on the `AuthState` contract), `INV-CLIENT-ARCH-1` (`OnboardingRepository` is the only wire-aware layer), `INV-CLIENT-A11Y-1` + `INV-CLIENT-UI-1` (Cupertino wizard, semantics), `INV-CLIENT-I18N-1` (wizard copy via `intl`), `INV-CLIENT-PHI-1` (no PHI collected — consent only), `INV-CLIENT-CONTRACT-1`. Backend: `INV-CONSENT-1`.

## Depends on

`auth` (signup/verify/token, tenant-less session, `/invite/accept`) · `core-shell` (dio/config/theme) · `router` (onboarding-required gate) · `affiliations` (alpha.5, interpreter final step) · backend `unified-signup`, `interpreter-profiles` (alpha.5/P2), catalog read endpoints, `POST /invitations`. Via [`platform-references.md`](../../docs/platform-references.md).

## Open questions / Out of scope

- **Backend `interpreter-profiles` + cert proof upload (S3 presigned)** — confirm endpoints + timing (alpha.5 vs P2); the interpreter onboarding step 5 depends on them.
- **Success-metric numbers** — founder to set funnel-completion targets.
- **MFA for personal interpreters** — a pre-affiliation interpreter has no org policy; confirm MFA is not forced until affiliated (design says "interpreters per org policy").
- **Resume signal — RESOLVED 2026-06-29:** `authenticated.onboardingRequired` on the `AuthState` contract (`INV-CLIENT-STATE-2`), server-derived. Remaining: confirm the backend surfaces onboarding-completeness (token claim or `/auth/me`) so `auth` can populate it.
- **LSP web→workstation** — after LSP signs up on web, `lsp_admin` simply logs into the workstation for dispatch (no native LSP onboarding); confirm.
