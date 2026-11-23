# Runs on a laptop as a one-shot SYSTEM scheduled task (ClaudeSidebarSync),
# registered by sync.py --apply. Waits until the Claude desktop app is fully
# quit, merges the staged sidebar entries with agent.js, optionally reopens
# Claude, then removes its own task. Log: <stage>\waiter.log
param([string]$Stage, [string]$AgentDir, [switch]$Relaunch)
$ErrorActionPreference = 'Continue'
$log = Join-Path $Stage 'waiter.log'
function Log($m) { "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $m" | Add-Content -LiteralPath $log }

# The desktop app only: the Store build lives under WindowsApps\Claude_*, the
# standard build under AnthropicClaude\. The Claude Code CLI is not matched.
function AppRunning {
  $p = Get-CimInstance Win32_Process -Filter "Name='claude.exe'" -ErrorAction SilentlyContinue |
       Where-Object { $_.ExecutablePath -match '\\AnthropicClaude\\|\\WindowsApps\\Claude_' }
  return @($p).Count -gt 0
}

Log "waiter started (stage $Stage, relaunch=$Relaunch)"
if (Test-Path (Join-Path $Stage 'result.json')) {
  Log 'already applied; removing task'
  Unregister-ScheduledTask -TaskName 'ClaudeSidebarSync' -Confirm:$false -ErrorAction SilentlyContinue
  exit 0
}
$wasRunning = AppRunning
if ($wasRunning) { Log 'Claude is open: waiting for it to be quit' }
do {
  while (AppRunning) { Start-Sleep -Seconds 2 }
  Start-Sleep -Seconds 3          # let the app finish writing its files
} while (AppRunning)

Log 'Claude is closed: applying'
$out = & 'C:\Program Files\nodejs\node.exe' (Join-Path $AgentDir 'agent.js') apply $Stage 2>&1
$code = $LASTEXITCODE
foreach ($line in $out) { Log "  $line" }
Log "apply exit code $code"

if ($Relaunch -and $wasRunning) {
  Start-ScheduledTask -TaskName 'ClaudeSidebarSync-Relaunch' -ErrorAction SilentlyContinue
  Log 'reopened Claude'
}
# Log first: removing its own task can end this process, and a shutdown can
# cut it off here. Either way the startup trigger finds result.json and tidies up.
Log 'done; removing task'
Unregister-ScheduledTask -TaskName 'ClaudeSidebarSync' -Confirm:$false -ErrorAction SilentlyContinue
