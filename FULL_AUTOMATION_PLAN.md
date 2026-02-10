# Full Automation Setup Plan — GWTH Projects

## Context

You're a solo developer working across two complex projects on GitHub, developed on a Windows P53 laptop and deployed to an Ubuntu P520 server. Currently, interactive Claude Code sessions are slow due to constant confirmation prompts, and bug fixes often cascade into regressions. This plan sets up:

- **Linear** (free) for visual Kanban ticket management via MCP
- **Telegram bot** for push notifications when things break
- **Maximum automation config** to eliminate confirmation clicking
- **Nightly regression tests** on P520 (cron)
- **Work-hours heartbeat** monitoring on both P53 and P520
- **GitHub Actions** with Claude Code Action for auto-fixing labeled issues
- **Vitest test suite** for the website (currently has zero tests)
- **Slash commands and agents** for reusable workflows

---

## Phase 1: Foundation (everything depends on this)

### 1.1 Create global CLAUDE.md
- **File:** `C:\Users\david\.claude\CLAUDE.md`
- Autonomy rules, testing mandates, context management, cross-project awareness
- **Verify:** Start Claude in any project, confirm it loads global rules

### 1.2 Create global agents
- **Create dir:** `C:\Users\david\.claude\agents\`
- **Files:** `bugfixer.md`, `qa-regression.md`
- qa-regression: detects project type (Python/Node), runs appropriate tests, writes TEST_REPORT.md
- bugfixer: reads bug, fixes, tests, fixes regressions, commits
- **Verify:** `/agents:qa-regression` activates in either project

### 1.3 Create fix-bug scripts
- **Files:** `C:\Users\david\.claude\scripts\fix-bug.sh` and `fix-bug.ps1`
- Reusable one-shot bug fix from any project directory
- Uses `claude -p` with `--dangerously-skip-permissions`
- **Verify:** `bash ~/.claude/scripts/fix-bug.sh "test bug"` starts a headless session

### 1.4 Set up Telegram notifications
- **Pre-req (manual):** User creates Telegram account, creates bot via @BotFather, gets token + chat ID, sets environment variables `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID`
- **Create:** `C:\Users\david\.claude\hooks\notify-telegram.ps1` (mirrors existing notify-slack.ps1 pattern)
- **Modify:** `C:\Users\david\.claude\settings.json` — add Telegram hook to existing Notification array (keep Slack + TTS)
- **Verify:** Run PS script directly, confirm message arrives in Telegram

---

## Phase 2: Pipeline Project (C:\Projects\1_gwthpipeline520)

### 2.1 Add pytest configuration
- **Create:** `C:\Projects\1_gwthpipeline520\pyproject.toml` — pytest section with markers: `acceptance`, `integration`, `unit`
- **Create:** `C:\Projects\1_gwthpipeline520\tests\conftest.py` — shared fixtures, dashboard_url, skip-if-not-running logic for acceptance tests
- **Verify:** `python -m pytest tests/ -m "not acceptance" --collect-only` discovers tests

### 2.2 Add test step to GitHub Actions deploy workflow
- **Modify:** `C:\Projects\1_gwthpipeline520\.github\workflows\deploy-p520.yml`
- Add `test` job (ubuntu-latest, Python 3.11, pip install, pytest -m "not acceptance") before `deploy` job
- Deploy gets `needs: test`
- **Verify:** Push commit, see both jobs in GitHub Actions

### 2.3 Add Claude Code GitHub Action
- **Create:** `C:\Projects\1_gwthpipeline520\.github\workflows\claude.yml`
- Triggers on issues labeled `claude` or comments containing `@claude`
- **Pre-req:** Add `ANTHROPIC_API_KEY` secret to `David-ACG/gwthpipeline520` repo
- **Verify:** Create test issue with `claude` label

### 2.4 Upgrade settings to maximum automation
- **Modify:** `C:\Projects\1_gwthpipeline520\.claude\settings.local.json`
- Clean up accumulated one-off permissions -> structured allow/deny lists
- Add PostToolUse hook (test reminder on Edit/Write)
- Add `Bash(pytest:*)`, `Bash(docker compose:*)` to allow list
- **Verify:** Edit a file in Claude Code, see hook reminder

### 2.5 Update CLAUDE.md with testing rules
- **Modify:** `C:\Projects\1_gwthpipeline520\.claude\CLAUDE.md`
- Append testing section: commands, categories (unit vs acceptance), autonomy rules
- **Verify:** Ask Claude about testing, confirm it knows the right commands

---

## Phase 3: Website Test Suite (C:\Projects\gwthtest2026-520)

### 3.1 Install Vitest and testing dependencies
- **Run:** `npm install -D vitest @vitejs/plugin-react jsdom @testing-library/react @testing-library/jest-dom @testing-library/user-event`
- **Create:** `C:\Projects\gwthtest2026-520\vitest.config.ts` — React plugin, jsdom, path aliases from tsconfig
- **Create:** `C:\Projects\gwthtest2026-520\src\__tests__\setup.ts` — testing-library/jest-dom matchers
- **Modify:** `package.json` — add `test`, `test:watch`, `test:coverage` scripts
- **Verify:** `npm test` runs Vitest (0 tests, passes)

### 3.2 Generate utility function tests
- **Create:** Tests for `src/lib/utils.ts`, `src/lib/pricing.ts`, and other pure utility files
- These are pure TypeScript — no React rendering needed
- **Verify:** `npm test` passes with utility tests

### 3.3 Generate API route tests
- **Create:** Tests for `/api/health`, `/api/newsletter`, `/api/waitlist`, `/api/contact`
- Import route handlers directly, call with mock NextRequest
- Mock Prisma client for database-dependent routes
- **Verify:** `npm test` passes with API tests

### 3.4 Generate React component tests
- **Create:** Tests for UI components (button, card, input) and key layout components
- **Create:** Mock files for `next/navigation`, `next/image`, `next-themes`
- Use React Testing Library — render, verify output, test interactions
- **Verify:** `npm test` passes with component tests

### 3.5 Update CLAUDE.md with testing rules
- **Modify:** `C:\Projects\gwthtest2026-520\CLAUDE.md`
- Append testing section at top: Vitest commands, run after every change, never skip
- **Verify:** Claude knows to run `npm test`

---

## Phase 4: Website CI/CD

### 4.1 Create GitHub Actions workflows
- **Create:** `C:\Projects\gwthtest2026-520\.github\workflows\test.yml` — runs on push/PR to main (npm ci, npm test, tsc --noEmit as non-blocking)
- **Create:** `C:\Projects\gwthtest2026-520\.github\workflows\claude.yml` — Claude Code Action for auto-fix issues
- **Pre-req:** Add `ANTHROPIC_API_KEY` secret to `David-ACG/gwth-prod` repo
- **Verify:** Push commit, see test workflow run

### 4.2 Upgrade settings to maximum automation
- **Modify:** `C:\Projects\gwthtest2026-520\.claude\settings.local.json`
- Replace fragmented permissions with structured allow/deny lists
- Add Edit, Write, npm test, npx, vitest, git operations, Playwright MCP tools
- Add PostToolUse hook (test reminder)
- **Verify:** Edit a file, see hook reminder

---

## Phase 5: Linear MCP Integration (can run alongside Phase 2-4)

### 5.1 Set up Linear account (manual)
- Sign up at linear.app (free tier — unlimited issues, unlimited for small teams)
- Create workspace "GWTH", team "GWTH Dev"
- Create labels: `bug`, `feature`, `claude`, `regression`, `urgent`
- Generate personal API key from Settings > API

### 5.2 Install Linear MCP server
- **Run:** `claude mcp add linear -s user -- npx -y @linear/mcp-server`
- Or add to `C:\Users\david\.claude\settings.json` under `mcpServers`
- Set `LINEAR_API_KEY` environment variable
- **Verify:** Ask Claude "List my Linear issues"

---

## Phase 6: P520 Scheduled Jobs

### 6.1 Create nightly regression script
- **Create on P520:** `/home/david/scripts/nightly-regression.sh`
- Runs pytest on pipeline (with Docker up), runs Vitest on website
- Sends Telegram alert on any failure
- **Cron:** `0 2 * * *` (2 AM UTC daily)
- **Verify:** Run manually via SSH

### 6.2 Create Claude-powered nightly regression
- **Create on P520:** `/home/david/scripts/claude-nightly-regression.sh`
- Uses `claude -p --dangerously-skip-permissions` to analyze failures, identify root causes, auto-fix simple regressions
- **Cron:** `30 2 * * *` (30 min after basic tests)
- **Verify:** Run manually via SSH

### 6.3 Create HEARTBEAT.md files
- **Create on P520:** `/home/david/gwth-pipeline-v2/HEARTBEAT.md` — Docker status, smoke tests, disk space, git status
- **Create on P520:** `/var/www/gwth-ai/HEARTBEAT.md` — PM2 status, health check, PostgreSQL, quick tests

### 6.4 Set up heartbeat cron
- **Create on P520:** `/home/david/scripts/heartbeat.sh`
- Uses `claude -p` with HEARTBEAT.md content and limited allowedTools
- **Cron:** `*/30 7-19 * * 1-5` (every 30 min, work hours Mon-Fri, UTC)
- **Verify:** `crontab -l` on P520

---

## Phase 7: P53 Work-Hours Heartbeat

### 7.1 Create P53 heartbeat script
- **Create:** `C:\Users\david\.claude\scripts\p53-heartbeat.ps1`
- Checks P520 dashboard health endpoint (192.168.178.50:8088)
- Checks website health endpoint (192.168.178.50:3000)
- Sends Telegram alert if either is unreachable/unhealthy
- **Task Scheduler:** Every 30 min, 8 AM - 8 PM
- **Verify:** `schtasks /query /tn "Claude-P53-Heartbeat"`

---

## Phase 8: Polish

### 8.1 Create project-level slash commands
- **Pipeline:** `.claude/commands/run-tests.md`, `fix-issue.md`, `deploy.md`
- **Website:** `.claude/commands/run-tests.md`, `fix-issue.md`, `deploy.md`
- `/project:fix-issue 1234` fixes a GitHub issue end-to-end
- **Verify:** Type `/project:` in Claude Code, see commands in autocomplete

### 8.2 Set up website kanban folders
- **Create:** `C:\Projects\gwthtest2026-520\kanban\{1_planning,2_testing,3_done}\`
- **Copy:** `run-kanban.sh` and `KANBAN_RUNNER.md` from claude-code-setup
- **Verify:** `ls kanban/` shows the structure

### 8.3 Add GitHub repo secrets
- **Run:** `gh secret set ANTHROPIC_API_KEY` in both project directories
- **Verify:** `gh secret list` shows the secret

### 8.4 Address TypeScript build flags (deferred)
- Run `npx tsc --noEmit 2>&1 | wc -l` to count errors
- If <50: fix in a dedicated session
- If >50: keep flags, add non-blocking CI check, create Linear issue to track
- **File:** `C:\Projects\gwthtest2026-520\next.config.mjs` — eventually remove `ignoreBuildErrors` and `ignoreDuringBuilds`

---

## Execution Order

```
Phase 1 ──┬──> Phase 2 (Pipeline) ──┬──> Phase 6 (P520 Cron)
           │                         │
           ├──> Phase 3 (Website) ───┤
           │         │               │
           │         └──> Phase 4 ───┘
           │
           ├──> Phase 5 (Linear) ── independent
           │
           └──> Phase 7 (P53 Heartbeat)
                         │
                         └──> Phase 8 (Polish)
