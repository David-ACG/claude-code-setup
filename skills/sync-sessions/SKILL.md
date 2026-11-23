---
name: sync-sessions
description: Copy Claude desktop Code-tab sidebar sessions between David's Windows laptops (X1EG3 and T14s) so the laptop he is on shows every session, including ones started on the other laptop. Use when David says /sync-sessions, "sync my sessions", "I've swapped laptops", "I'm on the T14s/X1EG3 now", "sessions are missing", "copy my sessions across", or when the sidebar lacks sessions he started on the other laptop.
---

# Sync sidebar sessions between laptops

Every Code-tab session runs on hlab (the P520). Each laptop only keeps its own
**sidebar list** of those sessions (one small record per session, plus which
section it sits in and the pins), and the Claude app does not sync that list.
So a session started on the X1EG3 is missing on the T14s, and the other way round.
The conversations themselves are never at risk: they live on hlab.

The script copies the missing entries **both ways**. It never deletes or
overwrites an entry, and never brings back a session deleted on the other laptop.

```bash
S=/home/david/projects/claude-code-setup/scripts/claude-sidebar-sync/sync.py
python3 $S where                         # which laptop this session runs from
python3 $S                               # dry run: what is missing on each laptop
python3 $S --apply --relaunch here       # stage the copy, reopen Claude here after
python3 $S status                        # did it land? (per laptop)
```

## Steps

1. **Dry run.** `python3 $S` (takes ~30 s: it reads both laptops over SSH). Tell
   David in one or two lines how many are missing on the laptop he is on, with
   their titles. If nothing is missing either way, say so and stop.
2. **Copy.** He asked for the sync by calling the skill, so do not ask again:
   run `python3 $S --apply --relaunch here`. If `where` says `unknown` (the
   session is not running from a laptop), leave out `--relaunch here`.
3. **Hand over in two lines:** *"Quit Claude fully: right-click the Claude icon
   in the taskbar tray, then Quit. It reopens by itself in about 10 seconds with
   the N sessions in the sidebar."* Add that this chat closes too and will be
   back in the sidebar, because it is on hlab. Closing the window is not enough:
   the app keeps running in the tray, and the copy waits until it has fully quit.
   Restarting the laptop works too (proven 2026-11-23): the copy lands as
   Windows closes Claude, and the startup run tidies up the task.
4. **Confirm** when he is back (his next message): `python3 $S status` should show
   `result: {"ok": true, "copied": [...]}` for the laptop he is on. Then run the
   dry run again: that laptop should show 0 missing.

The copy to the **other** laptop is staged as well. It lands the next time
Claude is fully quit there, or when that laptop restarts. Running the skill
again re-stages anything still missing, so nothing piles up.

## Things to tell him

- Entries marked `[active in the last 6 hours]` may still be open on the other
  laptop. Don't type into the same session on both laptops at once.
- `skipped: ... (runs on the laptop itself, not on hlab)` means a session whose
  folder is on that laptop's own disk. Those can't be opened from the other
  laptop, so they are left alone on purpose.
- If a laptop is off, asleep or off Tailscale, the SSH step times out. Say which
  one, and sync again when it is back.

## How it works (for fixing it)

- `sync.py` (hlab) runs `agent.js export` on both laptops (Node, copied over each
  run to `%LOCALAPPDATA%\claude-sidebar-sync\`), diffs the record ids, fetches
  the missing records, and gives each one the destination laptop's own working
  hlab connection (`sshConfig` from its newest session). It also strips
  `sshReattach`, `sshRemoteProcessId` and `bridgeSessionIds`, so the laptop
  starts its own remote process instead of grabbing the other laptop's.
- It sends a `stage-<time>-from-<laptop>` folder (records + `plan.json`) and
  registers a one-shot SYSTEM task, **ClaudeSidebarSync**, that runs
  `waiter.ps1`. The task waits for the desktop app (`claude.exe` under
  `AnthropicClaude\` or `WindowsApps\Claude_*`, not the CLI) to quit, runs
  `agent.js apply`, reopens Claude through **ClaudeSidebarSync-Relaunch** (if
  asked, and only if Claude was open when it started), and then removes itself.
  It also runs at startup, and it gives up after 3 days.
- `apply` adds the records, the archive-index entries, the section assignment
  (`dframe-group-scopes` → `assignments` / `order` / `groups`), any missing
  sections (`dframe-code-sections`) and pins (`starred-local-code-sessions`).
  These sit in `preferences.epitaxyPrefs` of `claude_desktop_config.json`.
- **Data folders:** X1EG3 (Store build) uses
  `%LOCALAPPDATA%\Claude-Data\claude_pzs8sxrjxfjjc\`. T14s (standard installer)
  uses `%APPDATA%\Claude\`. Both hold `claude-code-sessions\<account>\<org>\`.
- **Logs and backups:** `%LOCALAPPDATA%\claude-sidebar-sync\stage-*\waiter.log`
  and `result.json` on the laptop. The config is backed up next to itself as
  `claude_desktop_config.json.bak-sidebar-sync-<time>`. To undo, quit Claude,
  copy the backup back, and delete the copied `local_*.json` files listed in
  `result.json`. hlab keeps a copy of each package in
  `~/.local/state/claude-sidebar-sync/`.
- **A third laptop:** give hlab SSH into it
  (`scripts/windows-enable-ssh-from-hlab.ps1` plus a Tailscale grant). Add it to
  `HOSTS` in `sync.py` with its Tailscale address, and pass `--hosts a b` (the
  script syncs two laptops at a time).
- **Test without touching a laptop:** `python3 $S --stage-only` builds the
  packages in `~/.local/state/claude-sidebar-sync/` and sends nothing.
