# PULL-PROTOCOL — how a consumer takes a blueprint (RPG-1)

## 1. The index

`docs/PULL-INDEX.md`, generated from blueprint frontmatter by `scripts/build-index.sh`. Two
fenced TSV blocks: `PULL-INDEX v1` (id, defect_class, triggers, requires, closure, proven_in —
one row per blueprint) and `PULL-EDGES v1` (the adjacency list, one row per blueprint,
`none` spelled out). The frontmatter is the source; the index is a projection and the suite
proves it faithful.

## 2. The pull law

A consumer pulls by CAPABILITY: match a need against `defect_class` and `triggers`, then take
the blueprint AND its `requires` closure — the closure column is precomputed, and a distrustful
consumer can re-derive it from the edges block. Cite blueprints by repo-relative path.

## 3. Declared unasserted: trigger matching

Whether a live request actually matches a trigger phrase is JUDGMENT. Nothing here asserts it;
a consumer that mismatches triggers builds the wrong thing with a clean suite. Stated, not
promised away.

## 4. Declared unasserted: path-not-body

Nothing in THIS repo proves a consumer cited a path rather than inlining a blueprint's body.
The one real bound arrives with the parent consumer gate (RPG-2): the parent intake skill's
pull section carries a length/fence cap assertion, so a pasted-in blueprint body fails there.
Until that gate closes, this is a declared gap, not a control.

## 5. Staleness, honestly

`scripts/build-index.sh --check` regenerates to a temp file and diffs — it catches a STALE
tracked index, never a wrong generator (the same program writes both sides). Wrongness is the
validator's job: it re-derives pairs, adjacency, and the closure fixed point from frontmatter
without the generator.

## 6. Manual drills (run when this protocol or the graph changes)

1. **Closure by hand.** Pull `pair-edit-delta-zero`. Expect exactly three files: itself,
   `count-binding` (required), `negative-control` (transitive). The index closure column must
   say `count-binding,negative-control`.
2. **Trigger match.** Need: "our README numbers rot between sessions." Expect `count-binding`
   (defect class `unbound-figure-drift`), never `witness-manifest`.
3. **Vacuity check.** Empty the PULL-INDEX block in a scratch copy and run the suite against
   it mentally: the block-size guard must go red. (The suite runs this probe mechanically on
   every invocation.)

## 7. What this is not

This index is NOT the RSCH-1 graph-lane pilot's discharge — that question (a graph lane for
research corpora) stays open and is owned by the TEI arc. Recorded so the pilot cannot be
quietly double-counted as done.
