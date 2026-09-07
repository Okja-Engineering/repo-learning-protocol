# Research Plan: Repo Learning Protocol

## What this is

A research plan for developing the Repo Learning Protocol (RLP) into a rigorous, evidence-backed practice with a community of practitioners. The RLP playbook (see `docs/rlp-architect-construction-playbook.md`) provides the foundation — the protocol spec, the citation pool, the scripts, and the skill. This plan defines what research we still need to do, what claims we need to validate, and what the research brief will say.

## The thesis (one paragraph)

An agent session is a build; the repository is its source — the checks, tests, scoped context, and skills the agent runs against. A correction to agent output is a bug report, and durable fixes belong in the source, at the strongest tier that can hold them: enforced check > regression test > scoped context > skill > discard. With model weights frozen for closed frontier models, the repository is the only trainable component a team has. RLP is the discipline of compiling corrections into it.

## What we have (from the playbook)

1. **The protocol spec (v0.2)** — principles, router, artifact contract, ritual, acceptance tests, measurement, adoption, threats to validity
2. **The citation pool (109 entries)** — peer-reviewed papers, industry docs, vendor claims, practitioner reports
3. **The PREMISE.md** — the research premise with evidence and citations
4. **The scripts** — `capture_learnings.py` (auto-capture from PR reviews), `learning_health.py` (staleness, recurrence, budget, firings)
5. **The skill** — `rlp-architect` with scaffold, audit, and triage modes
6. **The ICM factory structure** — the repo itself as a self-describing, self-improving workspace

## What we need to research (open questions)

### Q1: Does the tier ladder actually prevent recurrence?
**Claim:** Routing corrections to the strongest tier (check > test > context > skill > discard) prevents the same class of mistake from recurring.
**Evidence we have:** Google Tricorder (decade of production), Uber uReview, Semgrep doctrine. But these are for human review, not agent corrections.
**What we need:** Field data from teams using RLP with coding agents. Does the repeat-correction rate actually drop?
**Method:** 6-week validation with retro-classified baseline (as specified in the playbook). Track repeat corrections in promoted classes.

### Q2: Is the 1,500-token budget the right number?
**Claim:** Always-on context ≤ 1,500 tokens is the right forcing function.
**Evidence we have:** Context rot research, NoLiMa, "The Power of Noise." These prove context degrades performance, but don't specify where the line sits.
**What we need:** Empirical testing of different budget levels. Does 1,500 work? Is 2,000 better? Is 1,000 better?
**Method:** A/B testing with different budget thresholds. Measure agent success rate and inference cost at each level.

### Q3: Does automated capture starve or flood the funnel?
**Claim:** Auto-capturing from PR review comments keeps the funnel fed without flooding it.
**Evidence we have:** Qodo mines PR history; Devin auto-suggests knowledge. But no published data on capture quality.
**What we need:** Data on what percentage of auto-captured candidates get promoted vs. discarded.
**Method:** Run `capture_learnings.py` for 4 weeks. Measure: candidates captured, candidates triaged, candidates promoted, candidates discarded. Healthy funnels discard most.

### Q4: Does the "second occurrence" rule prevent over-promotion?
**Claim:** Waiting for the second occurrence before promoting prevents promoting noise.
**Evidence we have:** Harness engineering says "whenever an issue happens multiple times." Qodo mines only accepted, repeated comments.
**What we need:** Data on how many one-off corrections would have been promoted without the rule, and whether they would have been useful.
**Method:** Retro-classify 4 weeks of corrections. Compare: what would have been promoted with vs. without the second-occurrence rule.

### Q5: Does the monthly prune actually delete stale artifacts?
**Claim:** Monthly prune with `verify_by` dates keeps the repository from accumulating stale context.
**Evidence we have:** Tricorder's probation system. Copilot's 28-day expiry.
**What we need:** Data on how many artifacts are pruned, how many are re-justified, and whether pruning improves agent performance.
**Method:** Run the protocol for 3 months. Track prune outcomes. Measure agent performance before and after prune.

### Q6: What does the vault-pull perspective add?
**Claim:** The pull-based, research-first model (90/10/1 — sources/insights/pull) improves the protocol by grounding corrections in research.
**Evidence we have:** The vault-pull skill works in practice for Auraprix. But no comparative data.
**What we need:** Case studies of teams using vault-pull + RLP together vs. RLP alone.
**Method:** Document the Auraprix experience as a case study. Compare with teams using RLP without the vault-pull model.

### Q7: How does RLP compare to alternatives?
**Claim:** RLP is more effective than alternatives (vector memory, knowledge graphs, trajectory stores, no system at all).
**Evidence we have:** The playbook's evidence review scored heavier options worse. But no head-to-head comparison.
**What we need:** Comparative studies. Even informal ones — teams trying different approaches and reporting results.
**Method:** Recruit 3-5 teams. Each tries a different approach for 6 weeks. Compare repeat-correction rates, agent success, and maintenance burden.

## Research brief structure

The research brief will follow this structure:

1. **The problem** — corrections don't persist; weights are frozen; repo is the only trainable component
2. **The evidence** — what's proven, what's supported, what's emerging, what's speculative
3. **The protocol** — the tier ladder, the router, provenance, budget, retirement, liveness
4. **What we don't know yet** — the open questions above
5. **How we'll find out** — the validation methods above
6. **What practitioners contribute** — field reports, case studies, corrections to the protocol itself
7. **What we deliberately reject** — vector memory, knowledge graphs, autonomous promotion, ungated auto-memory
8. **Threats to validity** — honest about what's observational vs. controlled, what's confounded

## What we need from the community

1. **Field reports** — teams using RLP reporting what worked, what didn't, what surprised them
2. **Case studies** — documented experiences with before/after data
3. **Corrections to the protocol** — filed as issues or PRs, triaged through the protocol's own router
4. **Validation data** — teams running the 6-week validation and sharing results
5. **Alternative approaches** — teams trying different methods and comparing

## Next steps

1. **Write the research brief** — the first artifact in this repo. Based on the playbook's PREMISE.md, extended with the open questions and validation plan.
2. **Build the skill** — execute the playbook phases to create `rlp-architect`.
3. **Set up the community** — Skool.com community for practitioners.
4. **Recruit pilot teams** — 3-5 teams willing to run the 6-week validation.
5. **Publish** — the brief, the skill, and the first round of validation data.
