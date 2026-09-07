# Repository Learning Protocol (RLP)

A protocol for turning corrections to AI-agent work into durable repository improvements.

Full research premise with citations: [`PREMISE.md`](PREMISE.md).
Canonical spec: [`stages/02-protocol/references/repository-learning-protocol.md`](stages/02-protocol/references/repository-learning-protocol.md).

## The idea

An agent session is a **build**. The repository is its **source** — the checks, tests, scoped context, and skills the agent runs against. A correction to agent output is a **bug report**, and durable fixes belong in the thing that *generates*, not the thing generated.

With model weights frozen for most teams, the repository is the only trainable component of an agentic engineering system. RLP is the discipline of compiling corrections into it, at the strongest tier that can hold the fix:

```text
enforced check > regression test > scoped context > skill > discard
```

RLP closes the loop the [Interpretable Context Methodology](https://github.com/RinDig/Interpretable-Context-Methodology) paper (Van Clief & McDermott, arXiv:2603.16021, §6.3) names as future work: recurring human edits are "debugging information… point[ing] to fixable source-level problems," and a workspace that incorporates them "become[s] a system that gets better with use." ICM structures context; RLP is the metabolism.

## Why this exists

People already build memory for agents: `CLAUDE.md`, `AGENTS.md`, memory banks, skills, rules. What was missing was a reproducible protocol for deciding *which* corrections become durable, *how* they are attached to the repository, and *when* they are retired.

Without a protocol, teams either:

- promote every correction and drown the agent in stale context, or
- promote nothing and pay to rediscover the same failure modes.

RLP is the middle path: capture everything, promote rarely, delete on schedule.

## Design principles

**The repository is the only trainable component.** Model weights are effectively frozen. OpenAI is winding down customer fine-tuning; Anthropic offers tuning only for a small legacy model through Bedrock; Cursor Agent mode cannot run a customer-tuned model. Whatever a team learns must live in checks, tests, rules, and skills that version with the code.

**Determinism first.** The strongest tier is always a check the agent cannot ignore. A scoped context file is a fallback. Ungated memory is out of scope.

**Context is not free.** Performance degrades with input length, and semantically related-but-wrong content is the most damaging kind. "Just add more context" makes agents worse. RLP caps always-on context and keeps scoped artifacts on triggers.

**Humans gate every promotion.** Auto-promoted context drifts. The strongest field result — dotnet/runtime lifting agent PR success 38.1%→69% — came from one carefully curated instructions file, not from unreviewed accumulation.

**Deletion is a success mode.** Cursor removed editor auto-memory. Windsurf deprecated memories for skills. Copilot Memory expires after 28 days. The systems that survive fence their memory; RLP makes the fence explicit.

## How it works

The protocol is a loop:

1. **Capture.** Every correction becomes a one-line candidate in `docs/learnings/inbox.md`. The inbox is a recurrence ledger, not agent context.
2. **Triage.** Once a week, a human routes candidates through the ladder. Second occurrence is the signal; security and data-corruption classes route immediately.
3. **Promote.** A promoted artifact carries provenance (`date`, `source`, `owner`, `scope`, `verify_by`) and is merged in one revertible PR.
4. **Deliver.** The artifact is attached to the existing native mechanism that consumes it: CI, a scoped rule, a stage contract, or a skill trigger.
5. **Measure.** Track repeat-correction rate, promotion liveness, funnel counts, and always-on context budget (≤ ~1,500 tokens).
6. **Retire.** Monthly prune. Artifacts that have not observably fired by their `verify_by` date are re-justified or deleted.

## The five invariants

These are the acceptance tests for any RLP installation:

1. **Repeat.** A fresh agent session facing the original situation is prevented or steered, unprompted.
2. **Provenance.** Every durable artifact traces to the correction that earned it in one hop.
3. **Deletion.** One PR revert fully removes a learning.
4. **Budget.** Always-on context stays at or under the declared budget, and the build checks the number.
5. **Liveness.** Every promoted deterministic artifact observably fires by its first prune, or is re-justified or deleted.

## What RLP rejects

- **Vector databases** as a memory tier.
- **Knowledge graphs** as a durable belief store.
- **Autonomous promotion** by an agent.
- **Ungated agent memory** that survives outside the repository.

These are not aesthetic preferences. Poisoned memory stores are exploited in the wild, LLMs cannot reliably self-correct without external feedback, and every heavier option scored worst on evidence, maintainability, small-team fit, and safety in our evidence review.

## The tooling

`rlp-architect` is a Devin plugin that exposes an Agent Skill named `rlp`. It provides four modes:

- `scaffold` — discover a target repo and propose minimal project-specific RLP wiring.
- `audit` — check promoted learnings against the five invariants.
- `triage` — route candidates and draft promotion PRs.
- `migrate` — move a legacy learning system through normal triage.

The skill is generalized; it never copies itself into a project's configuration. Only project-specific wiring lands in the target repository.

## Install

```bash
devin plugins install Okja-Engineering/repo-learning-protocol
devin plugins info rlp-architect
```

For local development, run `scripts/install-skill.sh`. Update a published install with `devin plugins update rlp-architect`.

## Use

Devin plugin commands use the form `/plugin-name:skill-name mode`:

```text
/rlp-architect:rlp scaffold
/rlp-architect:rlp audit
/rlp-architect:rlp triage
/rlp-architect:rlp migrate
```

## Repository layout

```text
.devin-plugin/plugin.json + skills/rlp/   # Devin plugin and Agent Skill bundle
scripts/install-skill.sh                   # install this checkout as a Devin plugin
tests/test_skill.sh                        # manifest and layout validation
tests/test_walk.sh                         # end-to-end plugin + scaffold + health tests
PREMISE.md                                 # full research premise with citations
stages/02-protocol/references/             # canonical RLP spec
docs/history/construction-playbook.md    # how this repo was originally built
docs/rlp-plugin-release-runbook.md         # gated passes from local plugin to public field trial
```

## Validation posture

We do not claim RLP is proven end-to-end. The composite protocol has not been evaluated in a controlled study. We claim only that each tier is individually supported by production evidence, and that the protocol is the simplest assembly that respects the evidence and rejects the riskiest options.

Open questions — including the right token budget, whether the second-occurrence rule prevents over-promotion, and how RLP compares head-to-head with alternatives — are documented in `stages/01-research/references/RESEARCH-PLAN.md`. We are recruiting teams to run six-week validations and share data.

## Contributing

Capture a correction in your own repository, route it through triage, and open an issue or PR back here with the decision. RLP improves the same way it asks other repositories to improve: through reviewed, revertible promotions.

## License

MIT. See [`LICENSE`](LICENSE).
