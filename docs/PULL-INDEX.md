# PULL-INDEX — generated from blueprint frontmatter by scripts/build-index.sh; do not hand-edit.

Columns (PULL-INDEX v1): id, defect_class, triggers (semicolon-separated), requires
(comma-separated or none), closure of requires, proven_in. Columns (PULL-EDGES v1): id,
requires — the adjacency list, one row per blueprint. Consumers: docs/PULL-PROTOCOL.md.
Regenerate: scripts/build-index.sh. Verify freshness: scripts/build-index.sh --check.

```text
# PULL-INDEX v1
assembled-needles	scanner-contains-prey	a scanner would contain its own prey; prose documenting a denied shape trips the denier; needles and fixtures share bytes with live guards	none	none	psychic-crew, psychic-crew-lite
commit-straddle	green-early-or-stale	a suite asserts its own commit count or head; the gated commit must contain the ledger row approving it; totals change in the closing commit itself	gate-machine	gate-machine	psychic-crew
count-binding	unbound-figure-drift	a readme states a number the repo can recompute; totals are quoted in more than one doc; a figure sat stale across sessions	negative-control	negative-control	psychic-crew, psychic-crew-lite, psychic-templates, psychic-sidekick, psychic-plugins
explainer-epoch	opaque-gate-change	a gate ledger exists; the operator reads ledgers rather than diffs; non-author comprehension is a requirement	gate-machine	gate-machine	psychic-crew, psychic-templates, psychic-sidekick, psychic-plugins
gate-machine	sentiment-approval	phase advancement exists; approval is currently inferred from chat sentiment; multiple sessions or writers share one ledger	none	none	psychic-crew, psychic-crew-lite, psychic-templates, psychic-sidekick, psychic-plugins
negative-control	never-seen-failing	a checker has never been seen failing; a passing control could be passing vacuously; a guard needle set just changed	none	none	psychic-crew, psychic-crew-lite, psychic-templates, psychic-sidekick, psychic-plugins
observer-fence	measurement-mutates	a metrics or census step edits what it measures; running the suite dirties the tree; a check regenerates a tracked file	none	none	psychic-crew
pair-edit-delta-zero	dual-doc-divergence	two documents describe one structure; a map and its territory are edited separately; a section count appears in two files	count-binding	count-binding,negative-control	psychic-crew
unknown-fields	guessed-in-requirements	an artifact looks complete but some fields were guessed; blanks silently become plausible values; requirements arrive unstructured	none	none	psychic-templates, psychic-sidekick, psychic-plugins, psychic-crew
vendored-vocabulary	brittle-or-silent-coupling	one repo consumes a sibling repo field list; the sibling checkout may be absent at run time; a sync check must never hard-depend on a sibling	negative-control	negative-control	psychic-sidekick, psychic-templates, psychic-crew-lite
witness-manifest	untracked-state-drift	untracked working files carry state between commits; a scratch directory feeds a tracked artifact; drift would surface only at clone time	negative-control	negative-control	psychic-crew-lite
```

```text
# PULL-EDGES v1
assembled-needles	none
commit-straddle	gate-machine
count-binding	negative-control
explainer-epoch	gate-machine
gate-machine	none
negative-control	none
observer-fence	none
pair-edit-delta-zero	count-binding
unknown-fields	none
vendored-vocabulary	negative-control
witness-manifest	negative-control
```
