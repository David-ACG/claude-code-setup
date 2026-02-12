# GWTH Development Workflow

## Overview

Issues are tracked in **Linear** and fixed interactively in **Claude Code**.
There is no headless automation — every fix is reviewed and tested before merging.

## Architecture

```
You (anywhere, mobile)              Claude Code (interactive session)
+-------------------+               +----------------------------+
| Create issue in   |               |                            |
| Linear on phone   |               |                            |
| Label it "claude" |               |                            |
|       |           |               |                            |
|       v           |   you tell    |                            |
| Telegram reminder | ------------> | "Check my Linear issues    |
| every hour        |   Claude to   |  and fix GWTH-12"          |
|                   |   look        |       |                    |
|                   |               |  Read code, understand it  |
|                   |               |  Ask you questions if      |
|                   |               |  anything is unclear        |
|                   |               |       |                    |
|                   |               |  Fix on branch, run tests  |
|                   |               |  Deploy to test port :8089 |
|                   |   <---------- |  "Test at :8089"           |
|                   |               |       |                    |
| Test it, add      |               |                            |
| comments in       | ----------->  |  Read your feedback        |
| Linear            |               |  Iterate on fix            |
|                   |               |       |                    |
|                   |   <---------- |  Merge to master           |
|                   |               |  Deploy to prod :8088      |
|                   |               |  Move issue to Done        |
+-------------------+               +----------------------------+
```

## Why This Workflow

We tried headless `claude -p` automation (Linear issue -> automated fix -> commit).
It failed because:

- **No visual feedback** — can't see if UI changes look correct
- **Guesses instead of asks** — makes wrong assumptions about hardware/config
- **Over-engineers** — adds unnecessary complexity instead of minimal fixes
- **No feedback loop** — commits without verifying anything works
- **Breaks things** — broke Qdrant while trying to fix the GPU status bar

The interactive workflow is better because **you are the eyes and Claude is the hands**.

## Components

### Linear (Issue Tracker)
- **Workspace:** GWTH Dev
- **Team key:** GWTH
- **URL:** https://linear.app
- **Mobile:** Linear app (iOS/Android)
- **Label for Claude:** `claude` (purple)

When you create an issue and label it `claude`, the hourly reminder
will send you a Telegram notification.

### Telegram (Notifications)
- **Bot:** @gwth_notifications_bot
- **What it sends:** Hourly summary of open `claude`-labeled issues (08:00-23:00)
- **One-way:** Replying to Telegram does NOT update Linear

### Linear MCP (Claude Code Integration)
- **Installed at:** user scope (`~/.claude.json`)
- **What it does:** Lets Claude Code read/update Linear issues directly

In a Claude Code session, you can say:
- "Check my Linear issues"
- "Read GWTH-12 and fix it"
- "Move GWTH-12 to Done"

### Test Port (Pre-production Verification)
- **Production:** http://192.168.178.50:8088
- **Test:** http://192.168.178.50:8089

Claude deploys fixes to :8089 first. You verify visually, then Claude
promotes to :8088.

### Gemini (GitHub Actions)
- **PR reviews:** Auto-reviews pull requests with inline suggestions
- **Issue triage:** Auto-labels new GitHub issues
- **Free tier:** 1,000 requests/day with Google API key
- **NOT used for:** Automated code fixes

## Step-by-Step: Fixing an Issue

### 1. Create the issue
Open Linear (web or mobile). Create an issue with:
- Clear title describing the problem
- Description with details, screenshots if possible
- Label: `claude`
- Status: `Todo`

### 2. Start a Claude Code session
Open your terminal and run `claude`. Tell it:
```
Check my Linear issues and fix GWTH-12
```

Claude will:
1. Read CLAUDE.md for project context
2. Read the issue from Linear (title, description, comments)
3. Read and understand the relevant source code
4. Ask you questions if anything is unclear
5. Create a fix branch: `gwth-12-fix`
6. Make minimal changes
7. Run tests

### 3. Test the fix
Claude deploys to the test port:
```bash
# Claude runs this on P520
docker run -d --name gwth-test -p 8089:8088 \
  -v /home/david/gwth-pipeline-test/app:/app/app \
  -v /home/david/gwth-dashboard:/data \
  ... gwth-pipeline-v2-dashboard
```
You verify at http://192.168.178.50:8089

### 4. Iterate if needed
Add comments in Linear:
- "The GPU bar looks better but Qdrant status is wrong"
- "Looks good, merge it"

Tell Claude Code to read your comments and continue fixing.

### 5. Merge and deploy
When you're happy:
```
Merge the fix to master and deploy to production
```

