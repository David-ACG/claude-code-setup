# Claude Code Remote Access Setup Guide

## Overview

This guide sets up a remote Claude Code environment where:
- **P520 Workstation** (Ubuntu Server, 128GB RAM, RTX 3060) runs Claude Code 24/7
- **P53 Laptop** (Windows 11, 64GB RAM) connects via SSH through Warp terminal
- **Pixel 9 Phone** (Android) connects via SSH through Termux

All connections are secured through Tailscale's private mesh network.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    P520 WORKSTATION (CUPBOARD)               │
│                    Ubuntu Server - Always On                 │
│                                                              │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  Services Running:                                  │   │
│   │  • Claude Code (in tmux session)                    │   │
│   │  • SSH Server (port 22)                             │   │
│   │  • Tailscale (100.x.x.x private IP)                 │   │
│   │  • Docker + NVIDIA runtime (for TTS)                │   │
│   └─────────────────────────────────────────────────────┘   │
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
│                      │        │                      │
│   • Warp Terminal    │        │   • Termux           │
│   • Tailscale        │        │   • Tailscale        │
│   • SSH client       │        │   • SSH client       │
└──────────────────────┘        └──────────────────────┘
```

---

## Part 1: P520 Workstation Setup

### Prerequisites Check

First, verify what's already installed:

```bash
# Check Ubuntu version
lsb_release -a

# Check if SSH server is running
sudo systemctl status ssh

# Check if Tailscale is installed
which tailscale

# Check Node.js version (need 18+)
node --version

# Check if tmux is installed
which tmux

# Check NVIDIA driver (for TTS work)
nvidia-smi
```

### Step 1: System Updates

```bash
sudo apt update && sudo apt upgrade -y
```

### Step 2: Install SSH Server (if not present)

```bash
# Install OpenSSH server
sudo apt install openssh-server -y

# Enable and start SSH
sudo systemctl enable ssh
sudo systemctl start ssh

# Verify it's running
sudo systemctl status ssh

# Check SSH is listening
sudo ss -tlnp | grep 22
```

### Step 3: Configure SSH for Security and Convenience

```bash
# Backup original config
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Edit SSH config
sudo nano /etc/ssh/sshd_config
```

**Ensure these settings are present:**

```
Port 22
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication yes
X11Forwarding no
MaxAuthTries 3
ClientAliveInterval 60
ClientAliveCountMax 3
```

**Apply changes:**

```bash
sudo systemctl restart ssh
```

### Step 4: Install Tailscale

```bash
# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Start Tailscale and authenticate
sudo tailscale up

# This will print a URL - open it in a browser to authenticate
# Use your personal Tailscale account (or create one at tailscale.com)

# After authentication, get your Tailscale IP
tailscale ip -4

# IMPORTANT: Note this IP address (e.g., 100.64.x.x)
# You'll need it for connecting from other devices
```

**Enable Tailscale to start on boot:**

```bash
sudo systemctl enable tailscaled
```

### Step 5: Install Node.js (if not present or outdated)

```bash
# Check current version
node --version

# If not installed or below v18, install via NodeSource
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Verify installation
node --version
npm --version
```

### Step 6: Install Claude Code

```bash
# Install Claude Code globally
npm install -g @anthropic-ai/claude-code

# Verify installation
claude --version

# First run - this will prompt for API key authentication
claude

# Follow the authentication prompts
# You'll be directed to claude.ai to authorize
```

### Step 7: Install and Configure tmux

```bash
# Install tmux
sudo apt install tmux -y

# Create tmux configuration
nano ~/.tmux.conf
```

**Add this configuration:**

```
# Better prefix key (Ctrl+a instead of Ctrl+b)
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# Enable mouse support (scrolling, clicking, resizing)
set -g mouse on

# Increase scrollback buffer
set -g history-limit 50000

# Better colors
set -g default-terminal "screen-256color"

# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1

# Faster key repetition
set -s escape-time 0

# Activity monitoring
setw -g monitor-activity on
set -g visual-activity on

# Status bar customization
set -g status-style bg=black,fg=white
set -g status-left '[#S] '
set -g status-right '%H:%M %d-%b'

