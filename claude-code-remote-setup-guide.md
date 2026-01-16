# Claude Code Remote Access Setup Guide

## Overview

This guide documents the complete setup of a remote Claude Code environment:
- **P520 Workstation** (Ubuntu Server, 128GB RAM, RTX 3060) - hostname "hlab" - runs Claude Code 24/7
- **P53 Laptop** (Windows 11, 64GB RAM) - connects via SSH through Warp terminal
- **Pixel 9 Phone** (Android) - connects via SSH through Termux

All connections are secured through Tailscale's private mesh network.

---

## Completed Setup Details

### Tailscale IPs

| Device | Tailscale IP | Hostname |
|--------|--------------|----------|
| P520 Workstation | 100.79.248.39 | hlab |
| P53 Laptop | 100.122.153.101 | p53 |
| Pixel 9 Phone | 100.86.38.19 | google-pixel-9-pro |

### Connection Commands

| From | Command | Result |
|------|---------|--------|
| P53 Laptop | `ssh claude` | Direct to Claude tmux session |
| P53 Laptop | `ssh p520` | SSH to P520 shell |
| Pixel 9 | `ssh claude` | Direct to Claude tmux session |

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    P520 WORKSTATION (hlab)                  │
│                    Ubuntu Server - Always On                │
│                    Tailscale: 100.79.248.39                 │
│                                                             │
│   ┌─────────────────────────────────────────────────────┐  │
│   │  Services Running:                                  │  │
│   │  • Claude Code (in tmux session)                    │  │
│   │  • SSH Server (port 22)                             │  │
│   │  • Tailscale VPN                                    │  │
│   └─────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ Tailscale Mesh VPN
                              │ (encrypted, NAT-punching)
                              │
              ┌───────────────┴───────────────┐
              │                               │
              ▼                               ▼
┌──────────────────────┐        ┌──────────────────────┐
│   P53 LAPTOP         │        │   PIXEL 9 PHONE      │
│   Windows 11         │        │   Android            │
│   100.122.153.101    │        │   100.86.38.19       │
│                      │        │                      │
│   • Warp Terminal    │        │   • Termux           │
│   • Tailscale        │        │   • Tailscale        │
│   • SSH client       │        │   • SSH client       │
└──────────────────────┘        └──────────────────────┘
```

---

## Part 1: P520 Workstation Setup

### Step 1: Install Tailscale

```bash
# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Start Tailscale and authenticate
sudo tailscale up

# Get your Tailscale IP (ours: 100.79.248.39)
tailscale ip -4

# Enable on boot
sudo systemctl enable tailscaled
```

### Step 2: Install Claude Code

```bash
# Install Claude Code globally
sudo npm install -g @anthropic-ai/claude-code

# Verify installation
claude --version
```

### Step 3: Configure tmux

Create `~/.tmux.conf`:

```bash
# Better prefix key (Ctrl+a instead of Ctrl+b)
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# Enable mouse support
set -g mouse on

# Increase scrollback buffer
set -g history-limit 50000

# Better colors
set -g default-terminal "screen-256color"

# Split panes using | and -
bind | split-window -h
bind - split-window -v

# Easy pane switching with Alt+arrow
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D
```

### Step 4: Add Bash Aliases

Add to `~/.bashrc`:

```bash
# Claude Code Remote Access Aliases
alias cc="tmux new-session -A -s claude"
alias ccp="tmux new-session -A -s claude -c ~/projects"
alias tls="tmux list-sessions"
alias cck="tmux kill-session -t claude"
alias myip="tailscale ip -4"
alias status="echo \"=== Tailscale ===\" && tailscale status && echo -e \"\n=== tmux sessions ===\" && tmux list-sessions 2>/dev/null || echo \"No sessions\" && echo -e \"\n=== System ===\" && uptime"
```

Apply: `source ~/.bashrc`

---

## Part 2: P53 Laptop Setup (Windows 11)

### Step 1: Install Tailscale

1. Download from https://tailscale.com/download/windows
2. Sign in with the **same account** as P520
3. Verify P520 appears in "My devices"

### Step 2: Configure SSH

Create/edit `~/.ssh/config`:

```
Host p520
    HostName 100.79.248.39
    User david
    IdentityFile ~/.ssh/p520_ed25519
    IdentitiesOnly yes
    ServerAliveInterval 60
    ServerAliveCountMax 3

