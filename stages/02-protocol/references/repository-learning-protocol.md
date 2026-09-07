# Repository Learning Protocol

**Turning agent corrections into durable engineering artifacts — a composition of current standards.**

Draft v0.2 · 2026-08-26 · incorporates first-round team review (capture, recurrence, budget, eval scoping, liveness)
Companion evidence review: *Managed Learning Arena* (research report, Aug 2026)

---

## Abstract

Teams using coding agents on closed-weight models re-buy the same discoveries. A reviewer corrects the agent's timezone handling on Tuesday; a different session makes the same mistake on Thursday. The correction was real work; nothing kept it. Model weights can't hold the lesson — frontier coding models used through tools like Cursor cannot be fine-tuned by their customers, and the industry is reducing weight access, not expanding it [D41, D42, D8]. The repository is the only substrate this class of team has.

The Repository Learning Protocol (RLP) is our name for a loop assembled entirely from existing, named standards: cross-tool context files and skills for scoped delivery (AGENTS.md, `.cursor/rules`, SKILL.md) [D16, D4, D8]; linters, Semgrep rules, tests, and CI for enforcement [D35]; eval-from-failure practice for verification [D63, D5]; git pull requests for gated promotion; and the lifecycle governance norms that static-analysis platforms proved at scale — usefulness thresholds, probation, retirement [P51, P52]. Nothing here is new. The contribution is the assembly: automated capture that keeps the funnel fed, a router that decides what a correction becomes, an artifact contract that makes every learning traceable and deletable, a thirty-minute weekly ritual that keeps the loop alive, and five acceptance tests that tell you whether it is working. The protocol is deliberately gated where the evidence demands it: LLM-generated context files measurably reduce agent success [P33], unreviewed self-generated knowledge drifts [P42, P30], and agent memory is a demonstrated attack surface [P23, D37, D40] — so nothing becomes durable without a human merging a PR, and everything durable carries an expiry.

RLP closes a loop the Interpretable Context Methodology paper names but leaves as future work: recurring human edits are "debugging information… point[ing] to fixable source-level problems," and a workspace that incorporates them "become[s] a system that gets better with use" [P57, §6.3]. ICM structures context; RLP is the metabolism that feeds, weighs, and prunes it. We intend to package the protocol as an adoption skill, in the spirit of icm-architect.

---

## 1. The missing loop

Coding agents get corrected constantly — in code review, in chat, by CI, occasionally by production. Almost none of it persists. The correction lives in a review thread; the thread scrolls away; the next agent session starts from the same weights and the same repo and makes the same mistake. Practitioners have started naming this gap from different directions: *harness engineering* says improve the controls "whenever an issue happens multiple times" [D66]; *compounding engineering* says turn "every pull request, bug fix, and code review into permanent lessons" [D67]; the ICM paper, from the content-pipeline side, observes that when a practitioner "edits the same kind of thing in the same stage's output three runs in a row," the system should "suggest a source-level change… turning one-off fixes into durable system improvements" — and marks the mechanism unimplemented [P57].