# Easy reload of config
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Split panes using | and -
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Easy pane switching with Alt+arrow
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D
```

### Step 8: Create Convenience Scripts and Aliases

```bash
# Edit bash profile
nano ~/.bashrc
```

**Add these aliases at the end:**

```bash
# ===========================================
# Claude Code Remote Access Aliases
# ===========================================

# Start or attach to Claude Code session
alias cc='tmux new-session -A -s claude'

# Quick Claude session with specific project
alias ccp='tmux new-session -A -s claude -c ~/projects'

# List all tmux sessions
alias tls='tmux list-sessions'

# Kill Claude session (use with caution)
alias cck='tmux kill-session -t claude'

# Show Tailscale IP
alias myip='tailscale ip -4'

# System status check
alias status='echo "=== Tailscale ===" && tailscale status && echo -e "\n=== tmux sessions ===" && tmux list-sessions 2>/dev/null || echo "No sessions" && echo -e "\n=== System ===" && uptime'
```

**Apply changes:**

```bash
source ~/.bashrc
```

### Step 9: Create a Startup Script

```bash
# Create startup script
nano ~/start-claude-server.sh
```

**Add this content:**

```bash
#!/bin/bash
# Claude Code Server Startup Script

echo "Starting Claude Code server environment..."

# Ensure Tailscale is connected
if ! tailscale status > /dev/null 2>&1; then
    echo "Starting Tailscale..."
    sudo tailscale up
fi

echo "Tailscale IP: $(tailscale ip -4)"

# Start or attach to tmux session
if tmux has-session -t claude 2>/dev/null; then
    echo "Attaching to existing Claude session..."
    tmux attach-session -t claude
else
    echo "Creating new Claude session..."
    tmux new-session -d -s claude
    tmux send-keys -t claude 'cd ~' Enter
    tmux send-keys -t claude 'echo "Claude Code server ready. Run: claude"' Enter
    tmux attach-session -t claude
fi
```

**Make it executable:**

```bash
chmod +x ~/start-claude-server.sh
```

### Step 10: Configure Auto-Start on Boot (Optional)

```bash
# Create systemd service for tmux session
sudo nano /etc/systemd/system/claude-tmux.service
```

**Add this content (replace YOUR_USERNAME with your actual username):**

```ini
[Unit]
Description=Claude Code tmux Session
After=network-online.target tailscaled.service
Wants=network-online.target

[Service]
Type=forking
User=YOUR_USERNAME
ExecStart=/usr/bin/tmux new-session -d -s claude
ExecStop=/usr/bin/tmux kill-session -t claude
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

**Enable the service:**

```bash
sudo systemctl daemon-reload
sudo systemctl enable claude-tmux.service
sudo systemctl start claude-tmux.service
```

### Step 11: Test the Setup

```bash
# Check everything is running
status

# Start Claude session
cc

# Inside tmux, start Claude Code
claude

# Test Claude is working, then detach
# Press: Ctrl+a then d
```

### Step 12: Note Your Connection Details

```bash
# Get your Tailscale IP
tailscale ip -4

# Get your username
whoami

# Record these for the other devices:
echo "=== CONNECTION DETAILS ==="
echo "Tailscale IP: $(tailscale ip -4)"
echo "Username: $(whoami)"
echo "SSH Command: ssh $(whoami)@$(tailscale ip -4)"
```

**Save these details - you'll need them for P53 and Pixel setup.**

---

## Part 2: P53 Laptop Setup (Windows 11)

### Step 1: Install Tailscale

1. Download Tailscale from: https://tailscale.com/download/windows
2. Run the installer
3. Click the Tailscale icon in system tray
4. Sign in with the **same account** you used on P520
5. Verify connection:
   - Right-click Tailscale tray icon → "My devices"
   - You should see both P53 and P520 listed

### Step 2: Install Warp Terminal (if not already installed)

1. Download from: https://www.warp.dev/
2. Install and launch
3. Complete initial setup

### Step 3: Test SSH Connection

In Warp, run:

```bash
# Replace with your actual P520 details
ssh your-username@100.x.x.x

# Accept the host key fingerprint (type 'yes')
# Enter your P520 password
```

### Step 4: Set Up SSH Key Authentication (Recommended)

In Warp on P53:

