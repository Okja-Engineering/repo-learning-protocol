# RLP-Architect Construction Playbook

From an empty repository to rlp-architect v0.2.0 — an ICM factory running RLP on itself.

**Date:** 2026-08-26
**Status:** Self-contained · self-verifying (15 tests · 34 checksums · walk test in CI)

## Purpose

Starting from an empty repository, build rlp-architect — the Repository Learning Protocol counterpart of icm-architect: a distributable Agent Skill that installs, audits, and operates RLP in any repo. The build is deliberately meta: the repository you construct is itself an ICM workspace (Layer 0/1 identity and routing, numbered stages with Inputs/Process/Outputs contracts, background exposed as stage references, walk test in CI) that runs RLP on itself (its own inbox, its own triage stage, field feedback routed by its own router). Everything needed is embedded in this one file: the research premise, the full citation pool, the protocol spec, every source file (verbatim, pre-tested), a proof suite, and a dogfood demonstration. When the last gate passes you have a releasable v0.2.0.

## How to run this

Create an empty git repo, drop this single file in the root, and execute one phase per Cursor/Claude agent run, in order (Phases 0–6). Each phase ends with a GATE — concrete evidence, captured output, no vibes. Do not start phase N+1 until phase N's gate passes. Commit at the end of each phase. Requirements: Python 3.10+, git, pip install pytest; semgrep and pre-commit are needed only from Phase 5 (install then if absent).

## Scope guard

This playbook creates files only inside this repository. It fetches nothing from the network except optional tool installs (pytest, semgrep). No external documents are required — the premise travels in Phase 0's blocks.

## Ground rules for the agent (read before every phase)

1. **Embedded blocks are law.** Every block marked verbatim is tested code with checksums in Appendix A. Write it byte-for-byte, ending with exactly one trailing newline. Do not reformat, "improve", rename, or fix style — if something looks wrong, finish the phase, then record the concern in NOTES.md as a playbook bug. A silent deviation is the one way to fail this playbook.
2. **Evidence or it didn't happen.** Every gate claim cites a command you ran and its captured output (paste trimmed output into the phase's commit message body or NOTES.md).
3. **The constructed tool must obey its own protocol.** The RLP hard rules apply to what you build: the learnings inbox is never agent context; humans gate promotion; determinism first; always-on budget ≤ ~1,500 tokens; no memory tier of any kind. If any instruction here ever seems to conflict with those rules, the rules win and the conflict goes in NOTES.md.
4. **Commit messages:** placeholders below are Conventional Commits style; match the repo's own style if one emerges. One commit per phase minimum.
5. **Do not add features.** No extra modes, no config systems, no cleverness. v0.1.0 is exactly what this file specifies; ideas go in NOTES.md for a human to triage later — that is, after all, the protocol.

## Orientation: what you are building and why

