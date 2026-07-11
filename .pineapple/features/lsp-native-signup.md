# Feature: lsp-native-signup

**Status:** Drafted (via `/pineapple:feature-spec`; amended 2026-07-11 for cross-spec-audit reconciliation) · **Phase:** P2 delta — **functionally** depends on `v0.0.1-p2-onboarding`'s `otp-email-verification` wire and `auth`'s MFA-enroll screen existing first (this spec reuses rather than builds them). **Scheduling is unconfirmed**: whether that means a separate pass after the taskgraph closes, or folding this work into the same taskgraph before it closes, is an open founder call (see Open questions) — do not read "P2 delta" as a locked ship-order. · **Owner:** client

## Summary

Lets LSP operators create their account **in-app** instead of being bounced to `leo-web`: picker → org details → OTP verify → MFA enroll → `/dispatch`. This is a delta on top of `onboarding.md`'s signup primitives, reusing the same screens and the same backend union (`leo-api` alpha.4+ already accepts `business_type: 'lsp'`; **no API changes**). Post-signup LSP back-office (rates, billing, users, languages/pricing) stays in `leo-web` via the existing chrome link — only the signup transaction itself moves in-app.

## User-facing behaviour

`/signup`'s LSP card no longer opens an external browser — tapping it pushes `/signup/details` with `SignupDraft(path: lsp)`, same affordance pattern as the personal/customer cards (whole card is the tap target). The details step collects org name, admin email, password, timezone, and three required consent checkboxes (ToS, privacy, **BAA**) — `baa_ack` is LSP-only and gates `Continue`. Submit → `/verify-email` (existing OTP screen). Because LSP admins are always privileged, verify success never mints a session directly: it returns `mfa_enrollment_required`, routing to the **existing** `/mfa/enroll` QR screen (`auth.md` D7) — no new MFA UI. Completing enrollment mints the session and the router sends `lsp_admin` → `/dispatch` (`INV-CLIENT-ROUTE-2`, unchanged mapping).

## Acceptance criteria

1. Tapping the LSP card on `/signup` pushes `/signup/details(path: lsp)` — no `launchUrl` / external browser for the signup step itself.
2. `Continue` on the LSP details step is disabled until `tos`, `privacy`, and `baa_ack` are all checked; an incomplete submission never reaches the network (client-side gate, not just server `400`).
3. Submit calls `AuthRepository.signupLsp(...)` → `POST /auth/signup { account_type: 'business', business_type: 'lsp', ..., consent: { tos, privacy, baa_ack } }`; success sets `emailVerificationPending` (router redirect to `/verify-email`, no imperative `push` — same pattern as `onboarding.md` AC4).
4. Verify-email success for an LSP account surfaces `{ mfa_enrollment_required, enrollment_token, otpauth_url, secret }` → `AuthState.mfaRequired(firstLogin: true, ...)` → router sends the user to the existing `/mfa/enroll` screen, not a token session.
5. A valid TOTP submit on `/mfa/enroll` posts `POST /auth/mfa/enroll { enrollment_token, totp_code }`; the resulting session has role `lsp_admin` and the router lands on `/dispatch`.
6. `409` (`EMAIL_ALREADY_EXISTS`) and `400` (`CONSENT_REQUIRED`) surface through the existing typed error envelope (`INV-CLIENT-NET-2`) — no bespoke error-code branch added for LSP.
7. No admin/back-office route is added anywhere in this delta; the only post-`/dispatch` LSP-admin surface remains the existing external `leo-web` chrome link.

## User flow & affordances

- **LSP card** — same whole-card tap target as personal/customer cards (`onboarding.md`); the *destination* changes (in-app push, not external launch) but the tap surface does not.
- **`baa_ack` checkbox** — full row is the input surface (not just the checkbox glyph), consistent with the existing `tos`/`privacy` rows on this screen.
- **`Continue` disabled state** — visual affordance is a greyed/disabled button; input surface is `onPressed: null` while any consent is unchecked, so a tap is inert rather than silently no-op-ing after being enabled.

