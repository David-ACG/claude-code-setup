#!/bin/bash
# Run a local PowerShell script on x1eg3 over SSH (from hlab).
# Multi-line safe: piping to `powershell -Command -` breaks on blocks that span lines,
# so the script is sent as -EncodedCommand (UTF-16LE base64).
# Usage: scripts/x1eg3-run.sh check.ps1 [timeout_seconds]
# Access: Windows OpenSSH, key-only, firewall + Tailscale grant allow hlab (tag:pbs) -> x1eg3:22 only.
set -euo pipefail
# Silence progress records, which arrive as CLIXML noise on stderr.
enc=$( { echo "\$ProgressPreference='SilentlyContinue'"; cat "$1"; } | iconv -f utf-8 -t utf-16le | base64 -w0)
timeout "${2:-90}" ssh -o BatchMode=yes x1eg3 "powershell -NoProfile -EncodedCommand $enc"
