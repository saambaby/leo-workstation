# Feature: router

**Status:** Drafted · **Phase:** P1 / `v0.0.1-alpha.1` · **Owner:** client

## Summary

The `go_router` configuration and the **redirect guard** for the whole app: the route
tree, the role→home mapping, and a redirect that is a **pure function of (auth state,
device class, current location)** re-evaluated on every auth-state change via
`refreshListenable`. Router consumes — never owns — auth state (`auth`) and
`DeviceClass` (`core-shell`); it decides *where* a user may be, not *how* they
authenticate. Navigation is therefore a pure function of state (`INV-CLIENT-STATE-1`),
with no imperative `push`/`pop` on login/logout.

## User-facing behaviour

A signed-out user hitting any protected route lands on `/login`. Mid-auth states park
the user on the right screen and **trap** them there until resolved (`/mfa`,
`/mfa/enroll`, `/select-workspace`). Once authenticated, each role lands on its home —
interpreter `/idle`, customer `/call`, dispatcher `/dispatch` — and is bounced off the
auth screens. A device that isn't entitled to a surface never sees its routes
(customer on smartphone is held off `/call` until `v0.1.0`).

## Acceptance criteria

1. `routerProvider` exposes a `GoRouter` whose `redirect` is pure over (auth state, device class, location) and re-runs on every auth change via `authRefreshListenableProvider` → `refreshListenable`.
2. Unauthenticated access to any non-public route → `/login`; the public set (`/login`, `/forgot-password`, `/reset-password`, `/invite/accept`) is reachable while signed out.
3. Auth-transition states route and trap: `mfaRequired` → `/mfa` (first login → `/mfa/enroll`), `pickMembership` → `/select-workspace`; the user cannot reach a role home until the state clears.
4. On `authenticated`, role→home: interpreter **and tenant-less interpreter** → `/idle`, `customer_user` → `/call`, `sub_admin`/`lsp_admin` → `/dispatch`; landing on `/login`/`/mfa`/`/select-workspace` while authenticated redirects to role home.
5. Device gating: a `customer_user` on `smartphone` is kept off customer routes via a "desktop/tablet required" screen until `v0.1.0`; gated routes are **absent**, not dead-ended.
6. `platform_admin` (web-only role) has no workstation home → a "continue in `leo-web`" interstitial (or forced sign-out), never a blank/broken route.
7. Deep links resolve safely: a link the user is entitled to (e.g. `/session/:id` for their live session) is honored; otherwise → role home (authed) or `/login` (not). Unknown paths → role home / `/login`.
8. **No redirect loop** for any (state × location) pair (login ↔ mfa ↔ picker ↔ home), proven by a redirect-table unit test.

## Redirect contract (the pure decision table)

`String? redirect(AuthState s, DeviceClass d, String loc)` — inputs camelCase Dart;
returns a path or `null` (stay). The `AuthState` union is owned by `auth` and frozen as
a shared contract (`INV-CLIENT-STATE-2`): arms `unauthenticated · loading · error(message) ·
mfaRequired(firstLogin, mfaToken) · pickMembership(memberships) · authenticated(role, tenantId?, onboardingRequired)`.

| Auth state | Condition | Result |
|---|---|---|
| `loading` | cold-start restore in flight | `null` (splash); no redirect |
| `unauthenticated` | `loc` ∈ PUBLIC | `null` |
| `unauthenticated` | otherwise | `/login` |
| `error` | on an auth screen | `null` (screen shows message) |
| `mfaRequired(firstLogin)` | — | `firstLogin ? /mfa/enroll : /mfa` |
| `pickMembership` | — | `/select-workspace` |
| `authenticated(_, onboardingRequired:true)` | `loc` ∉ `/onboarding/*` | onboarding entry (`/onboarding/personal` or `/onboarding/customer` by role) |
| `authenticated(role, …)` | `loc` ∈ {`/login`,`/mfa`,`/mfa/enroll`,`/select-workspace`} | role home |
| `authenticated(role)` | `role` device-disallowed at `loc` | blocked-surface screen |
| `authenticated(platform_admin)` | — | `/web-handoff` interstitial |
| `authenticated` | `loc` allowed | `null` |

PUBLIC = {`/login`, `/forgot-password`, `/reset-password`, `/invite/accept`}.
**Role→home is the canonical `INV-CLIENT-ROUTE-2` map:** `interpreter→/idle` (incl.
tenant-less, `INV-CLIENT-AUTH-3`), `customer_user→/call`, **`customer_admin→/call`**,
`sub_admin|lsp_admin→/dispatch`, `platform_admin→/web-handoff`.
`onboardingRequired` is server-derived on the `authenticated` arm (set by `auth` from
membership/profile state); the onboarding gate is therefore inside the pure redirect,
not a side signal. Onboarding entry paths are owned by `onboarding`.
**Loop-safety (the blast radius):** the guard must let the user *stay* on `/mfa`,
`/select-workspace`, `/onboarding/*` (while `onboardingRequired`), and any entitled deep
route — it only redirects when `loc` contradicts the state. Forbidden: redirecting
`authenticated`→home while *on* home (returns `null`, not the home path) — returning the
same path loops `go_router`.

