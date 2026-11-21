#!/data/data/com.termux/files/usr/bin/env bash
# Read-only package audit: show which debloat targets are installed, disabled or absent.
set -u

case "${1:-}" in
  --help|-h)
    echo "usage: audit.sh [--json]"
    echo "  --json   print a machine-readable report"
    exit 0
    ;;
  --json) JSON=1 ;;
  "") JSON=0 ;;
  *) echo "unknown option: $1 (try --help)" >&2; exit 2 ;;
esac

HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE" || exit 1
command -v pm >/dev/null 2>&1 || { echo "pm is required (run on an Android device)" >&2; exit 1; }

mapfile -t PKGS < <(grep -hE '^  com\.[A-Za-z0-9_.]+$' debloat.sh debloat-safe.sh | sed 's/^  //' | sort -u)
if ! INSTALLED_RAW=$(pm list packages 2>/dev/null); then
  echo "pm could not list packages; refusing to guess" >&2
  exit 1
fi
if ! ENABLED_RAW=$(pm list packages -e 2>/dev/null); then
  echo "pm could not list enabled packages; refusing to guess" >&2
  exit 1
fi
mapfile -t INSTALLED < <(printf '%s\n' "$INSTALLED_RAW" | sed 's/^package://')
mapfile -t ENABLED < <(printf '%s\n' "$ENABLED_RAW" | sed 's/^package://')

installed=0
disabled=0
absent=0
records=()
for p in "${PKGS[@]}"; do
  state="absent"
  if printf '%s\n' "${INSTALLED[@]}" | grep -Fxq "$p"; then
    installed=$((installed + 1))
    if printf '%s\n' "${ENABLED[@]}" | grep -Fxq "$p"; then
      state="enabled"
    else
      state="disabled"
      disabled=$((disabled + 1))
    fi
  else
    absent=$((absent + 1))
  fi
  records+=("$state"$'\t'"$p")
done

if [ "$JSON" = "1" ]; then
  printf '{"total":%d,"installed":%d,"disabled":%d,"absent":%d,"packages":[' "$((installed + absent))" "$installed" "$disabled" "$absent"
  first=1
  for record in "${records[@]}"; do
    state="${record%%$'\t'*}"; pkg="${record#*$'\t'}"
    [ "$first" = "1" ] || printf ','
    first=0
    printf '{"package":"%s","state":"%s"}' "$pkg" "$state"
  done
  printf ']}\n'
  exit 0
fi

printf 'Debloat target audit\n'
printf '  total     %d\n' "${#PKGS[@]}"
printf '  installed %d (%d enabled, %d disabled)\n' "$installed" "$((installed - disabled))" "$disabled"
printf '  absent    %d\n\n' "$absent"
for record in "${records[@]}"; do
  state="${record%%$'\t'*}"; pkg="${record#*$'\t'}"
  case "$state" in
    enabled)   printf '  enabled   %s\n' "$pkg" ;;
    disabled)  printf '  disabled  %s\n' "$pkg" ;;
    absent)    printf '  absent    %s\n' "$pkg" ;;
  esac
done
