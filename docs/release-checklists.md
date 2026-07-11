# leo-workstation — Release checklists

> Cut-the-release gates for **this repo** (Flutter ops client). Platform-wide D*/L* gates: [`platform-references.md`](./platform-references.md) → `../leo-api/docs/release-checklists.md`. Feature scope: [`release-plan.md`](./release-plan.md).

---

## Universal gate (every tag)

### Shared with platform

All **Shared (all repos)** items in `../leo-api/docs/release-checklists.md` (via [`platform-references.md`](./platform-references.md)) apply (CI green, no secrets, no PHI leak, SBOM, SAST, changelog, staging smoke).

### Flutter ops client (`leo-workstation`)

- [ ] **`flutter analyze` clean** — zero errors/warnings at gating level.
- [ ] **`flutter test` green** — unit + widget tests for touched features.
- [ ] **Certificate pinning verified** — pinned API cert (SHA-256); connection refused on mismatch (D6 / D13).
- [ ] **Secure storage verified** — refresh token in `flutter_secure_storage` only (D6).
- [ ] **Accessibility / semantics smoke** — semantics labels on touched screens; contrast check (ps §15, L3).
- [ ] **Signed build per shipped target** — desktop/mobile per version roadmap.
- [ ] **i18n lint** — no hardcoded user-facing strings (`intl` / `flutter_localizations`).
- [ ] **No admin CRUD routes** — no Flutter `/admin/users`, `/admin/reports` (BD7 / INV-CLIENT-ROUTE-1).

---

## Web admin app gates (from P2 — separate repo)

When tagging the **web admin app** (not this repo), also verify:

- [ ] **`next build` clean**
- [ ] **CSP + HSTS** (D6)
- [ ] **Auth handoff** from Flutter dashboard link (or standalone web login)
- [ ] **RBAC route guards** — `sub_admin` cannot reach back-office

---

## Per-version gates

### `v0.0.1-alpha.1` — P1 app shell

- [ ] Login → role home (`/idle`, `/call`, or `/dispatch`)
- [ ] WSS `notification.push` received on connect
- [ ] Customer routes **blocked on smartphone** (`DeviceClass`)
- [ ] LSP Admin dashboard link configured (may open stub URL)

### `v0.0.1-alpha.4` — Auth contract (client subset)

- [ ] Single-membership login → correct role home (server auto-picks active tenant)
- [ ] Tenant-less interpreter login → `/idle` without error
- [ ] MFA enroll/challenge for privileged roles (login resubmit + `/auth/mfa/enroll`)
- [ ] JWT handling uses `platform_admin` slug (no `superadmin` in code or docs)
- [ ] `platform_admin` session rejected in workstation (use `leo-web`)
- [ ] All alpha.1 app-shell gates still pass

> **Deferred:** multi-membership picker + `switch-tenant` UI — no memberships-list
> endpoint (`features/auth.md` D1/D2). Revisit when `leo-api` adds self-scoped
> memberships list.

### `v0.0.1` — P2 MVP

- [ ] Desktop E2E: customer request → interpreter accept → Vonage → complete
- [ ] Dispatch queue live via WSS
- [ ] Accept race 409 handled
- [ ] Vonage reconnect same session id
- [ ] No PHI persisted on device after sign-off

### `v0.1.0` — P3

- [ ] Customer smartphone `/call` enabled
- [ ] `sub_admin` vs `lsp_admin` routing
- [ ] OPI / multi-party UI smoke (per release-plan DoD)

---

*Platform gates and sign-off matrix: `../leo-api/docs/release-checklists.md` (via [`platform-references.md`](./platform-references.md)).*
