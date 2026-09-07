# Changelog

All notable changes to `rlp-architect`.

## Unreleased

- Removed `migrate` skill; the core plugin now consists of `scaffold`, `capture`, `triage`, and `audit`.
- Added `capture` skill to make adding a one-line learning candidate to the inbox a first-class interaction.
- Rewrote `triage` as an interactive layer-picker with seven ordered questions that route a learning to the strongest enforcement tier.
- Added capture ritual to `scaffold` to clarify how learnings are discovered and placed in the inbox.
- Updated `README.md`, `RELEASE_NOTES.md`, and tests to reflect the four-skill surface.
- Aligned all four `SKILL.md` files with Agent Skills spec: added `When to use`, `Examples`, `Deterministic actions`, and `Orchestration` sections; renamed capture script to `capture_learnings.sh` for consistency.

## 0.5.0 — planned

- Additional distribution paths as the ecosystem stabilizes (e.g. `npx skills` or agent marketplaces).

## 0.4.0 — 2026-09-10

**Public release as a multi-agent plugin.**

- Restructured plugin into four standalone Agent Skills: `scaffold`, `audit`, `triage`, `migrate`.
- Changed invocation from `/rlp-architect:rlp <mode>` to `/rlp-architect:<mode>`; the skill name is the mode.
- Dropped the ICM workspace layer (`AGENTS.md`, `CLAUDE.md`, `CONTEXT.md`, `stages/`) from the plugin repo; `RLP.md` now carries the rationale.
- Merged `PREMISE.md` into `RLP.md` as the "Evidence and detailed citations" section.
- Separated plugin tests from scaffolded assets; payload tests moved to `tests/payload/`.
- Removed `scripts/install-skill.sh`; install paths are now documented per agent/editor in `README.md`.
- Validated the plugin boundary in a production field repository by removing its project-local generalized-skill copy and routing it to the canonical plugin.
- Rewrote `README.md` with a problem/skill mapping, skills catalog, and clearer install story (Devin plugin and manual copy).
- Added `.out-of-scope.md` documenting deliberate boundaries and claims RLP does not make.
- Added native plugin manifests for Devin, Claude Code, Codex, and Cursor, all pointing at the same `skills/` directory.
- Extended `tests/test_skill.sh` to validate all plugin manifests.

## 0.3.0 — 2026-09-09

**Public release as a Devin plugin.**

- Shipped as `rlp-architect` plugin bundling the `rlp` Agent Skill.
- Renamed skill from `rlp-architect` to `rlp` and moved from `skill/` to `skills/` layout.
- Updated invocation to `/rlp-architect:rlp <mode>`.
- Added MIT `LICENSE`.
- Rewrote `README.md` as consumer-facing install/usage guide.
- Removed `SHA256SUMS` and archived the construction playbook under `docs/history/`.

## 0.2.1 — 2026-09-06

- Fixed payload test helper sourcing to work after `cd` into a temporary directory.

## 0.2.0 — 2026-09-06

**First distributable Agent Skill.**

- Aligned `rlp-architect` with the Agent Skills spec (`SKILL.md`, `scripts/`, `references/`, `assets/`).
- Added bash payload: `capture_learnings.sh`, `learning_health.sh`, `record_migration.sh`.
- Added templates for promoted artifacts (rules, API conventions, Semgrep).
- Added walk tests covering install, scaffold, capture/health, budget, and migration provenance.
- Added 109-entry citation pool and `PREMISE.md` research rationale.
- Documented the RLP spec in `stages/02-protocol/references/repository-learning-protocol.md` (since removed; the spec content lives in `RLP.md`).

## 0.1.0 — 2026-09-05

**Initial prototype.**

- Scaffolded the repository as an ICM workspace (research → protocol → skill → field).
- Drafted the Repository Learning Protocol v0.2.
- Added construction playbook and initial release pass records.
