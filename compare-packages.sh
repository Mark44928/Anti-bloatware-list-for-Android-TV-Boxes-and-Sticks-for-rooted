#!/data/data/com.termux/files/usr/bin/env bash
# compare-packages.sh <before.txt> <after.txt>
# Diff two backup-packages.sh dumps: what was removed, what appeared.
set -euo pipefail

usage() {
    echo "usage: compare-packages.sh <before.txt> <after.txt>" >&2
    exit 2
}

[ "$#" -eq 2 ] || usage
before="$1"
after="$2"
for f in "$before" "$after"; do
    [ -r "$f" ] || { echo "ERROR: cannot read $f" >&2; exit 1; }
done

pkglist() {
    awk -F= '/^package:/{print $NF}' "$1" | sed 's/[[:space:]]*$//' | sort -u
}

tmp_before=$(mktemp "${TMPDIR:-.}/pkgs-before.XXXXXX")
tmp_after=$(mktemp "${TMPDIR:-.}/pkgs-after.XXXXXX")
trap 'rm -f "$tmp_before" "$tmp_after"' EXIT

pkglist "$before" > "$tmp_before"
pkglist "$after"  > "$tmp_after"

removed=$(comm -23 "$tmp_before" "$tmp_after")
added=$(comm -13 "$tmp_before" "$tmp_after")
removed_n=$(printf '%s\n' "$removed" | grep -c . || true)
added_n=$(printf '%s\n' "$added" | grep -c . || true)

echo "Removed ($removed_n):"
if [ "$removed_n" -gt 0 ]; then printf '%s\n' "$removed" | sed 's/^/  - /'; else echo "  (none)"; fi
echo
echo "Added ($added_n):"
if [ "$added_n" -gt 0 ]; then printf '%s\n' "$added" | sed 's/^/  + /'; else echo "  (none)"; fi
