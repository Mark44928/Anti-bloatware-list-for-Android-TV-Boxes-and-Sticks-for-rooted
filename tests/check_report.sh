#!/data/data/com.termux/files/usr/bin/env bash
# Smoke test for report.sh — fixture pm stub, NOT a real device. Asserts the
# generated HTML contains the report title, count bars, legend and <details>.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
base_tmp="${TMPDIR:-${RUNNER_TEMP:-$HOME/.cache}}"
mkdir -p "$base_tmp"
tmp=$(mktemp -d "$base_tmp/report-check.XXXXXX")
trap 'rm -rf "$tmp"' EXIT

pm() {
  if [ "${1:-}" = "list" ] && [ "${2:-}" = "packages" ]; then
    if [ "${3:-}" = "-u" ]; then
      printf 'package:com.google.android.videos\npackage:com.google.android.play.games\n'
    else
      printf 'package:com.google.android.videos\n'
    fi
    exit 0
  fi
  exit 2
}
export -f pm

bash "$ROOT/report.sh" --output "$tmp/report.html" >/dev/null

fail=0
check() { if grep -q "$1" "$tmp/report.html"; then echo "ok: $2"; else echo "MISSING: $2 ($1)"; fail=1; fi; }
check '<title>Android TV debloat audit</title>' 'report title'
check 'class="bar-fill' 'visual count bars'
check 'Risk legend' 'labelled risk legend'
check '<details' 'details sections'
check 'com.google.android.videos' 'fixture package row'

if [ "$fail" -ne 0 ]; then
  echo "report smoke check FAILED"
  exit 1
fi
echo "report smoke check OK"
