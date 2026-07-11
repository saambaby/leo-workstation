# leo-workstation — Client invariants (`INV-CLIENT-*`)

> Stable, load-bearing rules for the **Flutter ops client**. Platform-wide `INV-*`
> (auth contract, RLS, money, PHI server-side) are canonical in
> [`../leo-api/.pineapple/invariants.md`](../../leo-api/.pineapple/invariants.md) — linked here, never copied.
> Citation conventions: see [`docs/platform-references.md`](../docs/platform-references.md).

These are extracted from the code patterns and target architecture
([`docs/architecture-overview.md`](../docs/architecture-overview.md)) and the
client split decisions (`BD1`, `BD7`). Gate IDs (`D6`/`D7`/`D13`/`L3`) resolve via
platform-references.

---

## Architecture & layering

### INV-CLIENT-ARCH-1 — Strict MVVM dependency direction
Every feature is a vertical slice: **View → ViewModel (Riverpod `Notifier`) → Repository → wire**. The View never touches `dio`, secure storage, or a repository directly; the Repository never imports Flutter. (arch §1)

### INV-CLIENT-ARCH-2 — No cross-slice data coupling
A feature slice never imports another feature's `data/` layer. Cross-feature reads go through the other feature's notifier provider (`ref.read`). (arch §2, §11)

### INV-CLIENT-SERIAL-1 — DTOs in `data/`, entity `fromJson` for responses
Wire serialization is explicit and typed. **Request** bodies are `freezed` DTOs under `data/dto/` with `toJson()`. **Responses** that match domain shape use `factory Entity.fromJson` on the existing `domain/<feature>_entities.dart` class — no duplicate wire types, no private `_map*` parsers, no inline `{'snake_key': …}` maps in repositories, no `*_models.dart` filenames. Discriminated API responses (e.g. login MFA vs session) use a custom `fromJson` on the domain union. DTOs never live in `domain/` or `presentation/`. Auth wire types live in `core/auth/` (`INV-CLIENT-AUTH-REPO-1`). (arch §1 wire serialization; reference: `core/auth/`, `features/onboarding/`)

### INV-CLIENT-STATE-1 — Immutable state, navigation is a pure function of state
View state is immutable (`freezed`). `go_router`'s `redirect` is keyed on auth state via `refreshListenable`; there is no imperative navigation on login/logout. (arch §3, §5)

### INV-CLIENT-STATE-2 — `AuthState` is the auth→router contract
`auth` owns the `AuthState` union and `router` consumes it; the union **arm** signature is frozen as a shared contract. Arms: `unauthenticated(forgotPasswordSending?, resendCodeSending?, emailVerificationPending?)` · `loading(reason?)` · `error(message)` · `mfaRequired(firstLogin, enrollmentToken?, otpauthUrl?, secret?)` · `authenticated(role, tenantId?, onboardingRequired)`. `emailVerificationPending` is **router-consumed** metadata (exception to UI-only optional fields). Optional metadata fields on other arms are UI-only and invisible to router redirect.

### INV-CLIENT-STATE-3 — Centralized async state, derived UI providers
Async and business state (loading, errors, lists fetched for UI, in-flight operations) is owned by the feature `Notifier` (`presentation/notifiers/`), not private fields on `State` / `ConsumerState`. Notifier state and derived UI helpers are `@freezed` under `presentation/state/` (`<feature>_state.dart`, `<feature>_ui_state.dart`). The derived UI `Provider` (`<feature>UiProvider`) is **co-located on the notifier file** — not a separate `presentation/providers/` file. Screens watch that provider for `isLoading`, `errorMessage`, etc. instead of pattern-matching the notifier union on every build. Views never call repositories. Ephemeral UI-only state (`TextEditingController`, focus nodes, overlay open/close) may remain local. Session transitions (login, logout, onboarding complete) navigate via `redirect` + `AuthState`, not imperative role-home `context.go`. Large notifiers may extract plain ops modules; they must not become separate providers that mutate the router contract. Reference: `features/auth/` (`AuthNotifier`, `authUiProvider`, ops modules), `features/onboarding/` (`SignupNotifier`, `OnboardingNotifier`). Cursor: `.cursor/rules/state-management.mdc`. (promoted 2026-06-30; refined 2026-07-11)