Host p520-local
    HostName 192.168.178.50
    User david
    IdentityFile ~/.ssh/p520_ed25519
    IdentitiesOnly yes

Host claude
    HostName 100.79.248.39
    User david
    IdentityFile ~/.ssh/p520_ed25519
    IdentitiesOnly yes
    ServerAliveInterval 60
    ServerAliveCountMax 3
    RequestTTY yes
    RemoteCommand tmux new-session -A -s claude
```

### Step 3: Add Host Key

If you get "Host key verification failed" after switching to Tailscale IP:

```bash
ssh-keyscan -H 100.79.248.39 >> ~/.ssh/known_hosts
```

### Step 4: Test Connection

```bash
ssh claude
```

You should connect directly to the tmux session on P520.

---

## Part 3: Pixel 9 Phone Setup (Android)

### Step 1: Install Tailscale

1. Install from Google Play Store
2. Sign in with the **same account**
3. Ensure VPN is connected (key icon in status bar)

**Important:** If SSH shows "Network unreachable", toggle Tailscale OFF and ON, or reinstall the app.

### Step 2: Install Termux

**Install from F-Droid, NOT Google Play Store:**

1. Download F-Droid from https://f-droid.org
2. Search for "Termux"
3. Install **"Termux - Terminal emulator with packages"**

### Step 3: Configure Termux

```bash
# Update packages
pkg update && pkg upgrade

# Install SSH
pkg install openssh
```

### Step 4: Generate SSH Key

```bash
ssh-keygen -t ed25519 -f ~/.ssh/p520_key -N ""

# Show public key
cat ~/.ssh/p520_key.pub
```

### Step 5: Add Key to P520

From P53 laptop (or any machine with access to P520):

```bash
ssh p520 "echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINy7XWq/J1FOfJHmz33VbikMdm6fSeL5KxLaYUQRfWph u0_a285@localhost' >> ~/.ssh/authorized_keys"
```

### Step 6: Create SSH Config on Phone

In Termux:

```bash
cat > ~/.ssh/config << 'EOF'
Host claude
    HostName 100.79.248.39
    User david
    IdentityFile ~/.ssh/p520_key
    ServerAliveInterval 60
    ServerAliveCountMax 3
    RequestTTY yes
    RemoteCommand tmux new-session -A -s claude
EOF
chmod 600 ~/.ssh/config
```

### Step 7: Connect

```bash
ssh claude
```

You'll connect to the same tmux session visible from all devices.

---

## Part 4: Status Line Configuration (Windows)

### Custom Status Line Script

Create `C:\Users\david\.claude\statusline.ps1`:

```powershell
$ESC = [char]27
$input_json = $input | Out-String
try { $data = $input_json | ConvertFrom-Json } catch { Write-Host "parse error"; exit 0 }

$cwd = $data.cwd
$model = if ($data.model.display_name) { $data.model.display_name } else { "Claude" }
$ctx_pct = $data.context_window.remaining_percentage
$ctx_size = $data.context_window.context_window_size
$total_input = $data.context_window.total_input_tokens
$total_output = $data.context_window.total_output_tokens
$cost = if ($data.cost.total_cost_usd) { $data.cost.total_cost_usd } else { 0 }
$lines_added = if ($data.cost.total_lines_added) { $data.cost.total_lines_added } else { 0 }
$lines_removed = if ($data.cost.total_lines_removed) { $data.cost.total_lines_removed } else { 0 }

$CYAN = "$ESC[36m"; $GREEN = "$ESC[32m"; $YELLOW = "$ESC[33m"; $RED = "$ESC[31m"; $MAGENTA = "$ESC[35m"; $DIM = "$ESC[2m"; $RESET = "$ESC[0m"

$short_dir = $cwd -replace ".*[/\\]Projects[/\\]", "~/Projects/" -replace "\\", "/"

$git_branch = ""
if ($cwd -and (Test-Path $cwd -ErrorAction SilentlyContinue)) {
    Push-Location $cwd
    $branch = git symbolic-ref --short HEAD 2>$null
    if ($branch) { $git_branch = " ${MAGENTA}${branch}${RESET}" }
    Pop-Location
}