The premise in one paragraph (Phase 0 writes the full, cited version to PREMISE.md): an agent session is a build; the repository is its source — the checks, tests, scoped context, and skills the agent runs against; a correction to agent output is a bug report, and durable fixes belong in the source, at the strongest tier that can hold them: enforced check > regression test > scoped context > skill > discard. With model weights frozen for closed frontier models, the repository is the only trainable component a team has. rlp-architect packages that discipline as an Agent Skill with three modes — scaffold (install RLP into a repo), audit (check an install against RLP's five invariants), triage (run the weekly session) — plus a payload of tested scripts and templates the skill deploys.

### Final layout (Appendix A holds the checksum manifest)

```
rlp-architect/
├── AGENTS.md · CLAUDE.md              # ICM Layer 0 — workspace identity (Phase 4)
├── CONTEXT.md                         # ICM Layer 1 — task routing (Phase 4)
├── README.md · PREMISE.md · LICENSE · NOTES.md
├── stages/                            # ICM Layer 2 — stage contracts (Phase 4)
│   ├── 01_research/{CONTEXT.md, references/, output/}   # references: REFERENCES.md (citation pool)
│   ├── 02_protocol/{CONTEXT.md, references/, output/}   # references: the RLP spec v0.2
│   ├── 03_skill/CONTEXT.md
│   └── 04_field/{CONTEXT.md, output/}
├── docs/learnings/{inbox.md, decisions.md}   # RLP applied to this repo itself (Phase 4)
├── skill/rlp-architect/
│   ├── SKILL.md                       # the three modes (the product)
│   └── payload/
│       ├── scripts/{capture_learnings.py, learning_health.py}
│       ├── docs/learnings/{inbox.md, decisions.md}
│       ├── docs/adr/0001-adopt-rlp.md
│       ├── docs/knowledge/escrow/rounding.md
│       ├── .cursor/commands/promote-learning.md
│       ├── .cursor/rules/api-conventions.mdc
│       ├── semgrep/rules.yml
│       ├── tests/test_utc_now.py
│       ├── AGENTS.md.seed
│       └── pre-commit-config.yaml.seed
├── tests/                             # test_payload.py (8) + test_walk.py (7)
├── examples/demo/                     # Phase 5 dogfood (created then, not embedded)
└── SHA256SUMS
```

---

## Phase 0 — Skeleton, premise, license

**Goal:** The repo exists, carries its own "why", and is legally distributable.

[Full verbatim blocks for PREMISE.md, README.md, LICENSE — see original playbook]

**GATE 0:** PREMISE.md, README.md, LICENSE, NOTES.md exist; python3 --version shows ≥3.10; git status is clean after commit.

**Commit:** `chore: scaffold rlp-architect — premise, readme, license`

---

## Phase 1 — The payload scripts, proven

**Goal:** The two load-bearing scripts exist and 8 tests pass.

[Full verbatim blocks for learning_health.py, capture_learnings.py, test_payload.py — see original playbook]

**GATE 1:** Output shows 8 passed.

**Commit:** `feat: payload scripts (capture, health) with passing proof suite`

---

## Phase 2 — The payload templates and router

**Goal:** Everything scaffold mode deploys.

[Full verbatim blocks for inbox.md, decisions.md, promote-learning.md, rules.yml, api-conventions.mdc, test_utc_now.py, AGENTS.md.seed, pre-commit-config.yaml.seed, 0001-adopt-rlp.md, rounding.md — see original playbook]

**GATE 2:** `find skill -type f | wc -l` returns 12; tests still pass.

**Commit:** `feat: payload templates — inbox/decisions, router command, semgrep, seeds`

---

## Phase 3 — The skill itself

**Goal:** The three-mode SKILL.md, in the open Agent Skills format.

[Full verbatim block for SKILL.md — see original playbook]

**GATE 3:** YAML frontmatter parses; description under 1024 chars; `find skill -type f | wc -l` returns 13.

**Commit:** `feat: rlp-architect skill — scaffold, audit, triage modes`

---

## Phase 4 — The ICM factory shell

**Goal:** The repository itself becomes an ICM workspace running RLP on itself.

[Full verbatim blocks for AGENTS.md, CLAUDE.md, CONTEXT.md, all stage CONTEXT.md files, REFERENCES.md (109-entry citation pool), RLP spec v0.2, inbox.md, decisions.md, test_walk.py — see original playbook]

**GATE 4:** Output shows 15 passed (8 payload + 7 walk).

**Commit:** `feat: ICM factory shell — layered identity/routing, stage contracts, self-RLP inbox, walk test`

---

## Phase 5 — Dogfood proof

**Goal:** Demonstrate that the skill's scaffold produces a repo where RLP's repeat test actually bites.

[Demo setup and proof steps — see original playbook]

**GATE 5:** PROOF.md exists with recurrence flag, semgrep finding, firing counts, budget check.

**Commit:** `test: dogfood proof — scaffold applied to examples/demo, repeat test demonstrated`

---

## Phase 6 — Release v0.2.0

**Goal:** Integrity sealed, fresh-clone verified, distributable.

[SHA256SUMS manifest and verification steps — see original playbook]

**GATE 6:** `sha256sum -c SHA256SUMS` all OK; fresh clone shows 15 passed; `git tag v0.2.0` exists.

**Commit:** `chore: release rlp-architect v0.2.0`

---

## Appendix A — Integrity manifest

The SHA256SUMS block in Phase 6 is the canonical manifest, generated from the reference build (all 15 tests passing, semgrep rules verified against positive and negative cases) at assembly time.

## Appendix B — What is deliberately absent

No vector memory, no knowledge graph, no trajectory store, no ungated auto-memory, no autonomous promotion, no custom context resolver, no config framework, no server. These are omissions on evidence (see PREMISE.md), not oversights.

## Appendix C — Lineage

Modeled on icm-architect (Van Clief & McDermott, MIT), which packages the Interpretable Context Methodology as a buildable skill; this playbook does the same for RLP, implementing the "systems that get better with use" loop ICM's paper (arXiv:2603.16021, §6.3) names as future work. The protocol itself is a composition of named practice: Google Tricorder's lifecycle governance, the AGENTS.md and Agent Skills open standards, Semgrep's rules-from-review doctrine, eval-from-failure practice, blameless-postmortem capture. Full citations: PREMISE.md.

**Companions:** Fix the Source (thesis) · RLP spec v0.2 · Managed Learning Arena (evidence) · rlp-kit (tested scripts this playbook installs).

---

*Note: This is a summary of the full playbook. The complete verbatim blocks for all phases are in the original document shared by the author. This summary preserves the structure, goals, gates, and commit messages. The full verbatim blocks should be sourced from the original document when executing the playbook.*
