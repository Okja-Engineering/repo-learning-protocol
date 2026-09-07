---
name: rlp-architect
description: Install, audit, and operate the Repository Learning Protocol (RLP) in any repository. Use when recurring agent mistakes reappear, when setting up a learning loop for coding agents, or when reviewing whether existing learnings are still firing. Provides scaffold, audit, and triage modes.
license: MIT
compatibility: POSIX shell (bash 3.2+ or zsh), git, and optional semgrep/pre-commit. No app-specific APIs required.
metadata:
  version: "0.2.0"
  spec: stages/02-protocol/references/repository-learning-protocol.md
---

# rlp-architect

Operate the Repository Learning Protocol in the current repository. RLP turns recurring agent corrections into durable artifacts at the strongest tier that can hold them: enforced check > regression test > scoped context > skill > discard.

## Modes

The user can invoke this skill with a mode argument. If they do not, ask which mode before acting.

- **scaffold** — install the RLP payload into the current repo
- **audit** — check the repo against RLP's five invariants
- **triage** — run the weekly triage session over the inbox

## scaffold

1. Read the bundled skill layout:
   - executable scripts in `scripts/`
   - reference docs and templates in `references/`
   - installable seed files in `assets/`
2. Copy the seed files into the repo root (or a chosen subdirectory such as `rlp/`):
   - `scripts/capture_learnings.sh` → `scripts/capture_learnings.sh`
   - `scripts/learning_health.sh` → `scripts/learning_health.sh`
   - `assets/inbox.md` → `docs/learnings/inbox.md`
   - `assets/decisions.md` → `docs/learnings/decisions.md`
   - `assets/semgrep/rules.yml` → `semgrep/rules.yml`
   - `assets/tests/*` → `tests/`
   - `assets/AGENTS.md.seed` → `AGENTS.md`
   - `assets/pre-commit-config.yaml.seed` → merge into `.pre-commit-config.yaml` if one exists
   - `references/0001-adopt-rlp.md` → `docs/adr/0001-adopt-rlp.md`
   - `references/example-rule.md` → `docs/knowledge/example-domain/example-rule.md`
   - `references/promote-learning.md` and `references/api-conventions.md` into the appropriate editor directory if it exists (`.devin/commands/` and `.devin/rules/`, `.cursor/commands/` and `.cursor/rules/`, `.claude/commands/` and `.claude/rules/`, etc.); otherwise place them under `docs/rlp-architect/` for manual use.
3. Make all `*.sh` files executable.
4. Run `tests/test_payload.sh` and confirm `0 failed`.
5. Report what was installed and the suggested first triage date.

## audit

1. Locate the installed RLP files:
   - `scripts/learning_health.sh`
   - `docs/learnings/inbox.md`
   - `docs/learnings/decisions.md`
   - `AGENTS.md`
   - any always-on context files referenced by `AGENTS.md`
2. Run `scripts/learning_health.sh -c` and capture the output.
3. Verify the five RLP acceptance tests:
   - **Repeat:** every promoted learning has a check that fires or a scoped context file that loads unprompted.
   - **Provenance:** every durable artifact traces to the correction that earned it (`date`, `source`, `owner`, `scope`, `verify_by`) or a `decisions.md` line.
   - **Deletion:** a single PR revert removes the learning.
   - **Budget:** always-on context is ≤ the declared budget and the health script reports it.
   - **Liveness:** every deterministic artifact has a recorded firing by its first prune.
4. Report pass/fail per invariant and list stale artifacts or budget overruns.

## triage

1. Run `scripts/learning_health.sh` to see recurrence counts and stale artifacts.
2. Read `docs/learnings/inbox.md`.
3. Apply the router to each candidate, in order:
   - security / data-corruption class → deterministic check + doc line, this week
   - first occurrence → stays in inbox
   - recurring (≥2) or expensive:
     1. mechanically checkable? → lint / Semgrep / CI check
     2. verifiable by execution? → regression test
     3. stable convention or "why"? → scoped rule / ADR / knowledge module
     4. reusable procedure? → skill / command note
     5. still uncertain? → stays in inbox with expiry; default outcome is deletion
4. Draft at most three promotion PRs. Each PR adds exactly one artifact plus the evidence that it fires.
5. Append every decision to `docs/learnings/decisions.md`:
   `- YYYY-MM-DD · <slug> · PROMOTED → stage NN / <paths> (PR) | DISCARDED — <reason> | HELD — <reason, expiry>`
6. Report decisions made and remaining inbox count.

## Constraints

- The inbox is read by triage, never loaded as agent context.
- Nothing is promoted without a human-merged PR.
- The default outcome of any candidate is deletion from the inbox.
- Always-on context stays under the declared budget; adding a line means deleting a line.
