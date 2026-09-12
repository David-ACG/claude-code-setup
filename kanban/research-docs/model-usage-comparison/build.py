#!/usr/bin/env python3
"""Render research.md -> index.html with the spend chart. Re-run after editing the md."""
import re, markdown
from pathlib import Path
HERE = Path(__file__).parent
md = (HERE / "research.md").read_text()
body_md = md.split("\n", 1)[1]
body_md = re.sub(r"^Research date:.*?\n\nBrowser page:.*?\n", "", body_md, flags=re.S)
body = markdown.markdown(body_md, extensions=["tables"])
body = body.replace("<table>", '<div class="tw"><table>').replace("</table>", "</table></div>")

months = ["Jun", "Jul", "Aug", "Sep*"]
claude = [2919, 6127, 2653, 2581]
codex = [402, 711, 306, 1616]
W, H, L, R, T, B = 640, 300, 56, 16, 20, 44
mx = 7000; pw = W - L - R; ph = H - T - B
g = pw / 4; bw = (g - 24) / 2
svg = [f'<svg class="chart" viewBox="0 0 {W} {H}" role="img" aria-label="API-equivalent spend per month, Claude Code vs Codex">']
for v in (0, 2000, 4000, 6000):
    y = T + ph - v / mx * ph
    svg.append(f'<line x1="{L}" x2="{W-R}" y1="{y:.1f}" y2="{y:.1f}" class="grid"/>'
               f'<text x="{L-8}" y="{y+4:.1f}" class="tick" text-anchor="end">${v//1000}k</text>')
for i, m in enumerate(months):
    x0 = L + i * g + 12
    for j, (v, cls) in enumerate(((claude[i], "s1"), (codex[i], "s2"))):
        h = v / mx * ph; x = x0 + j * (bw + 2); y = T + ph - h
        name = "Claude Code" if j == 0 else "Codex"
        svg.append(f'<rect class="{cls}" x="{x:.1f}" y="{y:.1f}" width="{bw:.1f}" height="{h:.1f}" rx="4">'
                   f'<title>{m} 2026 {name}: ${v:,}</title></rect>')
        svg.append(f'<rect class="{cls}" x="{x:.1f}" y="{y+4:.1f}" width="{bw:.1f}" height="{max(h-4,0):.1f}"/>')
        svg.append(f'<text x="{x+bw/2:.1f}" y="{y-6:.1f}" class="val" text-anchor="middle">${v:,}</text>')
    svg.append(f'<text x="{x0+bw+1:.1f}" y="{H-B+18}" class="tick" text-anchor="middle">{m}</text>')
svg.append(f'<line x1="{L}" x2="{W-R}" y1="{T+ph}" y2="{T+ph}" class="axis"/></svg>')
chart = "\n".join(svg)

