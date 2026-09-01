# RPG-1, explained plainly

## What changed

The gallery became a graph. An 11th blueprint was born (`explainer-epoch` — the per-gate
explainer discipline you are reading right now, written up as a reusable pattern). Every
blueprint now opens with machine frontmatter: its id, the one defect class it kills, at least
three trigger phrases, what it requires, and where it is proven. A generator projects that
frontmatter into `docs/PULL-INDEX.md` — one capability row per blueprint with the `requires`
closure precomputed — and `docs/PULL-PROTOCOL.md` says how a consumer pulls.

## Why

Ten patterns you have to already know about are advice; eleven patterns a consumer can match a
need against (defect class, triggers) and pull with their prerequisites is infrastructure. The
frontmatter is the source and the suite treats it that way: integrity is checked over the
frontmatter, and the index must separately prove itself a faithful projection of it.

## Verify it yourself

```
./scripts/validate-repurpose.sh      # 75 checks; C2 = the graph source, C3 = the projection
./scripts/build-index.sh --check     # freshness (its comment states what this cannot catch)
grep -A2 'Declared unasserted' docs/PULL-PROTOCOL.md
```

## What could break, and what catches it

Edit frontmatter without regenerating → the --check arm and the set-equality arms go red. A
requires cycle → the generator refuses AND the suite's independent Kahn peel fails. A wrong
closure column → the fixed-point arm fails; that arm now carries a positive witness (11 rows
checked) because its first version died silently on an awk reserved word and PASSED VACUOUSLY —
caught in-build, and the repair is the never-seen-failing blueprint applied to this repo's own
checker. What is NOT asserted is stated in the protocol: trigger matching is judgment, and
nothing here proves a consumer cited a path rather than inlining a body (that bound lands with
the parent consumer gate).