### INV-CLIENT-TEST-1 — No Flutter tests unless requested
Do not add or expand unit/widget/integration tests in this repo unless the user explicitly asks. Verification for agent work is `flutter analyze` (+ `build_runner` when codegen changes). Existing tests may be kept passing but must not be extended by default. (promoted 2026-06-30)

---

## Client boundary (BD7)

### INV-CLIENT-ROUTE-1 — No back-office in Flutter
No admin CRUD, reports, rate-card, or billing-export routes exist in this app. **LSP onboarding** (languages/partners/pricing) and all LSP back-office stay in **`leo-web`**. **LSP signup** (account creation → OTP verify → MFA enroll) is in-app as a P2 delta reusing the personal/customer signup screens (`features/lsp-native-signup.md`, ships after `v0.0.1-p2-onboarding`) — softened 2026-07-11; not yet shipped, see phase doc. **Personal (interpreter) + customer signup, email verification, and onboarding are in-app** (decided 2026-06-29; see [state.md](state.md) and [features/onboarding.md](features/onboarding.md)). LSP Admin reaches back-office web surfaces via an external link, never an in-app route. (client-map, BD7 line 223)

### INV-CLIENT-CONTRACT-1 — Thin, untrusted client
All business rules and billing live in `leo-api`. The client never computes a charge and never starts the billing meter; it reflects state pushed over WSS. (arch §6)

### INV-CLIENT-ROUTE-2 — Canonical role→home map
Exactly one role→home mapping: `interpreter → /idle` (incl. tenant-less), `customer_user → /call`, `customer_admin → /call`, `sub_admin → /dispatch`, `lsp_admin → /dispatch`. **`platform_admin` has no workstation home** — session mint is rejected in `AuthNotifier._applySession` with an error on `/login` (no `/web-handoff` route). `lsp_admin` reaches `leo-web` via the chrome external link only (`INV-CLIENT-ROUTE-1`).

### INV-CLIENT-ROUTE-GUARD-1 — Context guards live in `redirect.dart` only
Public routes that require route `extra` or query context (`/verify-email`, `/forgot-password/verify`, `/reset-password`, `/signup/details`) are guarded in `core/router/redirect.dart` via `route_guards.dart`. Feature route modules register paths only — no per-route `redirect` callbacks duplicating guards.

### INV-CLIENT-AUTH-REPO-1 — One shared auth wire layer in `core/auth`
All `/auth/*` HTTP (login, MFA enroll, refresh, logout, forgot/reset, signup, verify-email, resend-verify, invite accept) is implemented once in `lib/core/auth/data/auth_repository.dart` with DTOs in `core/auth/data/dto/` and shared domain types in `core/auth/domain/`. Feature slices (`auth`, `onboarding`) import `authRepositoryProvider` from core; `features/auth/data/` may re-export for backward compatibility but must not duplicate wire logic. Onboarding-specific non-auth endpoints (catalog, profiles, invitations) stay in `OnboardingRepository`.

---

## Security

### INV-CLIENT-AUTH-1 — Token storage split
The refresh token lives in `flutter_secure_storage` (Keychain/Keystore/libsecret/DPAPI). The access token is held **in memory only**, short-lived. (D6/D7; mirrors platform INV-AUTH-1/2)

### INV-CLIENT-AUTH-2 — One Bearer path, canonical role slug
Every authenticated request carries the access JWT via the single `dio` interceptor — no per-call bespoke auth. Role handling uses the `platform_admin` slug; `superadmin` never appears in code or docs. (mirrors INV-AUTH-1, INV-RBAC-2)

