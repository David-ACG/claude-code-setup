# Kanban Runner — Autonomous Prompt Loop

Loops through all `PROMPT_*.md` files in `kanban/1_planning/`, executes each one with Claude Code in autonomous mode, and moves completed prompts to `kanban/2_testing/`.

## Step-by-step instructions

### 1. Exit Claude Code
You cannot run this from inside Claude Code. Press `Ctrl+C` or type `/exit` to quit your current Claude Code session.

### 2. Stay in Warp
You should now be at a normal shell prompt in Warp.

### 3. cd to your project root
```bash
cd C:\Projects\claude-code-setup
```
(Or any project that has a `kanban/` folder.)

### 4. Run the script

**Windows (Warp/PowerShell):**
```powershell
& "C:\Program Files\Git\bin\bash.exe" -l kanban/run-kanban.sh
```

**Mac/Linux:**
```bash
bash kanban/run-kanban.sh
```

### 5. Walk away
Each `PROMPT_` file will be executed as a separate Claude Code session. Completed prompts move to `2_testing/`. Failed ones stay in `1_planning/`.

## Reusing in other projects

Copy `run-kanban.sh` into each project's `kanban/` folder — or keep one copy and pass the path:

**Windows (Warp/PowerShell):**
```powershell
cd C:\Projects\some-other-project
& "C:\Program Files\Git\bin\bash.exe" -l C:\Projects\claude-code-setup\kanban\run-kanban.sh
```

**Mac/Linux:**
```bash
cd /path/to/some-other-project
bash /path/to/claude-code-setup/kanban/run-kanban.sh
```

The script uses `$(pwd)` as the project root, so it works from wherever you `cd` to.

## What the script does

1. Finds all `PROMPT_*.md` in `kanban/1_planning/`, sorted by name
2. For each one, runs `claude --dangerously-skip-permissions` with the file content
3. Tells Claude that reference files (non-PROMPT) exist in `1_planning/` to read as needed
4. Tells Claude to compact context at 110k/200k tokens
5. On success → moves the PROMPT file to `kanban/2_testing/`
6. On failure → leaves it in `1_planning/`
7. Prints a summary at the end

## Requirements

- Claude Code CLI installed and on PATH
- `kanban/1_planning/` and `kanban/2_testing/` folders exist
- Prompt files named `PROMPT_*.md`
- **Windows**: Git for Windows (`winget install -e --id Git.Git`) — provides bash at `C:\Program Files\Git\bin\bash.exe`. The `-l` flag is required so standard tools (`mkdir`, `cp`, etc.) are on PATH.

## Safety

- Each prompt gets a fresh context window (no token limit issues across prompts)
- `--dangerously-skip-permissions` gives Claude full system access — run in a container if you want isolation
- Review results in `2_testing/` before moving to `3_done/`
