#!/data/data/com.termux/files/usr/bin/env bash
# Verify audit.sh classifies packages as enabled / disabled / absent.
# Uses a fixture pm, never a real device.
#
# Regression guard: audit.sh used to read "pm list packages -u" (which lists
# packages installed for the system but NOT for the user) as the installed
# set, which swapped "disabled" and "absent" and reported every installed
# package as enabled.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$tmp/bin"
cat >"$tmp/bin/pm" <<'EOF'
#!/usr/bin/env bash
if [ "${1:-}" = "list" ] && [ "${2:-}" = "packages" ]; then
    case "${3:-}" in
        -e)
            printf 'package:com.google.android.videos\n'
            exit 0
            ;;
        -u)
            echo "pm stub: '-u' must not be used for the installed set" >&2
            exit 3
            ;;
        *)
            printf 'package:com.google.android.videos\npackage:com.google.android.music\n'
            exit 0
            ;;
    esac
fi
exit 2
EOF
chmod +x "$tmp/bin/pm"

out=$(PATH="$tmp/bin:$PATH" bash "$ROOT/audit.sh")

grep -Fq "  enabled   com.google.android.videos" <<<"$out"
grep -Fq "  disabled  com.google.android.music" <<<"$out"
grep -Fq "  absent    com.google.android.katniss" <<<"$out"
grep -Fq "  installed 2 (1 enabled, 1 disabled)" <<<"$out"
if grep -Fq "  installed com." <<<"$out"; then
    echo "audit.sh used the removed 'installed' state" >&2
    exit 1
fi

json=$(PATH="$tmp/bin:$PATH" bash "$ROOT/audit.sh" --json)
grep -Fq '{"package":"com.google.android.videos","state":"enabled"}' <<<"$json"
grep -Fq '{"package":"com.google.android.music","state":"disabled"}' <<<"$json"
grep -Fq '{"package":"com.google.android.katniss","state":"absent"}' <<<"$json"

echo "audit classification check OK"
