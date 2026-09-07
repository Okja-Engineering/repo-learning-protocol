# The Premise

*Condensed from the Repository Learning Protocol spec v0.2 and its evidence
review (Okja Engineering, Aug 2026). This file travels with rlp-architect so the
tool carries its own "why". Nothing below claims novelty beyond the
assembly; sources are named throughout.*

## Thesis

An agent session is a **build**. The repository is its **source** — the
checks, tests, scoped context, and skills the agent runs against. A
correction to agent output is a **bug report**, and nobody serious patches
binaries: durable fixes land in the thing that *generates*, not the thing
generated. With model weights frozen, the repository is the only trainable
component of an agentic engineering system. RLP is the discipline of
compiling corrections into it, at the strongest tier that can hold the fix:

    enforced check > regression test > scoped context (on demand) > skill > discard

This closes the loop the Interpretable Context Methodology paper (Van Clief
& McDermott, arXiv:2603.16021) names as future work: recurring human edits
are "debugging information… point[ing] to fixable source-level problems,"
and a workspace that incorporates them "become[s] a system that gets better
with use." ICM structures context; RLP is the metabolism.

## The two boundary conditions

1. **Weights are frozen.** OpenAI is winding down customer fine-tuning
   entirely (closed to new orgs May 2026; ends Jan 2027; GPT-5.x/codex never
   tunable). Anthropic offers tuning only for a 2024-era small model via
   Bedrock. Cursor cannot run a customer-tuned model in Agent mode. Whatever
   a team learns must live in the repo.
2. **Context is not free.** Performance degrades with input length even on
   simple tasks (Chroma "Context Rot", 2025; NoLiMa, ICML 2025);
   semantically-related-but-wrong content is the most damaging kind ("The
   Power of Noise", SIGIR 2024). The only controlled study of repository
   context files (Gloaguen et al., arXiv:2602.11988) found no general
   success improvement, ~20% added inference cost, and a small *negative*
   effect from LLM-generated files. "Just add more context" makes agents
   worse.

## What the evidence supports (and what it rejects)

**Supports — the tiers RLP uses:**

- *Deterministic extraction* has a decade of production lifecycle evidence:
  Google Tricorder governed automated advice with usefulness thresholds
  (not-useful ≥10% = probation; >25% = off) for years at ~93k findings/day
  (ICSE 2015; CACM 2018); Uber's uReview rebuilt the loop for LLM review
  comments (65% addressed vs. 51% for human comments, with category
  suppression); Google's AutoCommenter lifted usefulness 54%→~80% mostly by
  *suppressing* noise. Semgrep's own doctrine: "automate PR comments that
  you frequently make in code reviews."
- *Human-written, specific, scoped context files* pay, with a caveat: the
  strongest field record — dotnet/runtime lifting Copilot coding-agent PR
  success 38.1%→69% across 878 PRs while iterating one instructions file
  (Toub, Mar 2026) — is observational and confounded; read it as direction
  under sustained human curation, not magnitude. Vendors converge on brutal
  concision ("would removing this line cause mistakes? If not, cut it").
- *Eval-from-failure practice* is the converged loop of AI-product
  engineering (error analysis first; failures become labeled regression
  cases; saturated evals become the permanent suite).
- *Trajectory-derived experience reuse* is real but immature research
  (SWE-Exp +6.6 points on a weak model shrinking to +2.2 on a strong one;
  Agent KB +4.0; Socratic-SWE +7.8 on SWE-bench Verified) — a watch-list,
  not a build-list.

**Rejects — the tier RLP refuses to have:**

- Unreviewed self-generated knowledge drifts: LLMs cannot reliably
  self-correct without external feedback (ICLR 2024); auto-generated skills
  recover less than half the value of human-authored ones (SkillLearnBench).
- Agent memory is a practical attack surface: <0.1% poisoning of a memory
  store yields ≥80% attack success (AgentPoison, NeurIPS 2024); Microsoft
  documents memory poisoning as a first-class failure mode; a coding
  agent's memory tool was exploited in the wild (Windsurf, 2025).
- The industry already retreated: Cursor removed its editor auto-memory
  outright (v2.1.x); Windsurf deprecated memories for skills; the survivors
  are fenced (GitHub Copilot Memory: code-validated, 28-day auto-expiry;
  Devin/Qodo/Semgrep: suggest-then-approve). RLP's gates are the documented
  survival pattern, not caution theater.

## The protocol, in one paragraph

Automated **capture** (review-thread comments become one-line inbox
candidates; the inbox is the recurrence ledger and is never agent context)
→ a **router** applied at a weekly 30-minute triage (second occurrence is
the signal; security-class routes immediately; deterministic tier first) →
**promotion** only by a human-merged PR, with provenance and a `verify_by`
date on every artifact → **delivery** through native mechanisms (CI
enforcement; scoped rules, nested AGENTS.md, skill triggers — no custom
resolver) → **measurement** (repeat-correction rate, promotion liveness via
recorded firings, funnel counts, a hard always-on token budget ≤ ~1,500
enforced in CI) → **retirement** on schedule (monthly prune; deletion is a
success mode).

## Five invariants (the acceptance tests)

1. **Repeat** — a fresh agent session facing the original situation is
   prevented (check fires) or steered (scoped context loads), unprompted.
2. **Provenance** — every durable artifact traces to the correction that
   earned it in one hop.
3. **Deletion** — one PR revert fully removes a learning.
4. **Budget** — always-on context is at or under the declared budget, and
   the build checks the number.
5. **Liveness** — every promoted deterministic artifact observably fires by
   its first prune, or is re-justified or deleted.

## Validation posture

Six weeks against a retro-classified baseline, judged on counts (repeat
corrections in promoted classes −≥50%; ≥70% of promotions observably fired;
ritual held ≥5/6 weeks) — never on self-reported speed: the one RCT in this
space (METR, 2025) found developers 19% slower with AI while believing
themselves 20% faster. On failure: stop and diagnose; do not escalate to
heavier infrastructure — every heavier option (vector memory, knowledge
graphs, trajectory stores) scored worst on evidence, maintainability,
small-team fit, and safety.
