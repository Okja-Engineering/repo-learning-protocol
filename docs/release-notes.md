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

### Cleanup before Pass 8

**Commit:** `f2266ab` (cleanup at `424a12a`, plus final stage-contract fix)  
**Outcome:** Removed low-value and confusing artifacts before publication; fixed ICM drift and stage contract accuracy.  
**Evidence:** `tests/test_skill.sh` 24 passed; `tests/test_walk.sh` 14 passed; `skill/rlp-architect/assets/tests/test_payload.sh` 12 passed.  
**Findings repaired:** Removed `SHA256SUMS`; archived construction playbook to `docs/history/`; removed `examples/demo/`; moved `research/RESEARCH-PLAN.md` to `stages/01-research/references/`; split pass records into `docs/release-notes.md`; fixed `stages/03-skill/CONTEXT.md` to reference shell tests; updated all cross-references.  
**Findings to triage:** None.  
**Human decision:** Retag `v0.3.0` at this commit and push.  
**Next pass authorized:** Pass 8 — Push and publish.

### Fresh-eyes pass (pre-Pass 8)

**Commit:** `492193b`  
**Outcome:** Public-facing README and SKILL.md improved for first-time visitors: clearer product identity, user/contributor split, install verification, invocation-syntax note, and a correct canonical spec reference.  
**Evidence:** `tests/test_skill.sh` 24 passed; `tests/test_walk.sh` 14 passed; `skill/rlp-architect/assets/tests/test_payload.sh` 12 passed.  
**Findings repaired:** README title changed to `rlp-architect`; "What's here" split by audience; added `devin plugins info` verification; explained `/plugin:skill` invocation; polished v0.3.0 status; listed LICENSE; replaced relative `metadata.spec` with canonical URL comment in SKILL.md.  
**Findings to triage:** None.  
**Human decision:** Continue to skill behavior pass.  
**Next pass authorized:** Skill behavior pass.

### Skill behavior pass (pre-Pass 8)

**Commit:** `b28e93c`  
**Outcome:** All four skill modes behave as documented on representative target repositories: scaffold is minimal and idempotent, audit respects always-on/scoped classification, triage produces revertible promotions, and migration produces durable provenance. One real bug in `learning_health.sh` was found and fixed.  
**Evidence:**
- Empty-repo scaffold produced 10 files, health reported `0 / 1500 tokens (OK)`, and a re-scaffold produced no diff.
- Existing staged workspace (Content Engine copy) scaffold produced no writes and no diff.
- Audit on the scaffolded repo: always-on budget 186/1500 OK; templates correctly excluded (adding them increased count only because deliberately passed).
- Triage: two `naive-datetime` captures promoted to `docs/knowledge/naive-datetime.md`; one `escrow-rounding` held; revert removed the promoted artifact.
- Migration: legacy `.vault/insights/legacy.md` removed, `record_migration.sh` produced a `source` value with commit hash and original path; promotion to `docs/knowledge/input-validation.md` created; revert removed it.  
**Findings repaired:** `learning_health.sh` now validates `verify_by` format before parsing and warns on placeholders instead of crashing on macOS.  
**Findings to triage:** None.  
**Human decision:** Continue to consumer point-of-view pass.  
**Next pass authorized:** Consumer POV / naming pass.

### Consumer POV / naming pass (pre-Pass 8)

**Commit:** `7b6daed`  
**Outcome:** The plugin namespace (`rlp-architect`) and skill namespace (`rlp`) are separated, and the skill bundle moved from the non-standard `skill/` directory to the Devin-default `skills/` directory. Invocation becomes `/rlp-architect:rlp <mode>`, which is shorter and avoids repeating the product name.  
**Evidence:**
- Devin plugin docs define invocation as `/<plugin>:<skill>` and the default skills directory as `skills/`.
- All tests pass after rename: `tests/test_skill.sh` 24 passed; `tests/test_walk.sh` 14 passed; `skills/rlp/assets/tests/test_payload.sh` 12 passed.  
**Findings repaired:**
- Moved `skill/rlp-architect/` → `skills/rlp/`.
- Changed skill name from `rlp-architect` to `rlp`.
- Updated plugin manifest `"skills": "skill"` → `"skills": "skills"`.
- Updated README invocation examples to `/rlp-architect:rlp <mode>`.
- Updated `SKILL.md` title, metadata.spec comment, and global skill install path.
- Updated `CLAUDE.md`, `CONTEXT.md`, `stages/03-skill/CONTEXT.md`, `docs/rlp-plugin-release-runbook.md`, and tests.
**Findings to triage:** None.  
**Human decision:** Continue to Research Publication Pass.  
**Next pass authorized:** Research Publication Pass.

### Research Publication Pass (pre-Pass 8)

**Commit:** `4442183`  
**Outcome:** Added a public-facing research manifesto (`MANIFESTO.md`) that explains the North Star, how the protocol was derived from the evidence, the 60/30/10 design posture, the promotion ladder, the five invariants, and how the tooling implements the protocol. Linked it from `README.md`, `CLAUDE.md`, and `CONTEXT.md` so it is the first document a public reader sees.  
**Evidence:**
- Studied `icm-architect` README as a model: short manifesto, paper/community links, what-it-does, layout.
- Drafted `MANIFESTO.md` (~115 lines) covering problem, evidence-based decisions, rejected alternatives, protocol, invariants, tooling, and validation posture.
- Cross-checked against `skill/rlp-architect` (`skills/rlp/SKILL.md`): promotion ladder, invariants, rejection list, capture→triage→promote→measure→retire flow, and human-gated promotions all align.
- All tests pass: `tests/test_skill.sh` 24 passed; `tests/test_walk.sh` 14 passed; `skills/rlp/assets/tests/test_payload.sh` 12 passed.  
**Findings repaired:** Created `MANIFESTO.md`; updated `README.md`, `CLAUDE.md`, and `CONTEXT.md` routing/shared-resources tables.  
**Findings to triage:** None.  
**Human decision:** Continue to final user-experience passes.  
**Next pass authorized:** Final UX pass #1.
