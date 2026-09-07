# Release notes

Append-only record for each completed release pass.

---

### Pass 1 record

**Pass:** Pass 1 — Plugin contract  
**Commit:** `1e6d913`  
**Outcome:** Plugin docs and installer aligned with observed Devin CLI behavior; structural tests pass. Plugin-install verification commands (`devin plugins install --local`, `devin plugins list`, `devin plugins info`) could not be re-run in this session because the CLI did not recognize the stored credentials as logged in.  
**Evidence:** `tests/test_skill.sh` 23 passed; `tests/test_walk.sh` 14 passed; `skill/rlp-architect/assets/tests/test_payload.sh` 12 passed; `shasum -a 256 -c SHA256SUMS` all OK.  
**Findings repaired:** Invocation syntax `/rlp-architect` → `/rlp-architect:rlp-architect`; installer changed to `devin plugins install --local`; test asserts `--local`; SKILL.md and migration guide use "staged workspace" instead of "ICM workspace".  
**Human decision:** Proceed without re-running authenticated plugin-management commands and continue to Pass 2.  
**Next pass authorized:** Pass 2 — Clean-room package.

### Pass 2 record

**Pass:** Pass 2 — Clean-room package  
**Commit:** `bcbea61`  
**Outcome:** Clean-room copy of the repository passes the entire local verification suite from the README instructions; no package-boundary or path failures found. The plugin-install step (`scripts/install-skill.sh`) could not be exercised because it requires a logged-in Devin CLI.  
**Evidence:** Copied repo to a temp directory; ran `tests/test_skill.sh` (23 passed), `tests/test_walk.sh` (14 passed), `skill/rlp-architect/assets/tests/test_payload.sh` (12 passed), and `shasum -a 256 -c SHA256SUMS` (all OK).  
**Findings repaired:** None.  
**Human decision:** Treat plugin-install verification as covered by Pass 1 caveat; continue to Pass 3.  
**Next pass authorized:** Pass 3 — Empty-repository scaffold.

### Pass 3 record

