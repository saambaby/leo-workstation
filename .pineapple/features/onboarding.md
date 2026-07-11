# Feature: onboarding

**Status:** Drafted (via `/pineapple:spec`, conversational; amended 2026-07-11 for cross-spec-audit reconciliation against `lsp-native-signup.md`) · **Phase:** signup/verify primitives = backend alpha.4 (shipped); native feature targets **P2 `v0.0.1`** (self-service live for the closed pilot) · **Owner:** client

## Summary

Native, self-service account creation and first-run setup for the **two personas the
workstation serves** — interpreters (personal) and customer orgs. The workstation
hosts the **full** flow for these two: account-type picker → signup → email
verification → onboarding (interpreter profile, or customer org + team). LSP
*onboarding* (languages/partners/pricing) stays in `leo-web`; LSP *signup* reuses this
feature's account-type picker and signup screens but is scoped and owned end-to-end by
[`lsp-native-signup.md`](lsp-native-signup.md), not restated here. The client is a thin
consumer of the backend's unified `POST /auth/signup` union (`INV-CLIENT-CONTRACT-1`);
it never writes tenancy rows itself.

## User-facing behaviour

`a-signup` (`SignupTypeScreen`) offers **Personal** (interpreter), **Customer**
(business that books interpreters), and **LSP** (business that provides interpreters)
cards. This spec owns the personal/customer submit transactions end-to-end; the LSP
card's behavior — in-app signup reusing these same screens — is owned by
[`lsp-native-signup.md`](lsp-native-signup.md) and not restated here. Personal/customer
submit email + password + consent → `a-verify` (6-digit OTP in-app — enter code,
resend) → onboarding:

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

1. The account-type picker (`SignupTypeScreen`) offers **personal**, **customer**, and **LSP** cards; selecting personal or customer pushes `/signup/details` with the matching `SignupDraft.path` — this spec owns and verifies that transaction. The LSP card's transaction (in-app signup via these same reused screens) is owned and verified by `lsp-native-signup.md`'s own acceptance criteria, not duplicated here.
2. Personal signup calls `POST /auth/signup {account_type:'personal'}` with `consent {tos, privacy}`; success requires email verification before any login (no `organizations`/`memberships` created).
3. Customer signup calls `POST /auth/signup {account_type:'business', business_type:'customer'}` with `consent {tos, privacy}`; the customer org is created `active`; success → email verification.
4. `a-verify` shows an **OTP entry screen** (`/verify-email`): 6-digit code, resend, wrong-email back to signup; calls `POST /auth/verify-email` via `authRepositoryProvider`; success → `AuthNotifier.applyLoginResult` → role home or MFA/onboarding; signup success sets `emailVerificationPending` (router redirect, no `push`).
5. Interpreter onboarding captures profile (name, timezone) + languages from the **read-only catalog** + certifications (optional proof upload); it completes by handing off to the **affiliation** step (owned by the `affiliations` feature); the account stays tenant-less.
6. Customer onboarding captures org profile (name, industry, registered address) + team invites via `POST /invitations` (`customer_user`/`customer_admin`); it does **not** collect PHI/billing-popup fields; completes to `/call`.
7. Invited members land (via `/invite/accept`) in a minimal profile-completion step then role home — no signup, no org creation.
8. Onboarding is **resumable** via the server-derived **`onboardingRequired`** flag on `AuthState.authenticated` (`INV-CLIENT-STATE-2`): a verified-but-not-onboarded user routed into the app is sent by `router` to the correct entry (`/onboarding/personal` or `/onboarding/customer` by role) and resumes there. Routes registered by this feature: `/signup`, `/signup/details`, `/verify-email`, `/onboarding/personal`, `/onboarding/customer`.

## User flow & affordances

**Concrete artifacts** (named here for cross-spec reuse, e.g. by `lsp-native-signup.md`): `SignupTypeScreen` is `a-signup`'s account-type picker; `SignupDetailsScreen` is the per-path details step registered at `/signup/details`; `SignupPath` is the path enum this feature defines as `personal`|`customer` (the LSP delta extends it with `lsp`); `SignupNotifier` owns submit state for all paths registered here.

- **Account-type cards** (`opt-card`): the **whole card** is the selection target (not just the radio dot); "Continue" advances. Personal/customer taps push `/signup/details` in-app. The LSP card's destination is owned by `lsp-native-signup.md` — see that spec for its current behavior rather than assuming it here.
- **Language / certification chips:** the **entire chip** toggles selection; "+ add" opens a catalog picker; "Upload proof" (the button, not the row) opens the file picker.
- **Wizard step indicators** are **display-only** (progress, not navigation) — they are not tap targets, to avoid a dead affordance.

## Wire-format contract