```bash
# Generate SSH key pair
ssh-keygen -t ed25519 -C "p53-laptop"

# Press Enter to accept default location
# Optionally add a passphrase

# Copy public key to P520
# Method 1: Using ssh-copy-id (if available)
ssh-copy-id your-username@100.x.x.x

# Method 2: Manual copy
# First, display the key:
cat ~/.ssh/id_ed25519.pub

# Copy the output, then SSH to P520:
ssh your-username@100.x.x.x

# On P520, add the key:
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
# Paste the key, save, exit

chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
exit
```

### Step 5: Create SSH Config for Easy Connection

In Warp on P53:

```bash
# Create/edit SSH config
nano ~/.ssh/config

# If nano doesn't work in Warp, use:
notepad ~/.ssh/config
```

**Add this configuration:**

```
Host p520
    HostName 100.x.x.x
    User your-username
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    ServerAliveCountMax 3

Host claude
    HostName 100.x.x.x
    User your-username
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    ServerAliveCountMax 3
    RequestTTY yes
    RemoteCommand tmux new-session -A -s claude
```

**Now you can connect with:**

```bash
# Simple SSH to P520
ssh p520

# Direct to Claude tmux session
ssh claude
```

### Step 6: Create Warp Aliases (Optional)

Warp supports custom workflows. Create these for quick access:

In Warp, go to Settings → Workflows → Create Workflow:

**Workflow 1: "Claude Code"**
- Name: `Claude Code`
- Command: `ssh claude`
- Description: `Connect to Claude Code on P520`

**Workflow 2: "P520 Shell"**
- Name: `P520 Shell`
- Command: `ssh p520`
- Description: `SSH to P520 workstation`

### Step 7: Test Full Workflow

```bash
# Connect to Claude session
ssh claude

# You should now be in tmux on P520
# Start Claude if not running:
claude

# Work with Claude...

# When done, detach (session keeps running):
# Press: Ctrl+a then d

# You're back on P53, Claude continues on P520
```

---

## Part 3: Pixel 9 Phone Setup (Android)

### Step 1: Install Tailscale

1. Open Google Play Store
2. Search for "Tailscale"
3. Install the official Tailscale app
4. Open and sign in with the **same account** used on P520 and P53
5. Verify all three devices appear in "My devices"

### Step 2: Install Termux

**IMPORTANT: Install from F-Droid, NOT Google Play Store**

The Play Store version is outdated and has issues.

1. Install F-Droid:
   - Open browser on phone
   - Go to: https://f-droid.org/
   - Download and install F-Droid APK
   - You may need to enable "Install from unknown sources"

2. Install Termux from F-Droid:
   - Open F-Droid
   - Search for "Termux"
   - Install "Termux" (by Fredrik Fornwall)
   - Also install "Termux:API" (optional, for clipboard access)

### Step 3: Configure Termux

Open Termux and run:

```bash
# Update packages
pkg update && pkg upgrade -y

# Install essential tools
pkg install openssh -y
pkg install mosh -y  # Better for mobile connections
pkg install tmux -y  # Local tmux if needed

# Set up storage access (optional)
termux-setup-storage
```

### Step 4: Generate SSH Key on Phone

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "pixel9-phone"

# Press Enter for default location
# Skip passphrase (just press Enter) for convenience on mobile

# Display public key
cat ~/.ssh/id_ed25519.pub
```

**Copy this key** (long-press to select, copy).

### Step 5: Add Phone's Key to P520

From Termux, SSH to P520 using password:

```bash
ssh your-username@100.x.x.x
# Enter password

# Add phone's public key
nano ~/.ssh/authorized_keys
# Paste the key on a new line
# Save and exit (Ctrl+O, Enter, Ctrl+X)

exit
```

### Step 6: Create SSH Config on Phone

```bash
# Create SSH config
mkdir -p ~/.ssh
nano ~/.ssh/config
```

**Add this configuration:**

```
Host p520
    HostName 100.x.x.x
    User your-username
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    ServerAliveCountMax 3

Host claude
    HostName 100.x.x.x
    User your-username
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    ServerAliveCountMax 3
    RequestTTY yes
    RemoteCommand tmux new-session -A -s claude
```

### Step 7: Create Quick-Access Aliases

```bash
# Edit bash profile
nano ~/.bashrc
```

**Add these aliases:**

```bash
# Quick connect to Claude session
alias cc='ssh claude'

