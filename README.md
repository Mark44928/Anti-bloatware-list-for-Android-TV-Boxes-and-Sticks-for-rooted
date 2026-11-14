<h1 align="center">Anti-Bloatware List for Android TV Boxes &amp; Sticks</h1>

<p align="center">
  <a href="https://github.com/Mark44928/Anti-bloatware-list-for-Android-TV-Boxes-and-Sticks-for-rooted/stargazers"><img src="https://img.shields.io/github/stars/Mark44928/Anti-bloatware-list-for-Android-TV-Boxes-and-Sticks-for-rooted?style=social" alt="Stars"></a>
  <a href="https://github.com/Mark44928/Anti-bloatware-list-for-Android-TV-Boxes-and-Sticks-for-rooted/network/members"><img src="https://img.shields.io/github/forks/Mark44928/Anti-bloatware-list-for-Android-TV-Boxes-and-Sticks-for-rooted?style=social" alt="Forks"></a>
  <a href="https://github.com/Mark44928/Anti-bloatware-list-for-Android-TV-Boxes-and-Sticks-for-rooted/blob/main/LICENSE"><img src="https://img.shields.io/github/license/Mark44928/Anti-bloatware-list-for-Android-TV-Boxes-and-Sticks-for-rooted?color=blue" alt="License"/></a>
  <img src="https://img.shields.io/badge/requires-root-red" alt="Root Required"/>
  <img src="https://img.shields.io/badge/Android-9%20%7C%2010%2B-green" alt="Android Version"/>
  <img src="https://img.shields.io/badge/list%20version-v2.0.0-blue" alt="List Version"/>
  <img src="https://img.shields.io/badge/scripts-debloat%20%C2%B7%20safe%20%C2%B7%20restore-informational" alt="Bundled scripts"/>
</p>

<p align="center">
  <b>Reclaim up to ~1.9 GB of storage and cut background work on rooted Android TV sticks and boxes. Community-tested ADB commands optimized for Android 9+ and remotes without microphones.</b>
</p>

---

> **What is this?** A curated, community-tested list of pre-installed bloatware on Android TV sticks and boxes that you can **safely remove** to free up storage, reduce background processes, reclaim RAM, and improve overall device performance. Includes two ready-to-run command blocks: one for remotes with microphones and one for no-mic setups.

