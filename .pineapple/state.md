# leo-workstation — As-built state

_Last updated: 2026-07-11._

> What is **actually built** in this repo right now, vs. what the docs target.
> Target architecture: [`docs/architecture-overview.md`](../docs/architecture-overview.md).
> Build order: [`docs/release-plan.md`](../docs/release-plan.md).

---

## Floor (shipped / on disk)

**P1 in progress — auth slice + core shell.**

| Area | As-built |
|---|---|
| `lib/core/` | Config, Dio + auth interceptor, **`api_error.dart` / `api_response.dart`** (INV-CLIENT-NET-2), **`lib/core/auth/`** (shared `AuthRepository`, DTOs, auth entities, email-verify context), `go_router` + `redirect.dart` + `route_guards.dart`, feature-owned route modules, `DeviceClassScope`, Cupertino theme, `DeviceClass`, `WorkstationScaffold`, `DesktopWorkstationShell`, `leo_roles`, `external_url`, `email_launcher` |
| `lib/features/auth/` | P1 auth presentation: freezed `AuthState` + `AuthUiState`, `AuthNotifier` coordinator + session/login/password-reset/invite ops, co-located `authUiProvider`, screens (login, MFA, forgot/reset two-step OTP, invite w/ consent). Wire re-exports `core/auth`. No membership picker or workspace switcher. `platform_admin` rejected at mint. |
| `lib/features/onboarding/` | Freezed `SignupState`/`SignupUiState` + `OnboardingState`/`OnboardingUiState`; co-located `signupUiProvider` / `onboardingUiProvider`. Signup type/details, OTP verify-email, personal + customer wizards. Signup/verify via `authRepositoryProvider`; catalog/profiles/org via `OnboardingRepository`. Router exits `/onboarding/*` when `!onboardingRequired`. |
| `pubspec.yaml` | `flutter_riverpod`, `go_router`, `dio`, `freezed`, `json_serializable`, `flutter_secure_storage`, `url_launcher`, `intl`, `crypto` |
| Tests | Minimal (`redirect_test`, a few core tests). **Policy: no new Flutter tests unless explicitly requested** (`INV-CLIENT-TEST-1`). |
| Theming | Cupertino (`CupertinoApp` + `CupertinoThemeData` light/dark/night) |

P2 features (`idle`, `session`, `dispatch`, `realtime`) are **not built** yet.

## Bridge (in flight / next)

**P1 / `v0.0.1-alpha.1` — remaining:** realtime WSS channel, onboarding screens, cert pinning.
Carve: [`phases/v0.0.1-alpha.1.md`](phases/v0.0.1-alpha.1.md).

