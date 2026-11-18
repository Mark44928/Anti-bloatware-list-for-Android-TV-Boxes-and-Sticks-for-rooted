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

install_count=$(read_json_number installed); install_count=${install_count:-0}
disabled_count=$(read_json_number disabled); disabled_count=${disabled_count:-0}
absent_count=$(read_json_number absent); absent_count=${absent_count:-0}
total_count=$(read_json_number total); total_count=${total_count:-0}
enabled_count=$((install_count - disabled_count))
generated=$(date -u '+%Y-%m-%d %H:%M:%S UTC')

pct() { if [ "$2" -gt 0 ]; then echo $(($1 * 100 / $2)); else echo 0; fi; }

enabled_pct=$(pct "$enabled_count" "$total_count")
disabled_pct=$(pct "$disabled_count" "$total_count")
absent_pct=$(pct "$absent_count" "$total_count")

rows=$(
  printf '%s\n' "$audit_json" \
    | grep -oE '\{"package":"[^"]+","state":"[^"]+"\}' \
    | sed -n 's/^{"package":"\([^"]*\)","state":"\([^"]*\)"}$/\1\t\2/p' \
    | sort
)

declare -A in_safe=()
while IFS= read -r p; do
  [ -n "$p" ] && in_safe[$p]=1
done < <(grep -hE '^  [A-Za-z0-9_.]+$' debloat-safe.sh | sed 's/^  //' | sort -u)

s_tot=0; s_ena=0; s_dis=0; s_abs=0
n_tot=0; n_ena=0; n_dis=0; n_abs=0
while IFS=$'\t' read -r pkg state; do
  [ -n "$pkg" ] || continue
  if [ -n "${in_safe[$pkg]:-}" ]; then
    s_tot=$((s_tot + 1))
    case "$state" in
      enabled)  s_ena=$((s_ena + 1)) ;;
      disabled) s_dis=$((s_dis + 1)) ;;
      absent)   s_abs=$((s_abs + 1)) ;;
    esac
  else
    n_tot=$((n_tot + 1))
    case "$state" in
      enabled)  n_ena=$((n_ena + 1)) ;;
      disabled) n_dis=$((n_dis + 1)) ;;
      absent)   n_abs=$((n_abs + 1)) ;;
    esac
  fi
done <<< "$rows"
s_present=$((s_ena + s_dis))
n_present=$((n_ena + n_dis))
s_pct=$(pct "$s_present" "$s_tot")
n_pct=$(pct "$n_present" "$n_tot")

