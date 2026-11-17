#!/bin/bash
# Run a local PowerShell script on a Windows host over SSH (hlab -> laptop).
# Usage: win-run.sh <ssh-host> <script.ps1> [timeout-seconds]
set -euo pipefail
host=$1; script=$2; t=${3:-90}
# Silence progress records, which arrive as CLIXML noise on stderr.
enc=$( { echo "\$ProgressPreference='SilentlyContinue'"; cat "$script"; } | iconv -f utf-8 -t utf-16le | base64 -w0)
timeout "$t" ssh -o BatchMode=yes "$host" "powershell -NoProfile -EncodedCommand $enc"
