# leo-workstation — Failure modes catalogue

> Guards installed by COE passes. Reviewer checks cite these IDs; specs cite them in
> component design / affordance clauses.

| ID | Pattern | Guard | Lives in |
|---|---|---|---|
| FM-CLIENT-1 | **Stretch-parent zero-height control** — `CupertinoButton(minimumSize: Size.zero)` (or equivalent) inside a `Column(crossAxisAlignment: stretch)` reports zero height; siblings paint on top of each other | Reviewer: any tappable in a stretch column must have explicit min height or non-zero intrinsic size; prefer `GestureDetector` + padding for custom checkboxes | reviewer · auth design widgets |
| FM-CLIENT-2 | **GoRouter context boundary** — `GoRouter.of(context)` in `CupertinoApp.router` `builder` runs above the inherited router → assert at runtime | Spec + reviewer: app chrome that needs `GoRouter` must mount in a root `ShellRoute`, not `CupertinoApp.builder`; pass `GoRouter` by constructor only when outside `ShellRoute` | [`features/router.md`](features/router.md) · reviewer |
| FM-CLIENT-3 | **Delegate notify during build** — `ListenableBuilder` on `GoRouterDelegate` during cold-start route restore triggers `setState()` while building | Reviewer: forbid listening to `GoRouterDelegate` from widgets that wrap the initial router mount; rely on `ShellRoute` rebuilds instead | reviewer · FM-CLIENT-2 |
| FM-CLIENT-4 | **canPop ≠ safe pop** — mixed `push` + `go` on auth flows leaves `canPop() == true` after `go('/login')` but `pop()` throws | Spec affordance clause: auth/onboarding surfaces use in-screen “Back to sign in” links; macOS window frame does **not** expose a global back control on public auth routes | [`features/router.md`](features/router.md) · [`features/core-shell.md`](features/core-shell.md) |
| FM-CLIENT-5 | **Platform shell vs workstation shell** — two layout layers confused (`DesktopWorkstationShell` window frame vs `WorkstationScaffold` role chrome) | Spec: document both in core-shell; window frame = macOS-only traffic-light inset; scaffold = logged-in rail/header | [`features/core-shell.md`](features/core-shell.md) |
| FM-CLIENT-6 | **Form row alignment** — OTP / labeled rows centered when design is start-aligned | Reviewer: labeled input rows in auth/onboarding use `MainAxisAlignment.start` and fixed cell sizes where spec shows left-aligned grids | reviewer · onboarding widgets |

_Pineapple catalogue patterns (shared):_

| # | Pattern | Guard |
|---|---|---|
| 1 | Tests mock at wrong boundary | Anti-tautology check · reviewer |
| 3 | Code shipped but unreachable | Reachability check · reviewer |
| 4 | Spec ambiguity → over-restrictive affordance | Affordance-vs-input-surface clause · spec user flow |

---

## Ratchet log

| Date | Phase / session | Bugs → new guards |
|---|---|---|
| 2026-06-30 | P1 shell + P2 onboarding acceptance walk | FM-CLIENT-1 … FM-CLIENT-6 installed (see [`phases/v0.0.1-alpha.1-coe.md`](phases/v0.0.1-alpha.1-coe.md)) |
