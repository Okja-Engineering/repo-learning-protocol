# repo-learning-protocol

A research-backed protocol for turning corrections to AI-agent work into durable repository improvements — checks, tests, scoped context, and skills — so the same mistake is never bought twice. The repository is the only trainable component when model weights are frozen.

## What's here

- `docs/rlp-architect-construction-playbook.md` — the full construction playbook
- `research/RESEARCH-PLAN.md` — the research plan: open questions, validation methods, brief structure
- `references/` — citation pool and supporting evidence (to be populated)

## Status

Research phase. The playbook provides the protocol spec, citation pool, and skill design. The research plan defines what we still need to validate.

## Thesis

An agent session is a build; the repository is its source. A correction to agent output is a bug report — fix the source, at the strongest tier that can hold it:

    enforced check > regression test > scoped context > skill > discard

## Lineage

Modeled on [icm-architect](https://github.com/RinDig/icm-architect) (Van Clief & McDermott, MIT), which packages the Interpretable Context Methodology as a buildable skill. RLP does the same for repository-level learning, implementing the "systems that get better with use" loop ICM's paper (arXiv:2603.16021, §6.3) names as future work.
