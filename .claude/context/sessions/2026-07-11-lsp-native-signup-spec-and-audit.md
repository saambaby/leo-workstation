# 2026-07-11 — LSP native signup spec + cross-spec-audit reconciliation

**Branch:** `feat/auth-state-refactor` · **Trigger:** `/pineapple:feature-spec .pineapple/features/lsp-native-signup.md` → `/pineapple:cross-spec-audit` → manual reconciliation → `/pineapple:context-update`

## What happened

1. Authored `.pineapple/features/lsp-native-signup.md` as a proper Phase-4a spec (from a pre-existing informal "Plan" doc) — lets LSP operators sign up in-app (picker → details → OTP verify → MFA enroll → `/dispatch`) instead of being bounced to `leo-web`. No backend changes; reuses `leo-api` alpha.4+'s existing `business_type: 'lsp'` union arm.
2. Ran the `pineapple-consistency-checker` sub-agent against the phase doc + `core-shell.md`/`auth.md`/`router.md`/`onboarding.md`/`otp-email-verification.md`/`lsp-native-signup.md`/`invariants-client.md`. Result: **5 DRIFT, 3 AMBIGUOUS, 3 OPEN** — the new spec contradicted four pre-existing docs that assumed LSP signup stays external forever.
3. User chose to reconcile immediately (not defer). Fixed all 5 DRIFT + 2 of 3 AMBIGUOUS by amending `invariants-client.md`, `phases/v0.0.1-p2-onboarding.md`, `onboarding.md`, `otp-email-verification.md`, and `lsp-native-signup.md` itself. Left the third AMBIGUOUS (fold-vs-separate-pass scheduling) explicitly open — it's a founder call, not a doc-consistency bug, and the spec/phase doc now both say so instead of asserting an answer.

## Root cause of the drift (worth remembering)

`onboarding.md`'s LSP exclusion was written once, in prose, in five different places (Summary, AC1, KD1, Non-goals, wire contract) instead of being delegated to a single invariant. When the LSP-signup decision changed, all five needed independent edits, and the informal artifact names used in `onboarding.md`'s "User flow & affordances" section (`opt-card`, `a-signup`) didn't match the concrete class names (`SignupTypeScreen`, `SignupPath`, etc.) that the new delta spec cited for reuse — so cross-spec verification couldn't even confirm the reuse claim without reading code. Fixed by naming the concrete artifacts in `onboarding.md` directly.

## Decisions

- **`INV-CLIENT-ROUTE-1` narrowed**, not replaced: LSP *onboarding* (languages/partners/pricing) and back-office stay `leo-web`-only; LSP *signup* is in-app as of this delta.
- **New `INV-CLIENT-CONSENT-1` promoted**: client-side consent gate before submit — was independently restated in `auth.md`, `onboarding.md`, `lsp-native-signup.md` with no shared invariant backing it.
- **Scheduling of `lsp-native-signup` left open** — fold into `v0.0.1-p2-onboarding` before it closes, or ship as a separate pass after. Not decided this session.

## Files touched (`.pineapple/` only — no `lib/` code this session)

`features/lsp-native-signup.md` (new), `features/onboarding.md`, `features/otp-email-verification.md`, `features/INDEX.md`, `invariants-client.md`, `phases/v0.0.1-p2-onboarding.md`, `cross-spec-audit.md` (addendum), `state.md`.

## Next step

Founder decision on `lsp-native-signup` scheduling, then `/pineapple:orchestrate` (either folded into the running `v0.0.1-p2-onboarding` taskgraph or a new one). Remaining spec loop unchanged: `realtime`, `interpreter-workstation`, `customer-call`, `dispatch-portal`.
