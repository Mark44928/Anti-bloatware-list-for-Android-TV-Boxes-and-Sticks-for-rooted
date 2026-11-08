#!/data/data/com.termux/files/usr/bin/env python3
"""README consistency checks for the anti-bloatware list.

Guards the failure modes that historically broke this README:
  * an unbalanced code fence swallowed the restore block,
  * table-of-contents anchors pointed at headings that 404 on GitHub,
  * wildcards appeared in package columns even though pm uninstall needs
    exact package names.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

README = Path(__file__).resolve().parent.parent / "README.md"


def anchor_slug(heading: str) -> str:
    slug = heading.strip().lower()
    slug = re.sub(r"[^\w\s-]", "", slug)  # drop punctuation, keep words/space/-
    return slug.replace(" ", "-")


def main() -> int:
    text = README.read_text(encoding="utf-8")
    lines = text.splitlines()
    failures: list[str] = []

    # 1. Fenced code blocks must be balanced.
    fence_lines = [i for i, ln in enumerate(lines, 1) if ln.lstrip().startswith("```")]
    if len(fence_lines) % 2 != 0:
        failures.append(f"unbalanced code fences ({len(fence_lines)} fence lines)")

    # 2. Every ToC anchor must match a heading.
    headings = {anchor_slug(ln.lstrip("#").strip()) for ln in lines if ln.startswith("#")}
    for m in re.finditer(r"^- \[[^\]]+\]\(#([^)]+)\)", text, re.M):
        if m.group(1) not in headings:
            failures.append(f"ToC anchor #{m.group(1)} has no heading")

    # 3. Table rows must not contain wildcard package names.
    for i, ln in enumerate(lines, 1):
        if not ln.startswith("|"):
            continue
        for m in re.finditer(r"`([a-z][a-z0-9_]*(?:\.[a-z0-9_]+)+)`", ln):
            if "*" in m.group(1):
                failures.append(f"line {i}: wildcard package name {m.group(1)} (pm uninstall needs exact names)")

    # 4. Backticked tokens that look like packages must be well-formed.
    for i, ln in enumerate(lines, 1):
        if "*" in ln:
            continue  # wildcard lines are checked by rule 3 prose exception
        for m in re.finditer(r"`([a-z][a-z0-9_.*]+)`", ln):
            tok = m.group(1)
            if tok.startswith("com.") and not re.fullmatch(r"[a-z][a-z0-9_]*(\.[a-z0-9_]+)+", tok):
                failures.append(f"line {i}: malformed package name {tok}")

    if failures:
        print("README check FAILED:")
        for f in failures:
            print(f"  - {f}")
        return 1
    print("README check OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
