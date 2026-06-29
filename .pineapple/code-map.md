# leo-workstation — Code map

_As-built file/dir guide. Updated 2026-06-29._

> Where things **are** today (mostly empty — pre-P1) and where they **will go**
> per [`docs/architecture-overview.md`](../docs/architecture-overview.md) §2.

## As-built (on disk)

```
lib/
  main.dart            # CupertinoApp -> WorkstationShell placeholder (the entire app today)
test/                  # default scaffold test
pubspec.yaml           # flutter, cupertino_icons, flutter_lints only
analysis_options.yaml  # flutter_lints
```

Platform folders (`android/ ios/ macos/ linux/ windows/ web/`) are the default
Flutter scaffold.

## Target layout (per architecture-overview §2)

```
lib/
  main.dart                  # ProviderScope + runApp(LeoApp)
  app.dart                   # CupertinoApp.router, theme, watches authNotifier
  core/
    config/    app_config.dart          # apiBaseUrl, realtimeWsUrl (env-scoped)
    network/   dio_provider.dart         # Dio + Bearer interceptor (+ cert pin)
    router/    app_router.dart           # go_router + auth redirect guard
    theme/     app_theme.dart            # Cupertino light/dark/night
    providers/ auth_refresh_listenable.dart
  features/<name>/            # one vertical slice each:
    data/                     # repositories, token storage (only layer that knows the wire)
    domain/                   # freezed + json models
    presentation/{screens,widgets,notifiers,state}
```

Per-feature targets and backend deps: architecture-overview §11.
**Not in this repo:** admin reports / user CRUD / rate cards (→ `leo-web`, INV-CLIENT-ROUTE-1).

## Doc & artifact map

| Artifact | Path |
|---|---|
| Implementation driver | `docs/release-plan.md` |
| Target architecture | `docs/architecture-overview.md` |
| Client map (roles/routes/devices) | `docs/client-map.md` |
| Client product spec | `docs/product-spec.md` |
| Platform links (canonical in leo-api) | `docs/platform-references.md` |
| Client invariants | `.pineapple/invariants-client.md` |
| As-built state | `.pineapple/state.md` |
| Phases | `.pineapple/phases/` |
| Feature specs | `.pineapple/features/` |
