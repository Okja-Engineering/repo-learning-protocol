---
name: rlp
description: Wire, audit, migrate, and operate the Repository Learning Protocol (RLP) in any repository. Use when recurring agent corrections should become enforced checks, regression tests, scoped context, or repo-specific procedures without growing always-on context. Provides scaffold, audit, triage, and migration guidance.
license: MIT
compatibility: POSIX shell (bash 3.2+ or zsh), git, and optional semgrep/pre-commit. No app-specific APIs required.
metadata:
  version: "0.3.0"
  # Canonical RLP spec lives in the source repository at
  # https://github.com/Okja-Engineering/repo-learning-protocol/blob/main/stages/02-protocol/references/repository-learning-protocol.md
---

# rlp

Turn recurring corrections into the strongest durable tier that can hold them: enforced check > regression test > scoped context > skill > discard.

RLP is a generalized plugin, not repository content. Install or update it globally with `devin plugins install Okja-Engineering/repo-learning-protocol` and `devin plugins update rlp-architect`, or install the skill globally at `~/.config/devin/skills/rlp/`. Never copy this bundle into a project's `.devin/skills/`; project skills are only for repository-specific procedures.

## Modes

If the user did not specify a mode, ask before acting.

- **scaffold** — add minimal, project-specific RLP wiring
- **audit** — check promoted learnings against the five invariants
- **triage** — route candidates and draft promotions
- **migrate** — move a legacy learning system through normal triage

## scaffold

Scaffold remains an invocation mode because repositories need wiring, but it does not install the skill payload.

1. Discover before proposing writes:
   - inspect `AGENTS.md`, `CONTEXT.md`, editor pointers, `.devin/`, `.claude/`, `.cursor/`, `stages/*/CONTEXT.md`, existing learning logs, tests, CI, linters, and Semgrep configuration;
   - classify the repo as an existing staged workspace, another routed workspace, or no router.
2. Present the discovered structure and exact proposed file changes. Ask the user which editor directory to wire (`.devin/`, `.claude/`, `.cursor/`, or another location). Do not infer it from an installed tool.
3. Ask for approval before writing.
4. Create only missing project wiring:
   - `docs/learnings/inbox.md` and `docs/learnings/decisions.md`;
   - repo-local copies of `scripts/capture_learnings.sh` and `scripts/learning_health.sh` when CI or local commands need them;
   - `docs/rlp-architect/templates/`, copied from bundled `templates/`, as inert starters for manual use during promotion;
   - an editor command note that invokes the global/plugin skill, if approved;
   - CI or pre-commit wiring only when the repository already uses that mechanism or the user approves adding it.
5. Preserve existing architecture:
   - merge a short RLP route into an existing `AGENTS.md` or root router; never replace the file;
   - if stage contracts exist, point each promoted artifact from the relevant existing `stages/*/CONTEXT.md`;
   - do not create an RLP stage in an existing staged workspace;
   - only when no router or staged workspace exists, propose a minimal root router and copy the bundled `assets/stages/00-learn/CONTEXT.md` to `stages/00-learn/CONTEXT.md`.
6. Make the operation idempotent: compare content before writing, preserve user text, do not duplicate routes, and report unchanged files.
7. Never copy an unfilled template into an active artifact path such as `docs/knowledge/`, `.devin/rules/`, or `semgrep/rules.yml`. Templates are not promotions.

## audit

1. Locate the inbox, decisions log, health command, existing stage contracts, and real promoted artifacts.
2. Exclude everything under a `templates/` directory and anything explicitly marked `TEMPLATE`. Placeholders do not satisfy an invariant.
3. Pass only the always-on files to `learning_health.sh --always`: root routers (`AGENTS.md` or equivalent), editor pointers such as `CLAUDE.md`, and global/always-apply rules. ADRs, knowledge modules, Semgrep rules, tests, and skills are scoped and do not count toward the default 1,500-token budget.
4. Verify each real promotion:
   - **Repeat:** its check fires or its scoped context loads from the relevant contract/trigger.
   - **Provenance:** it carries `date`, `source`, `owner`, `scope`, and `verify_by`, or traces in one hop through the decisions log.
   - **Deletion:** reverting one promotion PR removes it.
   - **Budget:** the measured always-on set is within the declared budget.
   - **Liveness:** every deterministic artifact has a recorded firing by its first prune or an explicit re-justification.
5. For migrated artifacts, reject `source` values that contain only a removed file path. Require real evidence plus the migration commit hash and original path.
6. Report pass/fail per invariant, the measured always-on file list, stale promotions, and excluded template paths.

## triage

1. Run the health command and read `docs/learnings/inbox.md`; the inbox is never agent context.
2. Route each candidate in order:
   - security or data corruption → deterministic check plus a scoped explanation this week;
   - first occurrence → hold with expiry;
   - recurring or expensive → mechanical check, regression test, scoped convention/ADR/knowledge module, repo-specific skill/command note, or discard.
3. In a staged workspace, attach scoped artifacts to the existing stage contract that consumes them. Use `docs/adr/` for decisions, `docs/knowledge/<domain>/` for tool conventions, editor/plugin procedures for reusable work, and CI/pre-commit for mechanical checks.
4. Copy a bundled template only after choosing a promotion tier. Replace every placeholder, add evidence that it works, and keep one promotion per revertible PR.
5. Draft at most three promotions and append every decision to `docs/learnings/decisions.md`.
6. Nothing becomes durable until a human approves and merges it.

## migrate

Follow `references/migration-guide.md`. Use `scripts/record_migration.sh` to construct a source value containing real evidence, the resolved migration commit hash, and the original legacy path. Migration never bypasses triage.

## Constraints

- Determinism first; no vector store, knowledge graph, or ungated memory tier.
- Every promoted artifact has provenance and an expiry.
- Default outcome is discard.
- Adding always-on context requires staying within the declared budget.
