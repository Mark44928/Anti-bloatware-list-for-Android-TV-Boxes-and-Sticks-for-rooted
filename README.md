# Android TV System Bloatware List 🪦
A guide to the pre-installed apps you can safely nuke on Android TV sticks to reclaim your 1.90GB+ free space.
> **Note:** This list is for **Rooted** users. Removing these apps will stop background updates and free up RAM/Storage. Pre-android 10 recommend, Android 10 and above okay but there's limitations unless you're rooted
## 🎤 The "No-Mic" Graveyard
> **⚠️ WARNING:** If your remote **DOES NOT** have a Microphone button, delete these apps immediately. They are completely useless and consume background resources.

| App Name | Package Name | Why it's Bloat |
| :--- | :--- | :--- |
| **Google App** | `com.google.android.katniss` | Main Voice Search engine. Massive storage hog. |
| **Google Assistant** | `com.google.android.apps.googleassistant` | Useless without a mic trigger. |
| **Speech Services** | `com.google.android.tts` | Text-to-speech engine. Unnecessary for most users. |
| **Voice Search** | `com.google.android.voicesearch.tv` | Legacy voice query launcher. |

## 🟢 Category: Safe to Remove (Universal Bloat)
These apps are standard on most Android TV builds and are safe to remove to free up system and data space.

| App Name | Package Name | Reason to Nuke |
| :--- | :--- | :--- |
| **Android TV Remote Service** | `com.google.android.tv.remote.service` | Used for phone-to-TV remote apps. Safe to nuke if using physical remote. |
| **Google Play Movies** | `com.google.android.videos` | Redundant streaming service. |
| **Google Play Music** | `com.google.android.music` | Dead service; no longer functions. |
| **Google Play Games** | `com.google.android.play.games` | Only needed if you play Android games on your TV. |
| **Print Spooler** | `com.android.printspooler` | TVs do not need printing capabilities. |
| **Talkback** | `com.google.android.marvin.talkback` | Accessibility bloat (unless visually impaired). |
| **Basic Daydreams** | `com.android.dreams.basic` | Default screensaver engine. Safe to remove if using a custom one. |

## 🔴 Category: DO NOT TOUCH
Deleting these will break your system or cause a bootloop:
* `com.google.android.gms` (Google Play Services)
* `com.android.vending` (Play Store)
* `com.google.android.packageinstaller` (System App Installer)

# THE COMMAND FOR DEBLOATING (Only remotes without Microphone.)
'''
pm uninstall --user 0 com.google.android.katniss; pm uninstall --user 0 com.google.android.apps.googleassistant; pm uninstall --user 0 com.google.android.tts; pm uninstall --user 0 com.google.android.voicesearch.tv; pm uninstall --user 0 com.google.android.tv.remote.service; pm uninstall --user 0 com.google.android.videos; pm uninstall --user 0 com.google.android.music; pm uninstall --user 0 com.google.android.play.games; pm uninstall --user 0 com.android.printspooler; pm uninstall --user 0 com.google.android.marvin.talkback; pm uninstall --user 0 com.android.dreams.basic; pm uninstall --user 0 com.android.providers.downloads.ui; pm uninstall --user 0 com.google.android.feedback; pm uninstall --user 0 com.google.android.syncadapters.contacts
'''
---
*Maintained by Mark44928 - Keeping sticks smooth af.*
