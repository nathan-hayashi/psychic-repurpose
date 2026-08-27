# pair-edit-delta-zero — a byte-pinned source and its generated twin move together

## What

When one document is canonical (a plan's directory map) and another is its projection (the
repo's DIRECTORY_GUIDE), every edit lands in BOTH in the same commit with identical bytes, and a
suite assertion diffs the projection against the canonical payload — delta 0 or red.

## Why

Two documents describing one structure WILL diverge unless a machine says they haven't. The
delta-0 check converts "remember to update both" into "the suite is red until you do." The
growth valve matters as much: the canonical side grows only through a dated changelog entry, so
every map change carries its own justification.

## When

Any generated-or-projected artifact pair: plan payload ↔ deployed file, schema ↔ vendored copy,
spec ↔ rendered doc. If you cannot regenerate one side from the other, you have two sources of
truth and this blueprint is the fix.

## Proven in

psychic-crew (EX-01: three seeds at delta 0 across every commit since F0; the §4.3 map grown
through dated D-entries — D16 for intake, D25 for the army selector — with the guide re-derived
to delta 0 in the same commit each time).

## How to re-instantiate

1. Name the canonical side explicitly in both files' headers.
2. Make every edit a guarded exactly-once substitution applied to both files in one operation.
3. Assert delta 0 in the suite (byte diff of the projection against the extracted payload).
4. Grow the canonical side only through a dated changelog entry that names the delta.
