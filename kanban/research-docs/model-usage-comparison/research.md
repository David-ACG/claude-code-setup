# Comparing Claude Code and Codex subscriptions: usage, cost and quality tools

Research date: 2026-09-11. Machine checked: hlab (Claude Max 20x, ChatGPT "Pro Lite" Codex plan, Claude Code 2.1.263, Codex CLI 0.154.0, ccusage 20.0.17).
Browser page: https://hlab.taila51191.ts.net:9459/model-usage-comparison/

## You already own most of this

The board's **[/usage page](https://hlab.taila51191.ts.net:8101/usage)** (GWTH-launch-plan, bead gwth-launch-44p, built 2026-07-12) already does the cross-subscription job: live Claude and Codex quota windows with burn rate and pace, a 24-hour utilisation history, per-model daily API-equivalent value for each vendor, a monthly value ledger expressed as a multiple of plan cost, and a frontier-model watch. Do not rebuild it.

Two of its feeds had died silently:

| Feed | State found 2026-09-12 | Cause | Status |
|---|---|---|---|
| Value ledger (`daily_burn`) | frozen at 2026-07-12 | nightly cron ran a bare `ccusage`; cron's PATH omits `~/.local/bin`, so every run died with `FileNotFoundError` | **fixed** and backfilled to 2026-06-05 (commit f5e7b05) |
| Claude quota lane | frozen at 2026-07-25, 48 days stale | `~/.claude/.credentials.json` on hlab has an expired token and an empty refresh token, because desktop-app sessions keep the OAuth token on the client and never write that file on hlab | **needs David**: run `claude` on hlab and `/login` |

The Codex quota lane is healthy. The page is honest about the staleness rather than hiding it, so the Claude bars read 0 to 2 percent and are labelled as frozen.

## Short answer

There is no single app that measures **quality, cost and usage** across both subscriptions. The space splits into three layers, and you need one tool from each:

| Layer | Question it answers | Best pick for David | Runner-up |
|---|---|---|---|
| Usage / cost | How many tokens did I burn, what would that have cost on the API, how much of my 5-hour / weekly allowance is left? | **ccusage** (already installed, covers both) for spend + **CodexBar CLI** or **RateTray** for live quota % on both | tokscale, AI Usage Tracker |
| Quality on public tasks | Which model/agent is better in general this month? | **Artificial Analysis Coding Agent Index** (scores the actual products Claude Code and Codex, with $/task) + **Terminal-Bench 4.0** | Arena Code leaderboard, Vals.ai |
| Quality on MY tasks | Which one solves my GWTH tickets better and cheaper? | **openbench** (runs Claude Code and Codex on your own tasks using your subscription logins, reports pass rate, time, tokens, confidence intervals) | UiPath coder_eval (simplest YAML A/B), promptfoo (needs API keys) |

Only one tool claims to measure output *quality* from everyday sessions: **Blume** (closed source, price undisclosed, tracks correction rate, steering frequency and "frustration"). Everything else measures tokens and money.

## What this machine says right now

API-equivalent spend computed by ccusage from local session logs (list prices; roughly 95 percent of tokens are cache reads, so the true value is lower, but the ratio between the two vendors is fair).

| Month | Claude Code (Max 20x, $200) | Codex (Pro Lite) | Claude models seen | Codex models seen |
|---|---|---|---|---|
| 2026-06 | $2,919 | $402 | Fable 5, Opus 4.8, Sonnet 4.6, Haiku 4.5 | GPT-5.5 |
| 2026-07 | $6,127 | $711 | + Opus 5, Sonnet 5 | GPT-5.5, GPT-5.6 Sol |
| 2026-08 | $2,653 | $306 | Fable 5, Opus 5, Sonnet 4.6, Haiku 4.5 | GPT-5.5, GPT-5.6 Sol |
| 2026-09 (11 days) | $2,577 | $1,591 | + Fable 5.1 | + GPT-5.6 Luna, Terra, GPT-6 Astra |

Live quota (Codex app-server RPC `account/rateLimits/read`): weekly window 79 percent used, no 5-hour window on this plan. Claude's OAuth usage endpoint answered but the local token had expired, so the Claude weekly percent was not read. Claude Code's built-in `/usage` shows it.

These figures cover hlab only. Sessions on x1eg3 and P53 are not counted unless their logs are pooled (ccusage supports comma-separated `CLAUDE_CONFIG_DIR` and `CODEX_HOME`).

## Layer 1: usage and cost trackers

