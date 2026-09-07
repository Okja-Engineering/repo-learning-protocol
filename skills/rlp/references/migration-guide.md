# Migrating an existing learning system

Use this flow for `.vault/`, `state/lessons/`, `decisions/`, or another legacy store. Migration is classification, not bulk promotion.

1. Inventory each legacy entry and locate the correction that earned it: a commit, PR, issue, or conversation. A legacy file path is context, not provenance.
2. Import unresolved entries into `docs/learnings/inbox.md`. Keep the inbox out of always-on context.
3. Commit that import separately. This is the migration commit and makes the old location recoverable by one revert.
4. Run triage. Discard stale or unsubstantiated entries; promote only entries that meet the normal recurrence or severity gate.
5. For each promotion, record `date`, `source`, `owner`, `scope`, and `verify_by`. Build `source` with:

   ```bash
   rlp-architect/scripts/record_migration.sh \
     --path .vault/original-rule.md \
     --migration-commit <import-commit> \
     --source "PR #412 and conversation 2026-08-19"
   ```

   The result has both durable evidence and migration lineage:

   ```yaml
   source: "PR #412 and conversation 2026-08-19; migrated in commit <full-hash> from .vault/original-rule.md"
   ```

6. Reference scoped ADRs or knowledge modules from the existing stage `CONTEXT.md` that needs them. Do not add an RLP stage to an existing staged workspace.
7. Remove the legacy system only after every entry is promoted, held in the inbox with an expiry, or discarded and logged. Keep that removal in a separate revertible PR.

If no real source can be recovered, do not represent the old path as provenance. Hold the candidate with an expiry or discard it.
