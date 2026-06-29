# Feature: auth (client)

**Status:** Drafted · **Phase:** P1 / `v0.0.1-alpha.1` (multi-membership UX = alpha.4 contract) · **Owner:** client

## Summary

The single authentication path for the Flutter ops client: email/password login,
MFA challenge + first-time enrollment, session restore, logout, and secure token
storage — built against the backend **alpha.4 identity contract** (`auth-identity-tokens`).
The client is a thin consumer (`INV-CLIENT-CONTRACT-1`): the backend owns the claim
contract; the client persists tokens, decodes claims for routing only, drives the
role redirect, and renders the workspace switcher. Login screens are shared design
across both apps — this repo implements the **dark workstation** variant.

## User-facing behaviour

`/login` (email, password, "remember device", "Forgot password?", "Create an
account"). On submit: a non-privileged single-membership user lands directly on their
role home; a privileged user is routed to `/mfa` (6-digit TOTP, "Use a backup code",
"Resend") and, on first login, to `/mfa/enroll` (QR + manual key + backup codes)
before landing. A user with **2+ active memberships** sees a **tenant/membership
picker** before redirect; a **0-membership** interpreter gets a tenant-less session
and lands on `/idle`. Once in-app, the header shows the active-tenant chip; tapping
the avatar opens the **"Your workspaces"** menu to switch context. Entry paths
`/forgot-password` → `/reset-password` and `/invite/accept` also resolve here.

## User flow & affordances

Role redirect is a pure function of auth state via `go_router` `refreshListenable`
(`INV-CLIENT-STATE-1`) — no imperative navigation. Two switch surfaces:

- **Login picker** — widget `tenant_picker_screen` mounted at the canonical route
  **`/select-workspace`** (`INV-CLIENT-ROUTE-2`), entered from `AuthState.pickMembership`:
  a full-screen list of memberships; the **entire row** is the tap target (not just a
  chevron). Selecting one mints that context, then redirects to its role home.
- **In-app workspace menu**: *affordance* = active-tenant chip in the header + avatar
  glyph; *input surface* = tapping the avatar opens the menu over the live app. Each
  row has a "Switch" button. Non-privileged target → switches instantly. Privileged
  target (`platform_admin`/`lsp_admin`/`sub_admin`) → the row **expands inline** to a
  6-cell OTP field (each cell one digit, auto-advance) + "Verify & switch".

## Acceptance criteria

1. Single-membership login persists tokens and redirects to the role home with no manual navigation.
2. Multi-membership login shows the picker; selecting a membership lands on that membership's role home.
3. A 0-membership interpreter logs in (tenant-less token, `role: interpreter`, no `tenant_id`) and lands on `/idle` without error.
4. A privileged role is MFA-challenged on **login and switch-tenant**; first login routes through `/mfa/enroll`; non-privileged roles are never challenged.
5. `switch-tenant` re-mints the active context; a tenant the user does not actively hold returns 404 and surfaces a graceful error (no crash, menu stays open).
6. Refresh token is stored in `flutter_secure_storage`; access token stays in memory; a silent refresh fires before `exp`; logout clears both and the secure store.
7. On cold start, a stored refresh restores the session (or routes to `/login` if absent/expired).
8. `/forgot-password` always shows the same "if that email exists…" result (no account enumeration); `/reset-password` and `/invite/accept` land the user correctly.

## Wire-format contract

- **`POST /auth/login`** `{ email, password }` → `200 { access_token, refresh_token }`, or an MFA challenge `{ mfa_required: true, mfa_token }` for privileged roles; `401` on bad credentials. *(Envelope is snake_case under `/api/v1`; confirm exact challenge field names against `auth-identity-tokens` — see Open questions.)*
- **`POST /auth/mfa`** `{ mfa_token, code }` → tokens. **`POST /auth/mfa/enroll`** → `{ provisioning_uri, backup_codes[] }`; verify TOTP to activate.
- **`POST /auth/switch-tenant`** `{ tenant_id }` (+ `mfa_token` for privileged) → re-minted tokens; non-held tenant → `404`.
- **`POST /auth/refresh`**, **`/auth/logout`**, **`/auth/forgot-password`** (always `200`), **`/auth/reset-password`** (`410` if token expired/used), **`/invitations/accept`**.
- **Access token** = JWT, claims `{ sub, role, tenant_id?, exp, iat, jti }`. `sub`/`tenant_id` are lowercase-uuid **strings**; `tenant_id` is **absent** for tenant-less tokens (gate `tenant_id != null` before using it). `exp`/`iat` are Unix-**seconds numbers** (not ISO) → `DateTime.fromMillisecondsSinceEpoch(exp * 1000)`. The client base64url-decodes claims **for routing/UX only** — the server remains source of truth.
- **Refresh token** = opaque string, returned **once** and never re-echoed; persist on receipt, never log (`INV-CLIENT-PHI-1` discipline).
- **Access-token holder (`INV-CLIENT-AUTH-4`):** `core-shell` defines `currentAccessTokenProvider` (in-memory) and the `dio` interceptor reads it; **`AuthNotifier` is the sole writer** — it sets the holder on every successful mint (login, MFA verify, refresh, switch-tenant) and clears it on logout. This is the access token's only home (never persisted).
- **Transformation owner:** `AuthRepository` is the only wire-aware layer (`INV-CLIENT-ARCH-1`); it maps snake_case JSON → camelCase `freezed` `AuthSession` via `@JsonKey`.
- **`AuthState` union (the auth→router contract, `INV-CLIENT-STATE-2`):** `unauthenticated` · `loading` · `error(message)` · `mfaRequired(firstLogin, mfaToken)` · `pickMembership(memberships)` · `authenticated(role, tenantId?, onboardingRequired)`. `onboardingRequired` is server-derived (membership/profile completeness) and drives the router onboarding gate; `tenantId` is null for tenant-less (`INV-CLIENT-AUTH-3`).

## Non-goals

Onboarding is a **separate feature** ([`onboarding.md`](onboarding.md)), not auth. Per
the 2026-06-29 decisions: the workstation hosts **native signup + email verification +
onboarding for personal (interpreter) + customer**; only **LSP** signup + onboarding
stay in `leo-web`. The client therefore *does* call `POST /auth/signup` (personal/
customer variants) — owned by the onboarding feature, reusing this feature's
`AuthRepository`/token handling — but auth owns no signup screens. Affiliation
management (`/settings/affiliations`) is its own alpha.5 feature. No admin/back-office
routes (`INV-CLIENT-ROUTE-1`).

## Touches

`INV-CLIENT-AUTH-1` (token split), `INV-CLIENT-AUTH-2` (one Bearer path, `platform_admin` slug — no `superadmin`), `INV-CLIENT-AUTH-3` (tenant-less gating + `/idle` landing), `INV-CLIENT-AUTH-4` (sole writer of the access-token holder), `INV-CLIENT-NET-1` (cert pinning on the auth `dio`), `INV-CLIENT-STATE-1` (redirect = f(state)), `INV-CLIENT-STATE-2` (owns the `AuthState` contract), `INV-CLIENT-ROUTE-1` (no admin routes) / `INV-CLIENT-ROUTE-2` (role→home + `/select-workspace`), `INV-CLIENT-ARCH-1` (`AuthRepository` is the only wire-aware layer), `INV-CLIENT-CONTRACT-1` (thin consumer), `INV-CLIENT-PHI-1` (tokens never logged/persisted in plaintext).

## Depends on

Backend `auth-identity-tokens` + `auth-rbac` (claim contract, switch-tenant, MFA-before-mint) via [`platform-references.md`](../../docs/platform-references.md). Client `core-shell` (`dioProvider`, `appConfigProvider`, `tokenStorageProvider`, **`currentAccessTokenProvider`** — auth writes it, `INV-CLIENT-AUTH-4`) and `router` (consumes `AuthState` + owns the `authRefreshListenableProvider` bridge) — both ✅ drafted.

## Approach

`features/auth/`: `data/auth_repository.dart` + `token_storage.dart`;
`domain/auth_models.dart` (`AuthSession`, decoded `Claims`, `Membership`);
`presentation/notifiers/auth_notifier.dart` (the `Notifier` ViewModel: login,
restoreSession, submitMfa, switchTenant, logout; **writes `currentAccessTokenProvider`**
on every mint and clears on logout, `INV-CLIENT-AUTH-4`); `presentation/state/auth_state.dart`
(`freezed` union per `INV-CLIENT-STATE-2`: `unauthenticated | loading | error(message) | mfaRequired(firstLogin, mfaToken) | pickMembership(memberships) | authenticated(role, tenantId?, onboardingRequired)`);
screens `login`, `mfa`, `mfa_enroll`, `tenant_picker` (at `/select-workspace`),
`forgot_password`, `reset_password`, `invite_accept`. `AuthNotifier.build()` restores
from secure storage on startup. Errors map to copy in the ViewModel
(`401 → "Invalid email or password"`).

## Open questions / Out of scope

- **Onboarding home — RESOLVED 2026-06-29:** the workstation hosts **native signup + email-verify + onboarding for personal + customer**; `leo-web` keeps **only** LSP signup + LSP onboarding. (Supersedes the earlier "signup/verify → leo-web" reading; the web→native handoff is moot — no handoff for these personas.) Consistent with `leo-api` decision-log line 223 ("LSP onboarding wizards" is the precise Flutter non-goal); BD7's parenthetical could be clarified upstream but is not contradicted. See [`onboarding.md`](onboarding.md).
- Exact MFA-challenge envelope field names (`mfa_required` vs `mfa_token`) — confirm against backend `auth-identity-tokens` AC-3/AC-4.
- Refresh-on-switch: backend rotates within the existing family — confirm the client must replace the stored refresh on every switch response.
- "Remember device" semantics (device-fingerprint header? skip-MFA window?) — confirm with backend D7.
