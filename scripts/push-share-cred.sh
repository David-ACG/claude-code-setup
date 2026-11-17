#!/bin/bash
# Installs the hlab Samba share password (kept in ~/.config/samba/p520-share-password, mode 600,
# never committed) into a Windows laptop's own credential vault, then remaps P:.
# cmdkey must run in the user's interactive logon, so share-cred-install.ps1 runs
# share-cred-user.ps1 as a one-shot scheduled task. The temp password file is deleted.
# Usage: push-share-cred.sh <ssh-host>   (laptop needs SSH-from-hlab + windows-map-p-drive.ps1)
set -euo pipefail
host=$1; here=$(cd "$(dirname "$0")" && pwd); D='C:/Users/ducce/AppData/Local/p520-map'
ssh -o BatchMode=yes "$host" "powershell -NoProfile -Command \"New-Item -ItemType Directory -Force \$env:LOCALAPPDATA\\p520-map | Out-Null\""
scp -q -o BatchMode=yes ~/.config/samba/p520-share-password "$host:$D/cred.tmp"
scp -q -o BatchMode=yes "$here/share-cred-user.ps1" "$host:$D/share-cred-user.ps1"
timeout 100 bash "$here/win-run.sh" "$host" "$here/share-cred-install.ps1" 90 || true
ssh -o BatchMode=yes "$host" "powershell -NoProfile -Command \"Remove-Item \$env:LOCALAPPDATA\\p520-map\\cred.tmp,\$env:LOCALAPPDATA\\p520-map\\share-cred-user.ps1 -Force -ErrorAction SilentlyContinue; Unregister-ScheduledTask p520-cred-once -Confirm:\$false -ErrorAction SilentlyContinue; Get-Content \$env:LOCALAPPDATA\\p520-map\\cred-install.log -Tail 4\""