# Quick connect to P520
alias p520='ssh p520'

# Use mosh for better mobile stability (optional)
alias ccm='mosh your-username@100.x.x.x -- tmux new-session -A -s claude'
```

**Apply changes:**

```bash
source ~/.bashrc
```

### Step 8: Configure Termux for Better Mobile Use

```bash
# Create Termux properties file
mkdir -p ~/.termux
nano ~/.termux/termux.properties
```

**Add these settings:**

```properties
# Use black keyboard background
use-black-ui = true

# Extra keys row for easier terminal use
extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]

# Allow external apps to execute termux commands
allow-external-apps = true

# Bell behavior
bell-character = vibrate
```

**Apply changes:**

```bash
termux-reload-settings
```

### Step 9: Test Full Mobile Workflow

```bash
# Connect to Claude session
cc

# You should now be in the same tmux session as from your laptop
# Claude Code state is preserved

# Detach when done:
# Press: Ctrl+a then d

# Or use the extra keys row: tap CTRL, then 'a', then 'd'
```

### Step 10: Create Termux Widget (Optional)

For one-tap access to Claude:

1. Install "Termux:Widget" from F-Droid
2. Create shortcut directory:
   ```bash
   mkdir -p ~/.shortcuts
   nano ~/.shortcuts/Claude
   ```
3. Add:
   ```bash
   #!/data/data/com.termux/files/usr/bin/bash
   ssh claude
   ```
4. Make executable:
   ```bash
   chmod +x ~/.shortcuts/Claude
   ```
5. Add Termux widget to home screen
6. Tap "Claude" to connect instantly

---

## Part 4: Daily Workflow Reference

### Starting Your Day

**From P53 Laptop (Warp):**
```bash
ssh claude
# You're now in Claude Code on P520
```

**From Pixel 9 Phone (Termux):**
```bash
cc
# Same Claude session, same state
```

### Working with Claude Code

**Essential Commands:**
```bash
# Start Claude (if not running)
claude

# Start with specific project
claude --project /path/to/project

# Continue previous conversation
claude --continue

# Check cost of current session
/cost

# Compact conversation (save context)
/compact