mkdir -p "$(dirname -- "$output")"
{
  printf '%s\n' '<!doctype html>' \
    '<html lang="en">' \
    '<meta charset="utf-8">' \
    '<meta name="viewport" content="width=device-width,initial-scale=1">' \
    '<title>Android TV debloat audit</title>' \
    '<style>' \
    'body{font:15px/1.45 system-ui,sans-serif;margin:0;background:#111;color:#e8e8e8}' \
    'main{max-width:860px;margin:auto;padding:24px}h1{margin:.1em 0}h2{font-size:.95rem;color:#9fd3ad;text-transform:uppercase;letter-spacing:.08em;margin:18px 0 8px}' \
    'p{color:#bbb;max-width:68ch}.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(120px,1fr));gap:10px;margin:18px 0}' \
    '.card{background:#1e1e1e;border:1px solid #333;border-radius:12px;padding:12px}.card b{display:block;font-size:1.5rem;color:#7bd88f}' \
    '.card span{color:#aaa;font-size:.82rem;text-transform:uppercase;letter-spacing:.08em}' \
    '.bar{display:grid;grid-template-columns:9.5em 1fr 4em;align-items:center;gap:10px;margin:6px 0}' \
    '.bar-label{color:#bbb;font-size:.85rem}.bar-num{color:#aaa;font-size:.82rem;text-align:right}' \
    '.bar-track{background:#1e1e1e;border:1px solid #333;border-radius:6px;height:16px;overflow:hidden}' \
    '.bar-fill{display:block;height:100%}.bar-fill.enabled,.bar-fill.safe{background:#7bd88f}.bar-fill.disabled,.bar-fill.nomic{background:#ffd166}.bar-fill.absent{background:#555}' \
    '.bar-note{font-size:.82rem;color:#888;margin:4px 0 0}' \
    '.panel{border:1px solid #333;border-radius:12px;background:#161616;padding:2px 12px 12px;margin:12px 0}' \
    '.panel summary{cursor:pointer;padding:10px 0;font-weight:600;color:#e8e8e8}' \
    '.legend{list-style:none;padding:0;margin:8px 0;color:#ccc}.legend li{display:flex;gap:10px;align-items:flex-start;margin:8px 0}' \
    '.sw{flex:0 0 auto;width:14px;height:14px;border-radius:4px;margin-top:3px}' \
    '.sw.safe{background:#7bd88f}.sw.nomic{background:#ffd166}.sw.caution{background:#e07a5f}.sw.dnt{background:#8b0000}' \
    'input{width:100%;box-sizing:border-box;background:#1e1e1e;color:#fff;border:1px solid #444;border-radius:8px;padding:10px;font:inherit}' \
    'table{width:100%;border-collapse:collapse;margin-top:14px;font-size:.9rem}th,td{text-align:left;border-bottom:1px solid #2c2c2c;padding:7px 8px}' \
    'th{color:#9fd3ad}.enabled{color:#7bd88f}.disabled{color:#ffd166}.absent{color:#888}' \
    'footer{margin-top:18px;color:#777;font-size:.78rem}code{background:#222;padding:2px 5px;border-radius:4px}' \
    '@media print{@page{margin:16mm}' \
    'body{background:#fff;color:#000;font-size:11pt}main{max-width:none;padding:0}' \
    'h1,h2,.panel summary,th{color:#000}p,.bar-label,.bar-num,.legend,.legend li{color:#222}' \
    '#filter-label,script{display:none}.card{background:#fff;border:1px solid #000;border-radius:6px;break-inside:avoid}' \
    '.card b,.card span{color:#000}.panel{background:#fff;border:1px solid #000;break-inside:avoid}' \
    '.bar-track{background:#fff;border:1px solid #000}.bar-fill{background:#000}' \
    '.enabled,.disabled,.absent{color:#000}th,td{border-bottom:1px solid #999;color:#000}' \
    'details>*:not(summary){display:block}.sw{background:#000}.sw.dnt{background:#fff;border:1px solid #000}' \
    'code{background:#eee;color:#000}a{color:#000;text-decoration:none}footer{color:#333}}' \
    '</style>' \
    '<main>' \
    '<h1>Android TV debloat audit</h1>' \
    "<p>Generated read-only at $generated. This report does not modify packages.</p>"
  printf '<div class="cards"><div class="card"><b>%s</b><span>targets</span></div><div class="card"><b>%s</b><span>installed</span></div><div class="card"><b>%s</b><span>enabled</span></div><div class="card"><b>%s</b><span>disabled</span></div><div class="card"><b>%s</b><span>absent</span></div></div>\n' \
    "$total_count" "$install_count" "$enabled_count" "$disabled_count" "$absent_count"
  printf '<section class="bars" aria-label="Audit count bars">\n<h2>Status totals</h2>\n'
  printf '<div class="bar" role="img" aria-label="enabled %s of %s audit targets"><span class="bar-label">enabled</span><div class="bar-track"><div class="bar-fill enabled" style="width:%s%%"></div></div><span class="bar-num">%s</span></div>\n' \
    "$enabled_count" "$total_count" "$enabled_pct" "$enabled_count"
  printf '<div class="bar" role="img" aria-label="disabled %s of %s audit targets"><span class="bar-label">disabled</span><div class="bar-track"><div class="bar-fill disabled" style="width:%s%%"></div></div><span class="bar-num">%s</span></div>\n' \
    "$disabled_count" "$total_count" "$disabled_pct" "$disabled_count"
  printf '<div class="bar" role="img" aria-label="absent %s of %s audit targets"><span class="bar-label">absent</span><div class="bar-track"><div class="bar-fill absent" style="width:%s%%"></div></div><span class="bar-num">%s</span></div>\n' \
    "$absent_count" "$total_count" "$absent_pct" "$absent_count"
  printf '<h2>Tier coverage (present on device)</h2>\n'
  printf '<div class="bar" role="img" aria-label="safe universal tier, %s of %s present"><span class="bar-label">safe universal</span><div class="bar-track"><div class="bar-fill safe" style="width:%s%%"></div></div><span class="bar-num">%s/%s</span></div>\n' \
    "$s_present" "$s_tot" "$s_pct" "$s_present" "$s_tot"
  printf '<div class="bar" role="img" aria-label="no-mic graveyard tier, %s of %s present"><span class="bar-label">no-mic graveyard</span><div class="bar-track"><div class="bar-fill nomic" style="width:%s%%"></div></div><span class="bar-num">%s/%s</span></div>\n' \
    "$n_present" "$n_tot" "$n_pct" "$n_present" "$n_tot"
  printf '<p class="bar-note">safe universal: %s enabled, %s disabled, %s absent · no-mic graveyard: %s enabled, %s disabled, %s absent</p>\n</section>\n' \
    "$s_ena" "$s_dis" "$s_abs" "$n_ena" "$n_dis" "$n_abs"
  printf '%s\n' '<details class="panel" open><summary>Risk legend</summary>' \
    '<ul class="legend">' \
    '<li><span class="sw safe"></span><span><b>Safe universal</b> — audited and counted above. Removable on any remote; ships in <code>debloat-safe.sh</code>. Data loss risk: low, but test one package at a time.</span></li>' \
    '<li><span class="sw nomic"></span><span><b>No-mic graveyard</b> — audited and counted above. Voice/assistant targets; only for remotes WITHOUT a microphone. Ships in <code>debloat.sh</code> only. Removing these breaks voice control.</span></li>' \
    '<li><span class="sw caution"></span><span><b>Use Caution</b> — NOT audited, never in any script. <code>com.google.android.tv.remote.service</code>: carries the phone remote, casting control and possibly the mic. Keep it if you cast.</span></li>' \
    '<li><span class="sw dnt"></span><span><b>DO NOT TOUCH</b> — NOT audited, never in any script. System components whose removal can boot-loop or break the device; see the README list.</span></li>' \
    '</ul>' \
    '<p class="bar-note">Bars count audit targets only (Safe universal + No-mic graveyard). Caution and DO NOT TOUCH packages are never audited or removed by these scripts.</p>' \
    '</details>'
  printf '%s\n' '<details class="panel" open><summary>Packages</summary>' \
    '<label id="filter-label">Filter packages<br><input id="filter" type="search" placeholder="package name…" autocomplete="off"></label>' \
    '<table><thead><tr><th>Package</th><th>State</th></tr></thead><tbody id="rows">'
  while IFS=$'\t' read -r pkg state; do
  [ -n "$pkg" ] || continue
  printf '<tr><td><code>%s</code></td><td class="%s">%s</td></tr>\n' "$pkg" "$state" "$state"
  done <<< "$rows"
  printf '%s\n' '</tbody></table>' \
    '</details>' \
    '<details class="panel"><summary>How this report is generated</summary>' \
    '<p>Built from <code>audit.sh --json</code> on the device: package lists in <code>debloat.sh</code> / <code>debloat-safe.sh</code> are classified enabled, disabled or absent via <code>pm list packages</code>. Single static file, no network, no telemetry, no external assets. Re-run <code>bash report.sh</code> on the device to refresh.</p>' \
    '</details>' \
    '<script>' \
    'const input=document.getElementById("filter"),rows=[...document.querySelectorAll("#rows tr")];' \
    'input.addEventListener("input",()=>{const q=input.value.trim().toLowerCase();for(const row of rows)row.hidden=q&&!row.textContent.toLowerCase().includes(q);});' \
    '</script>' \
    '<footer>Source: <code>audit.sh --json</code> · disabled targets are already present but inactive; absent targets are skipped by debloat scripts.</footer>' \
    '</main>' \
    '</html>'
} > "$output"

echo "wrote $output"
