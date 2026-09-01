---
id: unknown-fields
defect_class: guessed-in-requirements
triggers: an artifact looks complete but some fields were guessed; blanks silently become plausible values; requirements arrive unstructured
requires: none
proven_in: psychic-templates, psychic-sidekick, psychic-plugins, psychic-crew
---

# unknown-fields — blanks stay UNKNOWN, listed, never guessed into existence

## What

One doctrine line, embedded verbatim in every contract-shaped artifact and asserted by suite: "A
field left blank is UNKNOWN and stays UNKNOWN: the executor never fills it by guess — it may ask
a bounded question or proceed with the unknown recorded in the output." Plus the mechanization:
compilers and templates render blanks as UNKNOWN and emit a computed unknown_fields list.

## Why

The expensive failure in delegated work is a complete-LOOKING artifact hiding guessed-in
requirements. Optimizers fill gaps to look fluent; this doctrine makes the gap itself the
visible, durable artifact — incompleteness becomes a decision the requester can see, not an
accident the executor buried.

## When

Every request contract, intake layer, form compiler, or template library — anywhere a human's
underspecified intent becomes an executable instruction.

## Proven in

psychic-templates (the doctrine canonical in SCHEMA.md, verbatim in all four templates,
suite-asserted), psychic-sidekick (computeUnknowns as the product: live UNKNOWN strip, computed
unknown_fields, browser-render proof), psychic-plugins (the request-contract and unknown-audit
skills carry it to every surface), psychic-crew (the intake skill's clarify-never-proceed rule).

## How to re-instantiate

1. Fix the doctrine text once, canonically; embed verbatim everywhere it binds; assert the
   embedding (exact-string grep, count exactly 1 per artifact).
2. Mechanize: blank → "UNKNOWN" in output, plus a computed unknown_fields line; forbid typing it.
3. Pair with a bounded-clarification rule (at most N questions, each only if answers change the
   work) so UNKNOWN is never an excuse to interrogate.
