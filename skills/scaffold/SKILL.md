---
name: scaffold
description: Add minimal, project-specific Repository Learning Protocol (RLP) wiring to a target repository. Use when a repo needs an inbox, decisions log, health scripts, and inert promotion templates without copying the generalized skill bundle.
license: MIT
compatibility: POSIX shell (bash 3.2+ or zsh), git, and optional semgrep/pre-commit.
metadata:
  version: "0.4.0"
---

# scaffold

Add minimal, project-specific RLP wiring to a repository. Scaffold does not install the generalized skill; it creates only the files a project needs to operate the protocol locally.

## Process

1. Discover before proposing writes:
   - inspect `AGENTS.md`, `CONTEXT.md`, editor pointers (`.devin/`, `.claude/`, `.cursor/`), existing learning logs, tests, CI, linters, and Semgrep configuration;
   - classify the repo as an existing routed workspace or no router.
2. Present the discovered structure and exact proposed file changes. Ask the user which editor directory to wire (`.devin/`, `.claude/`, `.cursor/`, or another). Do not infer it from an installed tool.
3. Ask for approval before writing.
4. Create only missing project wiring:
   - `docs/learnings/inbox.md` and `docs/learnings/decisions.md`;
   - repo-local copies of `scripts/capture_learnings.sh` and `scripts/learning_health.sh` when CI or local commands need them;
   - `docs/rlp-architect/templates/`, copied from bundled `templates/`, as inert starters for manual use during promotion;
   - an editor command note that invokes the global/plugin skill, if approved;
   - CI or pre-commit wiring only when the repository already uses that mechanism or the user approves adding it.
5. Preserve existing architecture:
   - merge a short RLP route into an existing `AGENTS.md` or root router; never replace the file;
   - if stage contracts exist, note where promoted artifacts should be attached;
   - do not create an RLP stage in an existing staged workspace;
   - only when no router or staged workspace exists, propose a minimal root router and copy the bundled `assets/stages/00-learn/CONTEXT.md` to `stages/00-learn/CONTEXT.md`.
6. Make the operation idempotent: compare content before writing, preserve user text, do not duplicate routes, and report unchanged files.
7. Never copy an unfilled template into an active artifact path such as `docs/knowledge/`, `.devin/rules/`, or `semgrep/rules.yml`. Templates are not promotions.

## Constraints

- Determinism first; no vector store, knowledge graph, or ungated memory tier.
- Every promoted artifact has provenance and an expiry.
- Default outcome is discard.
- Adding always-on context requires staying within the declared budget.