**Pass:** Pass 3 — Empty-repository scaffold  
**Commit:** `b194512`  
**Outcome:** Scaffold fixes applied and verified on a fresh Git repository: the generated router no longer links to a missing ADR, and scaffold now copies the bundled `stages/00-learn/CONTEXT.md`. Health command runs; second run would be a no-op. The actual skill invocation could not be exercised because the Devin CLI plugin-management commands require authentication that is not persisting in this session.  
**Evidence:** After fixes, created temp repo; copied docs/learnings/{inbox,decisions}.md, scripts/{capture_learnings,learning_health}.sh, docs/rlp-architect/templates/*, AGENTS.md seed, `assets/stages/00-learn/CONTEXT.md`, and `.devin/CLAUDE.md` command note. `learning_health.sh` reported `Budget: 0 / 1500 tokens (OK)`. No skill bundle copied to project config; no templates placed in active paths; no broken ADR reference. `tests/test_skill.sh` passes (24/24).  
**Findings repaired:** Removed broken ADR link from `AGENTS.md.seed`; added `assets/stages/00-learn/CONTEXT.md` template; updated `SKILL.md` scaffold step to copy it; added test assertion; regenerated SHA256SUMS.  
**Findings to triage:** None.  
**Human decision:** Continue to Pass 4 — Existing-workspace discovery.  
**Next pass authorized:** Pass 4 — Existing-workspace discovery.

### Pass 4 record

**Pass:** Pass 4 — Existing-workspace discovery  
**Commit:** (no source change; verification only)  
**Outcome:** Scaffold on a disposable Content Engine copy correctly classifies the repo as an existing staged workspace and proposes no writes. The temp copy already has router, editor pointer, 10 stage contracts, learning logs, RLP scripts, and an ADR. The canonical skill must not add `stages/00-learn/` or replace `AGENTS.md` in this case.  
**Evidence:** Created temp copy of Content Engine at `/tmp/content-engine-pass4-77067`; inspected `AGENTS.md`, `CLAUDE.md`, `CONTEXT.md`, `stages/*/CONTEXT.md`, `docs/learnings/`, `docs/adr/`, `scripts/`, and `.devin/`. Simulated scaffold proposal: no changes. `git status --short` was empty; `./scripts/learning_health.sh -i docs/learnings/inbox.md` ran successfully.  
**Findings repaired:** None.  
**Findings to triage:** The Content Engine has a project-local skill copy at `.devin/skills/rlp-architect/`. The canonical RLP runbook specifies that the generalized skill should not be copied into project configuration; this is existing field state, not a scaffold defect, but should be migrated or removed during Pass 9.  
**Human decision:** Continue to Pass 5 — Audit semantics.  
**Next pass authorized:** Pass 5 — Audit semantics.

### Pass 5 record

**Pass:** Pass 5 — Audit semantics  
**Commit:** (no source change; verification only)  
**Outcome:** Audit classification behaves as specified: only explicitly-passed always-on files count toward the budget; scoped ADRs and inert templates are excluded by not being passed to `--always`; quoted and unquoted `verify_by` dates both parse; stale artifacts are reported.  
**Evidence:** Created temp audit fixture with `AGENTS.md`, `CLAUDE.md`, `docs/adr/test.md`, and `docs/rlp-architect/templates/example-rule.md`. With only `AGENTS.md` and `CLAUDE.md` on `--always`, budget was 21/1500 OK. Adding the scoped ADR and template increased the count only because they were deliberately passed; the SKILL.md audit instructions correctly exclude them. Both `verify_by: '2020-01-01'` and `verify_by: 2020-01-01` produced `Stale artifacts:` output.  
**Findings repaired:** None.  
**Findings to triage:** The health script has no automatic exclusion logic for templates or scoped artifacts; the agent performing `audit` must implement the exclusion by selecting files. This is by design per SKILL.md but could be surprising.  
**Human decision:** Continue to Pass 6 — One-learning migration.  
**Next pass authorized:** Pass 6 — One-learning migration.

### Pass 6 record

**Pass:** Pass 6 — One-learning migration  
**Commit:** (no source change; verification only)  
**Outcome:** One legacy learning was migrated through the full loop: a real historical commit was used as evidence, `record_migration.sh` produced a durable `source` value, the candidate was promoted to a scoped knowledge module, and reverting the promotion PR removed the artifact completely.  
**Evidence:** In a temp copy of the Content Engine, selected the `business-model-research` candidate from `docs/learnings/inbox.md` (original source `.vault/sources/luxury-content-commerce-research-brief.v1.0.md`, removed in commit `6b3db1e`). Ran `record_migration.sh` from the canonical skill to produce: `source: "commit 6b3db1e removed .vault and replaced with RLP; migrated in commit 6b3db1e6c6093571d63eb10e9b5cd91bde8cb660 from .vault/sources/luxury-content-commerce-research-brief.v1.0.md"`. Created `docs/knowledge/business-model-research.md` with date, source, owner, scope, verify_by, and appended the decision to `docs/learnings/decisions.md`. Committed, confirmed the artifact existed, ran `git revert --no-commit HEAD`, confirmed the artifact was removed.  
**Findings repaired:** None.  
**Findings to triage:** None.  
**Human decision:** Continue to Pass 7 — Public-readiness review.  
**Next pass authorized:** Pass 7 — Public-readiness review.

### Pass 7 record

**Pass:** Pass 7 — Public-readiness review  
**Commit:** `52a3f14`  
**Outcome:** The repository is clean of secrets and private references; package metadata is truthful; LICENSE (MIT) added; reader path is clear. Public-readiness gate passes.  
**Evidence:** Scanned source for `password`, `secret`, `token`, `api_key`, `localhost`, `file://`, `/Users/`, `/home/`, `TODO`, `FIXME`, `owner/repo`, `your-org`, and JWT-like strings. No real findings. Checked git history with `git log --all -p` for the same patterns; no real findings. Verified manifest version `0.3.0`, skill version `0.3.0`, README version `v0.3.0`. Invocation syntax is `/rlp-architect:rlp-architect <mode>`. Dependencies are POSIX shell, git, optional semgrep/pre-commit. Added `LICENSE` (MIT). Replaced `owner/repo` placeholder with `Okja-Engineering/repo-learning-protocol` in README, installer, SKILL.md, and runbook. All tests and checksums pass.  
**Findings repaired:** Added MIT LICENSE; replaced `owner/repo` placeholder; updated SHA256SUMS to include LICENSE.  
**Findings to triage:** None.  
**Human decision:** Continue to Pass 8 — Push and publish (requires explicit authorization).  
**Next pass authorized:** Pass 8 — Push and publish.
