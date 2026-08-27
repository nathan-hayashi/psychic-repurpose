# assembled-needles — a scanner never contains the pattern it hunts

## What

Every scanner that greps for forbidden content (credential shapes, absolute home paths, denied
verbs, reserved words) builds its needles from fragments at runtime — `"gh""p_"`, a printf'd
home-directory prefix — so the scanner's own source can never match itself, and tracked prose never carries
the contiguous forbidden string even to document the rule.

## Why

Two failure modes die together: the self-match (a scanner listing its own source as a violation,
then growing an allowlist that becomes the next drift) and the deny-adjacency trap (a hook or
policy matching command strings fires on legitimate documentation that merely SPELLS the
pattern). Fragment assembly makes the check clean and the docs writable.

## When

Every hygiene sweep and every deny-list adjacent artifact — the moment a rule's own text would
otherwise contain what the rule forbids.

## Proven in

psychic-crew (the standing-prohibition scanners; two F0 red gates came from writing the literal
token in prose, which is why the rule exists), psychic-crew-lite (`ABS=$(printf '/%s/' home)`
with the hazard argued in-file), all three skill/template siblings (credential needles CRED1–4
assembled; reserved words RW1/RW2 assembled in the plugins validator; clone-verb runtime
assembly for README quickstarts under the parent's deny-adjacent bash blocker).

## How to re-instantiate

1. Build each needle from fragments at runtime; never write the contiguous form, including in
   comments and docs — describe it instead.
2. Sweep tracked files via `git ls-files -z | xargs -0 grep -lF -- "$NEEDLE"`; capture, then
   test emptiness (no status-through-pipeline).
3. Negative control: a fixture containing the real pattern (generated at test time, gitignored
   or planted through the writer under test) must be caught.