## Route tree (P1)

`/login`, `/forgot-password`, `/reset-password`, `/invite/accept`, `/mfa`,
`/mfa/enroll`, `/select-workspace`, `/web-handoff`; role shells `/idle`, `/call`,
`/dispatch` (children — `/idle/requests`, `/call/new`, `/dispatch/unassigned`, … — are
owned by their workstation features, registered as sub-routes). `/signup`,
`/verify-email`, and `/onboarding/personal` · `/onboarding/customer` are registered by
the `onboarding` feature (concrete paths owned there); router gates `/onboarding/*`
behind the `authenticated(onboardingRequired:true)` arm above. `/web-handoff` opens
`core-shell`'s `webAdminBaseUrl` externally.

## Affordance note

Device-gated routes are **removed/guarded, not merely disabled** so no feature renders
a navigational affordance (rail item, button) to a route the redirect would bounce —
features read `deviceClassProvider` to hide the affordance; router is the backstop.
Interpreter "Accept on mobile" is an **action-level** block inside `/idle`, not a route
gate — out of scope here.

**Navigation affordance vs stack (FM-CLIENT-4):** public auth and onboarding screens
expose back via **in-screen copy** (e.g. “← Back to sign in” using `go('/login')` or
route-appropriate `pop()`). Do not add app-level toolbar back that calls `GoRouter.pop`
on those flows — mixed `push` + `go` makes `canPop()` lie. Global chrome that needs
`GoRouter` must live in a root **`ShellRoute`**, not `CupertinoApp.router` `builder`
(FM-CLIENT-2/3).

## Non-goals

Auth logic + the `AuthState` machine (`auth`); `DeviceClass` derivation + the app root
(`core-shell`); screen/rail contents (workstation features); WSS (`realtime`). No
admin/back-office routes (`INV-CLIENT-ROUTE-1`) — only `/web-handoff`'s external link.

## Touches

`INV-CLIENT-STATE-1` (redirect = f(state)) / `INV-CLIENT-STATE-2` (consumes the `AuthState` contract), `INV-CLIENT-ROUTE-2` (canonical role→home map + `/select-workspace`), `INV-CLIENT-AUTH-3` (tenant-less → `/idle`), `INV-CLIENT-DEVICE-1` (route gating by `DeviceClass`), `INV-CLIENT-ROUTE-1` (no in-app back-office routes), `INV-CLIENT-AUTH-2` (`platform_admin` slug routing — no `superadmin`).

## Depends on

`core-shell` (`deviceClassProvider`, app root, theme, `webAdminBaseUrl` for `/web-handoff`) · `auth` (the `AuthState` union only — role, `tenantId?`, `onboardingRequired`). Router **owns** the `authNotifier → ChangeNotifier` bridge (`authRefreshListenableProvider`) and does **not** consume the raw access token. Workstation + `onboarding` features register their own sub-routes.

## Approach

`lib/core/router/app_router.dart` (`routerProvider` → `GoRouter` with `routes` +
`redirect`); root routes wrapped in a **`ShellRoute`** hosting
`DesktopWorkstationShell` (macOS window frame — FM-CLIENT-5); **do not** mount
GoRouter-dependent chrome in `CupertinoApp.builder` (FM-CLIENT-2). `lib/core/router/redirect.dart` (the pure decision function, unit-tested
against the table); `lib/core/providers/auth_refresh_listenable.dart` (bridges
`authNotifier` → `ChangeNotifier`). Workstation features expose a `List<RouteBase>`
each, composed in `app_router.dart`.

## Open questions / Out of scope

- **Onboarding gate — RESOLVED 2026-06-29:** the signal is `authenticated.onboardingRequired` (server-derived; `INV-CLIENT-STATE-2`), so the gate lives inside the pure redirect table (row added). Confirm the backend exposes onboarding-completeness in the token/`/auth/me` so `auth` can populate the flag.
- `platform_admin` landing — `/web-handoff` interstitial (opens `webAdminBaseUrl`) vs. immediate forced sign-out? (Product call.)
- Splash/loading UX during cold-start `loading` — dedicated route or an overlay on `/login`?
- Confirm device breakpoints with `core-shell`'s `DeviceClass` (shared source of truth).