RLP is that mechanism, specified for software repositories where the agents are coding agents (Cursor, Claude Code, Copilot's coding agent, Devin) and the "source" that should improve is the repository itself: its checks, its tests, its context files, its documented decisions.

Two boundaries define the design space:

1. **Weights are frozen.** OpenAI is winding down customer fine-tuning entirely; Anthropic offers it only for a 2024-era small model; Cursor cannot run a customer-tuned model in its agent [D41, D42, D8]. Whatever the team learns must live in the repo.
2. **Context is not free.** Model performance degrades as input grows even on simple tasks [D59]; semantically-related-but-wrong content is the most damaging kind [P41]; and the only controlled study of repository context files found no general success improvement, a 20%+ inference-cost increase, and a small *negative* effect from LLM-generated files [P33]. A learning system that answers every lesson with "add more context" makes the agent worse.

These two constraints shape everything below: the repo is the substrate, and admission to it must be selective, scoped, gated, and reversible.

## 2. What is being composed

RLP invents no primitives. Each element is current practice with a name and, where it exists, evidence.

**2.1 Scoped context standards.** AGENTS.md is Linux Foundation-governed, read by 26 tools, used by 60k+ open-source repos, with nearest-file precedence for monorepos [D16]. Cursor adds glob-scoped rules and description-triggered skills [D8]; the Agent Skills format standardizes procedures that cost ~100 tokens until invoked [D4]. The evidence discipline: *developer-written, specific* instruction files are the ones that pay — and even that claim needs its caveat stated where it's made. The strongest field record — dotnet/runtime lifting its Copilot coding-agent PR success from 38.1% to 69% across 878 PRs while iterating one instructions file [D19] — is observational, confounded with fourteen months of model upgrades, and in tension with the controlled study's finding of no general success gain [P33]; read it as evidence of direction under sustained human curation, not of magnitude (§6). Auto-generated repository overviews measurably don't pay [P33]. Vendors' own guidance converges on brutal concision: "would removing this line cause mistakes? If not, cut it" [D2, D3].

**2.2 Deterministic-check governance.** Google's Tricorder ran the full knowledge lifecycle in production for a decade: every automated finding carries a "Not useful" control; a ≥10% not-useful rate puts a check on probation; >25% and it may be switched off immediately [P51, P52]. Uber's uReview rebuilt the same loop for LLM-generated review comments (65% of its comments get addressed — more than its human reviewers' 51% — with category-level suppression of noise) [D29]; Google's AutoCommenter moved perceived usefulness from 54% to ~80% mostly by *suppressing* seventeen non-actionable advice categories [P53]. Semgrep states the routing doctrine outright: "automate PR comments that you frequently make in code reviews" [D35]. RLP imports these norms wholesale: enforcement beats advice, usefulness is measured by developer action, and retirement is a scheduled activity, not an aspiration.

**2.3 Eval-from-failure practice.** The converged loop of AI-product engineering: error analysis first, real failures become labeled cases, cases become regression evals, saturated evals become the permanent suite [D63, D64, D5]. For a coding repo, the humbler form is older: every shipped bug earns a regression test.

**2.4 Incident-learning practice.** Blameless postmortems are the mature human-side template — triggered capture, a reviewed artifact, tracked prevention items [D57, D58]. RLP miniaturizes the ritual to a weekly half hour, because at ten engineers the volume is candidates-per-week, not incidents-per-quarter.

**2.5 The constraints as design inputs.** Unreviewed self-generated knowledge degrades — LLMs cannot reliably self-correct without external feedback [P42], and auto-extracted skills recover less than half the value of human-written ones [P30]. Agent memory is a practical attack surface — sub-0.1% poisoning of a memory store yields ≥80% attack success in research settings [P23], Microsoft documents memory poisoning as a first-class failure mode [D37], and a coding agent's memory tool was exploited in the wild for persistent exfiltration [D40]. The industry has already reacted: Cursor removed its editor auto-memory feature outright [D14]; GitHub shipped Copilot Memory fenced with code-validation and a 28-day automatic expiry [D18]; Devin and Qodo suggest knowledge but require human approval before it sticks [D7, D48]. RLP's gates are not caution theater; they are the documented survival pattern.

## 3. The protocol

### 3.1 Principles

Each is borrowed; the credit is the point.

1. **Determinism first.** If a lesson can fire in CI, it does not go in a prompt. (Semgrep doctrine [D35]; Tricorder workflow-integration finding [P52].)
2. **The second occurrence is the signal.** Once is noise; twice is a pattern. Security- or corruption-class lessons skip the gate. (Harness engineering [D66]; error-analysis-first [D63]; Qodo mines only *accepted, repeated* review comments [D48].)
3. **Humans gate promotion.** Nothing an LLM produced becomes durable without a person merging it. The gate sits at promotion, not capture: automated drafting of candidates is encouraged (§3.4); automated admission to durable context is forbidden. (Self-correction limits [P42]; the approve-before-save consensus across Devin, Qodo, Semgrep, Augment [D7, D48].)
4. **Provenance on everything.** Every durable artifact records the correction that earned it, its owner, and its verify-by date. (Tricorder's per-check accountability [P51]; postmortem practice [D57].)
5. **Retirement is scheduled.** Stale guidance is not neutral — it is related-but-wrong context, the worst kind [P41]. Verify-by dates plus a monthly prune; a budget forces one-in-one-out. (Tricorder probation [P51]; Copilot's 28-day expiry [D18].)
6. **Deliver through native mechanisms.** Rule types, glob scoping, skill triggers, and nested AGENTS.md are the resolver. Build no custom retrieval. (Tool docs [D16, D4, D8]; simplicity findings [P33, P34].)

### 3.2 The router

The core of RLP is a single decision procedure, applied to every correction, discovery, failure, or repeated success worth a thought:

```
ROUTE(observation):
  security / data-corruption class
      → deterministic check + doc line, THIS WEEK (no frequency gate)
  first occurrence
      → one line in the learnings inbox (date · link · slug · sentence); stop
  recurring (≥2) or expensive:
    1. mechanically checkable?      → lint rule / Semgrep rule / type / CI check
                                       (+ optional one-line rule naming the helper)
    2. verifiable by execution?     → regression test
                                       (agent-behavioral eval cases: later horizon, §4)
    3. stable convention or "why"?  → scoped rule (nested AGENTS.md / .mdc glob)
                                       or ADR / knowledge module
    4. reusable procedure, a "how"? → SKILL.md (name+description = when; body = how)
    5. still uncertain?             → stays in inbox with an expiry;
                                       the default outcome is deletion
```

Order matters. Try the deterministic tier even when the item smells like documentation: a Semgrep message that names the fix reaches the agent inside its own CI feedback loop — at the exact moment it can act, at zero context cost, for every tool and every teammate, forever. The hierarchy in force is: **enforced > executable-verified > curated context on demand > curated context always-on > unreviewed memory** — and RLP simply has no route to the last tier. There is deliberately no vector store of corrections, no knowledge graph, no trajectory database: the evidence review found these carry the worst evidence-to-burden ratio and concentrate the attack surface.

Two honest notes on the router's inputs and outputs. First, **recurrence is detected by the inbox, not by anyone's memory**: every entry carries a short class slug (`naive-datetime`, `escrow-rounding`), new entries are matched against open slugs at capture time, and `learning_health.py` tallies recurrences per slug. Detecting "≥2" is therefore only as good as capture coverage — which is why capture is automated in §3.4; the inbox is the recurrence ledger, and a starved inbox starves the whole router. Second, **route 2 currently means regression tests.** Repo-level agent-behavior evals — replaying "does the agent still mishandle timezones?" as a scored scenario — are the motivating case, but they are far more expensive to build than lint rules and are explicitly the later horizon of §4. Until that harness exists, behavior-class lessons are served by the deterministic and test tiers: the abstract's timezone correction routes to a Ruff/Semgrep check plus a regression test, not to an eval.

### 3.3 The artifact contract

Every promoted artifact — rule, Semgrep check, knowledge module, skill — carries provenance frontmatter:

```yaml
# provenance
date: 2026-08-27          # when promoted
source: MR !412, !418     # the corrections that earned it
owner: <engineer>         # who answers for it
scope: api/**             # where it applies (globs)
verify_by: 2027-03-01     # when it must be re-justified or deleted
```

Placement follows what tools natively read — locations are load-bearing, not aesthetic:

| Knowledge kind | Artifact | Location | Who consumes it |
|---|---|---|---|
| Mechanically checkable | lint / Semgrep / CI check | `semgrep/`, linter config | CI, pre-commit — agents and humans alike |
| Behavior that must hold | regression test / eval case | `tests/`, `evals/` | CI |
| Convention, decision, "why" | scoped rule · ADR · knowledge module | nested `AGENTS.md`, `.cursor/rules/*.mdc`, `docs/adr/`, `docs/knowledge/<domain>/` | agent context, on scope match |
| Reusable procedure, "how" | skill | `.cursor/skills/<name>/SKILL.md` | agent, on trigger |
| Candidate / uncertain | one-line entry | `docs/learnings/inbox.md` | weekly triage |
| Triage decisions | log line | `docs/learnings/decisions.md` | future humans and agents asking "why does this rule exist?" |

One hard budget: **always-on context ≤ ~1,500 tokens** (root AGENTS.md plus any `alwaysApply` rules). The number is a forcing function, not a derived threshold: the evidence establishes that always-on context carries real accuracy and cost penalties [P33, D59], not where the line sits — a line is chosen so that additions must compete. Past it, adding a line means deleting a line. `learning_health.py` enforces the budget in CI; the budget test's checker is the build, not a vibe. Everything else loads on scope or trigger.

### 3.4 The ritual

- **Capture (automated by default; manual always available):** a capture agent (`scripts/capture_learnings.py`, run on merge or nightly) drafts inbox entries from merged-PR review threads and CI failures — one line each: date · link · class slug · sentence. Anyone can also append a line by hand in 30 seconds for chat-session discoveries. Capture is automated because the funnel otherwise starves at the top — corrections happen in review threads and agent chats, and nobody context-switches to a markdown file — and because capture is pre-gate and low-stakes; the precedents are Qodo mining PR history automatically while gating activation on an admin [D48] and Devin auto-suggesting knowledge behind an approve/dismiss step [D7]. Two invariants keep automation safe: **the inbox is read by triage, never loaded as agent context** — drafted candidates cannot pollute sessions pre-review — and the human gate stays exactly where principle 3 puts it, at promotion.
- **Weekly triage (30 minutes, one slot):** run the router over the inbox; open at most ~3 promotion PRs; log every candidate's fate in `decisions.md`. The cap forces prioritization and keeps the gate honest.
- **Monthly prune (inside one triage slot):** run the staleness report; every artifact past `verify_by` is re-verified, rewritten, or deleted. Deletion is a success mode.

### 3.5 Acceptance tests

ICM has its walk test [P57]; RLP has five. A repository is running RLP when:

1. **Repeat test.** For any promoted learning, a fresh agent session facing the original situation is *prevented* (the check fires) or *steered* (the scoped context loads) — with no human reminding it.
2. **Provenance test.** Any durable artifact traces to the correction that earned it in one hop (its frontmatter, or `decisions.md`).
3. **Deletion test.** Any learning can be fully removed by reverting one PR.
4. **Budget test.** Always-on context is at or under the declared budget; the number is checked, not vibed.
5. **Liveness test.** Every promoted deterministic artifact has *observably* fired at least once by its first prune — recorded in CI logs or the counters `learning_health.py` collects — or is explicitly re-justified. A pre-commit hit that leaves no trace does not count; a check that runs only in pre-commit must log its hits or also run in CI. A rule that never fires is either total victory or dead weight; the prune decides which.

### 3.6 Measurement, sized honestly

Primary: **repeat-correction rate** (same-class corrections recurring after promotion — the definition of the system working), **promotion liveness**, the **capture→promote→discard funnel** (healthy funnels discard most), and the **token budget**. Anti-metrics, explicitly rejected: artifact count (cap it instead), and self-reported speedup — the one RCT in this space found developers 19% slower while believing themselves 20% faster [P48]. At ten engineers nothing reaches significance; these are decision heuristics, and the design compensates by favoring artifacts whose value does not depend on fine measurement (a lint rule either fires or it doesn't) and by making reversal one revert.

## 4. Adoption

**Day one** (fits the existing monorepo; every location is one a tool already reads):

```
repo/
├── AGENTS.md                      # <200 lines, tool-agnostic; links out, never inlines
├── api/AGENTS.md                  # scoped conventions
├── frontend/AGENTS.md
├── .cursor/
│   ├── rules/*.mdc                # glob-scoped, provenance headers
│   ├── skills/                    # procedures (added as they earn it)
│   └── commands/promote-learning.md   # walks the router, drafts the artifact
├── docs/
│   ├── adr/
│   ├── knowledge/<domain>/        # modules: specific, referenced, provenance-fronted
│   └── learnings/{inbox.md, decisions.md}
├── semgrep/rules.yml
├── evals/                         # later horizon
└── scripts/
    ├── capture_learnings.py       # drafts inbox lines from merged-PR reviews + CI failures
    └── learning_health.py         # staleness + slug-recurrence tally + CI budget check
```

**Validation (six weeks, ~1 day setup):** baseline by retro-classifying the last four weeks of review comments on agent changes into mistake classes; then run the ritual. Success = repeat corrections in promoted classes down ≥50%, ≥70% of deterministic promotions have observably fired, and the weekly slot survived without being pushed. Failure (any two: <20% reduction; a write-only inbox; artifacts that never fire; the ritual skipped three times) means **stop and diagnose — do not escalate to heavier infrastructure**. With auto-capture in place, a starved funnel is itself a finding: it means the team's actual repetition base rate is too low for the router to matter, not that capture friction hid it. The evidence review scored every heavier option worse on exactly the dimensions a small team cannot afford.

**Later, only if the curated corpus outgrows native scoping:** retrieval over *reviewed* modules (never raw exhaust); distilled experience banks in the SWE-Exp mold [P26] once a production implementation exists; metric-gated prompt optimization once an eval set exists to be its metric.

## 5. Where this works, and where it does not

RLP assumes a repository with CI, a team small enough for one triage slot, and enough task repetition for lessons to recur — a ~10-person product team in a monorepo sits in the center of that envelope. It degrades predictably outside it: with no CI the deterministic tier (the best tier) is unavailable; on one-off prototypes there is no repetition to amortize; a team unwilling to protect thirty minutes a week will watch the inbox go write-only, and should prefer plain "fix it twice, then write the test" minimalism over a decaying process. RLP is also not a memory platform and does not want to become one: routes to vector experience stores, knowledge graphs, and autonomous promotion are omitted on evidence, not oversight.

## 6. Threats to validity

The composition is evidenced; the *composite* is not: no controlled study evaluates this exact protocol end-to-end, and its components carry different confidence levels — the deterministic-governance precedents are decade-scale production evidence [P51, P52, D29, P53], while the context-file evidence is one controlled study plus one strong observational record that disagree about magnitude [P33, D19]. Measurement at n=10 is heuristic. Model progress may shrink the context tier's value (research gains from experience reuse already shrink as base models strengthen [P26]); the deterministic tier survives that trend, which is partly why it is ranked first. And the six-week validation is self-run, subject to the same self-assessment bias METR documented [P48] — which is why its success criteria are counts of recurrences and firings, not impressions.

## 7. Future work: the adoption skill

The ICM paper ships icm-architect, a workspace-builder that encodes the methodology's conventions so practitioners don't have to internalize them first. RLP intends the same: an **rlp-architect** skill that (a) scaffolds the day-one layout into an existing repo, (b) installs the capture agent (`capture_learnings.py`), the `/promote-learning` router command, and `learning_health.py`, (c) walks the team through the retro-classified baseline, and (d) runs the weekly triage as a guided session — capture review, router calls, drafted promotion PRs, decisions log. The skill is the distribution mechanism; this document is its specification. A second bridge is specific to ICM users: in an ICM workspace, RLP's router is a natural implementation of §6.3's edit-tracking loop — recurring stage-output edits become candidates, and promotion targets the stage contract or reference files instead of repo rules.

---

## References

Citations use the keys from `stages/01-research/references/REFERENCES.md` (the canonical citation pool). Key sources:

- [P57] Van Clief, J., McDermott, D. — *Interpretable Context Methodology* (arXiv:2603.16021)
- [D16] AGENTS.md specification (Agentic AI Foundation / Linux Foundation)
- [D4] Anthropic — *Agent Skills*
- [D2, D3] Anthropic — Claude Code memory & best-practices documentation
- [D8] Cursor — Rules / Skills / Hooks documentation
- [P33] Gloaguen et al. — *Evaluating AGENTS.md* (arXiv:2602.11988) — keystone
- [D19] Toub, S. — *Ten Months with Copilot Coding Agent in dotnet/runtime* — keystone
- [P34] Lulla et al. — *Impact of AGENTS.md on Efficiency* (arXiv:2601.20404)
- [P51, P52] Sadowski et al. — *Tricorder* (ICSE 2015, CACM 2018) — keystone
- [D35] Semgrep — *Rule ideas: automate PR comments*
- [D29] Uber Engineering — *uReview*
- [P53] Vijayaraghavan et al. — *AutoCommenter* (AIware 2024)
- [D63] Husain, H. — *Your AI Product Needs Evals*
- [D64] LangSmith evaluation documentation
- [D5] Anthropic — *Demystifying evals for AI agents*
- [D57] Google SRE Book — *Postmortem Culture*
- [D58] Allspaw, J. — *Blameless PostMortems and a Just Culture* (Etsy)
- [D59] Chroma — *Context Rot*
- [P41] Cuconasu et al. — *The Power of Noise* (SIGIR 2024)
- [P42] Huang et al. — *LLMs Cannot Self-Correct Reasoning Yet* (ICLR 2024)
- [P23] Chen et al. — *AgentPoison* (NeurIPS 2024)
- [D37] Microsoft — *Taxonomy of Failure Modes in Agentic AI Systems*
- [D40] Rehberger, J. — *Windsurf SpAIware exploit*
- [D14] Cursor staff — Memories feature removal
- [D18] GitHub — *Copilot Memory (public preview)*
- [D7] Cognition — Devin Knowledge documentation
- [D48] Qodo — Rule Miner documentation
- [P48] METR — *Impact of Early-2025 AI on Experienced OSS Developers* — keystone
- [D66] Böckeler, B. — *Harness engineering for coding agent users*
- [D67] Klaassen, K. — *Compounding engineering*
- [D41, D42] OpenAI deprecations; Anthropic/AWS Haiku tuning
- [P30] Zhong et al. — *SkillLearnBench*
- [P26] Chen et al. — *SWE-Exp*

Full annotated bibliography (109 entries) in `stages/01-research/references/REFERENCES.md`.

---

*Changelog — v0.2 (2026-08-26), from first-round team review: capture automated with the gate held at promotion and the inbox declared never-agent-context; the inbox specified as the recurrence ledger (class slugs, tallied by learning_health.py); the token budget labeled a forcing function and enforced in CI; route 2 honestly scoped to regression tests with agent-behavior evals deferred to §4; liveness redefined as observably fired; the dotnet/runtime figure caveated where it is cited.*
