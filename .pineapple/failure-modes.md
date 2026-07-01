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

## Orchestration & process (coordinator's own git/merge behavior, not shipped code)

| ID | Pattern | Guard | Lives in |
|---|---|---|---|
| FM-PROCESS-1 | **Local/origin `main` divergence silently widens PR scope** — coordinator commits land on local `main` but are never pushed; branching a task off that ahead-of-origin `main` and opening a PR makes GitHub diff against the real (older) `origin/main`, bundling unrelated prior commits into the reviewed/merged PR without anyone noticing | Before cutting any task branch: verify local `main` == `origin/main` (fetch + compare); push local `main` first if it's ahead. Reviewer diffs the actual remote PR (`gh pr diff <N>`), never local `git diff main...branch`, since local `main` can silently differ from `origin/main` | orchestrate Phase A precondition · reviewer check · [`config.yml`](config.yml) |
| FM-PROCESS-2 | **Coordinator autonomy exceeds environment trust boundary** — the coordinator pushes bookkeeping directly to `main`, or attempts to self-merge a PR right after only a self-spawned review, because the orchestrate skill's prose describes that as the normal autonomous flow | This project requires human approval for every merge and never allows the coordinator to push directly to `main` — not even for `.pineapple/` bookkeeping. Every coordinator-authored change, however trivial, goes through a branch + PR like a worker's would | [`config.yml`](config.yml) · orchestrate dispatch loop (per-project override) |

_See [`phases/v0.0.1-alpha.1-auth-live-coe.md`](phases/v0.0.1-alpha.1-auth-live-coe.md) for the incidents that produced these._

---

## Ratchet log

| Date | Phase / session | Bugs → new guards |
|---|---|---|
| 2026-06-30 | P1 shell + P2 onboarding acceptance walk | FM-CLIENT-1 … FM-CLIENT-6 installed (see [`phases/v0.0.1-alpha.1-coe.md`](phases/v0.0.1-alpha.1-coe.md)) |
| 2026-07-01 | `v0.0.1-alpha.1-auth-live` acceptance walk (PRs #15–#18) | FM-PROCESS-1, FM-PROCESS-2 installed (see [`phases/v0.0.1-alpha.1-auth-live-coe.md`](phases/v0.0.1-alpha.1-auth-live-coe.md)) |
