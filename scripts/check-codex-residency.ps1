# check-codex-residency.ps1
# Is this laptop writing Codex history locally again?
# Read-only. Run it on any laptop, any time.
# Bead: gwth-launch-jfw9
#
#   powershell -ExecutionPolicy Bypass -File P:\claude-code-setup\scripts\check-codex-residency.ps1

param(
    # Everything recovered onto the P520 on 2026-09-12. Anything newer than
    # this that is still sitting locally is fresh drift.
    [datetime]$RecoveredOn = "2026-09-12"
)

$ErrorActionPreference = "Stop"
$sessions = Join-Path $env:USERPROFILE ".codex\sessions"

Write-Host ""
Write-Host "Codex residency check on $env:COMPUTERNAME"

if (-not (Test-Path -LiteralPath $sessions)) {
    Write-Host "  No local sessions directory. This laptop is a clean thin client." -ForegroundColor Green
    exit 0
}

$all   = @(Get-ChildItem -LiteralPath $sessions -Recurse -Filter *.jsonl -ErrorAction SilentlyContinue)
$fresh = @($all | Where-Object { $_.LastWriteTime -gt $RecoveredOn })

Write-Host "  local session files       : $($all.Count)"
Write-Host "  written since $($RecoveredOn.ToString('yyyy-MM-dd')) : $($fresh.Count)"

if ($fresh.Count -eq 0) {
    Write-Host ""
    Write-Host "  No new local history. Codex is running on the P520 as intended." -ForegroundColor Green
    exit 0
}

Write-Host ""
Write-Host "  DRIFT: Codex has written $($fresh.Count) session(s) on this laptop." -ForegroundColor Yellow
Write-Host "  Those threads are invisible from every other machine."
$fresh | Sort-Object LastWriteTime -Descending | Select-Object -First 5 | ForEach-Object {
    Write-Host ("    {0}  {1}" -f $_.LastWriteTime.ToString("yyyy-MM-dd HH:mm"), $_.Name)
}
Write-Host ""
Write-Host "  Two things to do:"
Write-Host "    1. In Codex, open the P520 workspace rather than a local folder."
Write-Host "    2. Recover these first:"
Write-Host "       powershell -ExecutionPolicy Bypass -File P:\claude-code-setup\scripts\export-codex-history.ps1 -ViaDrive"
exit 1
