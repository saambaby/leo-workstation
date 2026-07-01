# 2026-07-01 — AL-T-02: MFA-enrollment QR + invite consent UI (`pin-14/mfa-qr-consent-ui`)

**Branch:** `pin-14/mfa-qr-consent-ui` (off `main`, post-AL-T-01) · **Tracker:** issue #14, PR #17 · **Trigger:** worker dispatch for `v0.0.1-alpha.1-auth-live` wave 2.

## TL;DR

Implemented the second (and final) task of the auth-live phase: finished the real
MFA-enrollment view that AL-T-01's contract rewrite made possible. Read the full
`features/auth.md` spec (D1–D7) and the taskgraph AL-T-02 row before touching
anything; confirmed AL-T-01 had already merged (`3fc83c0` on `main`) and had already
wired `InviteAcceptScreen`'s three consent checkboxes end-to-end (including
`Semantics` on `LeoCheckbox`) — verified this rather than assuming, made zero
changes to `reset_password_screen.dart`.

## What changed

- `pubspec.yaml`: added `qr_flutter: ^4.1.0` (D7, locked at taskgraph approval).
  Checked pub.dev's API directly for the current latest version/SDK constraint
  before pinning, rather than guessing a version.
- `mfa_screen.dart`: `MfaEnrollScreen` now renders a real `QrImageView` from
  `authUiProvider.otpauthUrl` and the manual key from `.mfaSecret`; deleted
  `_QrPlaceholder`, `_manualKey`, `_backupCodes`, and the entire backup-codes
  `LeoCard` block (grid + Download link + warning text).
- Also removed the dead "Use a backup code" link on the sibling `MfaScreen`
  (login-time MFA challenge screen) — not explicitly named in the task's file
  list, but directly required by spec AC-7 ("no UI path... renders backup
  codes"). Flagged this interpretation explicitly in the PR body for the
  reviewer in case they want it split into a separate change.
- `auth_strings.dart`: removed 4 now-unused backup-codes strings (grepped first
  to confirm no other references); added 2 new `Semantics`-label strings for
  the QR/manual-key affordances (`INV-CLIENT-A11Y-1`).

## Verification

`flutter pub get` (clean resolve) → `flutter analyze` (0 issues) → `flutter test`
(685/685 passing, no tests added per `INV-CLIENT-TEST-1`). No `@freezed`/
`@JsonSerializable` files touched, so no `build_runner` regen needed.

**Not done:** a real device/simulator smoke test (scan the QR with an actual
authenticator app) — no simulator available in this environment. Stated this
explicitly in the PR body rather than claiming visual verification.

## Rejected / considered

- Leaving the "Use a backup code" link on `MfaScreen` alone since it wasn't
  named in the task's explicit file-scope list — rejected because spec AC-7 is
  unambiguous and the link was already non-functional dead UI referencing a
  concept the backend doesn't support.
- Guessing a `qr_flutter` version — rejected in favor of querying
  `https://pub.dev/api/packages/qr_flutter` directly for the actual latest
  version and SDK constraint before pinning it in `pubspec.yaml`.

## Next action

PR #17 open against `main`, not merged — awaiting reviewer. If merged, this
closes out the `v0.0.1-alpha.1-auth-live` phase (2-task DAG, AL-T-01 → AL-T-02).
Remaining phase-adjacent open item: `INV-CLIENT-ROUTE-2`'s `/select-workspace`
clause still needs the doc amendment (tracked in `.pineapple/state.md`).
