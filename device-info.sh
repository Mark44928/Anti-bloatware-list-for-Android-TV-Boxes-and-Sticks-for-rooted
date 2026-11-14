#!/data/data/com.termux/files/usr/bin/env bash
# device-info.sh — read-only device identity report. No root, no changes.
# Handy before debloating: note the model/Android version so you can undo safely.
set -euo pipefail

prop() {
    if command -v getprop >/dev/null 2>&1; then
        getprop "$1" 2>/dev/null || true
    fi
}

row() {
    local value
    value="$(prop "$1")"
    printf '%-14s %s\n' "$2" "${value:-—}"
}

echo "Device report (read-only)"
echo "─────────────────────────"
row ro.product.manufacturer "Manufacturer"
row ro.product.model        "Model"
row ro.product.device       "Device"
row ro.build.version.release "Android"
row ro.build.version.sdk    "API level"
row ro.product.cpu.abi      "ABI"
row ro.build.characteristics "Form factor"
row ro.build.fingerprint    "Fingerprint"
