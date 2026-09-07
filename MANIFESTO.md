# Repository Learning Protocol: a manifesto

> An agent session is a build. The repository is its source. A correction to agent output is a bug report — fix the source, not the output.

## What this is

This repository is the artifact of a research program on **continuous learning for coding agents**. We started with a North Star: agents should get better with use, and the improvements should live where the work happens — in the repository — rather than in opaque model weights or external memory stores.

This repository records:

1. **The research** — what the evidence says works, what is still emerging, and what is too risky to adopt.
2. **The protocol** — a concrete, versioned discipline for turning corrections into durable repository improvements.
3. **The tooling** — a Devin plugin (`rlp-architect`) that helps teams adopt the protocol without copying a generalized skill into every project.

The protocol is the spec. The plugin is one implementation. Both mature here, together.

## The North Star

We want agents to stop making the same mistake twice. When an agent produces a correction, that correction should become:

- an **enforced check** if it can be,
- a **regression test** if it cannot be a check,
- **scoped context** if it cannot be a test,
- a **skill** only when it is general and proven,
- or **discarded** by default.

This is the promotion ladder:

```text
enforced check > regression test > scoped context > skill > discard
```

The strongest tier that can hold the fix wins. Weak fixes do not get promoted just because they exist.

## Why the repository is the only trainable component

Model weights are effectively frozen for most teams. OpenAI is winding down customer fine-tuning; Anthropic offers tuning only for a small legacy model through Bedrock; Cursor Agent mode cannot run a customer-tuned model. Whatever a team learns must live in the repository: checks, tests, rules, skills, and the procedures that keep them alive.

Context is also not free. Performance degrades with input length, and semantically related-but-wrong content is the most damaging kind. Adding more context makes agents worse, not better. The only safe improvement surface is the repository itself.

## How we landed on the protocol

We reviewed the evidence on repository-level learning, agent memory, and static-analysis-style advice systems. The pattern across successful systems is the same:

- **Deterministic enforcement first.** Google Tricorder, Semgrep, and Uber's uReview all route advice through mechanisms that can be checked automatically. Noise is suppressed, not amplified.
- **Human gate every promotion.** Auto-promoted context drifts. The strongest field result — dotnet/runtime lifting agent PR success 38.1%→69% — came from one carefully curated instructions file, not from unreviewed accumulation.
- **Deletion is a success mode.** Cursor removed editor auto-memory. Windsurf deprecated memories for skills. Copilot Memory expires after 28 days. The systems that survive fence their memory; RLP makes the fence explicit.
- **Memory tiers are an attack surface.** Poisoned memory stores are exploited in the wild. We do not use vector databases, knowledge graphs, or ungated automatic memory.

The protocol is the simplest discipline that honors these findings.

## The 60 / 30 / 10 rule

RLP tries to make the durable part of an agent system:

- **60% deterministic.** Checks, tests, and verifiable rules that a machine can enforce.
- **30% orchestration.** Plain-text contracts, routing files, and rituals that tell humans and agents what to read, when, and in what order.
- **10% AI judgment.** The agent reads the right context and decides, but the decision is bounded by the protocol and gated by a human before it becomes durable.

The repository, not the chat, is the source of truth.

## The protocol in brief

1. **Capture.** Every correction becomes a one-line candidate in `docs/learnings/inbox.md`. The inbox is a recurrence ledger, not agent context.
2. **Triage.** Once a week, a human routes candidates through the ladder. Second occurrence is the signal; security and data-corruption classes route immediately.
3. **Promote.** A promoted artifact carries provenance (`date`, `source`, `owner`, `scope`, `verify_by`) and is merged in one revertible PR.
4. **Deliver.** The artifact is attached to the existing native mechanism that consumes it: CI, a scoped rule, a stage contract, or a skill trigger.
5. **Measure.** Track repeat-correction rate, promotion liveness, funnel counts, and always-on context budget (≤ ~1,500 tokens).
6. **Retire.** Monthly prune. Artifacts that have not observably fired by their `verify_by` date are re-justified or deleted.

## What RLP rejects

- **Vector databases** as a memory tier — no ungated semantic retrieval.
- **Knowledge graphs** — no manually or automatically assembled graph of beliefs.
- **Autonomous promotion** — no agent may decide a correction becomes durable without human approval.
- **Auto-memory in the agent** — no session state that survives without explicit repository artifacts.

## The five invariants

These are the acceptance tests for any RLP installation:

1. **Repeat.** A fresh agent session facing the original situation is prevented or steered, unprompted.
2. **Provenance.** Every durable artifact traces to the correction that earned it in one hop.
3. **Deletion.** One PR revert fully removes a learning.
4. **Budget.** Always-on context stays at or under the declared budget, and the build checks the number.
5. **Liveness.** Every promoted deterministic artifact observably fires by its first prune, or is re-justified or deleted.

## The tooling

`rlp-architect` is a Devin plugin that exposes an Agent Skill named `rlp`. It provides four modes:

- `scaffold` — discover a target repo and propose minimal project-specific RLP wiring.
- `audit` — check promoted learnings against the five invariants.
- `triage` — route candidates through the ladder and draft promotion PRs.
- `migrate` — move a legacy learning system through normal triage.

The skill is generalized; it never copies itself into a project's configuration. Only project-specific wiring lands in the target repository.

## Validation posture

We do not claim RLP is proven end-to-end. The composite protocol has not been evaluated in a controlled study. We claim only that each tier is individually supported by production evidence, and that the protocol is the simplest assembly that respects the evidence and rejects the riskiest options.

The open questions — including the right token budget, whether the second-occurrence rule prevents over-promotion, and how the protocol compares head-to-head with alternatives — are documented in `stages/01-research/references/RESEARCH-PLAN.md`. We are recruiting teams to run six-week validations and share data.

## How to use this repository

- Start with the thesis and evidence: `PREMISE.md`.
- Read the full protocol spec: `stages/02-protocol/references/repository-learning-protocol.md`.
- Install the plugin: `devin plugins install Okja-Engineering/repo-learning-protocol`.
- Invoke the skill: `/rlp-architect:rlp scaffold`.
- Contribute findings: open an issue or capture a learning in your own repo and route it back here.

## License

MIT. See `LICENSE`.
