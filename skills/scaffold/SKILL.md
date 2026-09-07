---
name: scaffold
description: Add minimal, project-specific Repository Learning Protocol (RLP) wiring to a target repository. Use when a repo needs an inbox, decisions log, health scripts, and inert promotion templates without copying the generalized skill bundle.
license: MIT
compatibility: POSIX shell (bash 3.2+ or zsh), git, and optional semgrep/pre-commit.
metadata:
  version: "0.5.0"
---

# scaffold

Add minimal, project-specific RLP wiring to a repository. Scaffold does not install the generalized skill; it creates only the files a project needs to operate the protocol locally.

## When to use

Use when a repository needs:

- An inbox and decisions log for the Repository Learning Protocol.
- Health scripts to check recurrence, budget, and staleness.
- Inert promotion templates without copying the generalized skill bundle.

Use only after inspecting the existing router and editor configuration. Do not use scaffold to add active promotions or overwrite user files.

## Deterministic actions (60%)

### Files to create

Create only missing wiring:

- `docs/learnings/inbox.md`
- `docs/learnings/decisions.md`
- `scripts/capture_learnings.sh` (when CI or local commands need it)
- `scripts/learning_health.sh` (when CI or local commands need it)
- `docs/rlp-architect/templates/`, copied from bundled `templates/` — inert starters for manual use during promotion
- a minimal root router or merged route into existing `AGENTS.md`
- an editor command note that invokes the global/plugin skill, if approved
- CI or pre-commit wiring only when the repository already uses that mechanism or the user approves adding it

### Hard rules

- Compare content before writing; do not overwrite user files.
- Do not duplicate routes in `AGENTS.md` or root routers.
- Never copy an unfilled template into an active artifact path such as `docs/knowledge/`, `.devin/rules/`, or `semgrep/rules.yml`.
- Templates are not promotions.

### Capture ritual to include

Add this ritual to the created `AGENTS.md` or root router:

```text
/rlp-architect:capture <sentence>     # add a learning candidate to the inbox
scripts/capture_learnings.sh -l <link> -s <slug> -t "<sentence>"
```

Replace `<rlp-dir>` in `pre-commit-config.yaml.seed` with the target repository path before promotion.

## Orchestration (30%)

### Discovery process

1. Inspect `AGENTS.md`, `CONTEXT.md`, editor pointers (`.devin/`, `.claude/`, `.cursor/`), existing learning logs, tests, CI, linters, and Semgrep configuration.
2. Classify the repo as an existing routed workspace or no router.
3. Present the discovered structure and exact proposed file changes.
4. Ask the user which editor directory to wire (`.devin/`, `.claude/`, `.cursor/`, or another). Do not infer it from an installed tool.
5. Ask for approval before writing.

### Preserve existing architecture

- Merge a short RLP route into an existing `AGENTS.md` or root router; never replace the file.
- If stage contracts exist, note where promoted artifacts should be attached.
- Do not create an RLP stage in an existing staged workspace.
- Only when no router or staged workspace exists, propose a minimal root router and copy the bundled `assets/stages/00-learn/CONTEXT.md` to `stages/00-learn/CONTEXT.md`.

### Idempotency

- Compare content before writing.
- Preserve user text.
- Do not duplicate routes.
- Report unchanged files.

### Validation checklist

- [ ] No existing user files were overwritten.
- [ ] No duplicate routes exist in `AGENTS.md`.
- [ ] Created files match the bundled seeds.
- [ ] `scripts/learning_health.sh` runs without error.
- [ ] Templates remain in `docs/rlp-architect/templates/` and were not copied to active artifact paths.

## Examples

### Fresh repository with no router

Files created:

```text
docs/learnings/inbox.md
docs/learnings/decisions.md
scripts/capture_learnings.sh
scripts/learning_health.sh
docs/rlp-architect/templates/
AGENTS.md   (minimal root router)
```

### Repository with an existing `AGENTS.md`

The skill merges a short RLP route into `AGENTS.md` and reports unchanged files.

## Constraints

- Determinism first; no vector store, knowledge graph, or ungated memory tier.
- Every promoted artifact has provenance and an expiry.
- Default outcome is discard.
- Adding always-on context requires staying within the declared budget.
