# leo-workstation — Architecture (as-built)

_Reverse-engineered 2026-06-29 via `/pineapple:ongoing`._

> **As-built ≠ target.** The full target architecture (MVVM, Riverpod wiring,
> routing, media, security) is [`docs/architecture-overview.md`](../docs/architecture-overview.md).
> This file records the **current** structure only.

## Current structure

```
lib/main.dart   # the entire app
```

- Entry point: `main()` → `runApp(LeoWorkstationApp)`.
- `LeoWorkstationApp` → `CupertinoApp(home: WorkstationShell())`.
- `WorkstationShell` → `CupertinoPageScaffold` with a placeholder body.

**No** `ProviderScope`, router, network layer, feature slices, or state
management is present. Dependencies: `flutter`, `cupertino_icons` only.

## Gap to target

| Target capability (docs §) | As-built |
|---|---|
| Feature-first MVVM + repository (§1) | Absent — no `features/`, no `core/`. |
| Riverpod provider graph (§3) | Absent — no `flutter_riverpod` dependency. |
| `go_router` role redirect (§4) | Absent — `home:` static widget. |
| Auth + secure token storage (§5, §7) | Absent. |
| WSS realtime gateway (§6) | Absent. |
| Cupertino theme light/dark/night (§8) | Partial — `CupertinoApp` only, no theme data. |

The next phase ([`phases/v0.0.1-alpha.1.md`](phases/v0.0.1-alpha.1.md)) builds
the first real slice of the target architecture.
