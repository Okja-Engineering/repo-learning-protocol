# repo-learning-protocol

A research-backed protocol for turning corrections to AI-agent work into durable repository improvements — checks, tests, scoped context, and skills — so the same mistake is never bought twice. The repository is the only trainable component when model weights are frozen.

## What's here

- `PREMISE.md` — why RLP exists, with evidence and citations
- `stages/01-research/` — paper, evidence, and the 109-entry citation pool
- `stages/02-protocol/` — the canonical RLP spec
- `stages/03-skill/` — stage contract for the product
- `skill/rlp-architect/` — the shipped **Agent Skill** (`SKILL.md`, `scripts/`, `references/`, `assets/`)
- `scripts/install-skill.sh` — install `rlp-architect` into another repo
- `tests/test_skill.sh` — manifest and layout validation
- `tests/test_walk.sh` — end-to-end install + scaffold + health tests
- `docs/rlp-architect-construction-playbook.md` — the full construction playbook
- `research/RESEARCH-PLAN.md` — open questions and validation methods

## Status

**v0.2.0** — `rlp-architect` is a cross-tool Agent Skill in the open `agentskills.io` format. It has been tested via fresh-clone and install walk tests.

## Installing the skill in another repo

From this repo:

```bash
scripts/install-skill.sh /path/to/target-repo
```

This copies `skill/rlp-architect/` into the target repo at `.agents/skills/rlp-architect/`. Any agent that scans `.agents/skills/` (Devin, Cursor, Claude) will expose `/rlp-architect`.

## Using the skill

In the target repo, invoke the skill with a mode:

```text
/rlp-architect scaffold
```

Installs the RLP loop into the target repo: scripts, learning inbox, decisions log, sample ADR, scoped rule, Semgrep rule, and health checks.

```text
/rlp-architect audit
```

Runs `scripts/learning_health.sh` and checks the five RLP invariants.

```text
/rlp-architect triage
```

Walks the inbox through the RLP router and drafts promotion PRs.

## Running the local test suite

```bash
tests/test_skill.sh   # manifest / layout validation
tests/test_walk.sh    # install, scaffold, capture/health, fresh clone
```

Both must report `0 failed`.

## Thesis

An agent session is a build; the repository is its source. A correction to agent output is a bug report — fix the source, at the strongest tier that can hold it:

```text
enforced check > regression test > scoped context > skill > discard
```

## Lineage

Modeled on [icm-architect](https://github.com/RinDig/icm-architect) (Van Clief & McDermott, MIT), which packages the Interpretable Context Methodology as a buildable skill. RLP does the same for repository-level learning, implementing the "systems that get better with use" loop ICM's paper (arXiv:2603.16021, §6.3) names as future work.
