---
id: bad-frontmatter
triggers: only one; and a second
requires: ghost-blueprint
proven_in: psychic-crew
---

# bad-frontmatter — a fixture whose frontmatter is broken three ways

## What

A control fixture: no defect_class line, two triggers where three are the floor, and a
requires edge pointing at a blueprint that does not exist.

## Why

The frontmatter checker must fire on each of the three, and ONLY via frontmatter — sections
and provenance are deliberately sound here (isolation).

## When

Never pulled; exists to be refused.

## Proven in

psychic-crew (the negative-control discipline this fixture instantiates).

## How to re-instantiate

1. Break exactly the surface under test; keep every other surface green.
