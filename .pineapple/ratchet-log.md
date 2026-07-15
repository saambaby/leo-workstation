# Ratchet Log

The dated record of guards installed in response to escaped bugs. This is how
the method *compounds*: every bug that reached a human becomes a permanent
guard, so the next phase inherits a stronger net. Appended by `/pineapple:coe`
at phase close; never rewritten.

Each entry: the bug, the class `/pineapple:coe` assigned, which guard would have
caught it upstream, and where the guard now lives. If a bug matched an existing
pattern whose guard was simply not installed here, note that too — the ratchet
is as much about *installing* known guards as inventing new ones.

---

## 2026-07-12 · Phase `v0.0.1-p2-onboarding-lsp`

- **Bug:** First `cursor-agent --worktree "pin-31/signup-lsp-wire"` failed immediately (`Invalid --worktree name` — `/` forbidden). Branch format `pin-{issue}/{slug}` is legal for git refs but illegal for Cursor worktree folder names → wasted dispatch + re-dispatch.
- **Class:** env / worker-error (host CLI constraint)
- **Guard that would have caught it:** Orchestrate Cursor dispatch path must sanitize worktree names (replace `/` with `-`) while keeping the slash form only for the git branch / PR head.
- **Installed:** `FM-PROCESS-3` in `.pineapple/failure-modes.md` · this log · orchestrate Cursor dispatch note (sanitize worktree name ≠ branch name)
- **Alarm (if any):** none — caught before any bad code landed; process friction only.

- **Bug:** First successful worktree create + `cursor-agent -p … --output-format json` under `nohup` exited in seconds with only `Using worktree: …` and no implementation (PID gone, empty JSON). Required a second dispatch with `--workspace <existing-worktree>` + `--output-format text`.
- **Class:** flake / env (agent CLI invocation)
- **Guard that would have caught it:** After dispatch, require a liveness check within ~30s (worktree dirty OR agent still running OR non-trivial stdout). Treat “Using worktree” alone as failed start → re-dispatch before marking `task_dispatched` healthy.
- **Installed:** `FM-PROCESS-4` in `.pineapple/failure-modes.md` · this log
- **Alarm (if any):** none — no bad merge; operator/coordinator noticed via empty PR list.

- **Bug:** Taskgraph `owns` for LSP-T-01 omitted `onboarding_routes.dart`, which must parse `path=lsp` when `verifyEmailLocation` emits it. Work-order compile patched owns; taskgraph YAML was never amended → Gate 2 / ownership projection drifted from executable truth.
- **Class:** spec-drift (taskgraph incompleteness)
- **Guard that would have caught it:** Workorders compile stranger-test + “round-trip any new enum/query value” checklist; after compile, sync taskgraph `owns` when work order expands it (or fail Gate 2 until YAML matches).
- **Installed:** `FM-PROCESS-5` in `.pineapple/failure-modes.md` · this log · noted on future `/pineapple:workorders` owns-gap report
- **Alarm (if any):** assembly-check *did* catch the route mapping once code landed — good. The miss was earlier (taskgraph owns), not at assembly.

- **Bug:** Ledger projection showed tasks as `done` after `reviewer_skipped` / custom `task_awaiting_human_merge` while `commit` was still null and PR unmerged — confusing “done” vs “awaiting human merge” for wave gating.
- **Class:** process / tooling semantics
- **Guard that would have caught it:** Only emit `merge` after `gh pr view` reports `MERGED`; do not treat `reviewer_skipped` as terminal. Prefer a single explicit parked state until human merge.
- **Installed:** operational note under `FM-PROCESS-2` companion (human-merge park) in failure-modes · this log — no new ID; reinforce existing merge_requires_human_approval flow
- **Alarm (if any):** Upstream “done” signalling is theatre if humans must still merge — keep ledger `merged` as the only wave-advance signal (this phase recovered by waiting on human merge before T-02/T-03).

Ledger `coe` fold for this phase: **0** classified `task_failed` / stall / lease / assembly-fail / budget events. Escapes were process/host, not product defects in merged code. Final assembly-check: all pass. LSP-T-03 E2E consciously deferred (not a guard failure).