Claude will:
1. Merge the branch
2. Deploy to :8088
3. Tear down the test container
4. Move the Linear issue to Done

## Scheduled Tasks

| Task | Schedule | What it does |
|------|----------|-------------|
| Linear Reminder | Hourly 08:00-23:00 | Sends Telegram summary of open `claude` issues |

### Managing the reminder
```powershell
# Check status
schtasks /query /tn "Linear Reminder" /v

# Run manually
powershell -ExecutionPolicy Bypass -File C:\Users\david\.claude\scripts\linear-reminder.ps1

# Delete
schtasks /delete /tn "Linear Reminder" /f
```

## File Locations

### Scripts
| File | Purpose |
|------|---------|
| `~/.claude/scripts/linear-reminder.ps1` | Hourly Telegram reminder for open issues |
| `~/.claude/scripts/run-linear-reminder.vbs` | VBS wrapper for Task Scheduler (runs hidden) |
| `~/.claude/scripts/p53-heartbeat.ps1` | P520 health check |
| `~/.claude/hooks/notify-telegram.ps1` | Telegram notification hook |

### Environment Variables (User-level)
| Variable | Purpose |
|----------|---------|
| `LINEAR_API_KEY` | Linear API access |
| `TELEGRAM_BOT_TOKEN` | Telegram bot for notifications |
| `TELEGRAM_CHAT_ID` | Your Telegram chat ID |

### MCP Servers
| Server | Scope | Purpose |
|--------|-------|---------|
| `linear` | user | Read/update Linear issues from Claude Code |

## Projects

| Project | Local Path | GitHub | Stack |
|---------|-----------|--------|-------|
| Pipeline | `C:\Projects\1_gwthpipeline520` | `David-ACG/gwthpipeline520` | Python, Docker, Qdrant |
| Website | `C:\Projects\gwthtest2026-520` | `David-ACG/gwth-prod` | Next.js 15, PostgreSQL |

## Fix-All-Linear-Issues Workflow (`/fix-all-linear-issues`)

For batch-fixing all open `claude`-labeled issues in one session. Works in both projects.

### How It Works

```
You                                     Claude Code
+-------------------+                   +----------------------------+
| Create issues in  |                   |                            |
| Linear, label     |                   |  /fix-all-linear-issues     |
| them "claude"     |                   |       |                    |
|                   |                   |  Phase 1 (Interactive):    |
|                   |   <-------------- |  - Reads all open issues   |
|                   |   asks questions  |  - Analyzes codebase       |
|                   |   if unclear      |  - Writes plan to docs/    |
|                   |                   |  - Presents plan           |
| Review plan,      |                   |       |                    |
| approve or adjust | --------------->  |  Phase 2 (Autonomous):     |
|                   |                   |  - Fixes each issue        |
|                   |                   |  - Runs tests (3 retries)  |
|                   |                   |  - Commits per issue       |
|                   |                   |  - Pushes to master        |
|                   |                   |  - Waits for deploy        |
|                   |                   |  - Runs acceptance tests   |
|                   |                   |  - Writes report to docs/  |
|                   |   <-------------- |  - Updates Linear: Done    |
+-------------------+                   +----------------------------+
```

### Project-Aware

The command auto-detects which project it's running in:

| Project | Test Command | Deploy URL | Acceptance Tests |
|---------|-------------|------------|-----------------|
| Pipeline | `python -m pytest tests/ -m "not acceptance"` | :8088 | `tests/test_playwright_acceptance.py` |
| Website | `npm test` | :3000 | `npm run test:e2e` |

### Artifacts

| File | Purpose |
|------|---------|
| `docs/fix-plan-YYYY-MM-DD.md` | Execution plan (written in Phase 1) |
| `docs/fix-report-YYYY-MM-DD.md` | Results report (written in Phase 2) |

### Safety Rules
- 3-strike rule per issue (3 test failures = skip)
- 2-strike rule for deploy (2 acceptance failures = stop)
- Never force-pushes, always reverts on failure
- Documents everything in fix report

---

## What We Learned

1. **Headless AI coding doesn't work well for complex projects** — it lacks visual
   feedback, makes wrong assumptions, and over-engineers solutions.
2. **Interactive AI coding works great** — the human provides context, visual
   verification, and course correction. The AI provides speed and precision.
3. **Linear is a great control plane** — create issues anywhere (mobile), get
   notified via Telegram, fix them when you're at your desk with full Claude context.
4. **Always test before deploying** — the test port pattern (:8089) catches
   issues before they hit production (:8088).
