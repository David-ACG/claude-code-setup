$ErrorActionPreference = "Stop"

Write-Host "Codex X1EG3 repair starting..."
Write-Host "User profile: $env:USERPROFILE"

function Backup-IfExists {
    param([Parameter(Mandatory=$true)][string]$Path)

    if (Test-Path -LiteralPath $Path) {
        $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backup = "$Path.p53-sync-backup-$stamp"
        Move-Item -LiteralPath $Path -Destination $backup
        Write-Host "Backed up $Path -> $backup"
    }
}

Write-Host "`nInstalling/repairing common Codex Windows dependencies..."
$packages = @(
    "Microsoft.VCRedist.2015+.x64",
    "Microsoft.VCRedist.2015+.x86",
    "Microsoft.EdgeWebView2Runtime"
)

foreach ($pkg in $packages) {
    try {
        winget install --id $pkg --silent --accept-package-agreements --accept-source-agreements
    } catch {
        Write-Host "winget install for $pkg did not complete cleanly; continuing so local Codex state can still be repaired."
        Write-Host $_.Exception.Message
    }
}

$codexHome = Join-Path $env:USERPROFILE ".codex"
New-Item -ItemType Directory -Force -Path $codexHome | Out-Null

Write-Host "`nQuarantining P53/path-specific Codex state..."
$pathSpecific = @(
    "config.toml",
    ".codex-global-state.json",
    ".codex-global-state.json.bak",
    "auth.json",
    "cap_sid",
    "installation_id",
    "logs_2.sqlite",
    "logs_2.sqlite-shm",
    "logs_2.sqlite-wal",
    "state_5.sqlite",
    "state_5.sqlite-shm",
    "state_5.sqlite-wal",
    "models_cache.json",
    "session_index.jsonl",
    "history.jsonl",
    "sandbox.log",
    "version.json"
)

foreach ($name in $pathSpecific) {
    Backup-IfExists -Path (Join-Path $codexHome $name)
}

foreach ($dir in @(".sandbox", ".sandbox-bin", ".sandbox-secrets", ".tmp", "tmp", "cache", "browser", "log", "sqlite", "vendor_imports", "plugins")) {
    Backup-IfExists -Path (Join-Path $codexHome $dir)
}

$config = @'
model = "gpt-5.5"
model_reasoning_effort = "high"

[windows]
sandbox = "elevated"
'@

Set-Content -LiteralPath (Join-Path $codexHome "config.toml") -Value $config -Encoding UTF8
Write-Host "`nWrote fresh local config.toml for this Windows profile."

$ignorePath = Join-Path $codexHome ".stignore"
$ignore = @'
(?d).sandbox
(?d).sandbox-bin
(?d).sandbox-secrets
(?d).tmp
(?d)tmp
(?d)cache
(?d)browser
(?d)log
(?d)sqlite
(?d)vendor_imports
(?d)plugins
(?d)skills/.system

config.toml
auth.json
cap_sid
installation_id
*.sqlite
*.sqlite-shm
*.sqlite-wal
logs_*.sqlite*
state_*.sqlite*
models_cache.json
session_index.jsonl
history.jsonl
sandbox.log
version.json
.codex-global-state.json
.codex-global-state.json.bak
'@

Set-Content -LiteralPath $ignorePath -Value $ignore -Encoding UTF8
Write-Host "Wrote .stignore to keep machine-local Codex state from syncing."

Write-Host "`nDone. Restart Windows once, then open Codex again."
