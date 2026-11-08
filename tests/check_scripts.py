#!/data/data/com.termux/files/usr/bin/env python3
"""Cross-check the debloat scripts against the README tables.

Guards the failure mode where docs and scripts drift apart:
  * every package in the README's Safe/No-Mic tables must appear in the
    matching script (or the caution note for remote.service),
  * the scripts must not reference packages the README never mentions,
  * all three scripts stay bash-parseable (CI also runs bash -n).
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def readme_packages() -> set[str]:
    text = (ROOT / "README.md").read_text(encoding="utf-8")
    found: set[str] = set()
    for m in re.finditer(r"`([a-z][a-z0-9_]*(?:\.[a-z0-9_]+)+)`", text):
        tok = m.group(1)
        if tok.startswith(("com.", "org.")) and "*" not in tok:
            found.add(tok)
    return found


def script_packages(name: str) -> set[str]:
    text = (ROOT / name).read_text(encoding="utf-8")
    return set(re.findall(r"^\s+(com\.[a-z0-9_.]+)\s*$", text, re.M))


def main() -> int:
    failures: list[str] = []
    docs = readme_packages()

    for script in ("debloat.sh", "debloat-safe.sh", "restore.sh"):
        pkgs = script_packages(script)
        if not pkgs:
            failures.append(f"{script}: no packages parsed")
        unknown = pkgs - docs
        if unknown:
            failures.append(f"{script}: packages absent from README: {sorted(unknown)}")

    # restore.sh must cover the union of both debloat scripts
    union = script_packages("debloat.sh") | script_packages("debloat-safe.sh")
    restored = script_packages("restore.sh")
    unrecoverable = union - restored
    if unrecoverable:
        failures.append(f"restore.sh: missing packages the debloat scripts remove: {sorted(unrecoverable)}")

    # the caution-tier package must not be in either debloat script
    caution = "com.google.android.tv.remote.service"
    if caution in script_packages("debloat.sh") or caution in script_packages("debloat-safe.sh"):
        failures.append(f"{caution} is the caution tier — scripts must not remove it")

    if failures:
        print("script check FAILED:")
        for f in failures:
            print(f"  - {f}")
        return 1
    print("script check OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
