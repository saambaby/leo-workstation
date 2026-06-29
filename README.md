# leo-workstation

Flutter **realtime ops client** for **Leo (Leoconnexio)** — one app, three role-routed workstations (interpreter, customer, dispatcher).

## Docs

| Doc | Purpose |
|---|---|
| [`docs/release-plan.md`](docs/release-plan.md) | Client build plan (P1→GA) |
| [`docs/client-map.md`](docs/client-map.md) | Roles, routes, devices |
| [`.pineapple/features/INDEX.md`](.pineapple/features/INDEX.md) | Feature specs |
| [`docs/architecture-overview.md`](docs/architecture-overview.md) | MVVM + Riverpod architecture |

Platform product/architecture: **linked** (not copied) via [`docs/platform-references.md`](docs/platform-references.md) → `../leo-api`. Index: [`docs/README.md`](docs/README.md).

## Stack

Flutter · Riverpod · go_router · dio · freezed · Vonage (P2)

## Develop

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d macos
```
# leo-workstation
