#!/data/data/com.termux/files/usr/bin/env bash
# report.sh — build a static, read-only HTML report from the device audit.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"
output="audit-report.html"

case "${1:-}" in
  --help|-h)
    echo "usage: report.sh [--output FILE]"
    echo "  --output FILE   write the HTML report to FILE instead of audit-report.html"
    exit 0
    ;;
  --output)
    [ -n "${2:-}" ] || { echo "report.sh: --output needs a file" >&2; exit 2; }
    output="$2"
    ;;
  --output=*)
    output="${1#--output=}"
    [ -n "$output" ] || { echo "report.sh: --output needs a file" >&2; exit 2; }
    ;;
  "") ;;
  *) echo "unknown option: $1 (try --help)" >&2; exit 2 ;;
esac

command -v pm >/dev/null 2>&1 || { echo "pm is required (run on an Android device)" >&2; exit 1; }

audit_json=$(bash audit.sh --json)

read_json_number() {
  printf '%s' "$audit_json" | sed -n "s/.*\"$1\":\([0-9][0-9]*\).*/\1/p" | head -n 1
}

install_count=$(read_json_number installed)
disabled_count=$(read_json_number disabled)
absent_count=$(read_json_number absent)
total_count=$(read_json_number total)
generated=$(date -u '+%Y-%m-%d %H:%M:%S UTC')

rows=$(
  printf '%s\n' "$audit_json" \
    | grep -oE '\{"package":"[^"]+","state":"[^"]+"\}' \
    | sed -n 's/^{"package":"\([^"]*\)","state":"\([^"]*\)"}$/\1\t\2/p' \
    | sort
)

mkdir -p "$(dirname -- "$output")"
{
  printf '%s\n' '<!doctype html>' \
    '<html lang="en">' \
    '<meta charset="utf-8">' \
    '<meta name="viewport" content="width=device-width,initial-scale=1">' \
    '<title>Android TV debloat audit</title>' \
    '<style>' \
    'body{font:15px/1.45 system-ui,sans-serif;margin:0;background:#111;color:#e8e8e8}' \
    'main{max-width:860px;margin:auto;padding:24px}h1{margin:.1em 0}' \
    'p{color:#bbb;max-width:68ch}.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(130px,1fr));gap:10px;margin:18px 0}' \
    '.card{background:#1e1e1e;border:1px solid #333;border-radius:12px;padding:12px}.card b{display:block;font-size:1.5rem;color:#7bd88f}' \
    '.card span{color:#aaa;font-size:.82rem;text-transform:uppercase;letter-spacing:.08em}' \
    'input{width:100%;box-sizing:border-box;background:#1e1e1e;color:#fff;border:1px solid #444;border-radius:8px;padding:10px;font:inherit}' \
    'table{width:100%;border-collapse:collapse;margin-top:14px;font-size:.9rem}th,td{text-align:left;border-bottom:1px solid #2c2c2c;padding:7px 8px}' \
    'th{color:#9fd3ad}.enabled{color:#7bd88f}.disabled{color:#ffd166}.absent{color:#888}' \
    'footer{margin-top:18px;color:#777;font-size:.78rem}code{background:#222;padding:2px 5px;border-radius:4px}' \
    '</style>' \
    '<main>' \
    '<h1>Android TV debloat audit</h1>' \
    "<p>Generated read-only at $generated. This report does not modify packages.</p>"
  printf '<div class="cards"><div class="card"><b>%s</b><span>targets</span></div><div class="card"><b>%s</b><span>installed</span></div><div class="card"><b>%s</b><span>disabled</span></div><div class="card"><b>%s</b><span>absent</span></div></div>\n' \
    "${total_count:-?}" "${install_count:-?}" "${disabled_count:-?}" "${absent_count:-?}"
  printf '%s\n' '<label>Filter packages<br><input id="filter" type="search" placeholder="package name…" autocomplete="off"></label>' \
    '<table><thead><tr><th>Package</th><th>State</th></tr></thead><tbody id="rows">'
  while IFS=$'\t' read -r pkg state; do
  [ -n "$pkg" ] || continue
  printf '<tr><td><code>%s</code></td><td class="%s">%s</td></tr>\n' "$pkg" "$state" "$state"
  done <<< "$rows"
  printf '%s\n' '</tbody></table>' \
    '<script>' \
    'const input=document.getElementById("filter"),rows=[...document.querySelectorAll("#rows tr")];' \
    'input.addEventListener("input",()=>{const q=input.value.trim().toLowerCase();for(const row of rows)row.hidden=q&&!row.textContent.toLowerCase().includes(q);});' \
    '</script>' \
    '<footer>Source: <code>audit.sh --json</code> · disabled targets are already present but inactive; absent targets are skipped by debloat scripts.</footer>' \
    '</main>' \
    '</html>'
} > "$output"

echo "wrote $output"
