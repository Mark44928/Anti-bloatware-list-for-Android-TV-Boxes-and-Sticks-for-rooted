#!/data/data/com.termux/files/usr/bin/env bash
# debloat-safe.sh — universal-only debloat for a remote WITH a microphone.
# Never touches voice-search packages, and never touches the caution tier.
set -u

PKGS=(
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
  if pm list packages | grep -qx "package:$p"; then
    if pm uninstall --user 0 "$p" >/dev/null 2>&1; then
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