## Wire-format contract

`POST /auth/signup` body adds `business_type: 'lsp'` and a required `consent.baa_ack: bool` (optional `phone`, `business_hours`, `given_name`, `family_name`, `display_name` — same optional set as customer signup). Response `status` may be `"active"` or `"pending"` (`LSP_ACTIVATION_INTERIM_AUTO` server flag) — the client does not branch on this value; `email_verification_required: true` always drives the next step regardless. `POST /auth/verify-email` and `POST /auth/mfa/enroll` are byte-identical to the contracts already documented in `auth.md` — this feature adds no new response shapes, only a new caller. Transformation owner: `core/auth/data/AuthRepository` (`INV-CLIENT-AUTH-REPO-1`) — either a new `SignupLspRequestDto` or the existing customer DTO extended with `baaAck`; no duplicate DTO logic in `OnboardingRepository`.

## Non-goals

LSP languages/partners/pricing onboarding wizard in Flutter. New `leo-api` routes or DTO changes. Removing the `leo-web` LSP signup path (stays as an alternate entry). Any admin CRUD/rates/billing/users route — `INV-CLIENT-ROUTE-1`'s back-office half stays intact; only its signup carve-out changes.

## Touches

`INV-CLIENT-ROUTE-1` (**softened**: LSP *signup* now allowed in-app; back-office remains web-only — this narrows the invariant's LSP exclusion, it does not remove it), `INV-CLIENT-AUTH-REPO-1`, `INV-CLIENT-STATE-2` (reuses `mfaRequired`/`emailVerificationPending` arms, no new arms), `INV-CLIENT-ROUTE-2` (unchanged `lsp_admin` → `/dispatch` mapping, exercised by a new caller), `INV-CLIENT-NET-2`, `INV-CLIENT-PHI-1` (consent booleans only), `INV-CLIENT-UI-1` / `INV-CLIENT-A11Y-1` (checkbox semantics), `INV-CLIENT-I18N-1`. Backend: `INV-CONSENT-1`.

**Drift this creates (flag for `/pineapple:cross-spec-audit`):** `onboarding.md` AC1 ("selecting the LSP option opens the `leo-web` signup URL externally — no native LSP signup") and its KD1, `otp-email-verification.md`'s non-goals line ("LSP email verify... LSP signup stays `leo-web`"), and the `v0.0.1-p2-onboarding` phase doc's out-of-scope line ("LSP signup (leo-web)") all predate this spec and now describe the *pre-delta* behaviour. They need an update pass when this feature is scheduled, not silently left contradictory.

## Depends on

`onboarding.md` (reuses `SignupPath`, `SignupNotifier`, `SignupTypeScreen`, `SignupDetailsScreen` — this is a delta on those, not a parallel implementation) · `auth.md` (verify→MFA-enroll wire, `/mfa/enroll` screen, `AuthState.mfaRequired`) · `otp-email-verification.md` (verify-email wire) · `router` (existing redirect table; no new guards). **Ordering:** this delta cannot land before `otp-email-verification`'s wire and `auth`'s `/mfa/enroll` screen exist — but whether that's a separate pass after `v0.0.1-p2-onboarding` closes, or folded into that taskgraph before it closes, is unresolved (see Open questions). Do not schedule this work against either assumption without confirming first.

## Open questions / Out of scope

- **`status: "pending"` vs `"active"`** — confirm this has no client-visible branch; plan assumes purely informational/backend-internal (`LSP_ACTIVATION_INTERIM_AUTO`).
- **Scheduling** — confirm with founder whether this ships as its own P2 delta pass after `v0.0.1-p2-onboarding`, or gets folded into that taskgraph before it closes (affects the stale non-goals lines above).
- **`SignupLspRequestDto` vs extending the customer DTO** — implementation detail, decide at taskgraph time; either is compliant with `INV-CLIENT-SERIAL-1`.
