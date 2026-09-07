# The Repo Learning Protocol: A Research Brief

**Version:** 0.1 (draft)  
**Date:** 2026-09-06  
**Status:** Research phase — open for peer review and field validation

---

## 1. The problem

Teams using coding agents on closed-weight models re-buy the same discoveries. A reviewer corrects the agent's timezone handling on Tuesday; a different session makes the same mistake on Thursday. The correction was real work; nothing kept it. The next agent session starts from the same weights and the same repo and makes the same mistake.

This is not a tooling problem. It is a **learning problem** — and the learning has nowhere to live.

### 1.1 Weights are frozen

OpenAI is winding down customer fine-tuning entirely (closed to new orgs May 2026; ends Jan 2027; GPT-5.x/codex never tunable) [D41]. Anthropic offers tuning only for a 2024-era small model via Bedrock [D42]. Cursor cannot run a customer-tuned model in Agent mode [D8]. Whatever a team learns cannot be compiled into the model. It must live somewhere else.

**Confidence: PROVEN.** This is documented vendor policy, not speculation.

### 1.2 Context is not free

Model performance degrades as input grows even on simple tasks — Chroma's "Context Rot" (2025) [D59] and NoLiMa (ICML 2025) [P39] establish this. Semantically-related-but-wrong content is the most damaging kind — "The Power of Noise" (SIGIR 2024) [P41]. The only controlled study of repository context files (Gloaguen et al., arXiv:2602.11988) [P33] found no general success improvement, ~20% added inference cost, and a small *negative* effect from LLM-generated files.

**Confidence: SUPPORTED.** Multiple peer-reviewed studies converge. The magnitude is debated; the direction is not.

### 1.3 The repository is the only trainable component

If weights are frozen and context degrades with volume, then the repository — its checks, tests, scoped context files, and skills — is the only substrate a team has for compiling corrections into durable improvements. The question is not *whether* to use the repo as the learning substrate, but *how* — with what discipline, what gates, and what evidence that it works.

**Confidence: SUPPORTED.** The conclusion follows from 1.1 and 1.2. The "how" is what RLP specifies.

---

## 2. The evidence

### 2.1 Deterministic checks have a decade of production evidence

