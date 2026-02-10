# Claude in Chrome Extension - Windows Connection Bug

## Status: UNRESOLVED (as of 2026-01-31)

## Problem
The Claude in Chrome extension's native messaging does not connect to Claude Code CLI on Windows. The MCP server shows "connected" but all `mcp__claude-in-chrome__*` tool calls return "Browser extension is not connected."

## GitHub Issues to Monitor
- https://github.com/anthropics/claude-code/issues/22025 - Windows 11 not connecting
- https://github.com/anthropics/claude-code/issues/21371 - Extension installed but won't connect
- https://github.com/anthropics/claude-code/issues/20298 - Native messaging failure
- https://github.com/anthropics/claude-code/issues/21300 - MCP shows connected but tools fail
- https://github.com/anthropics/claude-code/issues/20862 - MCP tools fail despite Connected status
- https://github.com/anthropics/claude-code/issues/21363 - Native messaging on Windows 11

## Quick Check Command
```bash
# Search for updates on the main issue
gh issue view 22025 --repo anthropics/claude-code --comments
```

## Working Alternative: Playwright MCP
Playwright MCP is configured globally in `~/.claude.json` (user-level `mcpServers`).
It launches its own Chromium — no Chrome extension needed. Works in all projects.

Tested 2026-01-31: Successfully navigated to dashboard, read all tabs, clicked elements.

## Workarounds Tried for Chrome Extension (None Successful)
- Restart Chrome
- Reinstall extension
- Reboot computer
- /chrome -> Reconnect extension
- Verify extension enabled in chrome://extensions/
