---
id: vendored-vocabulary
defect_class: brittle-or-silent-coupling
triggers: one repo consumes a sibling repo field list; the sibling checkout may be absent at run time; a sync check must never hard-depend on a sibling
requires: negative-control
proven_in: psychic-sidekick, psychic-templates, psychic-crew-lite
---

# vendored-vocabulary — declared coupling with a conditional sync check

## What

When repo B consumes repo A's vocabulary (field names, schema, doctrine text), B carries a
vendored copy as its runtime truth, an INTEGRATION-CONTRACT document declaring the coupling, and
a validator section that diffs the vendored copy against a sibling checkout of A when one exists
— FAIL on drift, stated SKIP (never silent pass) when A is absent.

## Why

Cross-repo reads at runtime break standalone clones; silently copying breaks sync. Vendoring
with a declared, checked reconciliation gets both: B works alone, and the moment the repos sit
side by side, drift turns red. The stated SKIP matters — "deferred, stated" is honest; a
conditional that passes quietly when it cannot check is a fake control.

## When

Any consumer of another repo's canonical vocabulary: UIs over schemas, plugins over rule sets,
twins sharing doctrine text.

## Proven in

psychic-sidekick (vendor/SCHEMA-FIELDS.txt diffed live against psychic-templates' SCHEMA.md,
doctrine byte-equality asserted, PSYCHIC_TEMPLATES_PATH override, drift fixture in the
controls), following the psychic-crew-lite ↔ parent sync-correlation precedent.

## How to re-instantiate

1. Extract the vocabulary mechanically from A (awk over its canonical tables), commit as a
   vendored file in B; refreshes are gated changes citing A's commit.
2. Write the integration contract: what is consumed, the reconciliation semantics, the failure
   table, the hand-off boundary.
3. Validator: vendored copy well-formed → all B-side uses bound to it → conditional diff vs
   `${A_PATH:-../a-repo}` → drift fixture control.
