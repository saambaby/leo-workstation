# leo-workstation

> Thin index — map, not territory. Keep under ~500 lines.

## Stack

Dart 3 · Flutter (Cupertino) · Riverpod · go_router · dio · Vonage (P2)

## Where things live

- **Docs index** — `docs/README.md`
- **Release plan** — `docs/release-plan.md` (canonical client roadmap)
- **Client map** — `docs/client-map.md`
- **Client product spec** — `docs/product-spec.md`
- **Architecture** — `docs/architecture-overview.md`
- **Feature specs** — `.pineapple/features/INDEX.md`
- **Release gates** — `docs/release-checklists.md`
- **Platform references** — `docs/platform-references.md` (links to `../leo-api`; never copy platform docs)
- **Pineapple** — `.pineapple/config.yml`, `.pineapple/phases/INDEX.md`, `.pineapple/state.md`
- **Client invariants** — `.pineapple/invariants-client.md`

## Conventions

- `lib/features/<name>/{data,domain,presentation}` — MVVM slices
- `flutter analyze` · `dart run build_runner build --delete-conflicting-outputs`
- **Tests:** do not add Flutter tests unless explicitly requested (`INV-CLIENT-TEST-1`)
- **State:** async in notifiers + derived `<feature>_ui_provider`; see arch §1 checklist

## Pineapple

Close sessions with `/pineapple:context-update`. Tracker issues live in backend repo (`canonical_repo` in config).

## Autonomy

- **Proceed:** scaffold per `docs/release-plan.md`, run `flutter analyze`, fix lint in edited files.
- **Check in first:** product decisions, API contract changes, new dependencies, push/merge.
- **Do not add Flutter tests** unless the user asks (`INV-CLIENT-TEST-1`).