html = f'''<!doctype html>
<html lang="en" data-theme="light">
<head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Claude vs Codex Usage Tools</title>
<style>
:root{{--bg:#fcfcfb;--ink:#0b0b0b;--ink2:#52514e;--line:#e4e3df;--s1:#2a78d6;--s2:#eb6834;--card:#fff;--hdr:#f4f3f0;color-scheme:light dark}}
@media(prefers-color-scheme:dark){{:root:not([data-theme=light]){{--bg:#1a1a19;--ink:#fff;--ink2:#c3c2b7;--line:#33332f;--s1:#3987e5;--s2:#d95926;--card:#222220;--hdr:#2a2a28}}}}
:root[data-theme=dark]{{--bg:#1a1a19;--ink:#fff;--ink2:#c3c2b7;--line:#33332f;--s1:#3987e5;--s2:#d95926;--card:#222220;--hdr:#2a2a28}}
*{{box-sizing:border-box}}
body{{margin:0;background:var(--bg);color:var(--ink);font:15px/1.55 system-ui,-apple-system,Segoe UI,Roboto,sans-serif}}
main{{max-width:1100px;margin:0 auto;padding:32px 24px 80px}}
h1{{font-size:30px;line-height:1.2;margin:0 0 8px;letter-spacing:-.01em}}
h2{{font-size:21px;margin:44px 0 12px;padding-top:12px;border-top:1px solid var(--line)}}
.meta{{color:var(--ink2);font-size:14px;margin:0 0 28px}}
.tw{{overflow-x:auto;margin:14px 0}}
table{{border-collapse:collapse;width:100%;font-size:13.5px}}
th,td{{text-align:left;vertical-align:top;padding:8px 10px;border-bottom:1px solid var(--line)}}
th{{background:var(--hdr);font-weight:600;position:sticky;top:0}}
td:first-child{{font-weight:600;white-space:nowrap}}
a{{color:var(--s1)}}
.fig{{background:var(--card);border:1px solid var(--line);border-radius:10px;padding:18px 18px 8px;margin:18px 0}}
.fig h3{{margin:0 0 2px;font-size:15px}}
.fig .sub{{margin:0 0 10px;color:var(--ink2);font-size:13px}}
.legend{{display:flex;gap:18px;font-size:13px;color:var(--ink2);margin:6px 0 4px}}
.legend i{{display:inline-block;width:12px;height:12px;border-radius:3px;margin-right:6px;vertical-align:-1px}}
.chart{{width:100%;height:auto;display:block}}
.chart .grid{{stroke:var(--line);stroke-width:1}} .chart .axis{{stroke:var(--ink2);stroke-width:1}}
.chart .tick{{fill:var(--ink2);font-size:12px}} .chart .val{{fill:var(--ink);font-size:11px}}
.chart .s1{{fill:var(--s1)}} .chart .s2{{fill:var(--s2)}}
.chart rect:hover{{opacity:.8}}
.tldr{{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:14px;margin:18px 0}}
.tldr div{{background:var(--card);border:1px solid var(--line);border-radius:10px;padding:14px 16px}}
.tldr b{{display:block;margin-bottom:4px}} .tldr span{{color:var(--ink2);font-size:13px}}
blockquote{{margin:0;padding:8px 14px;border-left:3px solid var(--line);color:var(--ink2)}}
ol li,ul li{{margin:4px 0}}
</style></head>
<body><main>
<h1>Comparing Claude Code and Codex subscriptions: usage, cost and quality tools</h1>
<p class="meta">Research 2026-09-11, updated 2026-09-12. Checked on hlab: Claude Max 20x, ChatGPT Pro Lite (Codex), Claude Code 2.1.263, Codex CLI 0.154.0, ccusage 20.0.17. Source: <a href="research.md">research.md</a>. Live page: <a href="https://hlab.taila51191.ts.net:8101/usage">board /usage</a>.</p>

<div class="tldr">
<div><b>Usage and cost</b><span>ccusage (installed, covers both) for API-equivalent spend. CodexBar CLI or RateTray for live 5-hour / weekly quota on both.</span></div>
<div><b>Quality on public tasks</b><span>Artificial Analysis Coding Agent Index scores the real products with $ per task. Terminal-Bench 4.0 is the hardest current board.</span></div>
<div><b>Quality on your own tasks</b><span>openbench runs Claude Code and Codex on your tasks with your subscription logins. coder_eval is the simplest YAML A/B.</span></div>
</div>

<div class="fig">
<h3>API-equivalent spend on this machine, by month</h3>
<p class="sub">ccusage, list prices, hlab only. Sep* is 12 days. About 95 percent of tokens are cache reads, so absolute values are inflated; the ratio is fair.</p>
<div class="legend"><span><i style="background:var(--s1)"></i>Claude Code (Max 20x, $200/mo)</span><span><i style="background:var(--s2)"></i>Codex (Pro Lite)</span></div>
{chart}
</div>

{body}
</main></body></html>'''
(HERE / "index.html").write_text(html)
print("wrote index.html", len(html), "bytes")