```

Phases 2, 3, 5, and 7 can run in parallel after Phase 1 is done.

---

## Pre-requisites (manual, by user)

1. Create Telegram account + bot via @BotFather (for Phase 1.4)
2. Set `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` environment variables on both P53 and P520
3. Create Linear account at linear.app (for Phase 5.1)
4. Verify Claude Code is authenticated on P520: `ssh david@192.168.178.50 "claude --version"`

---

## Verification (end-to-end, after all phases)

1. Create a GitHub Issue on `David-ACG/gwthpipeline520` with label `claude` -> Claude auto-creates a PR
2. Create a Linear issue -> Claude reads it via MCP in interactive session
3. Run `bash ~/.claude/scripts/fix-bug.sh "test bug description"` -> headless fix session starts
4. Run `bash kanban/run-kanban.sh` in website project -> processes PROMPT files autonomously
5. Wait for 2 AM -> nightly regression runs, results in TEST_REPORT.md, Telegram alert if failures
6. Check P53 Task Scheduler -> heartbeat running every 30 min during work hours
7. Check P520 crontab -> heartbeat + nightly jobs scheduled
8. In Claude Code, type `/project:fix-issue 1` -> slash command activates

---

## Estimated Effort

| Phase | Time |
|-------|------|
| Phase 1: Foundation | ~50 min |
| Phase 2: Pipeline Automation | ~1 hr 15 min |
| Phase 3: Website Tests | ~2.5 hrs |
| Phase 4: Website CI/CD | ~25 min |
| Phase 5: Linear | ~20 min |
| Phase 6: P520 Cron | ~1 hr |
| Phase 7: P53 Heartbeat | ~15 min |
| Phase 8: Polish | ~30 min + variable for TS fixes |
| **Total** | **~7 hours** (spread across sessions) |