### INV-CLIENT-AUTH-3 — Tenant-less client contract
`tenant_id` is **optional** in the access-token claims; code gates `tenant_id != null` before using it. A 0-membership interpreter holds a tenant-less session and routes to `/idle`. (honored by auth, router, onboarding; mirrors platform INV-AUTH-4 / INV-TENANT-1)

### INV-CLIENT-AUTH-4 — Single in-memory access-token holder seam
`core-shell` defines `currentAccessTokenProvider` (in-memory, default `null`) and the `dio` interceptor **reads** it; `auth` is the **sole writer** — it sets the holder on every mint/refresh/switch-tenant and clears it on logout. No other feature reads or writes the raw access token; it is never persisted (`INV-CLIENT-AUTH-1`). (promoted 2026-06-29 from core-shell ⋂ auth)

### INV-CLIENT-NET-1 — Certificate pinning
API calls verify a pinned server cert (SHA-256) with rotation support; a pin mismatch refuses the connection. (D6/D13)

### INV-CLIENT-NET-2 — Typed error envelope + safe response bodies
Parse leo-api failures as `{ statusCode, message, error, code }` via `lib/core/network/api_error.dart` (mirrors platform `INV-ERROR-1`). **Show `message` in alerts/forms** — do not maintain a client code→copy map. **Branch on `code`** (`ApiErrorCode`) only when UX differs (redirect, field highlight, session teardown); never branch on `message` text. `mapUserFacingError` returns server `message` or a generic/fallback for non-envelope failures. Successful JSON bodies use `requireJsonMap` / `requireJsonList` (`api_response.dart`) — never `response.data!` into `fromJson`. (promoted 2026-07-11)

### INV-CLIENT-PHI-1 — No PHI at rest
No patient data is persisted on device. Session caches are ephemeral and cleared on sign-off and on backgrounding. (mirrors platform INV-PHI-1; ps §16)

### INV-CLIENT-CONSENT-1 — Client-side consent gate before submit
Every consent-bearing submit (`/auth/signup`, `/invitations/accept`, and LSP signup) gates on all required consent booleans being `true` **client-side** — an incomplete or false consent object is never sent to the network, not merely rejected server-side. Consent itself stays append-only server-side (`INV-CONSENT-1`, platform); this invariant is only about when the client is allowed to fire the request. Honored by `auth.md` AC6, `onboarding.md` AC2, `lsp-native-signup.md` AC2. (promoted 2026-07-11 from cross-spec audit — invariant-promotion candidate #1)

### INV-CLIENT-MEDIA-1 — Media tokens only, media never via Leo
The client exchanges encrypted A/V **directly** with Vonage (video) / Twilio (telephony) using short-lived tokens minted by `leo-api`. Media never transits the client's backend path. (mirrors platform INV-MEDIA-1; arch §6)

---

## Accessibility & device gating

### INV-CLIENT-A11Y-1 — Deaf-first, never audio-only
Semantics labels on every interactive element; alerts are visual/vibration/push, never audio-only; signed-language sessions are video-only. App-wide, persisted night mode for all roles. Hard product gate (L3, WCAG 2.1 AA). (mirrors platform INV-A11Y-1/2; ps §15)

### INV-CLIENT-UI-1 — Cupertino-first
The app is Cupertino-first (`CupertinoApp` + `CupertinoThemeData`, light/dark/night). New UI uses Cupertino widgets. (ps §15)

### INV-CLIENT-DEVICE-1 — DeviceClass gates routes
A `DeviceClass` derivation hides routes a device isn't entitled to: customer smartphone paths are blocked until `v0.1.0`; interpreter **Accept** is not reachable on mobile. (client-map, BD7)

### INV-CLIENT-I18N-1 — No hardcoded user-facing strings
User-facing copy goes through `intl`/`flutter_localizations`; no string literals in widgets. (release-checklists)

---

*Companion: target architecture [`docs/architecture-overview.md`](../docs/architecture-overview.md) · platform invariants `../leo-api/.pineapple/invariants.md`.*
