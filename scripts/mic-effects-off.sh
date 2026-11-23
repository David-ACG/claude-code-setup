#!/bin/bash
# Turn audio effects off for one mic on a Windows laptop (or undo), from hlab.
# Usage: mic-effects-off.sh <ssh-host> <endpoint-guid> [--undo]
#   e.g. mic-effects-off.sh t14s '{01d779c7-4f98-4b78-98f7-131869cf3695}'
# The ssh login is already elevated, which is enough (see the gotcha in the .ps1).
# The first run keeps a .reg backup in C:\ProgramData\mic-effects-off.
# Restarts the Windows audio services, so sound drops for a few seconds.
set -euo pipefail
host=$1; ep=$2; undo=${3:-}
here=$(cd "$(dirname "$0")" && pwd)
flag=''; [ "$undo" = "--undo" ] && flag=' -Undo'
ssh -o BatchMode=yes "$host" "New-Item -ItemType Directory -Force 'C:\ProgramData\mic-effects-off' | Out-Null" >/dev/null
scp -o BatchMode=yes -q "$here/mic-effects-off.ps1" "$host:C:/ProgramData/mic-effects-off/mic-effects-off.ps1"
timeout 120 ssh -o BatchMode=yes "$host" \
  "powershell -NoProfile -ExecutionPolicy Bypass -File C:\ProgramData\mic-effects-off\mic-effects-off.ps1 -EndpointId '$ep'$flag"
