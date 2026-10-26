<h1 align="center">Anti-Bloatware List for Android TV Boxes & Sticks</h1>

<p align="center">
  <a href="https://github.com/Mark44928/Anti-bloatware-list-for-Android-TV-Boxes-and-Sticks-for-rooted/stargazers"><img src="https://img.shields.io/github/stars/Mark44928/Anti-bloatware-list-for-Android-TV-Boxes-and-Sticks-for-rooted?style=social" alt="Stars"></a>
  <a href="https://github.com/Mark44928/Anti-bloatware-list-for-Android-TV-Boxes-and-Sticks-for-rooted/network/members"><img src="https://img.shields.io/github/forks/Mark44928/Anti-bloatware-list-for-Android-TV-Boxes-and-Sticks-for-rooted?style=social" alt="Forks"></a>
  <a href="https://github.com/Mark44928/Anti-bloatware-list-for-Android-TV-Boxes-and-Sticks-for-rooted/blob/main/LICENSE"><img src="https://img.shields.io/github/license/Mark44928/Anti-bloatware-list-for-Android-TV-Boxes-and-Sticks-for-rooted?color=blue" alt="License"/></a>
  <img src="https://img.shields.io/badge/requires-root-red" alt="Root Required"/>
  <img src="https://img.shields.io/badge/Android-9%20%7C%2010%2B-green" alt="Android Version"/>
</p>

<p align="center">
  <b>🚀 Reclaim 1.90GB+ of storage, 200MB+ of RAM, and boost performance on rooted Android TV sticks and boxes. Community-tested ADB commands optimized for Android 9+ and remotes without microphones.</b>
</p>

---

> **What is this?** A curated, community-tested list of pre-installed bloatware on Android TV sticks and boxes that you can **safely remove** to free up storage, reduce background processes, reclaim RAM, and improve overall device performance. Includes two ready-to-run command blocks: one for remotes with microphones and one for no-mic setups.

> **Read this first:** `pm uninstall --user 0 <package>` removes the app for the current user only. It is usually reversible with `cmd package install-existing <package>`, but it can still break features you rely on. Back up your device, remove one package at a time when testing, and never touch the [DO NOT TOUCH](#-do-not-touch) list.

---

## Why Debloat?

Android TV devices ship with dozens of pre-installed apps you'll never use. Removing them delivers real benefits:

| Benefit | Estimated Impact |
|:---|---:|
| **Storage Freed** | 1.90 GB+ |
| **RAM Saved** | ~200 MB+ |
| **Boot Time** | Up to 5–15% faster |
| **Background Processes** | Reduced by ~30% |
| **Idle CPU / battery** | Less background work on stick devices |

Removing bloatware also reduces telemetry, limits ad tracking, and minimizes unnecessary API calls — all without breaking your system if you follow this guide.

## Perfect For

- **Rooted Android TV users** who want a faster, cleaner device
- **Mi Box / MXQ / X96 owners** tired of bloat eating storage
- **Custom ROM testers** who need a clean baseline before flashing
- **Performance enthusiasts** optimizing boot time and RAM usage

---

## Table of Contents

- [Quick Start](#quick-start)
- [Requirements](#requirements)
- [Before You Start](#before-you-start)
- [Why Debloat?](#why-debloat)
- [Safe to Remove (Universal Bloat)](#-safe-to-remove-universal-bloat)
- [No-Mic Graveyard](#-no-mic-graveyard)
- [DO NOT TOUCH](#-do-not-touch)
- [Debloat Commands](#debloat-commands)
- [How to Restore](#how-to-restore)
- [Device Compatibility](#device-compatibility)
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
- **Root is recommended.** Some packages can be removed with plain ADB using `--user 0`; protected system packages may still require root.

---

## Safe to Remove (Universal Bloat)

These apps are safe to remove on **any** Android TV device, regardless of your remote type.

| App Name | Package Name | Why Remove It |
|:---|:---|:---|
| Android TV Remote Service | `com.google.android.tv.remote.service` | Phone-to-TV remote. Useless with a physical remote. |
| Google Play Movies | `com.google.android.videos` | Redundant streaming service. |
| Google Play Music | `com.google.android.music` | Dead service -- no longer functions. |
| Google Play Games | `com.google.android.play.games` | Only needed if you play Android games on your TV. |
| Print Spooler | `com.android.printspooler` | TVs do not need printing capabilities. |
| Talkback | `com.google.android.marvin.talkback` | Accessibility service (unless visually impaired). |
| Basic Daydreams | `com.android.dreams.basic` | Default screensaver. Safe to remove if using a custom one. |

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

Run this in an ADB shell with root access. This removes **all** bloat from both categories above.

```bash
pm uninstall --user 0 com.google.android.katniss; \
pm uninstall --user 0 com.google.android.apps.googleassistant; \
pm uninstall --user 0 com.google.android.tts; \
pm uninstall --user 0 com.google.android.voicesearch.tv; \
pm uninstall --user 0 com.google.android.tv.remote.service; \
pm uninstall --user 0 com.google.android.videos; \
pm uninstall --user 0 com.google.android.music; \
pm uninstall --user 0 com.google.android.play.games; \
pm uninstall --user 0 com.android.printspooler; \
pm uninstall --user 0 com.google.android.marvin.talkback; \
pm uninstall --user 0 com.android.dreams.basic
```

> **Pro tip:** Save this block as `debloat.sh` and run it from your PC:  
> `adb shell su -c "sh debloat.sh"`

### Has-Mic Remote (Safe Universal Only)

If your remote **has** a microphone, only remove the universal bloat:

```bash
pm uninstall --user 0 com.google.android.tv.remote.service; \
pm uninstall --user 0 com.google.android.videos; \
pm uninstall --user 0 com.google.android.music; \
pm uninstall --user 0 com.google.android.play.games; \
pm uninstall --user 0 com.android.printspooler; \
pm uninstall --user 0 com.google.android.marvin.talkback; \
pm uninstall --user 0 com.android.dreams.basic
```

> **Pro tip:** Save this block as `debloat-safe.sh` and run it from your PC:  
> `adb shell su -c "sh debloat-safe.sh"`

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

Restore the universal packages shown above (run the block that matches what you removed):

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
  com.android.dreams.basic; do
  cmd package install-existing "$p" 2>/dev/null || true
done
```

> **Note:** If `cmd package install-existing` fails on older devices, use:  
> `adb shell pm install-create -r -t -i com.android.packageinstaller.id` and reinstall from APK.

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

## Contributing

Contributions are welcome! If you've found new bloatware packages or tested on a new device:

1. Fork the repository
2. Add your findings to the appropriate table
3. Submit a Pull Request with the device model and Android version

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## You Might Also Like

- [NoNameOS](https://github.com/Mark44928/NoNameOS) - Pure C++ hobbyist OS simulation
- [SnakTUI](https://github.com/Mark44928/SnakTUI) - Neon terminal Snake game built with Python + Textual
- [Grub Blasters](https://github.com/Mark44928/GrubBlastersHTML) - Single-file Worms-style artillery game
- [CalculaHTML](https://github.com/Mark44928/CalculaHTML) - Modern calculator PWA with 14 themes

---

<p align="center">
  <i>Keep your sticks clean and fast.</i>
</p>
