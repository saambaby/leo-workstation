# leo-workstation — Documentation

One Flutter app, **three ops workstations** (interpreter · customer · dispatcher), role-routed after login (BD1 · BD7). LSP back-office → **web admin app** (separate repo).

## Canonical (this repo)

| Doc | Answers |
|---|---|
| [`release-plan.md`](./release-plan.md) | **When** — P1→GA build sequence, DoD, API deps |
| [`client-map.md`](./client-map.md) | **Which surface** — roles, routes, devices, journeys |
| [`architecture-overview.md`](./architecture-overview.md) | **How** — MVVM, Riverpod, navigation, media, security |
| [`product-spec.md`](./product-spec.md) | **Why** — client-scoped what/why |
| [`../.pineapple/features/INDEX.md`](../.pineapple/features/INDEX.md) | **What** — feature slice specs (Pineapple `features_dir`) |
| [`release-checklists.md`](./release-checklists.md) | **Gates** — Flutter (+ web admin) cut-the-release checks |
| [`repo-map.md`](./repo-map.md) | **Where** — this repo in the platform |

## Platform (linked — canonical in `leo-api`, never copied)

Platform architecture, product rules, decisions, and version sequencing live in the
sibling backend repo. They are **linked, not copied** — see
[`platform-references.md`](./platform-references.md) for the full pointer table and
citation conventions (`arch §N`, `ps §N`, `BD*`, `INV-*`).

## Pineapple

| Artifact | Path |
|---|---|
| Config | [`../.pineapple/config.yml`](../.pineapple/config.yml) |
| Current phase | [`../.pineapple/phases/INDEX.md`](../.pineapple/phases/INDEX.md) |
| As-built state | [`../.pineapple/state.md`](../.pineapple/state.md) |
| Client invariants | [`../.pineapple/invariants-client.md`](../.pineapple/invariants-client.md) |
| Code map | [`../.pineapple/code-map.md`](../.pineapple/code-map.md) |