- **`POST /auth/signup`** (`@Public()`) body: `{ account_type: 'personal'|'business', business_type?: 'customer', email, password, consent: { tos: bool, privacy: bool } }` — snake_case on the wire; **this spec's** screens emit only `personal` and `business+customer` (`lsp-native-signup.md` adds a third `business+lsp` variant on the same DTO shape, with an additional required `baa_ack` consent field — not exhaustive to this spec alone). Response: `{ user_id, organization_id, status, email_verification_required: true }` where for **personal** `organization_id` and `status` are **present-as-`null`** (not omitted) — the client must handle null, not missing. Duplicate email → `409`; missing/false consent → rejected.
  > **Dual "no-tenancy" convention (D5, known):** the signup response encodes "no org" as **`organization_id: null` present**, but the access-token JWT (`auth.md`) encodes it as **`tenant_id` absent/omitted**. Two payloads, two opposite encodings — the parser for each must be written accordingly (don't assume one rule). Both are backend-owned.
- **`POST /auth/verify-email`** `{ email, code }` → `LoginResult` (same discriminated shape as login). **`POST /auth/resend-verify`** `{ email }` → `200`.
- **Catalog (read-only, global):** `GET /catalog/languages`, `/catalog/certifications` — `is_signed`/`is_active` are JSON **booleans**; `code` is a BCP-47-style string; client never sets ids.
- **Invitations:** `POST /invitations { email, role }` (`customer_user`|`customer_admin`).
- **Interpreter profile + cert proof upload** are backend `interpreter-profiles` surface (alpha.5/P2) — likely S3 presigned upload; **confirm availability** (Open questions).
- **Consent** is append-only server-side (backend `INV-CONSENT-1`); the client submits booleans only.
- **Transformation owner:** `core/auth/data/AuthRepository` for signup + verify (`INV-CLIENT-AUTH-REPO-1`); `OnboardingRepository` for catalog, profiles, org, invitations only (`INV-CLIENT-ARCH-1`).

## Key decisions (with rejected alternatives)

- **KD1 — Native full self-service for personal + customer; LSP *onboarding* (not signup) stays web.** LSP *signup* was later moved in-app as a delta on these same screens (`lsp-native-signup.md`, P2 delta) — see that spec for the LSP-specific flow; this KD now covers onboarding-proper (languages/partners/pricing) only. *Rejected:* web→native handoff for personal/customer (an awkward cross-app seam for exactly the personas who live in the app); all-onboarding-on-web (interpreters/customers would set up on a site they won't use).
- **KD2 — Public self-service signup live from the P2 pilot, alongside invitations.** *Rejected:* invitation-only pilot (manual admin overhead, no self-serve funnel) — invitations still exist for admin-added members.
- **KD3 — Onboarding *links to* affiliation; it does not own the lifecycle.** *Rejected:* bundling the affiliation state machine into onboarding (it's reused in settings and is multi-LSP, alpha.5).

## Success metric (draft — confirm numbers)

Self-service **funnel completion**: % of personal signups that reach a first
**affiliation request** without dropping; % of customer signups that reach a first
`/call`. Target numbers TBD by founder (Open questions).

## Non-goals

LSP *onboarding* (languages/partners/pricing) → `leo-web`. LSP *signup* is not a
non-goal of the feature area — it ships in-app — but it is out of this spec's authoring
scope; see [`lsp-native-signup.md`](lsp-native-signup.md). Affiliation
management lifecycle → `affiliations` feature (alpha.5); onboarding only links into it.
PHI/billing-popup field config → `leo-web`. Cert *verification* is LSP-side (web).
Platform admin. No tenancy writes in the client (`INV-CLIENT-CONTRACT-1`).

## Touches

`INV-CLIENT-AUTH-REPO-1`, `INV-CLIENT-ROUTE-1` (personal+customer signup/onboarding allowed in-app; LSP *onboarding* stays web, LSP *signup* is in-app via `lsp-native-signup.md`) / `INV-CLIENT-ROUTE-2` (`customer_admin`/interpreter homes), `INV-CLIENT-AUTH-1/2`, `INV-CLIENT-AUTH-3` (tenant-less interpreter), `INV-CLIENT-STATE-1` / `INV-CLIENT-STATE-2` (resumable via `onboardingRequired`; `emailVerificationPending` for verify redirect), `INV-CLIENT-ARCH-1`, `INV-CLIENT-A11Y-1` + `INV-CLIENT-UI-1` (Cupertino wizard, semantics), `INV-CLIENT-I18N-1` (wizard copy via `intl`), `INV-CLIENT-PHI-1` (no PHI collected — consent only), `INV-CLIENT-CONSENT-1` (consent gated client-side before submit, AC2), `INV-CLIENT-CONTRACT-1`. Backend: `INV-CONSENT-1`.

## Depends on

`core/auth` (signup/verify wire) · `auth` (session, `emailVerificationPending`, `/invite/accept`) · `otp-email-verification.md` · `core-shell` (dio/config/theme) · `router` (onboarding-required gate, verify context guards) · `affiliations` (alpha.5, interpreter final step) · backend `unified-signup`, `interpreter-profiles` (alpha.5/P2), catalog read endpoints, `POST /invitations`. Via [`platform-references.md`](../../docs/platform-references.md).

## Open questions / Out of scope

- **Backend `interpreter-profiles` + cert proof upload (S3 presigned)** — confirm endpoints + timing (alpha.5 vs P2); the interpreter onboarding step 5 depends on them. **Action:** track as cross-repo ask; do not block P1 verify/signup taskgraph.
- **Success-metric numbers** — founder to set funnel-completion targets.
- **MFA for personal interpreters** — confirm MFA is not forced until affiliated (org policy). **Action:** confirm with backend/product before enforcing interpreter MFA in onboarding.
- **Resume signal — RESOLVED 2026-06-29:** `authenticated.onboardingRequired` on the `AuthState` contract (`INV-CLIENT-STATE-2`), server-derived. Remaining: confirm the backend surfaces onboarding-completeness (token claim or `/auth/me`) so `auth` can populate it.
- **LSP web→workstation** — after LSP signs up on web, `lsp_admin` simply logs into the workstation for dispatch (no native LSP onboarding); confirm.
- **"Remember device"** — open product question; no client wire impact yet (see `auth.md`).
- **Production verification email format** — confirm OTP email template with backend ops.
