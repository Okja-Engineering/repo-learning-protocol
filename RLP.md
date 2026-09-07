# Repository Learning Protocol (RLP)

A protocol for turning corrections to AI-agent work into durable repository improvements.

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

**Context is not free.** Performance degrades with input length, and semantically related-but-wrong content is the most damaging kind. "Just add more context" makes agents worse, not better. RLP caps always-on context and keeps scoped artifacts on triggers.

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

## Validation posture

We do not claim RLP is proven end-to-end. The composite protocol has not been evaluated in a controlled study. We claim only that each tier is individually supported by production evidence, and that the protocol is the simplest assembly that respects the evidence and rejects the riskiest options.

The open questions — including the right token budget, whether the second-occurrence rule prevents over-promotion, and how RLP compares head-to-head with alternatives — are tracked in issues and validated through field reports. We are recruiting teams to run six-week validations and share data.

## How we work

We run everything in cycles: plan → implement → verify → review → decide. Research is not a separate phase; it is the first step of every cycle. When the evidence changes, the protocol changes. When the protocol changes, the skill changes. Nothing is durable until a human approves it.

For the plugin itself, that means each change starts with the user experience we want, is implemented against the five invariants, and is proven with a test before it is promoted. The same loop applies to the protocol and to any repository that uses it.

## Contributing

Capture a correction in your own repository, route it through triage, and open an issue or PR back here with the decision. RLP improves the same way it asks other repositories to improve: through reviewed, revertible promotions.

## Evidence and detailed citations

*Condensed from the Repository Learning Protocol spec v0.2 and its evidence review (Aug 2026). Nothing below claims novelty beyond the assembly; sources are named throughout.*

### Thesis

An agent session is a **build**. The repository is its **source** — the checks, tests, scoped context, and skills the agent runs against. A correction to agent output is a **bug report**, and nobody serious patches binaries: durable fixes land in the thing that *generates*, not the thing generated. With model weights frozen, the repository is the only trainable component of an agentic engineering system. RLP is the discipline of compiling corrections into it, at the strongest tier that can hold the fix:

    enforced check > regression test > scoped context (on demand) > skill > discard

This closes the loop the Interpretable Context Methodology paper (Van Clief & McDermott, arXiv:2603.16021) names as future work: recurring human edits are "debugging information… point[ing] to fixable source-level problems," and a workspace that incorporates them "become[s] a system that gets better with use." ICM structures context; RLP is the metabolism.

### The two boundary conditions

1. **Weights are frozen.** OpenAI is winding down customer fine-tuning entirely (closed to new orgs May 2026; ends Jan 2027; GPT-5.x/codex never tunable). Anthropic offers tuning only for a 2024-era small model via Bedrock. Cursor cannot run a customer-tuned model in Agent mode. Whatever a team learns must live in the repo.
2. **Context is not free.** Performance degrades with input length even on simple tasks (Chroma "Context Rot", 2025; NoLiMa, ICML 2025); semantically-related-but-wrong content is the most damaging kind ("The Power of Noise", SIGIR 2024). The only controlled study of repository context files (Gloaguen et al., arXiv:2602.11988) found no general success improvement, ~20% added inference cost, and a small *negative* effect from LLM-generated files. "Just add more context" makes agents worse.

### What the evidence supports (and what it rejects)

**Supports — the tiers RLP uses:**

- *Deterministic extraction* has a decade of production lifecycle evidence: Google Tricorder governed automated advice with usefulness thresholds (not-useful ≥10% = probation; >25% = off) for years at ~93k findings/day (ICSE 2015; CACM 2018); Uber's uReview rebuilt the loop for LLM review comments (65% addressed vs. 51% for human comments, with category suppression); Google's AutoCommenter lifted usefulness 54%→~80% mostly by *suppressing* noise. Semgrep's own doctrine: "automate PR comments that you frequently make in code reviews."
- *Human-written, specific, scoped context files* pay, with a caveat: the strongest field record — dotnet/runtime lifting Copilot coding-agent PR success 38.1%→69% across 878 PRs while iterating one instructions file (Toub, Mar 2026) — is observational and confounded; read it as direction under sustained human curation, not magnitude. Vendors converge on brutal concision ("would removing this line cause mistakes? If not, cut it").
- *Eval-from-failure practice* is the converged loop of AI-product engineering (error analysis first; failures become labeled regression cases; saturated evals become the permanent suite).
- *Trajectory-derived experience reuse* is real but immature research (SWE-Exp +6.6 points on a weak model shrinking to +2.2 on a strong one; Agent KB +4.0; Socratic-SWE +7.8 on SWE-bench Verified) — a watch-list, not a build-list.

**Rejects — the tier RLP refuses to have:**

- Unreviewed self-generated knowledge drifts: LLMs cannot reliably self-correct without external feedback (ICLR 2024); auto-generated skills recover less than half the value of human-authored ones (SkillLearnBench).
- Agent memory is a practical attack surface: <0.1% poisoning of a memory store yields ≥80% attack success (AgentPoison, NeurIPS 2024); Microsoft documents memory poisoning as a first-class failure mode; a coding agent's memory tool was exploited in the wild (Windsurf, 2025).
- The industry already retreated: Cursor removed its editor auto-memory outright (v2.1.x); Windsurf deprecated memories for skills; the survivors are fenced (GitHub Copilot Memory: code-validated, 28-day auto-expiry; Devin/Qodo/Semgrep: suggest-then-approve). RLP's gates are the documented survival pattern, not caution theater.

### Validation posture

Six weeks against a retro-classified baseline, judged on counts (repeat corrections in promoted classes −≥50%; ≥70% of promotions observably fired; ritual held ≥5/6 weeks) — never on self-reported speed: the one RCT in this space (METR, 2025) found developers 19% slower with AI while believing themselves 20% faster. On failure: stop and diagnose; do not escalate to heavier infrastructure — every heavier option (vector memory, knowledge graphs, trajectory stores) scored worst on evidence, maintainability, small-team fit, and safety.

## License

MIT. See [`LICENSE`](LICENSE).
