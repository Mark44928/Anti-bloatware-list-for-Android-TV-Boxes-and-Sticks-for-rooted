#!/data/data/com.termux/files/usr/bin/env bash
# backup-packages.sh [output] — snapshot installed packages before debloating.
# Read-only: needs neither root nor adb; writes one text file you can keep.
set -euo pipefail

command -v pm >/dev/null 2>&1 || {
    echo "ERROR: 'pm' not found. Run this inside Termux on the device (or adb shell)." >&2
    exit 1
}

OUT="${1:-$HOME/android-packages-$(date +%Y%m%d-%H%M%S).txt}"
mkdir -p "$(dirname "$OUT")"
pm list packages -f > "$OUT"
COUNT=$(grep -c '^package:' "$OUT" || true)
printf 'Saved %s installed packages to %s\n' "$COUNT" "$OUT"
printf 'Keep this file: it is your restore reference (package + APK path).\n'