Google's Tricorder ran the full knowledge lifecycle in production for a decade: every automated finding carries a "Not useful" control; a ≥10% not-useful rate puts a check on probation; >25% and it may be switched off immediately [P51, P52]. Uber's uReview rebuilt the same loop for LLM-generated review comments (65% of its comments get addressed — more than its human reviewers' 51% — with category-level suppression of noise) [D29]. Google's AutoCommenter moved perceived usefulness from 54% to ~80% mostly by *suppressing* seventeen non-actionable advice categories [P53]. Semgrep states the routing doctrine outright: "automate PR comments that you frequently make in code reviews" [D35].

**Confidence: PROVEN.** Decade-scale production evidence at Google, Uber, and across Semgrep's user base.

**What this means for RLP:** The deterministic tier (lint rules, Semgrep, CI checks) is the strongest tier. If a correction can be enforced mechanically, it should be. Prose is not the primary carrier.

### 2.2 Human-written scoped context files pay — with a caveat

The strongest field record — dotnet/runtime lifting Copilot coding-agent PR success from 38.1% to 69% across 878 PRs while iterating one instructions file [D19] — is observational and confounded with fourteen months of model upgrades. It is in tension with the controlled study's finding of no general success gain [P33]. Read it as evidence of *direction under sustained human curation*, not of magnitude.

**Confidence: SUPPORTED (direction), EMERGING (magnitude).** The direction is consistent across studies; the magnitude is contested.

**What this means for RLP:** Scoped context files (nested AGENTS.md, `.cursor/rules`, skill triggers) are a valid tier — but they are not the first resort. They sit below checks and tests in the tier ladder. And they must be curated: auto-generated context files measurably don't pay [P33].

### 2.3 Eval-from-failure is converged practice

The converged loop of AI-product engineering: error analysis first, real failures become labeled cases, cases become regression evals, saturated evals become the permanent suite [D63, D64, D65, D5]. For a coding repo, the humbler form is older: every shipped bug earns a regression test.

**Confidence: PROVEN.** This is standard practice across AI-product teams and has been standard SWE practice for decades.

**What this means for RLP:** The test tier (regression tests pinning the exact failure) is the second-strongest tier. A correction that can be verified by execution becomes a test, not a prose note.

### 2.4 Incident learning is mature practice

Blameless postmortems are the mature human-side template — triggered capture, a reviewed artifact, tracked prevention items [D57, D58]. RLP miniaturizes the ritual to a weekly half hour, because at ten engineers the volume is candidates-per-week, not incidents-per-quarter.

**Confidence: PROVEN.** Google SRE and Etsy established this practice over a decade ago.

**What this means for RLP:** The weekly triage is not a novel invention. It is a postmortem ritual scaled down to team size.

### 2.5 What doesn't work

**Unreviewed self-generated knowledge drifts.** LLMs cannot reliably self-correct without external feedback [P42]. Auto-generated skills recover less than half the value of human-authored ones (SkillLearnBench) [P30].

**Agent memory is a practical attack surface.** Sub-0.1% poisoning of a memory store yields ≥80% attack success (AgentPoison, NeurIPS 2024) [P23]. Microsoft documents memory poisoning as a first-class failure mode [D37, D38]. A coding agent's memory tool was exploited in the wild (Windsurf, 2025) [D40].

**The industry already retreated.** Cursor removed its editor auto-memory feature outright (v2.1.x) [D14]. Windsurf deprecated memories for skills [D48]. The survivors are fenced: GitHub Copilot Memory uses code-validation and 28-day auto-expiry [D18]; Devin and Qodo suggest knowledge but require human approval [D7, D48].

**Confidence: PROVEN.** These are documented product decisions and peer-reviewed security research.

**What this means for RLP:** There is no memory tier. No vector stores, no knowledge graphs, no ungated auto-memory. The gates (human promotion, provenance, retirement) are not caution theater — they are the documented survival pattern.

---

## 3. The protocol

### 3.1 The tier ladder

Every correction is routed to the strongest tier that can hold it:

```
enforced check > regression test > scoped context (on demand) > skill > discard
```

Order matters. A Semgrep message that names the fix reaches the agent inside its own CI feedback loop — at the exact moment it can act, at zero context cost, for every tool and every teammate, forever. The hierarchy in force is: **enforced > executable-verified > curated context on demand > curated context always-on > unreviewed memory** — and RLP has no route to the last tier.

**Confidence: SUPPORTED.** The tier ordering follows from the evidence in §2. The specific ordering is a design decision grounded in evidence, not a directly tested hypothesis.

### 3.2 The router

A single decision procedure applied to every correction:

1. Security or data-corruption class? → deterministic check NOW (skip the frequency gate) + a doc line.
2. First occurrence? → one line in the learnings inbox; stop.
3. Recurring (≥2) or expensive? → route to the strongest tier that fits (check → test → context → skill → discard).

The second occurrence is the signal. Once is noise; twice is a pattern. This prevents over-promotion: most corrections are one-offs and should die in the inbox.

**Confidence: PLAUSIBLE.** The "second occurrence" rule is grounded in harness engineering practice [D66] and Qodo's mining of only accepted, repeated comments. But no controlled study validates this specific threshold.

**Open question (Q4):** Does the second-occurrence rule prevent over-promotion? See `research/RESEARCH-PLAN.md`.

### 3.3 Provenance and retirement

Every promoted artifact carries provenance: `date`, `source`, `owner`, `scope`, `verify_by`. The `verify_by` date is when the artifact must be re-justified or deleted. A monthly prune enforces this. Deletion is a success mode.

**Confidence: SUPPORTED.** Tricorder's probation system [P51, P52] and Copilot's 28-day expiry [D18] are production precedents.

### 3.4 The budget

Always-on context ≤ ~1,500 tokens (root AGENTS.md plus any always-on rules). The number is a forcing function, not a derived threshold: the evidence establishes that always-on context carries real accuracy and cost penalties [P33, D59], not where the line sits. Past the budget, adding a line means deleting a line.

**Confidence: PLAUSIBLE.** The concept is supported; the specific number is a design choice.

**Open question (Q2):** Is 1,500 tokens the right budget? See `research/RESEARCH-PLAN.md`.

### 3.5 Liveness

Every promoted deterministic artifact must observably fire by its first prune — recorded in CI logs or firing counters — or be explicitly re-justified. A rule that never fires is either total victory or dead weight; the prune decides which.

**Confidence: PLAUSIBLE.** The liveness concept follows from Tricorder's usefulness thresholds [P51, P52]. No direct study validates the specific "fire by first prune" rule.

---

## 4. What we don't know yet

The composition is evidenced; the *composite* is not. No controlled study evaluates this exact protocol end-to-end. The open questions are documented in `research/RESEARCH-PLAN.md`:

1. **Does the tier ladder prevent recurrence?** — field data needed
2. **Is 1,500 tokens the right budget?** — empirical testing needed
3. **Does auto-capture starve or flood the funnel?** — 4-week capture study
4. **Does "second occurrence" prevent over-promotion?** — retro-classification
5. **Does the monthly prune work?** — 3-month tracking
6. **What does the pull-based, research-first model add?** — case study
7. **How does RLP compare to alternatives?** — comparative study

---

## 5. How we'll find out

Six-week validation against a retro-classified baseline, judged on counts:
- Repeat corrections in promoted classes down ≥50%
- ≥70% of deterministic promotions observably fired
- The weekly ritual survived without being pushed (≥5/6 weeks)

Never on self-reported speed: the one RCT in this space (METR, 2025) [P48] found developers 19% slower with AI while believing themselves 20% faster.

On failure: stop and diagnose. Do not escalate to heavier infrastructure — every heavier option (vector memory, knowledge graphs, trajectory stores) scored worst on evidence, maintainability, small-team fit, and safety.

---

## 6. What practitioners contribute

1. **Field reports** — teams using RLP reporting what worked, what didn't, what surprised them
2. **Case studies** — documented experiences with before/after data
3. **Corrections to the protocol** — filed as issues or PRs, triaged through the protocol's own router (stage 04)
4. **Validation data** — teams running the 6-week validation and sharing results
5. **Alternative approaches** — teams trying different methods and comparing

Field feedback flows back through this repo's own inbox (`docs/learnings/inbox.md`) and is triaged in stage 04 — the workspace improves by its own protocol.

---

## 7. What we deliberately reject

No vector memory, no knowledge graph, no trajectory store, no ungated auto-memory, no autonomous promotion, no custom context resolver, no config framework, no server. These are omissions on evidence (see §2.5), not oversights. A future contributor proposing one should first produce the controlled evidence the premise says is missing.

---

## 8. Threats to validity

- **The composition is evidenced; the composite is not.** No controlled study evaluates RLP end-to-end. Components carry different confidence levels — the deterministic-governance precedents are decade-scale production evidence [P51, P52, D29, P53], while the context-file evidence is one controlled study plus one strong observational record that disagree about magnitude [P33, D19].
- **Measurement at n=10 is heuristic.** These are decision heuristics, not statistics.
- **Model progress may shrink the context tier's value.** Research gains from experience reuse already shrink as base models strengthen [P26]. The deterministic tier survives that trend, which is partly why it is ranked first.
- **The six-week validation is self-run.** Subject to the same self-assessment bias METR documented [P48] — which is why success criteria are counts of recurrences and firings, not impressions.
- **The "second occurrence" threshold is a design choice.** No evidence says 2 is better than 3 or 1. It is a judgment call grounded in practice but not tested.

---

## References

Full annotated bibliography (109 entries) in `stages/01-research/references/REFERENCES.md`. Key citations:

- [P33] Gloaguen et al. — *Evaluating AGENTS.md* (arXiv:2602.11988) — the controlled study of repo context files
- [P48] METR — *Impact of Early-2025 AI on Experienced OSS Developers* — the RCT showing 19% slower while believing 20% faster
- [P51, P52] Sadowski et al. — *Tricorder* (ICSE 2015, CACM 2018) — decade of production governance evidence
- [D19] Toub — *Ten Months with Copilot Coding Agent in dotnet/runtime* — the strongest field record for scoped context
- [D29] Uber — *uReview* — LLM review comments with 65% address rate
- [P42] Huang et al. — *LLMs Cannot Self-Correct Reasoning Yet* (ICLR 2024) — why human gates are necessary
- [P23] Chen et al. — *AgentPoison* (NeurIPS 2024) — why memory is an attack surface
- [D14] Cursor staff — Memories feature removal — why the industry retreated from auto-memory

---

## Changelog

- v0.1 (2026-09-06): Initial draft. Based on the RLP playbook PREMISE.md, extended with open questions, validation plan, and community contribution model.
