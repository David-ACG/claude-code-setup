# export-codex-history.ps1
# Copies this laptop's Codex interactive history to the P520 (hlab) for merging.
# READ ONLY on this machine: it never moves, deletes or edits anything in .codex.
# Bead: gwth-launch-jfw9
#
#   powershell -ExecutionPolicy Bypass -File .\export-codex-history.ps1
#   powershell -ExecutionPolicy Bypass -File .\export-codex-history.ps1 -CountOnly

param(
    [string]$RemoteHost = "hlab",
    [string]$RemoteDir  = "/home/david/codex-history-import",
    [string]$DrivePath  = "P:\codex-history-import",
    [switch]$ViaDrive,
    [switch]$CountOnly
)

$ErrorActionPreference = "Stop"

$codex    = Join-Path $env:USERPROFILE ".codex"
$sessions = Join-Path $codex "sessions"
$archived = Join-Path $codex "archived_sessions"

if (-not (Test-Path -LiteralPath $sessions)) {
    Write-Host "No sessions directory at $sessions."
    Write-Host "Nothing is stranded on this laptop: it was already using the P520."
    exit 0
}

$files = @(Get-ChildItem -LiteralPath $sessions -Recurse -Filter *.jsonl -ErrorAction SilentlyContinue)
$archFiles = @()
if (Test-Path -LiteralPath $archived) {
    $archFiles = @(Get-ChildItem -LiteralPath $archived -Recurse -Filter *.jsonl -ErrorAction SilentlyContinue)
}
$totalMb = [math]::Round((($files + $archFiles) | Measure-Object -Property Length -Sum).Sum / 1MB, 1)

Write-Host ""
Write-Host "Codex history on $env:COMPUTERNAME"
Write-Host "  sessions          : $($files.Count) files"
Write-Host "  archived_sessions : $($archFiles.Count) files"
Write-Host "  total size        : $totalMb MB"
if ($files.Count -gt 0) {
    $oldest = ($files | Sort-Object LastWriteTime | Select-Object -First 1).LastWriteTime
    $newest = ($files | Sort-Object LastWriteTime | Select-Object -Last 1).LastWriteTime
    Write-Host "  date range        : $($oldest.ToString('yyyy-MM-dd')) to $($newest.ToString('yyyy-MM-dd'))"
}
Write-Host ""

if ($CountOnly) { exit 0 }
if ($files.Count -eq 0 -and $archFiles.Count -eq 0) {
    Write-Host "Nothing to export."
    exit 0
}

$stamp   = Get-Date -Format "yyyyMMdd-HHmmss"
$name    = "codex-history-$($env:COMPUTERNAME.ToLower())-$stamp"
$staging = Join-Path $env:TEMP $name
$zip     = Join-Path $env:TEMP "$name.zip"

Write-Host "Staging a copy (originals are not touched)..."
New-Item -ItemType Directory -Path $staging -Force | Out-Null
Copy-Item -LiteralPath $sessions -Destination (Join-Path $staging "sessions") -Recurse -Force
if (Test-Path -LiteralPath $archived) {
    Copy-Item -LiteralPath $archived -Destination (Join-Path $staging "archived_sessions") -Recurse -Force
}
foreach ($extra in @("session_index.jsonl", "installation_id")) {
    $p = Join-Path $codex $extra
    if (Test-Path -LiteralPath $p) { Copy-Item -LiteralPath $p -Destination $staging -Force }
}
"$env:COMPUTERNAME`n$(Get-Date -Format o)" | Set-Content -Path (Join-Path $staging "ORIGIN.txt")

Write-Host "Compressing to $zip ..."
if (Test-Path -LiteralPath $zip) { Remove-Item -LiteralPath $zip -Force }
Compress-Archive -Path (Join-Path $staging "*") -DestinationPath $zip -CompressionLevel Optimal

$zipMb = [math]::Round((Get-Item -LiteralPath $zip).Length / 1MB, 1)
Write-Host "Archive is $zipMb MB."

if ($ViaDrive) {
    # Fallback for laptops where ssh to the P520 does not work. The mapped
    # drive reaches the same machine over Samba, so nothing else changes.
    Write-Host "Copying over the mapped drive to $DrivePath ..."
    if (-not (Test-Path -LiteralPath $DrivePath)) {
        New-Item -ItemType Directory -Path $DrivePath -Force | Out-Null
    }
    Copy-Item -LiteralPath $zip -Destination $DrivePath -Force
} else {
    Write-Host "Copying to ${RemoteHost}:${RemoteDir} ..."
    ssh $RemoteHost "mkdir -p '$RemoteDir'"
    if ($LASTEXITCODE -ne 0) {
        throw "ssh to $RemoteHost failed. Re-run with -ViaDrive to use the mapped drive instead."
    }
    scp $zip "${RemoteHost}:${RemoteDir}/"
    if ($LASTEXITCODE -ne 0) {
        throw "scp to $RemoteHost failed. Re-run with -ViaDrive to use the mapped drive instead."
    }
}

Remove-Item -LiteralPath $staging -Recurse -Force
Write-Host ""
Write-Host "Done. Uploaded $name.zip"
Write-Host "Nothing on this laptop was changed. Tell Claude on the P520 that the upload is there."
