# S5-README-UX (repurpose leg), explained plainly

## What changed

The Kills table now links every blueprint to its file, the requires graph is RENDERED in the
README as Mermaid — and bound: the suite re-derives the rendered edges and set-compares them
against the index's PULL-EDGES block (never a third hand-copy), with a dropped-edge control. A
bound blueprints badge and a "What is not asserted" section complete it.

## Why

A drawn graph that nobody checks becomes the most confident lie in the repo. This one is
derived-checked: edit frontmatter, regenerate the index, and the picture must follow or the
suite goes red.

## Verify it yourself

```
./scripts/validate-repurpose.sh | grep -A3 'C4'
```

## What could break, and what catches it

Any edge added, dropped, or redirected in the picture alone → set-inequality names it. The
extractor that reads the linked table rows was updated in the same commit the links landed.