> **Read this first:** `pm uninstall --user 0 <package>` removes the app for the current user only. It is usually reversible with `cmd package install-existing <package>`, but it can still break features you rely on. Back up your device, remove one package at a time when testing, and never touch the [DO NOT TOUCH](#do-not-touch) list.

---

## Why Debloat?

Android TV devices ship with dozens of pre-installed apps you'll never use. Removing them delivers real benefits:

| Benefit | Estimated Impact |
|:---|---:|
| **Storage Freed** | Up to ~1.9 GB (varies by device and image) |
| **RAM Saved** | ~150–250 MB |
| **Boot Time** | Often a few seconds faster |
| **Background Processes** | Noticeably fewer wakeups on stick hardware |

> These are community measurements from common Android 9/10 TV sticks and boxes, not guaranteed figures — the exact savings depend on your device's factory image. Removing bloatware also reduces telemetry, limits ad tracking, and minimizes unnecessary API calls — all without breaking your system if you follow this guide.

## Perfect For

- **Rooted Android TV users** who want a faster, cleaner device
- **Mi Box / MXQ / X96 owners** tired of bloat eating storage
- **Custom ROM testers** who need a clean baseline before flashing
- **Performance enthusiasts** optimizing boot time and RAM usage

---

## Table of Contents

- [Why Debloat?](#why-debloat)
- [Quick Start](#quick-start)
- [Requirements](#requirements)
- [Before You Start](#before-you-start)
- [Safe to Remove (Universal Bloat)](#safe-to-remove-universal-bloat)
- [Use Caution](#use-caution)
- [No-Mic Graveyard](#no-mic-graveyard)
- [DO NOT TOUCH](#do-not-touch)
- [Debloat Commands](#debloat-commands)
- [How to Restore](#how-to-restore)
- [Device Compatibility](#device-compatibility)
- [Vendor-Specific Bloatware](#vendor-specific-bloatware-safe-to-remove)
- [Changelog](#changelog)
- [Contributing](#contributing)
- [License](#license)

---

## Quick Start

1. Enable **ADB debugging** in Developer Options and connect to your TV.
2. **Root** your device using Magisk or SuperSU.
3. Run the appropriate command block from the [Debloat Commands](#debloat-commands) section.
4. **Reboot** and enjoy a cleaner, faster device.

> **No-Mic remote?** Use the Full Debloat script.  
> **Has-Mic remote?** Use the Safe Universal Only script.

---

## Requirements

- **Rooted** Android TV device (Magisk, SuperSU, or kernel-level root)
- ADB shell access (via `adb shell` or a terminal emulator on-device)
- Android 9 or higher (works on Android 10+ with some limitations when not rooted)

---

## Before You Start

1. **Back up your data** -- Removing system apps is reversible, but it's good practice.
2. **Know your remote** -- If your remote has a **microphone button**, skip the "No-Mic" section.
3. **Never remove Google Play Services** (`com.google.android.gms`) or the Play Store (`com.android.vending`) -- this will break your system.

### Safety checklist

- **Verify the package exists first:** `pm list packages | grep <name>`
- **Check what it is:** `pm path <package>`
- **Remove one package at a time while testing**, not the whole block at once.
- **Use `--user 0`:** `pm uninstall --user 0 <package>` is per-user and usually reversible.
- **Restore it:** `cmd package install-existing <package>`
- **Never use `pm uninstall` without `--user 0`** unless you have a full system backup and know exactly what you are doing.

### Device report (no root)

Note what you are working on before removing anything — model, Android
version and ABI, straight from `getprop`:

```bash
bash device-info.sh
```

### Package backup (no root)

Before removing anything, keep a restorable list of every installed package
and its APK path:

```bash
bash backup-packages.sh                 # -> ~/android-packages-<timestamp>.txt
bash backup-packages.sh ~/my-backup.txt
```

The dump pairs each package with its `pm path` APK, so you can reinstall or
verify exactly what you removed.

---

## Safe to Remove (Universal Bloat)

These apps are safe to remove on **any** Android TV device, regardless of your remote type.

| App Name | Package Name | Why Remove It |
|:---|:---|:---|
| Google Play Movies | `com.google.android.videos` | Redundant streaming service. |
| Google Play Music | `com.google.android.music` | Dead service -- no longer functions. |
| Google Play Games | `com.google.android.play.games` | Only needed if you play Android games on your TV. |
| Print Spooler | `com.android.printspooler` | TVs do not need printing capabilities. |
| Talkback | `com.google.android.marvin.talkback` | Accessibility service (unless visually impaired). |
| Basic Daydreams | `com.android.dreams.basic` | Default screensaver. Safe to remove if using a custom one. |
| **Legacy Photo Viewer** | `com.android.gallery3d` | Old gallery app; replaced by Google Photos. |
| **Feedback Consent** | `com.android.tv.feedbackconsent` | Telemetry opt-in prompt. Safe to remove. |
| **On-Device Personalization** | `com.android.ondevicepersonalization.services` (Chromecast / Google TV Streamer: `com.google.android.ondevicepersonalization.services`) | ML personalization service; not needed on TV. |
| **Federated Compute** | `com.android.federatedcompute.services` (Chromecast / Google TV Streamer: `com.google.android.federatedcompute`) | Cross-device ML; unnecessary on TV. |
| **Ambient Backdrop** | `com.google.android.backdrop` | Ambient mode screensaver; uses storage/bandwidth. |
| **Ambient DreamX** | `com.google.android.apps.tv.dreamx` | Screensaver framework; safe if not using Ambient mode. |
| **Privacy Sandbox Ads API** | `com.android.adservices.api` (Chromecast / Google TV Streamer: `com.google.android.adservices.api`) | Ad targeting framework; TV apps don't use it. |
| **Partner Setup** | `com.google.android.partnersetup` | OEM attribution pings; safe to remove. |
| **One-Time Initializer** | `com.google.android.onetimeinitializer` | Runs once at setup; no ongoing function. |
| **Calendar Sync Adapter** | `com.google.android.syncadapters.calendar` | No calendar app on TV; safe to remove. |

> **Package names differ by device family.** The Privacy Sandbox packages above ship under both `com.android.*` (onn., TCL Google TV) and `com.google.*` (Chromecast with Google TV, Google TV Streamer) names — the command blocks below remove **both** variants, and missing ones fail harmlessly.

---

## Use Caution

These are *mostly* useless but have known side effects. Remove them one at a time and reboot after each.

| App Name | Package Name | What breaks / costs you |
|:---|:---|:---|
| Android TV Remote Service | `com.google.android.tv.remote.service` | Breaks the Google TV **phone remote** and Google Home casting control; on some devices it also carries the remote's microphone, and community tools (tv-detox) report it can hijack the default input method. Keep it if you ever cast or use the phone app. |

---

## No-Mic Graveyard

> **If your remote does NOT have a microphone button**, remove these apps. They are completely useless without a mic trigger and waste background resources.

| App Name | Package Name | Why Remove It |
|:---|:---|:---|
| Google App | `com.google.android.katniss` | Main voice search engine. Massive storage hog. |
| Google Assistant | `com.google.android.apps.googleassistant` | Useless without a mic trigger. |
| Speech Services | `com.google.android.tts` | Text-to-speech engine. Unnecessary for most users. |
| Voice Search | `com.google.android.voicesearch.tv` | Legacy voice query launcher. |

---

## DO NOT TOUCH

Deleting these will **break your system** or cause a bootloop:

| Package Name | What It Is |
|:---|:---|
| `com.google.android.gms` | Google Play Services -- required by almost everything |
| `com.android.vending` | Google Play Store |
| `com.google.android.packageinstaller` | System app installer |

---

## Debloat Commands

### No-Mic Remote (Full Debloat)

Run this in an ADB shell with root access. This removes **all** bloat from both categories above. Packages that do not exist on your device fail harmlessly.

```bash
pkgs=(
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
for p in "${pkgs[@]}"; do
  pm list packages | grep -qx "package:$p" && pm uninstall --user 0 "$p" || echo "skip (not installed): $p"
done
```

> **This block is also a file in this repo:** [`debloat.sh`](debloat.sh) — push it
> and run it instead of copy-pasting:
> ```bash
> adb push debloat.sh /sdcard/debloat.sh
> adb shell su -c "sh /sdcard/debloat.sh"
> ```
> It existence-checks every package first (`pm list packages`), so misses on
> your device are reported and skipped, and it is safe to run twice. [`restore.sh`](restore.sh)
> undoes both blocks.

### Has-Mic Remote (Safe Universal Only)

If your remote **has** a microphone, only remove the universal bloat:

```bash
pkgs=(
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
for p in "${pkgs[@]}"; do
  pm list packages | grep -qx "package:$p" && pm uninstall --user 0 "$p" || echo "skip (not installed): $p"
done
```

> **This block is also a file in this repo:** [`debloat-safe.sh`](debloat-safe.sh) —
> same push-and-run flow, same existence checks, same [`restore.sh`](restore.sh)
> safety net.

---

## How to Restore

If you accidentally removed something important, restore it with:

```bash
cmd package install-existing <package.name>
```

Example:

```bash
cmd package install-existing com.google.android.music
```

Packages that were system apps and are not in the Play Store sometimes need one reboot before `install-existing` sees them again.

### Restore everything (both command blocks, universal + no-mic)

```bash
for p in \
  com.google.android.katniss \
  com.google.android.apps.googleassistant \
  com.google.android.tts \
  com.google.android.voicesearch.tv \
  com.google.android.tv.remote.service \
  com.google.android.videos \
  com.google.android.music \
  com.google.android.play.games \
  com.android.printspooler \
  com.google.android.marvin.talkback \
  com.android.dreams.basic \
  com.android.gallery3d \
  com.android.tv.feedbackconsent \
  com.google.android.backdrop \
  com.google.android.apps.tv.dreamx \
  com.google.android.partnersetup \
  com.google.android.onetimeinitializer \
  com.google.android.syncadapters.calendar \
  com.android.ondevicepersonalization.services \
  com.google.android.ondevicepersonalization.services \
  com.android.federatedcompute.services \
  com.google.android.federatedcompute \
  com.android.adservices.api \
  com.google.android.adservices.api; do
  cmd package install-existing "$p" 2>/dev/null || echo "not restored: $p"
done
```

> **Note:** `cmd package install-existing` is the correct restore for user-0 removals. If it reports a package as missing, the app was fully uninstalled (not `--user 0`) — reinstalling the original APK with `adb install` or a factory reset are the only options then. `pm install-create -r -t -i com.android.packageinstaller.id` creates an install session but does **not** restore a removed package on its own, so it is not a valid restore path here.

---

## Device Compatibility

This list has been tested on common Android TV sticks and boxes running Android 9+. Known compatible devices:

| Device | Android Version | Notes |
|:---|:---|:---|
| Generic MXQ / X96 boxes | 9.0 | Fully compatible |
| Xiaomi Mi Box S | 9.0 / 10.0 | Some Google apps may reappear after updates |
| Chromecast with Google TV | 10.0+ | Limited -- some packages are protected |
| Onn. Android TV Box | 10.0 | Fully compatible |

> Have a device not listed? [Open an issue](https://github.com/Mark44928/Anti-bloatware-list-for-Android-TV-Boxes-and-Sticks-for-rooted/issues) and let us know!

---

### Vendor-Specific Bloatware (Safe to Remove)

These packages are pre-installed by specific manufacturers and are generally safe to remove. **Always test one at a time.**

| Vendor | Package Name | Description |
|:---|:---|:---|
| **Xiaomi / Mi** | `com.mitv.tvhome.atv` | PatchWall launcher rows |
| **Xiaomi / Mi** *(cont.)* | `com.mitv.tvhome.michannel` | Mi content rows |
| **Xiaomi / Mi** *(cont.)* | `com.mitv.tvhome.mitvplus` | Mi TV+ ad-funded channels |
| **Xiaomi / Mi** *(cont.)* | `com.mitv.tvhome.oemtab` | Xiaomi ad row on home |
| **Xiaomi / Mi** *(cont.)* | `com.miui.tv.analytics` | Mi analytics telemetry |
| **TCL** | `com.tcl.channelplus` | TCL Live FAST channels |
| **TCL** *(cont.)* | `com.tcl.dashboard` | TCL Home panel &amp; promos |
| **TCL** *(cont.)* | `com.tcl.esticker` | Store demo stickers |
| **TCL** *(cont.)* | `com.tcl.exhibit` | Store demo mode |
| **TCL** *(cont.)* | `com.tcl.gamebar` | Game mode overlay |
| **TCL** *(cont.)* | `com.tcl.guard` | TGuard: tracking &amp; memory cleaner |
| **TCL** *(cont.)* | `com.tcl.hearaid` | Hearing test / volume adaptation |
| **TCL** *(cont.)* | `com.tcl.hotelmenu` | Hotel mode |
| **TCL** *(cont.)* | `com.tcl.initsetup` | First-run setup with ACR hooks |
| **TCL** *(cont.)* | `com.tcl.interactive` | TIAS background service |
| **TCL** *(cont.)* | `com.tcl.logkit` | Log capture &amp; upload |
| **TCL** *(cont.)* | `com.tcl.messagebox` | Pushed messages &amp; promos |
| **TCL** *(cont.)* | `com.tcl.ocean.instructions` | E-manual |
| **TCL** *(cont.)* | `com.tcl.partnercustomizer` | Google TV home row tweaks |
| **TCL** *(cont.)* | `com.tcl.repairguide` | Self-diagnosis tool |
| **TCL** *(cont.)* | `com.tcl.smartalexa` | Alexa client (keep if using Alexa) |
| **TCL** *(cont.)* | `com.tcl.smartlink.core` | Silent app installer bundle |
| **TCL** *(cont.)* | `com.tcl.t_solo` | Bluetooth "listen alone" |
| **TCL** *(cont.)* | `com.tcl.ttvs` | BI/awareness/identifier services |
| **TCL** *(cont.)* | `com.tcl.tv.plus` | TCL TV+ free channels |
| **TCL** *(cont.)* | `com.tcl.tv.tclhome_passive` | Pushes TCL content at boot |
| **TCL** *(cont.)* | `com.tcl.useragreement` | EULA/privacy screens |
| **TCL** *(cont.)* | `com.tcl.usercenter` | TCL account sign-in |
| **TCL** *(cont.)* | `com.tcl.waterfall.overseas` | Content "waterfall" recommendations |
| **Sony** | `com.sony.dtv.customersupport` | Help tile |
| **Sony** *(cont.)* | `com.sony.dtv.da.service` | Device analytics |
| **Sony** *(cont.)* | `com.sony.dtv.demosupport` | Demo mode support |
| **Sony** *(cont.)* | `com.sony.dtv.demosystemsupport` | Demo system support |
| **Sony** *(cont.)* | `com.sony.dtv.multiscreendemo` | Multi-screen demo |
| **Sony** *(cont.)* | `com.sony.dtv.smarthelp` | Smart help overlay |
| **Sony** *(cont.)* | `com.sony.dtv.sonybugreportsys` | Bug report system |
| **Sony** *(cont.)* | `com.sonyericsson.idd.agent` | Legacy IDD agent |
| **Sony** *(cont.)* | `com.qterics.da.product` | Device analytics |
| **Philips / TP Vision** | `com.mediatek.opapp` | Euro satellite operator apps |
| **Philips / TP Vision** *(cont.)* | `com.mstar.android.tv.disclaimercustomization` | Disclaimer popup |
| **NVIDIA SHIELD** | `com.nvidia.diagtools` | Log collector (re-enable if support asks) |
| **NVIDIA SHIELD** *(cont.)* | `com.nvidia.feedback` | Crash reports &amp; feedback form |
| **NVIDIA SHIELD** *(cont.)* | `com.nvidia.nvgamecast` | GameStream receiver (Moonlight/Sunshine don't need it) |
| **NVIDIA SHIELD** *(cont.)* | `com.nvidia.stats` | Anonymous usage statistics |
| **NVIDIA SHIELD** *(cont.)* | `com.nvidia.tegrazone3` | "NVIDIA Games" app row (GeForce NOW is separate) |
| **Freeview / UK TV** | `uk.co.freeview.*`, `org.droidtv.*` | Prefix families, not single packages -- see the snippet below |

### Removing prefix families

`pm uninstall` cannot take wildcards, so expand a prefix family first:

```bash
for p in $(pm list packages | grep -E '^(uk\.co\.freeview|org\.droidtv)' | cut -d: -f2); do
  pm uninstall --user 0 "$p"
done
```

---

## Changelog

### v2.0.0
- **Correctness audit against current community lists** — the three Privacy
  Sandbox packages ship under two naming variants (`com.android.*` on onn. /
  TCL Google TV, `com.google.*` on Chromecast with Google TV and Google TV
  Streamer); both are now documented and removed
- `com.google.android.tv.remote.service` moved out of "Safe" into a new
  **Use Caution** tier — it carries the phone remote, casting control, and on
  some devices the remote's microphone
- Fixed the broken code fence that swallowed the restore block, the three
  404-ing table-of-contents anchors, and the invalid `pm install-create`
  restore fallback
- The restore block now covers **every** package in both debloat blocks
- Both blocks are shipped as real scripts — [`debloat.sh`](debloat.sh),
  [`debloat-safe.sh`](debloat-safe.sh), [`restore.sh`](restore.sh) — with
  `pm list packages` existence checks so misses are skipped, not fatal
- Wildcard "packages" (`uk.co.freeview.*`) replaced with a working
  `pm list packages | grep` expansion snippet
- Vendor tables: continuation cells name their vendor again (screen-reader and
  parser friendly)
- CI now checks fence balance, ToC anchors, package-name syntax, and that the
  scripts and README cannot drift apart. The three scripts (`debloat.sh`,
  `debloat-safe.sh`, `restore.sh`) are `bash -n`-parsed and cross-checked
  against the README tables.

## Contributing

Contributions are welcome! If you've found new bloatware packages or tested on a new device (see [CONTRIBUTING.md](CONTRIBUTING.md); all contributors follow the [Code of Conduct](CODE_OF_CONDUCT.md)):

1. Fork the repository
2. Add your findings to the appropriate table
3. Submit a Pull Request with the device model and Android version

---


## 🛠️ More from Mark44928

Tiny, dependency-free tools from the same family:

- [plusafetch](https://github.com/Mark44928/plusafetch) — C++23 fetch for Termux — ~23 ms, zero subprocesses on the default path
- [Plusalator](https://github.com/Mark44928/Plusalator) — C++17 calculator REPL — Qalculate-flavored, ghost autosuggest, 18 themes
- [GrubBlastersHTML](https://github.com/Mark44928/GrubBlastersHTML) — Worms-style artillery in one HTML file — 70 weapons, fully destructible terrain
- [SnakTUI](https://github.com/Mark44928/SnakTUI) — modern Snake for your terminal — Textual + Python
- [Easy-Termux-Package-Manager](https://github.com/Mark44928/Easy-Termux-Package-Manager) — fzf-driven package manager for Termux — snapshots, audit, 183 tests
- [NoNameOS](https://github.com/Mark44928/NoNameOS) — OS simulation in a single C++17 file — virtual FS, real shell
- [Greenit](https://github.com/Mark44928/Greenit) — green-injected theme family — dark + light, single palette.json
- [CalculaHTML](https://github.com/Mark44928/CalculaHTML) — static HTML calculator — 15 themes + System mode, zero deps
- [android12-fastfetch](https://github.com/Mark44928/android12-fastfetch) — fastfetch config for Android 12 + native X11 Termux desktops
- [Android9-audios](https://github.com/Mark44928/Android9-audios) — 217 stock Android 9 system sounds + per-file SHA-256

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

<p align="center">
  <i>Keep your sticks clean and fast.</i>
</p>
