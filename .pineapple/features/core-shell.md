# Feature: core-shell

**Status:** Drafted · **Phase:** P1 / `v0.0.1-alpha.1` · **Owner:** client

## Summary

The application foundation every other feature mounts onto: app bootstrap
(`ProviderScope` + `CupertinoApp.router`), environment config, the Cupertino theme
(light/dark/**night**) mapped from the design tokens, the `DeviceClass` helper, the
shared `dio` HTTP client (Bearer + cert-pin), secure token storage, and the shared
**workstation chrome** (header with active-tenant chip + avatar menu mount, and the
LSP-admin → `leo-web` external link). It owns no business flow — it provides the
primitives `auth`, `router`, `realtime`, and every workstation slice consume
(`INV-CLIENT-CONTRACT-1`). The workstation surface is **dark by default**; the same
auth screens render light in `leo-web`.

## User-facing behaviour

On launch the app boots into the Cupertino theme and the router's initial location.
Once authenticated, role workstations render inside the shared chrome: a left rail
(role-specific items, owned by each feature) + a header carrying the **active-tenant
chip** (e.g. "Acme Language Services · LSP Admin") and an avatar. Night mode is
app-wide, persisted, and available to all roles. On a device class a surface isn't
entitled to, routes are absent (gating enforced by `router`, derived here).

## User flow & affordances

- **Boot:** `main()` → `ProviderScope` → `LeoApp` (`CupertinoApp.router`) → theme +
  router resolve → initial route. No business logic in the widget tree root.
- **Active-tenant chip + avatar:** *affordance* = the tenant chip and avatar glyph in
  the header; *input surface* = the **avatar is the tap target** that opens the
  workspace menu (the `auth`/switch-tenant feature owns the menu contents); the chip
  itself is a status label, not interactive.
- **Admin-dashboard link:** *affordance* = an "Admin dashboard" item in the rail
  footer; *input surface* = the full row is tappable and opens the configured
  `leo-web` URL in an external browser (`url_launcher`). Shown **only** to
  `lsp_admin`; hidden (not merely disabled) for all other roles and while the
  `leo-web` URL is unset.

## Acceptance criteria

1. `main()` wraps the app in `ProviderScope`; `LeoApp` builds a `CupertinoApp.router` using the theme + router providers; `flutter analyze` is clean and the app boots to the router's initial location.
2. `appConfigProvider` exposes `apiBaseUrl`, `realtimeWsUrl`, and `webAdminBaseUrl?` from `.env` (loaded at startup via `flutter_dotenv`).
3. The theme provides **light, dark, and night** `CupertinoThemeData` variants mapped from the design tokens; the workstation defaults to **dark**; the chosen brightness is persisted and restored on next launch.
4. `deviceClassProvider` derives `DeviceClass { desktop, tablet, smartphone }` from `MediaQuery` (documented short-side breakpoints) and updates on resize/rotation.
5. `dioProvider` returns a `Dio` (baseUrl from config) whose request interceptor injects `Authorization: Bearer <access>` from the in-memory token seam, and whose `badCertificateCallback` enforces SHA-256 pin(s) with a rotation list; a pin mismatch fails the request (`INV-CLIENT-NET-1`).
6. `tokenStorageProvider` reads/writes/clears the refresh token in `flutter_secure_storage` only; it is never written to logs/metrics (`INV-CLIENT-AUTH-1`, `INV-CLIENT-PHI-1`).
7. The shared chrome renders the header (tenant chip + avatar mount) and exposes the rail-footer "Admin dashboard" external link **only** for `lsp_admin`, hidden until `webAdminBaseUrl` is set.
8. **macOS window frame (FM-CLIENT-5):** on macOS, the system title bar is hidden; `DesktopWorkstationShell` (root `ShellRoute`) reserves traffic-light inset only — **not** a global back control. Auth/onboarding back navigation uses in-screen links (“Back to sign in”), never toolbar `pop()` (FM-CLIENT-4). `WorkstationScaffold` is the **logged-in** rail/header layout and is unrelated to the macOS window frame.

## Wire-format contract

- **`AppConfig`** is loaded from `.env` at startup (`flutter_dotenv`). Copy `.env.template` → `.env` for local dev. No runtime mutation; it's a `Provider<AppConfig>` of an immutable struct. **`webAdminBaseUrl` is the single source** for both the `lsp_admin` "Admin dashboard" link (here) and `router`'s `platform_admin` `/web-handoff` interstitial.
- **Bearer seam (`INV-CLIENT-AUTH-4`, avoids a circular dep):** `dioProvider`'s interceptor **reads** `currentAccessTokenProvider` (in-memory holder, default `null`); core-shell defines the holder + interceptor but never writes it — **`auth` (`AuthNotifier`) is the sole writer**. Header is exactly `Authorization: Bearer <token>` when non-null, omitted otherwise.
- **Theme tokens:** design CSS custom properties (`--black-900 #0A0A0B` … `--signal-live #22C55E`, `--signal-white #F8F8FA`) map to `Color(0xFF…)` constants; spacing/radius tokens (`--r-md` etc.) to `double`s. Owner: `app_theme.dart`. Night ≠ dark — night is a separate, dimmer variant, not a brightness toggle.
- **Cert pin:** SHA-256 base64 pin list compiled in (or from config); `badCertificateCallback` returns `true` only on a pin match.

## Non-goals

Auth/login/MFA/token-refresh logic (`auth`); the `GoRouter` instance + redirect rules
+ device route-gating logic (`router`); WSS connection (`realtime`); per-role rail
*contents* and workstation screens (each workstation feature). No admin/back-office
routes (`INV-CLIENT-ROUTE-1`). The workspace-switcher menu contents belong to `auth`.

## Touches

`INV-CLIENT-ARCH-1/2` (provides the layered primitives; defines no feature data), `INV-CLIENT-UI-1` (Cupertino theme), `INV-CLIENT-A11Y-1` (night mode app-wide; semantics baked into chrome), `INV-CLIENT-I18N-1` (chrome copy via `intl`), `INV-CLIENT-NET-1` (cert-pinned `dio`), `INV-CLIENT-AUTH-1` (token storage) / `INV-CLIENT-AUTH-4` (defines the `currentAccessTokenProvider` holder + interceptor; auth writes it), `INV-CLIENT-DEVICE-1` (provides `DeviceClass`), `INV-CLIENT-ROUTE-1` (the only back-office touchpoint is the external link), `INV-CLIENT-CONTRACT-1`.

## Depends on

New deps: `flutter_riverpod`, `dio`, `flutter_secure_storage`, `url_launcher`, `cupertino_icons`. No backend dependency (config + transport only). Consumed by `auth`, `router`, `realtime`, and every workstation feature.

## Approach

`lib/main.dart` (ProviderScope) + `lib/app.dart` (`LeoApp`). `lib/core/config/app_config.dart`; `core/network/dio_provider.dart` + `currentAccessTokenProvider`; `core/theme/app_theme.dart` (token constants + 3 `CupertinoThemeData` + persisted brightness via secure-storage/prefs); `core/device/device_class.dart` + `deviceClassProvider`; `core/storage/token_storage.dart`; `core/shell/workstation_scaffold.dart` (header + rail slots + tenant chip + admin link). Cert pinning belongs at `dioProvider`.

## Open questions / Out of scope

- **Cert-pin blast radius:** pinning **blocks** local dev against a self-signed/proxy host (Charles/Proxyman) and any non-pinned env. Dev escape hatch: pinning disabled in debug builds (`kDebugMode`) when no pins are configured — must never ship enabled-bypass in release.
- Brightness persistence store — reuse `flutter_secure_storage` or add `shared_preferences`? (theme choice is non-sensitive; prefs is lighter.)
- Exact `DeviceClass` breakpoints (tablet vs desktop short-side px) — confirm against `client-map` device matrix.
- `webAdminBaseUrl` source — `.env` for now, or fetched per-tenant from the API later?
