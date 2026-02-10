# Autonomous Ticket Workflows for Claude Code

A comprehensive guide to working on tickets, bugs, and tasks with minimal human intervention using Claude Code. Covers lightweight methods for quick bug fixes through to full Kanban automation, regression testing, scheduled jobs, and heartbeat monitoring.

---

## Table of Contents

1. [The Problem](#the-problem)
2. [Quick Wins: Reduce Clicking Immediately](#quick-wins-reduce-clicking-immediately)
3. [Lightweight Bug Fix Workflow (Quick Tickets)](#lightweight-bug-fix-workflow-quick-tickets)
4. [The Ralph Wiggum Method (Heavy Tickets)](#the-ralph-wiggum-method-heavy-tickets)
5. [Free Ticket Management Tools](#free-ticket-management-tools)
6. [GitHub Issues as Your Ticket System](#github-issues-as-your-ticket-system)
7. [Markdown-Based Kanban Tools](#markdown-based-kanban-tools)
8. [MCP Servers for Ticket Integration](#mcp-servers-for-ticket-integration)
9. [Regression Testing](#regression-testing)
10. [Scheduled Jobs with Cron / Task Scheduler](#scheduled-jobs-with-cron--task-scheduler)
11. [Heartbeat Monitoring](#heartbeat-monitoring)
12. [Multi-Agent Orchestration](#multi-agent-orchestration)
13. [Recommended Setups by Use Case](#recommended-setups-by-use-case)
14. [Reference Links](#reference-links)

---

## The Problem

When working interactively with Claude Code on complex codebases:

- **Constant confirmations** -- clicking "yes", "accept", or typing "continue" dozens of times per change
- **Cascade bugs** -- fixing one thing breaks another because the codebase is large and interconnected
- **Context loss** -- Claude doesn't retain knowledge between sessions about what's fragile
- **Setup overhead** -- the Ralph Wiggum method works brilliantly but writing detailed prompts for every small bug is too slow

The solutions below are ordered from **lightest** (change a setting) to **heaviest** (full CI/CD pipeline).

---

## Quick Wins: Reduce Clicking Immediately

These require zero new tools. Just configuration changes.

### 1. Permission Modes

Claude Code has built-in permission modes that dramatically reduce confirmations:

| Mode | What it does |
|------|-------------|
| `--yes` / `-y` | Auto-accepts all permission prompts for one session |
| `--dangerously-skip-permissions` | Bypasses ALL permission checks (use in sandboxed environments) |
| `allowedTools` in settings | Whitelist specific tools so they never prompt |

**Recommended: Use `allowedTools` in your project's `.claude/settings.local.json`:**

```json
{
  "permissions": {
    "allow": [
      "Edit",
      "Write",
      "Bash(npm test:*)",
      "Bash(npm run:*)",
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git diff:*)",
      "Bash(git status:*)",
      "Bash(npx:*)",
      "Bash(python:*)",
      "Bash(pip:*)"
    ]
  }
}
```

This lets Claude edit files, run tests, and use git without asking. You'll only get prompted for unusual commands.

### 2. CLAUDE.md Rules to Stop Questions

Add these to your project's `CLAUDE.md` file:

```markdown
# Autonomy Rules

- Do NOT ask clarifying questions. Make reasonable assumptions and proceed.
- Do NOT stop to ask for confirmation. Complete the full task.
- If something fails, fix it and retry up to 3 times before reporting.
- Always run tests after making changes. Fix any failures you introduce.
- If you are unsure about an approach, pick the simplest one and implement it.
- NEVER leave code in a broken state. If your change breaks tests, fix them before stopping.
```

### 3. Sandboxing (84% Fewer Prompts)

Anthropic's newer approach to autonomy uses OS-level sandboxing. In their internal testing, this **reduces permission prompts by 84%** while maintaining security. The sandbox enforces filesystem isolation (read/write only in working directory) and network isolation.

- **Linux/WSL2**: Uses `bubblewrap`
- **macOS**: Uses `seatbelt` framework
- **Windows**: Requires WSL2

Enable via the `/sandbox` command inside Claude Code.

### 4. Custom Skill: `/fix-issue`

Create a reusable slash command that fixes GitHub issues end-to-end. Save as `.claude/commands/fix-issue.md`:

```markdown
Analyze and fix the GitHub issue: $ARGUMENTS.

1. Use `gh issue view` to get the issue details
2. Understand the problem described in the issue
3. Search the codebase for relevant files
4. Implement the necessary changes
5. Write and run tests
6. Ensure code passes linting and type checking
7. Create a descriptive commit message
8. Push and create a PR linking the issue
```

Now just type `/project:fix-issue 1234` to fix any GitHub issue autonomously. This is how Anthropic's own teams work with tickets.

### 5. Hooks for Auto-Acceptance

Add a hook that auto-compacts when context gets large (in `.claude/settings.local.json`):

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "type": "command",
        "command": "echo 'CONTEXT MANAGEMENT: If context exceeds 80%, run /compact before continuing.'"
      }
    ]
  }
}
```

---

## Lightweight Bug Fix Workflow (Quick Tickets)

For small bugs where the Ralph Wiggum method is overkill. This is the "sweet spot" for most day-to-day work.

### Method A: One-Shot Headless Command

Run a single bug fix without even opening an interactive session:

```bash
claude -p "Fix the bug where clicking the save button on the settings page throws a TypeError. The error is in src/components/Settings.tsx. Run tests after fixing." --allowedTools "Edit,Write,Bash(npm test:*)"
```

For Windows (PowerShell):
```powershell
claude -p "Fix the bug where clicking the save button on the settings page throws a TypeError. The error is in src/components/Settings.tsx. Run tests after fixing." --allowedTools "Edit,Write,Bash(npm test:*)"
```

### Method B: Bug Fix Script

Create a reusable script. Save as `fix-bug.sh` (or `fix-bug.ps1` for Windows):

**bash (Mac/Linux/Git Bash on Windows):**
```bash
#!/usr/bin/env bash
# Usage: bash fix-bug.sh "description of the bug"
set -e

BUG_DESC="$1"
PROJECT_ROOT="$(pwd)"

if [ -z "$BUG_DESC" ]; then
    echo "Usage: bash fix-bug.sh \"description of the bug\""
    exit 1
fi

PROMPT="You are working in project: $PROJECT_ROOT

RULES:
- Do NOT ask questions. Just fix the bug.
- Run the test suite after your fix.
- If your fix breaks other tests, fix those too.
- If you cannot fix it after 3 attempts, write a summary of what you tried to FAILED_FIX.md

BUG TO FIX:
$BUG_DESC"

claude -p "$PROMPT" --allowedTools "Edit,Write,Bash(npm test:*),Bash(npm run:*),Bash(git diff:*)"
```

**PowerShell (Windows native):**
```powershell
# Usage: .\fix-bug.ps1 "description of the bug"
param([string]$BugDesc)

if (-not $BugDesc) {
    Write-Host "Usage: .\fix-bug.ps1 'description of the bug'"
    exit 1
}

$prompt = @"
You are working in project: $(Get-Location)

RULES:
- Do NOT ask questions. Just fix the bug.
- Run the test suite after your fix.
- If your fix breaks other tests, fix those too.
- If you cannot fix it after 3 attempts, write a summary of what you tried to FAILED_FIX.md

BUG TO FIX:
$BugDesc
"@

claude -p $prompt --allowedTools "Edit,Write,Bash(npm test:*),Bash(npm run:*),Bash(git diff:*)"
```

**Usage:**
```bash
bash fix-bug.sh "The dropdown menu on the dashboard doesn't close when clicking outside"
```

### Method C: Batch Bug Fix from a Simple List

Create a file `bugs.txt` with one bug per line:
```
Fix: Login page crashes when email field is empty
Fix: Dark mode toggle doesn't persist across page refresh
Fix: API timeout not handled on the search results page
```

Then run them all:
```bash
#!/usr/bin/env bash
while IFS= read -r bug; do
    [ -z "$bug" ] && continue
    echo "========================================="
    echo "FIXING: $bug"
    echo "========================================="
    claude -p "Fix this bug in the project. Do not ask questions. Run tests after. Bug: $bug" \
        --allowedTools "Edit,Write,Bash(npm test:*),Bash(npm run:*)"
done < bugs.txt
```

### Method D: Claude Code Built-in Todo System

Claude Code has a built-in task/todo system you can leverage. In your CLAUDE.md:

```markdown
When given multiple tasks, use the TodoWrite tool to create a task list,
then work through each task sequentially without stopping to ask questions.
Mark each task complete as you finish it.
```

---

## The Ralph Wiggum Method (Heavy Tickets)

For larger features or complex changes that need detailed prompts. This is the method you already use.

### Folder Structure
```
kanban/
  1_planning/     # Prompts waiting to run (PROMPT_01_xxx.md, PROMPT_02_xxx.md, ...)
  2_testing/      # Completed prompts awaiting human review
  3_done/         # Verified and accepted
  run-kanban.sh   # The runner script
```

### When to Use Ralph Wiggum vs Lightweight
| Scenario | Method |
|----------|--------|
| Single bug fix, clear description | Lightweight (Method A or B) |
| 2-5 related small fixes | Lightweight (Method C - batch) |
| New feature, 1 prompt worth | Lightweight (Method B with longer description) |
| New feature, needs multiple steps | Ralph Wiggum |
| Major refactor or architectural change | Ralph Wiggum |
| Multi-file feature with dependencies between steps | Ralph Wiggum |

### Tips to Speed Up Ralph Wiggum Prompt Writing

1. **Use a template** -- keep a `PROMPT_TEMPLATE.md` you copy/edit:
```markdown
# Prompt: [TITLE]

## Objective
[One sentence: what should be different when this prompt is done]

## Context
[2-3 sentences: what exists now, what file(s) are involved]

## Requirements
- [ ] Requirement 1
- [ ] Requirement 2

## Testing
- Run: `npm test`
- Verify: [what to check manually]

## Constraints
- Do NOT modify [protected files]
- Do NOT ask questions
```

2. **Let Claude write the prompts** -- describe the feature conversationally, then ask Claude to generate the PROMPT files:
```
I need to add a new user preferences page. It should have theme selection,
notification settings, and language choice. Generate PROMPT_*.md files
in kanban/1_planning/ that break this into logical steps.
```

3. **Reference architecture docs** -- put non-PROMPT files in `1_planning/` that Claude reads as context (you already do this).

---

## Free Ticket Management Tools

### Tools That Integrate Directly with Claude Code

| Tool | Type | How it works | Link |
|------|------|-------------|------|
| **GitHub Issues** | Built-in | Claude Code's GitHub Action watches issues. Mention `@claude` to trigger. Free for public repos. | [github.com/apps/claude](https://github.com/apps/claude) |
| **Backlog.md** | Markdown file | A single `BACKLOG.md` file that Claude reads as context. No external tool needed. | Just create the file |
| **TaskMaster AI** | CLI + MCP | AI-powered task management. Breaks PRDs into tasks. Has an MCP server for Claude Code. | [github.com/eyaltoledano/claude-task-master](https://github.com/eyaltoledano/claude-task-master) |
| **Plane** | Web app | Open-source Jira/Linear alternative. Self-hostable. Free tier. Has API that MCP servers can connect to. | [plane.so](https://plane.so) |
| **Linear** | Web app | Free for small teams. Has an official MCP server for Claude Code. | [linear.app](https://linear.app) |

### MCP-Based Ticket Connectors

These MCP servers let Claude Code read/write tickets directly:

| MCP Server | Connects to | Link |
|------------|------------|------|
| **mcp-ticketer** | GitHub Issues, Linear, Jira, Asana | [npmjs.com/package/mcp-ticketer](https://www.npmjs.com/package/mcp-ticketer) |
| **GitHub Official MCP** | GitHub Issues, PRs, repos | [github.com/github/github-mcp-server](https://github.com/github/github-mcp-server) |
| **Linear MCP** | Linear issues and projects | [github.com/linear/linear-mcp](https://github.com/anthropics/linear-mcp-server) |
| **Atlassian MCP** | Jira, Confluence | [atlassian.com/mcp-server](https://support.atlassian.com/atlassian-rovo-mcp-server/docs/setting-up-clients/) |
| **taskqueue-mcp** | Structured task queue with human-approval checkpoints | [github.com/chriscarrollsmith/taskqueue-mcp](https://github.com/chriscarrollsmith/taskqueue-mcp) |

**taskqueue-mcp deserves special mention** -- it gives Claude a structured task queue where you break a project into steps and add approval checkpoints. Claude can't run ahead without your sign-off at gates you define. Approve tasks via CLI: `npx taskqueue approve-task -- <projectId> <taskId>`. The project describes itself as being good for "taming an over-enthusiastic Claude."

**To add an MCP server**, add it to `.claude/settings.local.json`:
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "<your-token>"
      }
    }
  }
}
```

---

## GitHub Issues as Your Ticket System

This is probably the **best free option** that requires the least new tooling if your code is on GitHub.

### Setup: Claude Code GitHub Action

1. Install the GitHub App: visit [github.com/apps/claude](https://github.com/apps/claude) or run `/install-github-app` inside Claude Code
2. Add the workflow file `.github/workflows/claude.yml`:

```yaml
name: Claude Code
on:
  issues:
    types: [opened, labeled]
  issue_comment:
    types: [created]

jobs:
  claude:
    if: |
      (github.event_name == 'issues' && contains(github.event.issue.labels.*.name, 'claude')) ||
      (github.event_name == 'issue_comment' && contains(github.event.comment.body, '@claude'))
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
      issues: write
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          claude_args: "--allowedTools Edit Write Bash(npm test:*)"
```

### Workflow
1. Create a GitHub Issue: "Bug: Settings page crashes when email is empty"
2. Add the `claude` label
3. Claude Code automatically creates a branch, fixes the bug, runs tests, and opens a PR
4. You review the PR and merge

### Batch Processing with Labels
- Label issues `claude` to auto-assign to Claude
- Label `claude-urgent` for priority ordering
- Claude processes them as separate PRs

### CCPM -- Claude Code Project Management

For a more structured approach, **CCPM** uses GitHub Issues as the source of truth with git worktrees for parallel agent execution. It turns PRDs into epics, then issues, then code -- with full traceability. Multiple Claude instances can work on the same project simultaneously, each in its own worktree.

GitHub: [github.com/automazeio/ccpm](https://github.com/automazeio/ccpm)

---

## Markdown-Based Kanban Tools

These are lightweight alternatives to your current folder-based system:

| Tool | Description | Link |
|------|-------------|------|
| **Backlog.md pattern** | A single markdown file with `## Todo`, `## In Progress`, `## Done` sections. Claude reads it as context and updates it as it works. Zero setup. | Just create the file |
| **Backlog.md (tool)** | Full CLI + MCP server. Turns any git repo folder into a project board with Markdown files + YAML metadata. All changes are git commits. | [github.com/MrLesk/Backlog.md](https://github.com/MrLesk/Backlog.md) |
| **Vibe Kanban** | Kanban board with MCP server for AI agents. Supports parallel execution across agents with git worktree isolation. Works with Claude Code, Cursor, etc. | [vibekanban.com](https://www.vibekanban.com/) |
| **MarkdownTaskManager** | Single HTML file that turns markdown into interactive Kanban. Includes a Claude Code skill. | [github.com/ioniks/MarkdownTaskManager](https://github.com/ioniks/MarkdownTaskManager) |
| **TaskBoardAI** | File-based Kanban with web UI + MCP server for Claude Code integration | [github.com/TuckerTucker/TaskBoardAI](https://github.com/TuckerTucker/TaskBoardAI) |
| **kanban-md** | Agents-first, file-based Kanban CLI/TUI built for multi-agent workflows. No database, no server. | [github.com/antopolskiy/kanban-md](https://github.com/antopolskiy/kanban-md) |
| **Claude-Code-Board** | Kanban WebUI specifically for Claude Code | [github.com/cablate/Claude-Code-Board](https://github.com/cablate/Claude-Code-Board) |
| **Claude Code Kanban Automator** | Kanban board with Claude Code automation, real-time execution, and feedback loops | [github.com/cruzyjapan/Claude-Code-Kanban-Automator](https://github.com/cruzyjapan/Claude-Code-Kanban-Automator) |

### The Backlog.md Pattern (Simplest Possible)

Create `BACKLOG.md` in your project root:

```markdown
# Backlog

## Todo
- [ ] BUG-001: Settings page crashes when email is empty (src/components/Settings.tsx)
- [ ] BUG-002: Dark mode toggle doesn't persist (src/hooks/useTheme.ts)
- [ ] FEAT-003: Add password strength indicator to signup form

## In Progress

## Done
- [x] BUG-000: Fixed login redirect loop
```

Then add to your `CLAUDE.md`:
```markdown
# Task Management
- Read BACKLOG.md at the start of each session
- Pick the next unchecked item from the Todo section
- Move it to In Progress while working, Done when complete
- Do NOT ask which task to work on. Just pick the next one.
```

Now you can run:
```bash
claude -p "Work through the backlog. Fix each bug, run tests, update BACKLOG.md." --allowedTools "Edit,Write,Bash(npm test:*)"
```

---

## Regression Testing

### The Core Problem

AI-generated code changes can introduce regressions in distant parts of the codebase. The solution is layered:

### Layer 1: Make Claude Run Tests After Every Change

Add to `CLAUDE.md`:
```markdown
# Testing Rules (CRITICAL)
- After ANY code change, run the full test suite: `npm test`
- If any test fails that was passing before your change, fix it before moving on
- NEVER skip tests. NEVER mark tests as skipped to make them pass.
- If you cannot fix a regression after 3 attempts, revert your change and report.
```

### Layer 2: Pre-Commit Hook

Use Claude Code's hooks system to enforce testing before commits:

In `.claude/settings.local.json`:
```json
{
  "hooks": {
    "PreCommit": [
      {
        "type": "command",
        "command": "npm test",
        "blocking": true
      }
    ]
  }
}
```

Or use a standard git pre-commit hook in `.git/hooks/pre-commit`:
```bash
#!/bin/bash
npm test
```

### Layer 3: Nightly Full Regression Test

Run a comprehensive test suite every night to catch anything that slipped through.

**GitHub Actions (free for public repos, 2000 mins/month for private):**

```yaml
name: Nightly Regression Tests
on:
  schedule:
    - cron: '0 2 * * *'  # 2 AM every day
  workflow_dispatch:       # Manual trigger button

jobs:
  regression:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm ci
      - run: npm test -- --coverage
      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: test-results
          path: coverage/
```

**With Claude Code for AI-Powered Regression Detection:**

```yaml
name: Claude Regression Check
on:
  schedule:
    - cron: '0 3 * * *'  # 3 AM daily

jobs:
  claude-regression:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Full history for diff
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Review all commits from the last 24 hours.
            Run the full test suite.
            If any tests fail, create a GitHub Issue with:
            - Which test(s) failed
            - Which commit likely introduced the failure
            - A suggested fix
          claude_args: "--allowedTools Edit Write Bash(npm test:*) Bash(git log:*) Bash(git diff:*)"
```

### Layer 4: Local Nightly Tests (Windows Task Scheduler / Cron)

For running tests on your own machine while you sleep:

**Windows Task Scheduler (PowerShell):**
```powershell
# Create a scheduled task that runs tests at 2 AM
$action = New-ScheduledTaskAction -Execute "cmd.exe" `
    -Argument "/c cd /d C:\Projects\my-app && npm test > test-results.log 2>&1"
$trigger = New-ScheduledTaskTrigger -Daily -At 2am
Register-ScheduledTask -TaskName "NightlyTests" -Action $action -Trigger $trigger
```

**With Claude Code for smarter analysis:**
```powershell
$action = New-ScheduledTaskAction -Execute "cmd.exe" `
    -Argument '/c cd /d C:\Projects\my-app && claude -p "Run the full test suite. If anything fails, write a report to TEST_REPORT.md with what failed and likely causes." --allowedTools "Edit,Write,Bash(npm test:*),Bash(git log:*)"'
$trigger = New-ScheduledTaskTrigger -Daily -At 2am
Register-ScheduledTask -TaskName "ClaudeNightlyRegression" -Action $action -Trigger $trigger
```

**Linux/macOS cron:**
```bash
# crontab -e
0 2 * * * cd /path/to/project && claude -p "Run full test suite. Report failures to TEST_REPORT.md" --allowedTools "Edit,Write,Bash(npm test:*)"
```

### Layer 5: QA Sub-Agents

Create specialized testing agents in `.claude/agents/` that Claude can delegate to. Real-world results:

- **OpenObserve** built 8 QA sub-agents, growing test coverage from 380 to 700+ tests with flaky tests reduced by 85%
- **Airwallex** cut integration test creation from 2 weeks to 2 hours, delivering 4,000+ integration tests

Create `.claude/agents/qa-regression.md`:
```markdown
You are a QA regression specialist. When invoked:
1. Run the full test suite and record results
2. Compare against the last known-good test results
3. For any new failures, use git log and git diff to identify which commit introduced the regression
4. Attempt to fix regressions. If a fix breaks other tests, revert it.
5. Write a summary to TEST_REPORT.md listing: tests passed, tests failed, regressions found, fixes applied
6. Never mark tests as skipped to hide failures.
```

Resources:
- [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) -- 100+ sub-agents including QA category
- [ClaudeCodeAgents](https://github.com/darcyegb/ClaudeCodeAgents) -- QA-specific agent collection

### Layer 6: TDD Guard Tool

**tdd-guard** enforces test-driven development by intercepting file modifications. It blocks implementation code that doesn't have corresponding failing tests first. Supports Jest, Vitest, pytest, PHPUnit, Go, and Rust.

```bash
# Install
brew install tdd-guard  # macOS

# Toggle on/off
tdd-guard on
tdd-guard off
```

Set up via `/hooks` in Claude Code to configure PreToolUse, UserPromptSubmit, and SessionStart hooks.

### Layer 7: Playwright Agents for UI Regression

Playwright ships with three AI agents that integrate with Claude Code:
- **Planner** -- designs test strategies
- **Generator** -- writes test code
- **Healer** -- automatically fixes broken selectors when UI changes

This is particularly useful for catching visual/UI regressions that unit tests miss.

Source: [Playwright Agents + Claude Code](https://shipyard.build/blog/playwright-agents-claude-code/)

### Layer 8: Agent Evaluation with Promptfoo

**Promptfoo** can evaluate Claude Code's agent behavior over time -- catching regressions not just in code but in the AI's testing quality itself:

```yaml
providers:
  - id: anthropic:claude-agent-sdk
    config:
      working_dir: ./sandbox
      disallowed_tools: ['Bash']  # Read-only evaluation
```

Set thresholds for cost, latency, and correctness. Use `--repeat N` to measure variance across non-deterministic runs.

Source: [promptfoo.dev](https://www.promptfoo.dev/docs/providers/claude-agent-sdk/)

---

## Scheduled Jobs with Cron / Task Scheduler

### Windows Task Scheduler

Create scheduled Claude Code tasks on Windows:

```powershell
# Daily code quality check at 9 AM
schtasks /create /tn "Claude-CodeQuality" `
    /tr "cmd.exe /c cd /d C:\Projects\my-app && claude -p \"Review code quality. Check for TODO items, dead code, and potential bugs. Write report to QUALITY_REPORT.md\" --allowedTools \"Edit,Write,Bash(npm test:*)\"" `
    /sc daily /st 09:00

# Weekly dependency audit on Sundays at midnight
schtasks /create /tn "Claude-DepAudit" `
    /tr "cmd.exe /c cd /d C:\Projects\my-app && claude -p \"Run npm audit. Update any packages with known vulnerabilities. Run tests after updating.\" --allowedTools \"Edit,Write,Bash(npm:*)\"" `
    /sc weekly /d SUN /st 00:00

# List your scheduled tasks
schtasks /query /tn "Claude-*"

# Delete a task
schtasks /delete /tn "Claude-CodeQuality" /f
```

### Linux/macOS Cron

```bash
# crontab -e

# Daily regression tests at 2 AM
0 2 * * * cd /path/to/project && claude -p "Run full test suite and report" --allowedTools "Edit,Write,Bash(npm test:*)" > /tmp/claude-test.log 2>&1

# Weekly security audit on Sundays
0 0 * * 0 cd /path/to/project && claude -p "Run security audit" --allowedTools "Edit,Write,Bash(npm audit:*)" > /tmp/claude-audit.log 2>&1
```

### claude-code-scheduler (Cross-Platform)

A dedicated tool that abstracts away the differences between cron, launchd, and Windows Task Scheduler:

```bash
npm install -g claude-code-scheduler

# Schedule a daily test run
claude-schedule add --name "nightly-tests" \
    --cron "0 2 * * *" \
    --project /path/to/project \
    --prompt "Run all tests and report failures"

# List scheduled tasks
claude-schedule list

# Remove a task
claude-schedule remove --name "nightly-tests"
```

GitHub: [github.com/jshchnz/claude-code-scheduler](https://github.com/jshchnz/claude-code-scheduler)

---

## Heartbeat Monitoring

### What is a Heartbeat?

A heartbeat is a periodic check that fires on a timer. Instead of Claude only responding when you type something, a heartbeat makes it **proactive** -- it can check for tasks, monitor for issues, and alert you.

### When a Heartbeat Helps

- **Long-running autonomous sessions** -- detect if Claude has stalled or crashed
- **Task queue monitoring** -- periodically check if new tickets have been added and start working on them
- **Health checks** -- verify your dev server is still running, tests still pass, etc.
- **Proactive alerts** -- notify you if something breaks overnight

### OpenClaw (formerly Clawbot) Heartbeat Pattern

OpenClaw is an open-source personal AI assistant (44k+ GitHub stars) that pioneered the heartbeat pattern for AI agents. Its approach:

1. A `HEARTBEAT.md` file defines what to check on each heartbeat
2. A timer fires every N minutes (default 30)
3. The agent reads `HEARTBEAT.md`, checks for pending tasks
4. If nothing to do, responds `HEARTBEAT_OK` (silent)
5. If action needed, proactively messages you or takes action

**Adapting this for Claude Code:**

Create `HEARTBEAT.md` in your project:
```markdown
# Heartbeat Checks

On each heartbeat, perform these checks:

1. Are there new items in BACKLOG.md marked as Todo? If yes, start working on the next one.
2. Run `npm test` -- are all tests passing? If not, create an entry in BACKLOG.md.
3. Check git status -- are there uncommitted changes that look abandoned? Report them.
4. If nothing to do, exit with code 0.
```

Then schedule the heartbeat with cron or Task Scheduler:
```bash
# Every 30 minutes during work hours (9 AM - 6 PM, Mon-Fri)
*/30 9-18 * * 1-5 cd /path/to/project && claude -p "$(cat HEARTBEAT.md)" --allowedTools "Edit,Write,Bash(npm test:*),Bash(git status:*)"
```

**Windows equivalent:**
```powershell
# Create a heartbeat task that runs every 30 minutes
schtasks /create /tn "Claude-Heartbeat" `
    /tr "cmd.exe /c cd /d C:\Projects\my-app && claude -p \"Read HEARTBEAT.md and perform all checks listed there.\" --allowedTools \"Edit,Write,Bash(npm test:*),Bash(git status:*)\"" `
    /sc minute /mo 30
```

### Claude Code's Built-in Heartbeat (Multi-Agent)

When using Claude Code's swarm/multi-agent mode, there's a built-in 5-minute heartbeat timeout. If an agent doesn't respond within 5 minutes, its task is released back to the pool. This prevents deadlocks in parallel workflows.

### Pop-Heartbeat Skill

Available on MCPMarket, this Claude Code skill provides real-time session monitoring -- tracking tool calls, file modifications, and command success rates. Useful for understanding session health.

---

## Multi-Agent Orchestration

For large codebases where you want multiple Claude instances working in parallel:

| Tool | What it does | Link |
|------|-------------|------|
| **claude-flow** | Full orchestration platform with heartbeats, task queues, and agent coordination | [github.com/ruvnet/claude-flow](https://github.com/ruvnet/claude-flow) |
| **ccswarm** | Lightweight swarm mode for Claude Code using git worktrees | [github.com/nwiizo/ccswarm](https://github.com/nwiizo/ccswarm) |
| **oh-my-claudecode** | 5 execution modes (Autopilot, Ultrapilot 3-5x parallel, Swarm, Pipeline, Ecomode). 31+ skills, 32 agents. | [github.com/Yeachan-Heo/oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| **Claude Code Agentrooms** | Route tasks to specialized agents with @mentions coordination | [claudecode.run](https://claudecode.run/) |
| **Custom sub-agents** | Create `.claude/agents/*.md` files defining specialized agents | built-in to Claude Code |

### Planning-with-Files Skill (Manus-Style Persistent Planning)

This free Claude Code skill implements persistent markdown planning across sessions:
- `task_plan.md` tracks phases and progress
- `findings.md` stores research
- `progress.md` logs session activity
- Treats the filesystem as persistent "disk" storage vs. context window as volatile "RAM"
- Automatically recovers unfinished work when you run `/clear`

GitHub: [github.com/OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files)

### Custom Sub-Agents

Create specialized agents in `.claude/agents/`:

**`.claude/agents/bugfixer.md`:**
```markdown
You are a bug-fixing specialist. When given a bug report:
1. Read the relevant source files
2. Identify the root cause
3. Write a fix
4. Run the test suite
5. If your fix breaks other tests, fix those too
6. Never ask questions. Just fix.
```

**`.claude/agents/tester.md`:**
```markdown
You are a testing specialist. When given code changes:
1. Review what changed (git diff)
2. Run the existing test suite
3. Write new tests for any uncovered paths
4. Ensure all tests pass
5. Report any regressions found
```

Use them with: `claude -p "Use the bugfixer agent to fix: [bug description]"`

---

## Recommended Setups by Use Case

### Solo Developer, Small Project, Quick Bug Fixes
```
Tools needed: None (just configuration)
Setup time: 5 minutes

1. Add autonomy rules to CLAUDE.md
2. Set up allowedTools in .claude/settings.local.json
3. Use the fix-bug.sh script for one-shot fixes
4. Use BACKLOG.md for task tracking
```

### Solo Developer, Complex Project, Mix of Bugs and Features
```
Tools needed: GitHub Issues (free)
Setup time: 30 minutes

1. Everything from above
2. Install Claude Code GitHub Action
3. Use GitHub Issues with 'claude' label for bugs
4. Use Ralph Wiggum kanban for features
5. Set up nightly test run (Task Scheduler or cron)
```

### Team, Large Project, Needs Regression Testing
```
Tools needed: GitHub Actions + MCP server for your ticket system
Setup time: 1-2 hours

1. Everything from above
2. Add GitHub Actions for nightly regression tests
3. Add pre-commit hooks for test enforcement
4. Install an MCP server (GitHub, Linear, or Jira) for ticket integration
5. Set up heartbeat checks for continuous monitoring
```

### Full Automation (Ralph Wiggum + Scheduling + Monitoring)
```
Tools needed: Kanban runner + Task Scheduler + Heartbeat
Setup time: 2-3 hours

1. Kanban folder structure with run-kanban.sh
2. BACKLOG.md for lightweight items
3. Scheduled nightly regression tests
4. Heartbeat monitoring every 30 minutes during work hours
5. GitHub Actions for CI/CD
6. Custom sub-agents for specialized tasks
```

---

## Maximum Automation Config (Copy-Paste Ready)

For the highest level of automation with safety, combine everything into a single project config.

**`.claude/settings.local.json`:**
```json
{
  "defaultMode": "acceptEdits",
  "permissions": {
    "allow": [
      "Read",
      "Edit",
      "Write",
      "Bash(npm run:*)",
      "Bash(npm test:*)",
      "Bash(npx:*)",
      "Bash(git diff:*)",
      "Bash(git log:*)",
      "Bash(git status:*)",
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git checkout:*)",
      "Bash(gh issue view:*)",
      "Bash(gh pr create:*)",
      "Bash(python:*)",
      "Bash(pip:*)"
    ],
    "deny": [
      "Bash(rm -rf:*)",
      "Bash(git push --force:*)"
    ]
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'File modified -- remember to run tests before committing.'"
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "matcher": "compact",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'CRITICAL REMINDERS AFTER COMPACTION: Always run tests after changes. Never ask questions -- just fix issues. Read BACKLOG.md for pending tasks.'"
          }
        ]
      }
    ]
  }
}
```

**`CLAUDE.md` (project root):**
```markdown
# Project Rules

## Autonomy
- Do NOT ask clarifying questions. Make reasonable assumptions and proceed.
- Do NOT stop to ask for confirmation. Complete the full task.
- If something fails, fix it and retry up to 3 times before reporting.
- NEVER leave code in a broken state.

## Testing (CRITICAL)
- After ANY code change, run the full test suite
- If any test fails that was passing before your change, fix it before moving on
- NEVER skip tests. NEVER mark tests as skipped to make them pass.
- If you cannot fix a regression after 3 attempts, revert your change and report to FAILED_FIX.md

## Task Management
- Read BACKLOG.md at the start of each session for pending tasks
- Pick the next unchecked item from the Todo section
- Move it to In Progress while working, Done when complete
- Do NOT ask which task to work on. Just pick the next one.

## Context Management
- If context usage exceeds 80%, run /compact before continuing
```

**Session resumption** -- if Claude crashes or you need to continue later:
```bash
# Continue the most recent session
claude -c

# Resume a specific session by ID
claude -r <session-id>
```

---

## Reference Links

### Official Anthropic
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Claude Code GitHub Action](https://github.com/anthropics/claude-code-action)
- [Claude Code SDK (Python)](https://pypi.org/project/claude-code-sdk/)
- [Claude Code SDK (TypeScript)](https://www.npmjs.com/package/@anthropic-ai/claude-code-sdk)

### Scheduling
- [claude-code-scheduler](https://github.com/jshchnz/claude-code-scheduler) -- cross-platform scheduled tasks
- [runCLAUDErun](https://runclauderun.com/) -- macOS scheduling GUI

### Ticket Management
- [TaskMaster AI](https://github.com/eyaltoledano/claude-task-master) -- AI task management with MCP
- [mcp-ticketer](https://www.npmjs.com/package/mcp-ticketer) -- multi-platform ticket MCP
- [Plane](https://plane.so) -- free open-source project management

### Regression Testing
- [tdd-guard](https://github.com/nizos/tdd-guard) -- enforce TDD workflow in Claude Code
- [Promptfoo Agent Eval](https://www.promptfoo.dev/docs/providers/claude-agent-sdk/) -- evaluate AI agent quality over time
- [Playwright Agents + Claude](https://shipyard.build/blog/playwright-agents-claude-code/) -- UI regression testing with AI
- [awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) -- 100+ sub-agents including QA
- [ClaudeCodeAgents](https://github.com/darcyegb/ClaudeCodeAgents) -- QA-specific agent collection
- [OpenObserve QA Case Study](https://openobserve.ai/blog/autonomous-qa-testing-ai-agents-claude-code/) -- 380 to 700+ tests
- [Airwallex Testing Case Study](https://medium.com/airwallex-engineering) -- 2 weeks to 2 hours

### Monitoring
- [Claude-Code-Usage-Monitor](https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor) -- real-time session monitoring
- [Pop-Heartbeat Skill](https://mcpmarket.com/tools/skills/session-heartbeat-monitor) -- session health monitoring

### Multi-Agent
- [claude-flow](https://github.com/ruvnet/claude-flow) -- orchestration with heartbeats
- [ccswarm](https://github.com/nicobailon/ccswarm) -- lightweight parallel execution

### Heartbeat / Proactive AI
- [OpenClaw (formerly Clawbot)](https://docs.openclaw.ai/gateway/heartbeat) -- heartbeat pattern reference

### Kanban / Task Boards
- [Vibe Kanban](https://www.vibekanban.com/) -- Kanban with MCP server and parallel agent support
- [Backlog.md](https://github.com/MrLesk/Backlog.md) -- git-based project board with MCP server
- [TaskBoardAI](https://github.com/TuckerTucker/TaskBoardAI) -- file-based Kanban with web UI + MCP
- [MarkdownTaskManager](https://github.com/ioniks/MarkdownTaskManager) -- single HTML Kanban with Claude Code skill
- [Claude-Code-Board](https://github.com/cablate/Claude-Code-Board) -- Kanban WebUI for Claude Code
- [CCPM](https://github.com/automazeio/ccpm) -- GitHub Issues + git worktrees for parallel agents

### Task Management
- [taskqueue-mcp](https://github.com/chriscarrollsmith/taskqueue-mcp) -- structured queue with approval gates
- [Planning-with-Files](https://github.com/OthmanAdi/planning-with-files) -- Manus-style persistent planning skill

### Workflow Automation
- [n8n](https://n8n.io/) -- free self-hosted workflow automation with Claude integration
- [Activepieces](https://www.activepieces.com/) -- MIT-licensed no-code automation (Zapier alternative)
- [n8n-MCP bridge](https://github.com/czlonkowski/n8n-mcp) -- connect n8n's 1,084 nodes to Claude Code

### Prompt Management
- [Claude Code Custom Slash Commands](https://code.claude.com/docs/en/slash-commands) -- reusable prompts as `.md` files
- [Claude Command Suite](https://github.com/qdhenry/Claude-Command-Suite) -- professional slash commands collection

### Community Resources
- [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) -- curated list of tools and resources
- [awesome-mcp-servers](https://github.com/wong2/awesome-mcp-servers) -- curated MCP servers list
- [Anthropic Skills Repository](https://github.com/anthropics/skills) -- official reusable skills

---

*Last updated: 2026-02-10*
*Generated for sharing across projects using Claude Code*
