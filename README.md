# rlp-architect

> Repository Learning Protocol (RLP) — turn corrections to AI-agent work into durable repository improvements.

A research-backed protocol for turning corrections to AI-agent work into durable repository improvements — checks, tests, scoped context, and skills — so the same mistake is never bought twice. The repository is the only trainable component when model weights are frozen.

Read the research and design rationale first: [`MANIFESTO.md`](MANIFESTO.md).

## What's here

### For users of the plugin

- `.devin-plugin/plugin.json` — the Devin plugin manifest
- `skills/rlp/` — the shipped **Agent Skill** (`SKILL.md`, `scripts/`, `references/`, `templates/`, `assets`)
- `scripts/install-skill.sh` — install this checkout as a Devin plugin
- `tests/test_skill.sh` — manifest and layout validation
- `tests/test_walk.sh` — end-to-end plugin + scaffold-wiring + health tests

### For contributors to the protocol

- `PREMISE.md` — why RLP exists, with evidence and citations
- `stages/01-research/` — paper, evidence, and the 109-entry citation pool
- `stages/02-protocol/` — the canonical RLP spec
- `stages/03-skill/` — stage contract for the product
- `docs/history/construction-playbook.md` — the original construction playbook (origin story)
- `docs/rlp-plugin-release-runbook.md` — small, gated passes from local plugin to public field trial
- `stages/01-research/references/RESEARCH-PLAN.md` — open questions and validation methods
- `LICENSE` — MIT license

## Status

**v0.3.0** — `rlp-architect` ships as a Devin plugin that bundles an Agent Skill in the open [`agentskills.io`](https://agentskills.io) format.

## Installing the plugin

Install the published repository globally:

```bash
devin plugins install Okja-Engineering/repo-learning-protocol
```

Verify the plugin is recognized:

```bash
devin plugins info rlp-architect
```

For local development, run `scripts/install-skill.sh`. Update a published install with `devin plugins update rlp-architect`. Scaffold writes only project-specific RLP wiring; it does not copy the generalized skill into the target repository.

## Using the skill

In the target repo, invoke the skill with a mode. Devin plugin commands use the form `/plugin-name:skill-name mode`:

```text
/rlp-architect:rlp scaffold
```

Discovers the repository, asks which editor directory to use, and proposes minimal wiring: scripts, learning logs, inert templates, router references, and approved CI hooks. Existing stage contracts are extended rather than duplicated.

```text
/rlp-architect:rlp audit
```

Runs `scripts/learning_health.sh` and checks the five RLP invariants.

```text
/rlp-architect:rlp triage
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
