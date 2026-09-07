# RLP Plugin Release Runbook

Use this runbook to move the current local RLP plugin redesign from a clean commit to a public, field-tested release. Work one pass at a time. Do not preload later-pass detail; open the linked files and run the commands only when that pass begins.

## Operating loop

Every pass follows the same loop:

1. **Plan** — state the pass outcome, changed surface, risks, and proof before editing.
2. **Execute** — make only the changes required for that outcome.
3. **Verify** — run the pass checks and capture the evidence.
4. **Review** — inspect the full changed surface; repair real findings and rerun verification.
5. **Gate** — stop for a human decision. Commit only a coherent, passing pass.

A failed gate does not roll into the next pass. Fix it in the current pass or record why work is stopping. Do not push, publish, change repository visibility, or modify the field repository unless that pass explicitly authorizes it.

## State at entry

- Local redesign commit: `84fe75d refactor(skill): distribute RLP as a repo-aware plugin`
- Expected branch: `main`
- Expected working tree: clean
- Remote: `Okja-Engineering/repo-learning-protocol`
- Publication and cross-repository writes: not yet authorized

Confirm before Pass 1:

```bash
git status --short --branch
git log -1 --oneline
```

---

## Pass 1 — Plugin contract

**Outcome:** The repository is structurally valid as a Devin plugin and the documented commands match actual CLI behavior.

**Load only:**

- `.devin-plugin/plugin.json`
- `skill/rlp-architect/SKILL.md`
- Devin plugin manifest and command documentation
- `tests/test_skill.sh`

**Work:**

1. Validate every manifest field against the installed Devin CLI documentation.
2. Install the local checkout with `devin plugins install --local .`.
3. Confirm the plugin appears in `devin plugins list` and inspect it with `devin plugins info rlp-architect`.
4. Start a fresh session and confirm the actual invocation name shown by Devin.
5. Correct manifest, README, or invocation examples only if observed behavior differs.

**Verification:**

```bash
tests/test_skill.sh
devin plugins list
devin plugins info rlp-architect
```

**Gate:** The plugin installs locally, exposes exactly one intended skill, and the README uses the observed invocation syntax.

**Intermediate state:** A locally installable plugin; no target repository changed.

---

## Pass 2 — Clean-room package

**Outcome:** A user can follow the repository instructions without relying on the authoring checkout or hidden context.

**Load only:**

- `README.md`
- `.devin-plugin/plugin.json`
- files referenced directly by the README installation and test sections

**Work:**

1. Copy the current repository snapshot to a temporary clean location.
2. Follow only the README.
3. Install the plugin from that location.
4. Run the documented test commands.
5. Record every unstated prerequisite, placeholder, broken path, or author-only assumption.
6. Repair only the instructions or package boundary responsible for a reproduced failure.

**Verification:**

```bash
tests/test_skill.sh
tests/test_walk.sh
skill/rlp-architect/assets/tests/test_payload.sh
shasum -a 256 -c SHA256SUMS
```

**Gate:** Clean-room use succeeds from the README alone and the working tree is clean after any repair commit.

**Intermediate state:** A self-contained package ready to exercise, still private and unpushed.

---

## Pass 3 — Empty-repository scaffold

**Outcome:** Scaffold proposes the smallest usable RLP wiring when no router or staged workspace exists.

**Load only:**

- the scaffold section of `skill/rlp-architect/SKILL.md`
- `skill/rlp-architect/assets/`
- `skill/rlp-architect/templates/`
- the temporary repository created for this pass

**Work:**

1. Create a temporary Git repository with no agent configuration.
2. Invoke scaffold from a fresh session.
3. Confirm it reports what it discovered and asks for the editor directory before writing.
4. Review the exact proposal before approving it.
5. Approve once, inspect the resulting router, stage-00 contract, inbox, decisions log, scripts, and inert templates.
6. Invoke scaffold again and confirm the second run is a no-op.

**Verification:**

- No generalized skill bundle exists under the temporary repository’s project configuration.
- Templates exist only under `docs/rlp-architect/templates/`.
- No placeholder exists in `docs/knowledge/`, an active rules directory, or `semgrep/rules.yml`.
- The second scaffold run reports unchanged files and introduces no diff.
- The generated health command runs successfully.

**Gate:** First run is minimal and reviewed; second run is idempotent.

**Intermediate state:** Empty-repository behavior is proven without touching the field repository.

---

## Pass 4 — Existing-workspace discovery

**Outcome:** Scaffold understands an existing workspace without creating a parallel structure.

**Load only:**

- the scaffold section of `skill/rlp-architect/SKILL.md`
- a disposable copy of the Content Engine root router
- its stage contract filenames, not their full contents unless a proposed route requires one

**Work:**

1. Create a disposable copy or branch of the Content Engine; do not use the production working tree for the first attempt.
2. Invoke scaffold without approving writes.
3. Confirm discovery identifies the existing router, editor configuration, numbered stages, learning system, CI, and checks.
4. Inspect the proposal for overwrites, duplicate stages, duplicated routes, and unnecessary always-on context.
5. Approve only after the proposal maps RLP wiring onto existing contracts.
6. Run scaffold a second time.

**Verification:**

- Existing router text is preserved.
- No new numbered RLP stage is added.
- Stage-specific references go into the stage contract that consumes them.
- The editor directory was chosen by the user.
- The second run produces no duplicate wiring or diff.

**Gate:** Existing structure is extended rather than replaced or paralleled.

**Intermediate state:** Repository-aware behavior is proven on a disposable field copy.

---

## Pass 5 — Audit semantics

**Outcome:** Audit measures only real promotions and only charges always-on files to the context budget.

**Load only:**

- the audit section of `skill/rlp-architect/SKILL.md`
- `scripts/learning_health.sh` in the disposable target
- target router and editor pointers
- one template and one real promoted artifact fixture

