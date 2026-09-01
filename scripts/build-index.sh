#!/usr/bin/env bash
# build-index.sh — regenerate docs/PULL-INDEX.md from blueprint frontmatter (the single source).
#   default : rewrite the tracked index in place
#   --check : generate to mktemp and diff against the tracked file; nonzero on drift
# Honest limit, stated: --check catches a STALE tracked index and nothing else — the same
# generator writes both sides of that diff, so a wrong generator passes its own check. Wrongness
# is caught one layer up: validate-repurpose re-derives (id,class) pairs, the adjacency list and
# the closure fixed point from the frontmatter WITHOUT this script.
set -euo pipefail
cd "$(dirname "$0")/.."
mode="${1:-build}"
out=docs/PULL-INDEX.md
rows=$(mktemp); tmp=$(mktemp)
trap 'rm -f "$rows" "$tmp"' EXIT

awk '
  FNR==1 { dash=0; id=""; cls=""; trg=""; req=""; prv="" }
  dash>=2 { next }
  /^---$/ { dash++; if (dash==2) print id "\t" cls "\t" trg "\t" req "\t" prv; next }
  dash==1 {
    line=$0
    if      (sub(/^id: /,"",line))           id=line
    else if (sub(/^defect_class: /,"",line)) cls=line
    else if (sub(/^triggers: /,"",line))     trg=line
    else if (sub(/^requires: /,"",line))     req=line
    else if (sub(/^proven_in: /,"",line))    prv=line
  }
' blueprints/*.md > "$rows"

if ! clo=$(awk -F'\t' '
  { req[$1]=$4; order[NR]=$1; n=NR }
  END {
    for (k=1; k<=n; k++) {
      x=order[k]; out=""; frontier=req[x]
      if (frontier=="none" || frontier=="") { print x "\tnone"; continue }
      changed=1
      while (changed) {
        changed=0; m=split(frontier, a, ",")
        for (i=1;i<=m;i++) {
          it=a[i]; if (it=="" || it=="none") continue
          if (index("," out ",", "," it ",")==0) {
            out=(out=="" ? it : out "," it)
            if (req[it]!="none" && req[it]!="") { frontier=frontier "," req[it]; changed=1 }
          }
        }
      }
      if (index("," out ",", "," x ",")>0) { print "CYCLE " x; exit 1 }
      print x "\t" out
    }
  }' "$rows"); then
  echo "build-index: cycle detected in requires — refusing to generate" >&2
  exit 1
fi

sorted=$(sort "$rows")
{
  printf '# PULL-INDEX — generated from blueprint frontmatter by scripts/build-index.sh; do not hand-edit.\n\n'
  printf 'Columns (PULL-INDEX v1): id, defect_class, triggers (semicolon-separated), requires\n'
  printf '(comma-separated or none), closure of requires, proven_in. Columns (PULL-EDGES v1): id,\n'
  printf 'requires — the adjacency list, one row per blueprint. Consumers: docs/PULL-PROTOCOL.md.\n'
  printf 'Regenerate: scripts/build-index.sh. Verify freshness: scripts/build-index.sh --check.\n\n'
  printf '%s\n' '```text'
  printf '# PULL-INDEX v1\n'
  while IFS=$'\t' read -r rid rcls rtrg rreq rprv; do
    rclo=$(awk -F'\t' -v k="$rid" '$1==k{print $2}' <<<"$clo")
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$rid" "$rcls" "$rtrg" "$rreq" "$rclo" "$rprv"
  done <<<"$sorted"
  printf '%s\n\n%s\n' '```' '```text'
  printf '# PULL-EDGES v1\n'
  awk -F'\t' '{print $1 "\t" $4}' <<<"$sorted"
  printf '%s\n' '```'
} > "$tmp"

if [ "$mode" = "--check" ]; then
  if diff -u "$out" "$tmp"; then
    echo "build-index --check: tracked index is current"
  else
    echo "build-index --check: DRIFT — run scripts/build-index.sh to regenerate" >&2
    exit 1
  fi
else
  cat "$tmp" > "$out"
  echo "build-index: wrote $out ($(grep -c . "$rows") blueprints)"
fi
