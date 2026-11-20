#!/data/data/com.termux/files/usr/bin/env bash
# Verify debloat scripts honour --dry-run: they list targets but never call
# pm uninstall. Uses a fixture pm, never a real device.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
tmp=$(mktemp -d "${TMPDIR:-$HOME/.cache}/debloat-dryrun.XXXXXX")
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$tmp/bin"
cat >"$tmp/bin/pm" <<'EOF'
#!/data/data/com.termux/files/usr/bin/env bash
if [ "${1:-}" = "list" ] && [ "${2:-}" = "packages" ]; then
    printf 'package:com.google.android.videos\n'
    exit 0
fi
if [ "${1:-}" = "uninstall" ]; then
    printf '%s\n' "$4" >>"$PM_LOG"
    exit 0
fi
exit 2
EOF
chmod +x "$tmp/bin/pm"
export PM_LOG="$tmp/uninstalled.log"
: >"$PM_LOG"

for script in debloat.sh debloat-safe.sh; do
    out=$(PATH="$tmp/bin:$PATH" bash "$ROOT/$script" --dry-run)
    grep -Fq "would remove  com.google.android.videos" <<<"$out"
    if grep -Fq "removed  com.google.android.videos" <<<"$out"; then
        echo "$script: --dry-run printed removed" >&2
        exit 1
    fi
done
[ ! -s "$PM_LOG" ] || { echo "dry-run called pm uninstall:" >&2; cat "$PM_LOG" >&2; exit 1; }

PATH="$tmp/bin:$PATH" bash "$ROOT/debloat-safe.sh" >/dev/null
grep -Fxq "com.google.android.videos" "$PM_LOG"

echo "debloat dry-run check OK"