$ctx_color = if ($ctx_pct -lt 20) { $RED } elseif ($ctx_pct -lt 40) { $YELLOW } else { $GREEN }
$used_k = [math]::Round(($total_input + $total_output) / 1000)
$total_k = [math]::Round($ctx_size / 1000)
$context = "${ctx_color}${ctx_pct}%${RESET} ${DIM}${used_k}k/${total_k}k${RESET}"

$cost_str = ""
if ($cost -gt 0) { $cost_str = " ${DIM}`$${RESET}$([math]::Round($cost, 2))" }

$lines_str = ""
if ($lines_added -gt 0 -or $lines_removed -gt 0) {
    $lines_str = " ${GREEN}+${lines_added}${RESET}${DIM}/${RESET}${RED}-${lines_removed}${RESET}"
}

$status = "${CYAN}${short_dir}${RESET}${git_branch} ${DIM}|${RESET} $model ${DIM}ctx:${RESET}$context$cost_str$lines_str"
Write-Host $status
```

### Configure settings.json

In `C:\Users\david\.claude\settings.json`, add:

```json
{
  "statusLine": {
    "type": "command",
    "command": "powershell.exe -ExecutionPolicy Bypass -NoProfile -File C:\\Users\\david\\.claude\\statusline.ps1"
  }
}
```

### Status Line Output

The status line displays:
```
~/Projects/claude-code-setup master | Opus 4.5 ctx:68% 184k/200k $7.48 +194/-101
```

- **Directory** (cyan) - shortened path
- **Git branch** (magenta) - when in a repo
- **Model name**
- **Context remaining** (color-coded: green >40%, yellow 20-40%, red <20%)
- **Token usage** - e.g., 184k/200k
- **Session cost** - e.g., $7.48
- **Lines changed** - +added/-removed

---

## Part 5: tmux Commands Reference

| Action | Keys |
|--------|------|
| Detach (leave running) | `Ctrl+a` then `d` |
| Scroll up | `Ctrl+a` then `[`, then scroll |
| Exit scroll mode | `q` |
| New window | `Ctrl+a` then `c` |
| Next window | `Ctrl+a` then `n` |
| Previous window | `Ctrl+a` then `p` |
| List windows | `Ctrl+a` then `w` |
| Vertical split | `Ctrl+a` then `|` |
| Horizontal split | `Ctrl+a` then `-` |
| Switch panes | `Alt+Arrow` |

---

## Part 6: Troubleshooting

### SSH "Network is unreachable" (Mobile)

Tailscale VPN isn't routing traffic:
1. Open Tailscale app
2. Toggle OFF then ON
3. Or reinstall Tailscale

### Host Key Verification Failed

After changing IPs (e.g., switching to Tailscale IP):

```bash
ssh-keyscan -H 100.79.248.39 >> ~/.ssh/known_hosts
```

### Status Line Shows Wrong Context %

The correct JSON field is `remaining_percentage`, not calculated from tokens. The script above uses this correctly.

### PowerShell ANSI Codes Not Working

Use `$ESC = [char]27` instead of `` `e `` for escape sequences - works on all PowerShell versions.

### Claude Code Not Found on P520

Install with:
```bash
sudo npm install -g @anthropic-ai/claude-code
```

---

## Files Reference

### P520 (Ubuntu)

| File | Purpose |
|------|---------|
| `~/.tmux.conf` | tmux configuration |
| `~/.bashrc` | Shell aliases |
| `~/.ssh/authorized_keys` | SSH public keys |

### P53 (Windows)

| File | Purpose |
|------|---------|
| `~/.ssh/config` | SSH connection shortcuts |
| `~/.ssh/p520_ed25519` | SSH private key |
| `~/.claude/settings.json` | Claude Code global settings |
| `~/.claude/statusline.ps1` | Status line script |

### Pixel 9 (Termux)

| File | Purpose |
|------|---------|
| `~/.ssh/config` | SSH connection shortcuts |
| `~/.ssh/p520_key` | SSH private key |

---

## Summary

The setup provides:

- **Always-on Claude Code** running on P520 in a tmux session
- **Seamless access** from laptop (Warp) and phone (Termux)
- **Persistent sessions** - disconnect and reconnect without losing state
- **Secure connections** via Tailscale mesh VPN
- **Rich status line** showing context, cost, and changes

All three devices connect to the **same tmux session**, so you can start work on your laptop and continue on your phone with full context preserved.
