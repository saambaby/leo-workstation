# leo-workstation — As-built state

_Last updated: 2026-07-01._

> What is **actually built** in this repo right now, vs. what the docs target.
> Target architecture: [`docs/architecture-overview.md`](../docs/architecture-overview.md).
> Build order: [`docs/release-plan.md`](../docs/release-plan.md).

---

## Floor (shipped / on disk)

**P1 in progress — auth slice + core shell.**

| Area | As-built |
|---|---|
| `lib/core/` | Config, Dio + auth interceptor, `go_router` + redirect guard, Cupertino theme, `DeviceClass`, `WorkstationScaffold`, `DesktopWorkstationShell` (macOS window frame), `leo_roles` (+ `roleDisplayLabel`), `external_url` |
| `lib/features/auth/` | Full P1 auth vertical slice: repository (mock + live), `AuthNotifier`, `AuthState` (with sub-flow metadata fields), `authUiProvider`, screens (login, MFA, enroll, tenant picker, forgot/reset, invite), design system widgets, `AuthFormShell`, `MfaCodeForm`, workspace switcher |
| `lib/features/onboarding/` | Signup type/details, verify email, personal + customer onboarding wizards (mock-first) |
| `pubspec.yaml` | `flutter_riverpod`, `go_router`, `dio`, `freezed`, `json_serializable`, `flutter_secure_storage`, `url_launcher`, `intl`, `crypto` |
| Tests | Minimal (`redirect_test`, a few core tests). **Policy: no new Flutter tests unless explicitly requested** (`INV-CLIENT-TEST-1`). |
| Theming | Cupertino (`CupertinoApp` + `CupertinoThemeData` light/dark/night) |

P2 features (`idle`, `session`, `dispatch`, `realtime`) are **not built** yet.

## Bridge (in flight / next)

**P1 / `v0.0.1-alpha.1` — remaining:** realtime WSS channel, onboarding screens, cert pinning.
Carve: [`phases/v0.0.1-alpha.1.md`](phases/v0.0.1-alpha.1.md).

**Auth slice live-contract rework (`v0.0.1-alpha.1-auth-live` phase) — in progress.**
`features/auth.md` was corrected 2026-06-30 against the live backend (D1–D7).
**AL-T-01** (contract core: repository/state-machine rewrite, router alignment,
`tenant_picker_screen.dart`/`workspace_switcher.dart`/`/select-workspace` deletion)
merged to `main` 2026-07-01 (PR #15, commit `3fc83c0`). **AL-T-02** (real MFA-enrollment
QR via `qr_flutter`, backup-codes UI deletion, invite-consent verification) is out for
review on branch `pin-14/mfa-qr-consent-ui` — [PR #17](https://github.com/saambaby/leo-workstation/pull/17),
not yet merged. `INV-CLIENT-ROUTE-2`'s `/select-workspace` clause still needs the
doc amendment (tracked as an open item below).

## Platform dependency (sibling `../leo-api`)

| Backend | State |
|---|---|
| Current phase | **`v0.0.1-alpha.5` complete** — auth spine done. |
| Next backend phase | **P2 / `v0.0.1` MVP** — sessions, matching, first-dollar billing. |
| Auth contract for the client | Build against **alpha.4+** (multi-membership, `switch-tenant`, `platform_admin`). |

---

## Decisions (client-side)

- **2026-06-30 — Centralized presentation state (FINAL):** async/business state must live in feature notifiers, not private `_loading` / `_submitting` fields on widgets. Screens use derived `<feature>_ui_provider` for loading/error display. Repository calls only from notifiers. Route param guards in `go_router` redirects. Reference implementation: `features/auth/`. Codified in `INV-CLIENT-STATE-3`, `.cursor/rules/pineapple-project.mdc`, `docs/architecture-overview.md` §1 checklist.
- **2026-06-30 — No default Flutter tests:** agents do not add unit/widget tests unless the user explicitly asks. Verification = `flutter analyze` (+ `build_runner` when needed). Codified in `INV-CLIENT-TEST-1`.
- **2026-06-30 — COE acceptance walk:** six client failure modes FM-CLIENT-1…6 recorded ([`failure-modes.md`](failure-modes.md), [`phases/v0.0.1-alpha.1-coe.md`](phases/v0.0.1-alpha.1-coe.md)). macOS window frame ≠ `WorkstationScaffold`.
- **2026-06-29 — Onboarding home (FINAL):** workstation hosts personal + customer signup/verify/onboarding; LSP stays in `leo-web`. Spec: [`features/onboarding.md`](features/onboarding.md).
- **2026-06-30 — Auth contract corrected against live backend (FINAL):** read `leo-api/src/modules/auth/*` source + the running server's `/api/docs-json` (`localhost:3000/api/v1`) and found the original `ApiAuthRepository` was built against an assumed, wrong contract. Locked: drop the pre-login membership picker (D1); cut the in-app workspace switcher — no memberships-list endpoint exists (D2); rebuild MFA around resubmitting `/auth/login` with `totp_code`, no separate verify endpoint/`mfa_token`, no backup codes (D3); hold password in volatile memory only across the MFA round-trip (D4); signup stays owned by `onboarding.md`, already correctly wired (D5); `/invite/accept` needs `tos`/`privacy`/`baa_ack` consent (D6); add a QR-rendering dependency for MFA enrollment (D7). Full rationale + rejected alternatives: [`features/auth.md`](features/auth.md).

## Open items

- **AL-T-02 review** — PR #17 (`pin-14/mfa-qr-consent-ui`) open against `main`; awaiting reviewer merge. `qr_flutter ^4.1.0` added and locked (D7). `flutter analyze`/`flutter test` (685 passing) both clean; manual device/simulator QR-scan smoke test not performed by the worker (no simulator available in that environment) — flagged in the PR body for the reviewer.
- Memberships-list endpoint — flag to `leo-api` if/when multi-tenant switching (D2) is reprioritized; not yet filed.
- `INV-CLIENT-ROUTE-2` needs amending to drop the `/select-workspace` clause — deferred to Phase 2 persist, not yet done.
- Feature-spec loop: `realtime` pending — see [`features/INDEX.md`](features/INDEX.md).
- P1 remaining: WSS realtime, onboarding, cert pinning.
- Onboarding backend deps — confirm timing; see [`features/onboarding.md`](features/onboarding.md).