**Auth slice live-contract rework (`v0.0.1-alpha.1-auth-live` phase) — complete.**
`features/auth.md` was corrected 2026-06-30 against the live backend (D1–D7). Both
tasks merged to `main` 2026-07-01: **AL-T-01** (contract core: repository/state-machine
rewrite, router alignment, `tenant_picker_screen.dart`/`workspace_switcher.dart`/
`/select-workspace` deletion, PR #15, commit `3fc83c0`) and **AL-T-02** (real
MFA-enrollment QR via `qr_flutter`, backup-codes UI deletion, invite-consent
verification, PR #17, commit `1238a84`). `flutter analyze` clean, 685 tests passing
on `main`. `INV-CLIENT-STATE-2`/`INV-CLIENT-ROUTE-2` amendments landed with AL-T-01.

## Platform dependency (sibling `../leo-api`)

| Backend | State |
|---|---|
| Current phase | **`v0.0.1-alpha.5` complete** — auth spine done. |
| Next backend phase | **P2 / `v0.0.1` MVP** — sessions, matching, first-dollar billing. |
| Auth contract for the client | Build against **alpha.4+** (multi-membership, `switch-tenant`, `platform_admin`). |

---

## Decisions (client-side)

- **2026-07-12 — LSP native signup phase shipped (separate pass):** `v0.0.1-p2-onboarding-lsp` complete — LSP-T-01 ([#35](https://github.com/saambaby/leo-workstation/pull/35) → `8d607b6`), LSP-T-02 ([#36](https://github.com/saambaby/leo-workstation/pull/36) → `dedf468`); LSP-T-03 staging E2E **deferred** (operator skip). In-app LSP card → details + `baa_ack` gate → `signupLsp` → existing verify/MFA path. Scheduling open item closed: shipped as its own pass, not folded into `v0.0.1-p2-onboarding`.
- **2026-07-11 — API error envelope + safe response bodies (FINAL):** client parses leo-api `{ statusCode, message, error, code }` in `api_error.dart`; **show `message`** in UI; **branch on `code` only** for special flows (e.g. `EMAIL_NOT_VERIFIED` redirect) — no client code→copy map. Success paths use `requireJsonMap`/`requireJsonList` — no `response.data!`. Codified `INV-CLIENT-NET-2`.
- **2026-07-11 — Presentation state layout refined (FINAL):** freezed notifier state + freezed UI state under `presentation/state/`; derived `<feature>UiProvider` co-located on the notifier file (no `presentation/providers/*_ui_provider.dart`); screens watch UI providers only; large auth flows use ops modules under a thin `AuthNotifier` coordinator; onboarding mirrors the same pattern; wizard exit is redirect-driven when `onboardingRequired` clears. Codified in `INV-CLIENT-STATE-3`, `.cursor/rules/state-management.mdc`, `.cursor/rules/pineapple-project.mdc`, `CLAUDE.md`, `docs/architecture-overview.md` §1.
- **2026-07-11 — Cross-spec audit + taskgraph refresh:** P1 taskgraph revised (`status: shipped`); new P2 onboarding taskgraph (`v0.0.1-p2-onboarding`). Wire paths aligned to alpha.6 (`/auth/resend-verify`, `/auth/reset-password/verify`). Core auth repo (`INV-CLIENT-AUTH-REPO-1`), OTP verify, `emailVerificationPending` redirect, route guards, no `/web-handoff`. Audit: [`.pineapple/cross-spec-audit.md`](cross-spec-audit.md).
- **2026-07-11 — LSP native signup specced + cross-spec-audit reconciled:** new spec [`features/lsp-native-signup.md`](features/lsp-native-signup.md) moves LSP account signup in-app (OTP verify → MFA enroll → `/dispatch`), reusing `onboarding.md`'s signup screens and `auth.md`'s MFA-enroll screen; LSP *onboarding* (languages/partners/pricing) and all back-office stay in `leo-web`. `INV-CLIENT-ROUTE-1` narrowed accordingly; new `INV-CLIENT-CONSENT-1` promoted (client-side consent gate before submit, previously restated ad hoc in three specs). Follow-up audit found + fixed 5 DRIFT / 2 of 3 AMBIGUOUS against `onboarding.md`/`otp-email-verification.md`/the phase doc — addendum in [`cross-spec-audit.md`](cross-spec-audit.md). Session note: [`.claude/context/sessions/2026-07-11-lsp-native-signup-spec-and-audit.md`](../.claude/context/sessions/2026-07-11-lsp-native-signup-spec-and-audit.md).
- **2026-07-07 — Flutter email verify = pending screen only (SUPERSEDED 2026-07-11):** interim magic-link pending screen; replaced by OTP in-app flow.
- **2026-07-06 — Domain terminology (`model` → `entity`):** renamed `auth_models.dart` / `onboarding_models.dart` → `*_entities.dart`; docs/rules/invariants updated. Domain layer uses **entity**; wire request bodies stay **DTO** in `data/dto/`. MVVM **ViewModel** unchanged.
- **2026-07-06 — Wire serialization (DTO + entity):** replaced private `_map*` parsers and inline wire maps in auth/onboarding repositories. Request bodies → `data/dto/` (`freezed` + `toJson`); responses → `fromJson` on domain entities (`LoginResult`, `AuthSession`, `SignupResult`, catalog types). New invariant `INV-CLIENT-SERIAL-1`; documented in `docs/architecture-overview.md` §1 wire serialization, `.cursor/rules/pineapple-project.mdc`, `.pineapple/code-map.md`.
- **2026-07-06 — Feature-owned route modules:** split monolithic `app_router.dart` into `features/auth/presentation/routes/auth_routes.dart`, `features/onboarding/presentation/routes/onboarding_routes.dart`, and `core/router/role_home_routes.dart`; `DeviceClassScope` extracted to `core/router/device_class_scope.dart`. Path constants for redirect deduped via feature exports. Documented in `docs/architecture-overview.md` §1/§2/§4 and `.pineapple/code-map.md`.
- **2026-06-30 — Centralized presentation state (FINAL; refined 2026-07-11):** async/business state must live in feature notifiers, not private `_loading` / `_submitting` fields on widgets. Screens use derived `<feature>UiProvider` for loading/error display. Repository calls only from notifiers. Route param guards in `go_router` redirects. Reference: `features/auth/` (+ `features/onboarding/` after 2026-07-11). See also 2026-07-11 refinement above.
- **2026-06-30 — No default Flutter tests:** agents do not add unit/widget tests unless the user explicitly asks. Verification = `flutter analyze` (+ `build_runner` when needed). Codified in `INV-CLIENT-TEST-1`.
- **2026-06-30 — COE acceptance walk:** six client failure modes FM-CLIENT-1…6 recorded ([`failure-modes.md`](failure-modes.md), [`phases/v0.0.1-alpha.1-coe.md`](phases/v0.0.1-alpha.1-coe.md)). macOS window frame ≠ `WorkstationScaffold`.
- **2026-06-29 — Onboarding home (FINAL; amended 2026-07-11):** workstation hosts personal + customer signup/verify/onboarding; LSP *onboarding* stays in `leo-web`, LSP *signup* moved in-app as a delta (see 2026-07-11 entry above). Spec: [`features/onboarding.md`](features/onboarding.md).
- **2026-06-30 — Auth contract corrected against live backend (FINAL):** read `leo-api/src/modules/auth/*` source + the running server's `/api/docs-json` (`localhost:3000/api/v1`) and found the original `ApiAuthRepository` was built against an assumed, wrong contract. Locked: drop the pre-login membership picker (D1); cut the in-app workspace switcher — no memberships-list endpoint exists (D2); rebuild MFA around resubmitting `/auth/login` with `totp_code`, no separate verify endpoint/`mfa_token`, no backup codes (D3); hold password in volatile memory only across the MFA round-trip (D4); signup stays owned by `onboarding.md`, already correctly wired (D5); `/invite/accept` needs `tos`/`privacy`/`baa_ack` consent (D6); add a QR-rendering dependency for MFA enrollment (D7). Full rationale + rejected alternatives: [`features/auth.md`](features/auth.md).

## Open items

- **Manual QR-scan smoke test** — AL-T-02's real MFA-enrollment QR (`qr_flutter`) was never scanned with an actual authenticator app (no simulator/device available to the worker or coordinator this session). Worth a real device check before this ships to users.
- **LSP-T-03 staging E2E (deferred)** — in-app LSP signup happy path + baa gate + 409 path not walked against staging; code is on `main`. Re-run S1–S7 when convenient ([#33](https://github.com/saambaby/leo-workstation/issues/33)).
- **Known MFA-retry UX gap (pre-existing, not introduced by the auth-live rework)** — a failed MFA submit transitions to `AuthState.error`, which loses the `AuthMfaRequired` arm `submitMfa`'s guard checks; a retry on the same screen silently no-ops until the user navigates back to `/login`. Flagged during AL-T-01 review, not fixed (out of that task's scope).
- Memberships-list endpoint — flag to `leo-api` if/when multi-tenant switching (D2) is reprioritized; not yet filed.
- Stale remote branches on GitHub (`pin-2`…`pin-6`, `pin-13`, `pin-14`, `pin-revert/orchestration-state-direct-push`) — merged/closed PRs didn't auto-delete them; left alone pending explicit cleanup authorization.
- Feature-spec loop: `realtime`, session/dispatch/call — see [`features/INDEX.md`](features/INDEX.md).
- **P2 onboarding orchestration:** PR [#29](https://github.com/saambaby/leo-workstation/pull/29) merged to `main` (`6a9372b`). P2-O-T-01..04 done; [#28](https://github.com/saambaby/leo-workstation/issues/28) manual E2E smoke remains.
- P2 remaining beyond onboarding: WSS realtime, session/dispatch/call MVP.
- Onboarding backend deps — see [`features/onboarding.md`](features/onboarding.md) open questions (A8).
