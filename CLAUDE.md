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

- `lib/features/<name>/{data,domain,presentation}` — MVVM slices; wire DTOs in `data/dto/`, domain entities in `domain/<name>_entities.dart`
- `lib/core/network/` — `api_error.dart` (INV-ERROR-1 / `ApiErrorCode`), `api_response.dart` (`requireJsonMap`/`requireJsonList`; no `response.data!`)
- `flutter analyze` · `dart run build_runner build --delete-conflicting-outputs`
- **Tests:** do not add Flutter tests unless explicitly requested (`INV-CLIENT-TEST-1`)
- **State (INV-CLIENT-STATE-1…3):** freezed `<feature>_state.dart` + `<feature>_ui_state.dart` under `presentation/state/`; Notifier owns async/repo; co-locate `<feature>UiProvider` on the notifier file; screens watch the UI provider only; session nav via `redirect.dart` (not imperative `context.go` after login/onboarding). Ops modules OK for large notifiers. References: `features/auth/`, `features/onboarding/`. Detail: `.cursor/rules/state-management.mdc` · arch §1

## Pineapple

Close sessions with `/pineapple:context-update`. Tracker issues live in backend repo (`canonical_repo` in config).

## Autonomy

- **Proceed:** scaffold per `docs/release-plan.md`, run `flutter analyze`, fix lint in edited files.
- **Check in first:** product decisions, API contract changes, new dependencies, push/merge.
- **Do not add Flutter tests** unless the user asks (`INV-CLIENT-TEST-1`).