**Work:**

1. Run audit with inert templates present.
2. Confirm templates are listed as excluded and cannot pass provenance, repeat, or liveness checks.
3. Confirm the budget file list contains only root routers, editor pointers, and global or always-apply rules.
4. Add a scoped ADR or knowledge fixture and confirm it is not charged to the budget.
5. Exercise quoted and unquoted `verify_by` values.

**Verification:**

- Template placeholders do not create audit failures or false passes.
- Scoped ADRs, knowledge modules, tests, Semgrep rules, and skills are excluded from budget counting.
- Both `'YYYY-MM-DD'` and `"YYYY-MM-DD"` parse correctly.
- Audit reports the exact measured and excluded file lists.

**Gate:** Audit output matches the stated scope with no hidden classification assumptions.

**Intermediate state:** Audit behavior is trusted before legacy data is introduced.

---

## Pass 6 — One-learning migration

**Outcome:** One real legacy learning moves through normal triage with durable provenance.

**Load only:**

- `skill/rlp-architect/references/migration-guide.md`
- `skill/rlp-architect/scripts/record_migration.sh`
- one selected `.vault/`, `state/lessons/`, or decisions entry
- the real commit, PR, issue, or conversation that earned it

**Work:**

1. Select one representative legacy entry with recoverable evidence.
2. Import it as a candidate in a dedicated migration commit.
3. Run normal triage; do not assume promotion.
4. If promoted, generate provenance using the real evidence, migration commit hash, and original path.
5. Attach the artifact to the existing stage contract or deterministic mechanism that consumes it.
6. Verify that reverting the promotion PR removes the learning completely.

**Verification:**

```bash
skill/rlp-architect/scripts/record_migration.sh \
  --path <legacy-path> \
  --migration-commit <real-commit> \
  --source "<real PR, commit, issue, or conversation>"
```

- `source` is not a dead path.
- `date`, `source`, `owner`, `scope`, and `verify_by` are populated.
- The repeat mechanism fires or the scoped contract demonstrably loads.
- One revert removes the promotion.

**Gate:** One learning completes capture → triage → promotion or discard with truthful lineage.

**Intermediate state:** Migration is proven on one case; bulk migration remains out of scope.

---

## Pass 7 — Public-readiness review

**Outcome:** The repository can be made public without exposing private material or misleading users.

**Load only:**

- tracked file list
- Git history and tags
- README, LICENSE, manifest, checksums, examples, and documentation links
- repository hosting settings relevant to visibility

**Review lenses:**

1. **Secrets and private references** — credentials, private URLs, internal names, customer data, local absolute paths, and conversation excerpts.
2. **Package truthfulness** — owner/repo placeholders, version, invocation syntax, dependencies, supported shells, and update behavior.
3. **License and attribution** — repository license, bundled skill license, borrowed material, citations, and third-party notices.
4. **History** — sensitive content removed from the working tree but still present in commits or tags.
5. **Reader path** — a new user can understand install → invoke → scaffold/audit without learning the workspace methodology’s label.

**Verification:**

- Secret scanning and repository search produce no real findings.
- Public links resolve or are clearly marked as placeholders before publication.
- Tests and checksum verification pass on the final revision.
- A second full review pass finds zero real defects.

**Gate:** Human explicitly approves publication. Changing visibility is a separate action and requires confirmation at that moment.

**Intermediate state:** Public-ready local repository, still private until approved.

---

## Pass 8 — Push and publish

**Outcome:** The reviewed revision is available publicly and installable from its canonical source.

**Dependencies:** Passes 1–7 are green and publication is explicitly authorized.

**Work:**

1. Re-run the complete verification suite on the exact commit to publish.
2. Push the reviewed commits without rewriting history.
3. Change repository visibility only after explicit confirmation.
4. Install from the public `Okja-Engineering/repo-learning-protocol` source in a clean environment.
5. Confirm update behavior and public documentation links.
6. Tag a release only if the version and release notes have passed review.

**Verification:**

```bash
git status --short --branch
tests/test_skill.sh
tests/test_walk.sh
skill/rlp-architect/assets/tests/test_payload.sh
shasum -a 256 -c SHA256SUMS
devin plugins install Okja-Engineering/repo-learning-protocol
devin plugins info rlp-architect
```

**Gate:** Public install succeeds from the canonical repository at the published commit.

**Intermediate state:** Public plugin release; field rollout has not yet modified the production repository.

---

## Pass 9 — Production field trial

**Outcome:** The public plugin performs one controlled scaffold, audit, and migration loop in the Content Engine.

**Dependencies:** Public installation succeeds and the Content Engine has its own clean branch or revertible PR.

**Work:**

1. Install or update the public plugin.
2. Run scaffold in proposal-only mode and review the changed-surface plan.
3. Apply approved wiring in one small PR.
4. Run audit and repair only findings caused by the wiring.
5. Migrate one legacy learning in a separate PR.
6. Record field feedback as candidates in this repository rather than patching the installed copy.

**Verification:**

- Wiring PR is independently revertible.
- Migration PR is independently revertible.
- Always-on context remains within budget.
- No generalized plugin payload was copied into the project.
- Any correction routes back to the canonical source repository.

**Gate:** Human accepts the field trial or reverts it. Wider migration is planned only after this pass succeeds.

**Intermediate state:** One production repository has validated the loop; broader adoption remains separately planned and gated.

---

## Closeout record

For each completed pass, append a short record to the working issue or release notes:

```text
Pass:
Commit:
Outcome:
Evidence:
Findings repaired:
Human decision:
Next pass authorized:
```

Do not combine pass records. The point is to preserve what was proven at each boundary, not to produce one retrospective summary after the fact.

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