| Tool | Claude | Codex | Measures | Cost signal | Quality signal | Install | Maintained |
|---|---|---|---|---|---|---|---|
| [ccusage](https://github.com/ryoppippi/ccusage) (`ccusage codex` for Codex) | Yes | Yes | Tokens per day/week/month/session/5h block, 19 agents | API-equivalent $ (LiteLLM prices) | No | `npx ccusage@latest`, `ccusage codex monthly` | 18.5k stars, v20.0.20 2026-08-15 |
| [tokscale](https://github.com/junhoyeo/tokscale) | Yes | Yes | Tokens per model/client/workspace, TUI + web graphs | Yes | Partial (LLM session summaries) | `npx tokscale@latest` | 5.4k stars, v4.15.1 2026-09-03 |
| [CodexBar](https://github.com/steipete/CodexBar) (macOS; [Windows port](https://github.com/babakarto/CodexBar-Win)) | Yes | Yes | Live official 5h/weekly % + reset countdown, 65 providers; `codexbar` CLI has Linux builds | Local-log $ | No | `brew install --cask codexbar` | 21.3k stars, v0.59.0 2026-09-11 |
| [RateTray](https://ratetray.nowrap.net/) (Windows) | Yes | Yes | 5h/weekly % as tray icons | No | No | RateTray.exe (.NET 9) | 1 star, MIT |
| [ClaudeBar](https://github.com/tddworks/ClaudeBar) (macOS) | Yes | Yes | Quota %, notifications, iPhone Live Activity | No | No | brew cask | 1.5k stars, 2026-09-09 |
| [MeterBar](https://meterbar.dev/) (macOS 26) | Yes | Yes | Quota windows, local only | No | No | brew cask | 8 stars |
| [Claude-Code-Usage-Monitor](https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor) | Yes | **No** | Live 5h burn rate, predictions | Per-model $ | No | `uv tool install claude-monitor` | 8.7k stars, v4.0.0 2026-06-27 |
| [viberank](https://github.com/sculptdotfun/viberank) | Yes | Yes | Leaderboard of ccusage output, subscription calculator | ccusage $ | No | `npx viberank-cli` | 116 stars |
| [claude-hud](https://github.com/jarrodwatts/claude-hud) / [ccstatusline](https://github.com/sirmalloc/ccstatusline) | Yes | No | Statusline context %, 5h/7d bars, session $ | Session $ | No | plugin / npx | 27.9k / 12.8k stars |
| [AI Usage Tracker](https://github.com/658jjh/claude-usage-tracker) | Yes | Yes | Per-project $ across 10 tools, heatmaps | Yes | No | build from source (macOS) | 59 stars |
| [VibeBar](https://github.com/yelog/vibebar) (macOS) | Yes | Yes | Session state, tokens, est. $ | Yes | No | brew cask | 30 stars, 2026-04 |
| [codex-usage-dashboard](https://github.com/YUHAO-corn/codex-usage-dashboard) | No | Yes | Codex tokens/$ dashboard | Estimate | No | pipx | 14 stars |
| [codex-trace](https://github.com/PixelPaw-Labs/codex-trace) | No | Yes | Turn-by-turn session viewer with tokens | No | No | Docker | 103 stars |
| [Raycast Agent Usage](https://www.raycast.com/thuggyduck/agent-usage) | Yes | Yes | Live quotas for 19 agents | No | No | Raycast Store | 3.3k installs |
| [SessionWatcher](https://sessionwatcher.com/codex) (paid) | Yes | Yes | Menu-bar quota %, pace, 7-day chart | Yes | No | $14.99 bundle | proprietary |
| [Blume](https://blume.codes/) (paid, closed) | Yes | Yes | Tokens **plus correction rate, steering, frustration** | Yes | **Yes** | download | unverified |
| Built-in Claude Code `/usage`, `/insights` | Yes | - | 5h + weekly bars, attribution by skill/subagent/MCP, session $; `/insights` writes a friction report to `~/.claude/usage-data/report.html` | Session $ | Qualitative | built in | official |
| Built-in Codex `/status`, [usage page](https://chatgpt.com/codex/settings/usage) | - | Yes | Remaining % of 5h and weekly, credits | No | No | built in | official |

Data sources confirmed on hlab: Claude writes `~/.claude/projects/<project>/*.jsonl` with per-message `usage` (2.7 GB here). Codex writes `~/.codex/sessions/YYYY/MM/DD/rollout-*.jsonl` with cumulative `token_count` events that now carry the `rate_limits` block inline (3,463 files, 8.5 GB here), plus `state_5.sqlite`.

Programmatic quota reads: Anthropic `GET https://api.anthropic.com/api/oauth/usage` with the OAuth token from `~/.claude/.credentials.json` (undocumented, 429s unless a `claude-code/<ver>` User-Agent is sent and polling is 180 s or slower). Codex: `codex app-server` JSON-RPC `account/rateLimits/read` (marked experimental).

## Layer 2: public quality leaderboards (Claude 5 family vs Codex models)

Note: the "GPT-5.x-codex" line ended with GPT-5.3-Codex. Codex now runs GPT-5.6 Sol/Terra/Luna (July 2026) and GPT-6 Astra (default since 2026-09-04).

| Leaderboard | Method | Claude side | Codex side | Verdict |
|---|---|---|---|---|
| [Artificial Analysis Coding Agent Index](https://artificialanalysis.ai/agents/coding-agents) | Runs the real products (Claude Code, Codex) on DeepSWE, TB 4.0, SWE-Atlas; reports $/task and time | Claude Code + Fable 5.1 (max) **62.2**; Opus 5 (max) 59.7 | Codex + GPT-6 Astra (max) **61.6**; Sol (max) 54.6 | Dead heat at the top; Opus 5 is 2 to 3 points behind at 60 to 75 percent of the per-task price |
| [Terminal-Bench 4.0](https://www.tbench.ai/leaderboard/terminal-bench/2.0) (reset 2026-08-29) | 66 hardened terminal tasks, Harbor | Fable 5.1 **57.9 ±3.8** (#1), Opus 5 51.8, Sonnet 5 12.4 | GPT-6 Astra 57.7 to 58.2, Sol 37.3 | Inside error bars |
| [Terminal-Bench 2.1 (Vals, 2026-09-10)](https://benchlm.ai/benchmarks/valsterminalbench21) | 89 tasks, Terminus 2 harness | Fable 5.1 85.0, Opus 5 84.6, Haiku 4.5 43.8 | Astra **87.3**, Sol 85.8 | Near saturated |
| [Arena Code leaderboard](https://arena.ai/leaderboard/code) (2026-09-08) | Human pairwise preference on front-end builds | fable-5.1-max 1764 (#2), opus-5-max 1688 | gpt-6-astra-max **1796** (#1) | Astra leads by about 30 Elo |
| [SWE-bench Verified (Vals)](https://www.vals.ai/benchmarks/swebench) | 500 GitHub issues | Opus 5 **97.0** | Sol 96.2 (vendor); OpenAI withdrew Feb 2026 | Saturated |
| [SWE-bench Pro (Scale SEAL)](https://labs.scale.com/leaderboard/swe_bench_pro_public) | 731 harder instances | Vendor: Fable 5.1 81.2; standardised board has no Claude 5 entries yet | Vendor: Sol 64.6; OpenAI disputes the benchmark | Stale / disputed |
| [METR time horizons](https://metr.org/time-horizons/) | Task length at 50 percent success | No Opus 5 / Fable 5 numbers | No Sol / Astra numbers | Not useful for current models |
| [Aider Polyglot](https://aider.chat/docs/leaderboards/), [LiveCodeBench](https://livecodebench.github.io/leaderboard.html) | Exercise-style | Not updated for 2026 models | Same | Skip |
| [Composio Golden Eval, 2026-08-18](https://composio.dev/content/claude-code-vs-openai-codex) | 47 MCP workflows | Fable 5 + Claude Code 47/47, 277k tokens avg | Sol + Codex 45/47, 224k tokens | Codex cheaper, Claude completes more |

Consistent pattern in the 2026 write-ups ([Firecrawl](https://www.firecrawl.dev/blog/claude-code-vs-codex), [Composio](https://composio.dev/content/claude-code-vs-openai-codex), [CloudZero](https://www.cloudzero.com/blog/codex-vs-claude-code/)): Codex uses 1.4 to 4 times fewer tokens per task; Claude Code finishes slightly more tasks and writes more complete first drafts. On a subscription the token gap shows up as how fast you hit the weekly cap, not as dollars.

## Layer 3: run head-to-head on your own tasks

| Tool | Runs Claude Code | Runs Codex | Measures | Setup | Licence |
|---|---|---|---|---|---|
| [openbench](https://github.com/minghinmatthewlam/openbench) | Yes (isolated config dir) | Yes (+ pi, opencode, cursor) | Pass/fail via checker script, wall clock, fresh-token cost, Wilson 95% CIs | Medium: `obench init` scaffolds Harbor tasks, `obench run suite.toml` | MIT, 133 stars. **Only tool documented to run on subscription OAuth logins** |
| [UiPath coder_eval](https://github.com/uipath/coder_eval) | Yes | Yes (`[codex]` extra) | Sandboxed YAML tasks, weighted 0 to 1 scores, A/B experiment layer | Medium: `uv tool install "coder-eval[codex]"` | Apache-2.0, 128 stars |
| [promptfoo](https://www.promptfoo.dev/docs/guides/test-agent-skills/) | Yes (`anthropic:claude-agent-sdk`) | Yes (`openai:codex-sdk`) | Assertions, LLM rubric, cost, latency, web diff UI | Low: one YAML | MIT, 25k stars. Expects API keys |
| [Harbor / TB 4.0 tasks](https://www.tbench.ai/) | Yes | Yes | Same methodology as the public board | High: Docker + Harbor | OSS |
| [Langfuse coding-agent tracing](https://langfuse.com/resources/engineering/coding-agent-tracing) | Yes (Stop hook) | Yes (Codex plugin hooks) | Per-session tokens, $, every tool call | Low | OSS. Observability only, no scoring |
| [Braintrust](https://www.braintrust.dev/) | Yes (headless sessions) | Not documented | Trajectory scoring | Medium | Commercial |
| [TribeAI/claude-evals](https://github.com/TribeAI/claude-evals) | Yes | No | 50-case golden set, sweep Opus/Sonnet/Haiku | Low | Apache-2.0. Claude-only, good for Fable vs Opus vs Sonnet |

## Cross-model second-opinion plugins (quality via disagreement)

- **[openai/codex-plugin-cc](https://github.com/openai/codex-plugin-cc)** (official OpenAI, 33k stars): `/codex:review`, `/codex:adversarial-review`, `/codex:rescue`, `/codex:setup --enable-review-gate`. Uses your ChatGPT login and counts against Codex limits. Install: `/plugin marketplace add openai/codex-plugin-cc`, `/plugin install codex@openai-codex`, `/codex:setup`.
- [hamelsmu/claude-review-loop](https://github.com/hamelsmu/claude-review-loop) (725 stars): Claude implements, Stop hook spawns up to 4 parallel Codex reviewers.
- [cathrynlavery/codex-skill](https://github.com/cathrynlavery/codex-skill), [boyand/codex-review](https://github.com/boyand/codex-review), [zeikar/hyperclaude](https://github.com/zeikar/hyperclaude), [drewburchfield/braintrust](https://github.com/drewburchfield/braintrust) (also runs from inside Codex).
- Reverse direction: no official Anthropic plugin for Codex. Only shell-out skills calling `claude -p`.
- Related in-flight ship on the board: `claudex-cockpit` (cross-model review in the cockpit, deferred).

## Subscription prices and limits (Sept 2026)

| Plan | Price | 5-hour window | Weekly | Notes |
|---|---|---|---|---|
| Claude Pro | $20 | base allowance, shared claude.ai + Claude Code | yes | |
| Claude Max 5x | $100 | 5x Pro | yes, plus model-specific cap | Claude Code 5h limits doubled 2026-05-06; permanent +25 percent weekly from 2026-09-14 (community-reported) |
| Claude Max 20x | $200 | 20x Pro | yes | David's plan |
| ChatGPT Plus | $20 | Astra 5 to 45 msgs, Sol 10 to 100, Terra 25 to 200, Luna 250 to 2,000 | may apply | 5h cap re-enabled 2026-08-25 |
| ChatGPT Pro 5x | $100 | Astra 25 to 225, Sol 50 to 500 | may apply | 5h limit off for Pro tiers "for the upcoming months" |
| ChatGPT Pro 20x | $200 | Astra 100 to 900, Sol 200 to 2,000 | may apply | |
| ChatGPT Pro Lite | unpublished | none (`secondary: null`) | weekly only | David's plan per the app-server RPC |

Sources: [claude.com/pricing](https://claude.com/pricing), [Max plan help](https://support.claude.com/en/articles/11049741-what-is-the-max-plan), [learn.chatgpt.com pricing](https://learn.chatgpt.com/docs/pricing), [9to5Mac 2026-08-24](https://9to5mac.com/2026/08/24/openai-restores-5-hour-codex-and-work-limits-for-chatgpt-plus-users/). Anthropic's pricing page and OpenAI's limits help article blocked automated fetches, so message counts come from secondary pages.

## Gaps nobody fills

1. No tool joins "API-equivalent $ per month" with "percent of weekly allowance actually used" for both vendors on one screen. ccusage has the $ side, CodexBar and RateTray have the % side.
2. API-equivalent $ overstates real cost: about 95 percent of tokens are cache reads priced at list rate, with no correction for the 1-hour cache TTL or fast-mode multipliers. The Claude:Codex ratio is still meaningful.
3. Quality from everyday sessions is unmeasured except by Blume (closed). Nothing counts commits or PRs shipped per subscription.
4. Both quota APIs are undocumented; every monitor is one header change from breaking.
5. Multi-device blind spot: local-log tools see one machine only.
6. Standardised boards lag one generation (Scale SEAL, METR, Aider, LiveCodeBench have no Claude 5 or GPT-5.6/Astra entries).
7. Subscription-login support in eval harnesses is documented only for openbench.

## Not verified

`codex_usage` Rust crate and usages.pro (403), solux-dev VS Code extension (empty page), markhudsonn/raycast-llm-usage (404), RateTray and SessionWatcher release dates, Blume pricing and metric definitions, the July 2026 Codex 5-hour-window removal/restore story, morphllm's TB 2.1 figures (429), the claim that OpenAI retracted its SWE-bench Pro recommendation for Astra.