# Clear and start fresh
/clear
```

### tmux Commands (When Connected)

| Action | Keys |
|--------|------|
| Detach (leave session running) | `Ctrl+a` then `d` |
| Scroll up | `Ctrl+a` then `[`, then scroll/arrows |
| Exit scroll mode | `q` |
| Create new window | `Ctrl+a` then `c` |
| Next window | `Ctrl+a` then `n` |
| Previous window | `Ctrl+a` then `p` |
| Split horizontally | `Ctrl+a` then `-` |
| Split vertically | `Ctrl+a` then `|` |
| Close current pane | `exit` or `Ctrl+d` |
| List sessions | `Ctrl+a` then `s` |

### Checking System Status

**On P520:**
```bash
status  # Custom alias showing Tailscale, tmux, uptime
```

**On any device:**
```bash
ssh p520 'tailscale status'  # Check Tailscale
ssh p520 'tmux list-sessions'  # Check tmux sessions
```

### If Connection Drops

**Session is preserved!** Just reconnect:
```bash
ssh claude
# or
cc  # on phone
```

The tmux session on P520 keeps running. Your Claude conversation and any running processes are intact.

---

## Part 5: Troubleshooting

### SSH Connection Refused

```bash
# On P520, check SSH is running:
sudo systemctl status ssh

# If not running:
sudo systemctl start ssh

# Check firewall (if using UFW):
sudo ufw status
sudo ufw allow 22/tcp
```

### Tailscale Not Connecting

```bash
# Check Tailscale status:
tailscale status

# Restart Tailscale:
sudo systemctl restart tailscaled

# Re-authenticate if needed:
sudo tailscale up --reset
```

### tmux Session Lost

```bash
# List all sessions:
tmux list-sessions

# If no sessions exist, create new:
tmux new-session -s claude

# If session exists but detached:
tmux attach-session -t claude
```

### Claude Code Authentication Issues

```bash
# Re-authenticate Claude:
claude logout
claude

# Follow the authentication prompts
```

### Slow Connection on Phone

Try using mosh instead of SSH for better mobile performance:

```bash
# On P520, install mosh:
sudo apt install mosh -y
sudo ufw allow 60000:61000/udp  # mosh ports

# On phone, connect with mosh:
mosh your-username@100.x.x.x -- tmux attach -t claude
```

### Copy/Paste Issues

**In Termux:**
- Long-press to select text
- Tap "COPY" in the popup
- Long-press to paste

**In Warp:**
- Standard Ctrl+C / Ctrl+V works
- Select with mouse to auto-copy

### Common Error Messages

| Error | Solution |
|-------|----------|
| `Connection refused` | SSH not running on P520, or wrong IP |
| `Permission denied` | Wrong password or SSH key not added |
| `No route to host` | Tailscale not connected on one device |
| `tmux: no sessions` | No tmux session exists; create with `tmux new -s claude` |
| `Host key verification failed` | Remove old key: `ssh-keygen -R 100.x.x.x` |

---

## Part 6: Security Considerations

### What's Protected

- **Tailscale encryption:** All traffic between devices is encrypted
- **No open ports:** P520 is not exposed to public internet
- **SSH keys:** More secure than passwords
- **Private network:** Only your Tailscale devices can connect

### Recommendations

1. **Use SSH keys** instead of passwords (set up in this guide)
2. **Keep systems updated:** `sudo apt update && sudo apt upgrade`
3. **Don't share Tailscale account** - it's your private network
4. **Use strong P520 password** even with SSH keys
5. **Consider passphrase on SSH key** for extra security

### Optional: Disable Password Authentication

Once SSH keys are working on all devices:

```bash
# On P520:
sudo nano /etc/ssh/sshd_config

# Change:
PasswordAuthentication no

# Restart SSH:
sudo systemctl restart ssh
```

**Warning:** Only do this after confirming key-based login works from all devices!

---

## Quick Reference Card

### Connection Commands

| Device | Command | Result |
|--------|---------|--------|
| P53 Laptop | `ssh claude` | Connect to Claude tmux session |
| P53 Laptop | `ssh p520` | Connect to P520 shell |
| Pixel 9 | `cc` | Connect to Claude tmux session |
| Pixel 9 | `p520` | Connect to P520 shell |

### Key IP Addresses

| Device | Tailscale IP |
|--------|--------------|
| P520 | 100.x.x.x (fill in) |
| P53 | 100.x.x.x (fill in) |
| Pixel 9 | 100.x.x.x (fill in) |

### Important Paths (P520)

| Item | Path |
|------|------|
| SSH config | `/etc/ssh/sshd_config` |
| Authorized keys | `~/.ssh/authorized_keys` |
| tmux config | `~/.tmux.conf` |
| Bash aliases | `~/.bashrc` |

---

## Setup Checklist

### P520 Workstation
- [ ] SSH server installed and running
- [ ] Tailscale installed and authenticated
- [ ] Tailscale IP noted: `____________`
- [ ] Node.js 18+ installed
- [ ] Claude Code installed and authenticated
- [ ] tmux installed and configured
- [ ] Convenience aliases added to .bashrc
- [ ] Username noted: `____________`

### P53 Laptop
- [ ] Tailscale installed and authenticated
- [ ] Warp terminal installed
- [ ] SSH key generated
- [ ] SSH key added to P520
- [ ] SSH config created
- [ ] Can connect with `ssh claude`

### Pixel 9 Phone
- [ ] Tailscale installed and authenticated
- [ ] Termux installed from F-Droid
- [ ] SSH key generated
- [ ] SSH key added to P520
- [ ] SSH config created
- [ ] Can connect with `cc` alias
- [ ] (Optional) Termux widget configured

---

## Summary

You now have a powerful, always-available Claude Code environment:

- **P520** runs 24/7 in the cupboard, maintaining your Claude sessions
- **P53** connects seamlessly via Warp when you're at your desk
- **Pixel 9** connects from anywhere via Termux

All connections are:
- Encrypted via Tailscale
- Persistent via tmux (sessions survive disconnects)
- Authenticated via SSH keys (no passwords needed)

Your Claude Code conversations and context persist across all devices and survive network interruptions. Start a conversation on your laptop, continue it on your phone, and pick it back up on your laptop - it's all the same session.
