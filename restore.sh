#!/data/data/com.termux/files/usr/bin/env bash
# restore.sh — restore every package the debloat scripts may have removed.
#
# `cmd package install-existing` re-enables a package that was removed with
# `pm uninstall --user 0`. Fully-uninstalled (not --user 0) packages cannot be
# restored this way — the script reports them so you know to sideload the APK.
set -u

PKGS=(
  com.google.android.katniss
  com.google.android.apps.googleassistant
  com.google.android.tts
  com.google.android.voicesearch.tv
  com.google.android.tv.remote.service
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

restored=0
missing=0
for p in "${PKGS[@]}"; do
  if pm list packages -u | grep -qx "package:$p"; then
    if cmd package install-existing "$p" >/dev/null 2>&1; then
      echo "restored $p"
      restored=$((restored + 1))
    else
      echo "FAILED   $p"
    fi
  else
    echo "absent   $p (fully uninstalled — sideload the APK)"
    missing=$((missing + 1))
  fi
done
echo
echo "done: $restored restored, $missing absent. Reboot to settle."
