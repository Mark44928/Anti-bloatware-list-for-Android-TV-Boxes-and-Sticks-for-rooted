#!/data/data/com.termux/files/usr/bin/env bash
# debloat.sh — full debloat for a NO-MIC remote (run on the device as root).
#
# Every package is existence-checked first, so running the script twice (or on
# a device missing half the list) is safe: misses are reported, never fatal.
# Review the README tables before enabling this — use caution tier packages
# are deliberately NOT included here.
set -u

# One optional flag: --dry-run prints the plan without removing anything.
set -u

DRY=0
case "${1:-}" in
  "") ;;
  --dry-run|-n) DRY=1 ;;
  --help|-h)
    echo "usage: debloat.sh [--dry-run]"
    echo "  removes the no-mic/safe-tier packages listed in this script"
    echo "  --dry-run, -n  print what would be removed; change nothing"
    exit 0
    ;;
  *)
    echo "unknown argument: $1 (this script takes at most --dry-run; refusing to run)" >&2
    exit 2
    ;;
esac

PKGS=(
  # No-mic graveyard
  com.google.android.katniss
  com.google.android.apps.googleassistant
  com.google.android.tts
  com.google.android.voicesearch.tv
  # Safe universal
  com.google.android.videos
  com.google.android.music
  com.google.android.play.games
  com.android.printspooler
  com.google.android.marvin.talkback
  com.android.dreams.basic
  com.android.gallery3d
  com.android.tv.feedbackconsent
  com.google.android.backdrop
  com.google.android.apps.tv.dreamx
  com.google.android.partnersetup
  com.google.android.onetimeinitializer
  com.google.android.syncadapters.calendar
  # Privacy Sandbox — both naming variants (device-dependent)
  com.android.ondevicepersonalization.services
  com.google.android.ondevicepersonalization.services
  com.android.federatedcompute.services
  com.google.android.federatedcompute
  com.android.adservices.api
  com.google.android.adservices.api
)

removed=0
skipped=0
for p in "${PKGS[@]}"; do
  if pm list packages | grep -Fqx "package:$p"; then
    if [ "$DRY" = "1" ]; then
      echo "would remove  $p"
      removed=$((removed + 1))
    elif pm uninstall --user 0 "$p" >/dev/null 2>&1; then
      echo "removed  $p"
      removed=$((removed + 1))
    else
      echo "FAILED   $p"
    fi
  else
    echo "skip     $p (not installed)"
    skipped=$((skipped + 1))
  fi
done
echo
echo "done: $removed removed, $skipped not present. Reboot to settle."
