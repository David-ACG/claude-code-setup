$ErrorActionPreference = "Stop"

$p53DeviceId = "QEJVAE4-B2UF64N-3YI57TO-3IRALFA-NMD6MKH-TW3ULFR-VYYXYXS-ZUK57AD"
$codexPath = Join-Path $env:USERPROFILE ".codex"
$agentsPath = Join-Path $env:USERPROFILE ".agents"

function Get-SyncthingApi {
    $configPath = Join-Path $env:LOCALAPPDATA "Syncthing\config.xml"
    if (-not (Test-Path -LiteralPath $configPath)) {
        throw "Syncthing config not found at $configPath. Start SyncTrayzor/Syncthing once, then rerun this script."
    }

    $apiKey = (Select-Xml -Path $configPath -XPath "//gui/apikey").Node.InnerText
    $configuredAddress = (Select-Xml -Path $configPath -XPath "//gui/address").Node.InnerText
    $candidates = @()
    if ($configuredAddress) { $candidates += "http://$configuredAddress" }
    $candidates += @("http://127.0.0.1:8384", "http://localhost:8384")

    foreach ($base in ($candidates | Select-Object -Unique)) {
        try {
            $status = Invoke-RestMethod -Uri "$base/rest/system/status" -Headers @{ "X-API-Key" = $apiKey } -TimeoutSec 5
            return @{
                Base = $base
                ApiKey = $apiKey
                MyId = $status.myID
            }
        } catch {
            Write-Host "Could not reach Syncthing API at $base"
        }
    }

    throw "Syncthing API is not reachable. Start SyncTrayzor/Syncthing and rerun this script."
}

function Write-CodexIgnore {
    New-Item -ItemType Directory -Force -Path $codexPath | Out-Null
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
(?d)avatars
(?d)sessions
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
transcription-history.jsonl
sandbox.log
version.json
.codex-global-state.json
.codex-global-state.json.bak
.personality_migration
'@
    Set-Content -LiteralPath (Join-Path $codexPath ".stignore") -Value $ignore -Encoding UTF8
}

function New-SyncFolder {
    param(
        [Parameter(Mandatory=$true)][string]$Id,
        [Parameter(Mandatory=$true)][string]$Label,
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$MyId
    )

    return @{
        id = $Id
        label = $Label
        filesystemType = "basic"
        path = $Path
        type = "sendreceive"
        devices = @(
            @{ deviceID = $p53DeviceId; introducedBy = ""; encryptionPassword = "" },
            @{ deviceID = $MyId; introducedBy = ""; encryptionPassword = "" }
        )
        rescanIntervalS = 3600
        fsWatcherEnabled = $true
        fsWatcherDelayS = 10
        fsWatcherTimeoutS = 0
        ignorePerms = $false
        autoNormalize = $true
        minDiskFree = @{ value = 1; unit = "%" }
        versioning = @{
            type = "staggered"
            params = @{ cleanInterval = "3600"; maxAge = "2592000" }
            cleanupIntervalS = 3600
            fsPath = ""
            fsType = "basic"
        }
        copiers = 0
        pullerMaxPendingKiB = 0
        hashers = 0
        order = "random"
        ignoreDelete = $false
        scanProgressIntervalS = 0
        pullerPauseS = 0
        pullerDelayS = 1
        maxConflicts = 10
        disableSparseFiles = $false
        paused = $false
        markerName = ".stfolder"
        copyOwnershipFromParent = $false
        modTimeWindowS = 0
        maxConcurrentWrites = 16
        disableFsync = $false
        blockPullOrder = "standard"
        copyRangeMethod = "standard"
        caseSensitiveFS = $false
        junctionsAsDirs = $false
        syncOwnership = $false
        sendOwnership = $false
        syncXattrs = $false
        sendXattrs = $false
        xattrFilter = @{ entries = @(); maxSingleEntrySize = 1024; maxTotalSize = 4096 }
    }
}

Write-Host "Accepting Codex portable sync on X1EG3..."
Write-Host "Target Codex path: $codexPath"
Write-Host "Target agents path: $agentsPath"

New-Item -ItemType Directory -Force -Path $codexPath,$agentsPath | Out-Null
Write-CodexIgnore

$api = Get-SyncthingApi
$headers = @{ "X-API-Key" = $api.ApiKey; "Content-Type" = "application/json" }
$config = Invoke-RestMethod -Uri "$($api.Base)/rest/config" -Headers @{ "X-API-Key" = $api.ApiKey }
$existing = @($config.folders | ForEach-Object { $_.id })

$folders = @(
    (New-SyncFolder -Id "codex-config-sync" -Label "Codex Portable Config" -Path $codexPath -MyId $api.MyId),
    (New-SyncFolder -Id "agents-config-sync" -Label "Agent Skills" -Path $agentsPath -MyId $api.MyId)
)

foreach ($folder in $folders) {
    if ($existing -contains $folder.id) {
        Write-Host "Folder already exists: $($folder.id)"
    } else {
        Invoke-RestMethod -Uri "$($api.Base)/rest/config/folders" -Headers $headers -Method Post -Body ($folder | ConvertTo-Json -Depth 20) | Out-Null
        Write-Host "Added folder: $($folder.id) -> $($folder.path)"
    }
}

Invoke-RestMethod -Uri "$($api.Base)/rest/db/scan" -Headers @{ "X-API-Key" = $api.ApiKey } -Method Post | Out-Null

Write-Host "Done. Syncthing should now sync portable Codex config and agent skills."
