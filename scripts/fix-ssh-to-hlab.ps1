# fix-ssh-to-hlab.ps1
# Make 'ssh hlab' work from this laptop. Bead: gwth-launch-ok90
#
# Three faults seen on X1EG3 2026-09-12: ssh connected as the Windows user
# 'ducce' rather than 'david', no key existed under any default name, and no
# ssh-agent was running. It fell through to password auth for an account that
# does not exist on hlab, so the server closed the connection.
#
#   powershell -ExecutionPolicy Bypass -File P:\claude-code-setup\scripts\fix-ssh-to-hlab.ps1

param(
    [string]$RemoteUser = "david",
    [string]$TailscaleHost = "100.79.248.39",
    [string]$LanHost = "192.168.178.50"
)

$ErrorActionPreference = "Stop"
$sshDir = Join-Path $env:USERPROFILE ".ssh"
$config = Join-Path $sshDir "config"

if (-not (Test-Path -LiteralPath $sshDir)) { New-Item -ItemType Directory -Path $sshDir -Force | Out-Null }

Write-Host ""
Write-Host "Looking for an existing private key..."
$keys = @(Get-ChildItem -LiteralPath $sshDir -File -ErrorAction SilentlyContinue |
          Where-Object { $_.Extension -ne ".pub" -and $_.Name -notin @("config","known_hosts","known_hosts2","authorized_keys") } |
          Where-Object { (Get-Content -LiteralPath $_.FullName -TotalCount 1 -ErrorAction SilentlyContinue) -match "PRIVATE KEY" })

foreach ($k in $keys) { Write-Host "  found: $($k.Name)" }

# hlab already trusts a key commented ducce@x1eg3-id_ed25519_p520, so prefer
# that filename if it is still here.
$key = $keys | Where-Object { $_.Name -eq "id_ed25519_p520" } | Select-Object -First 1
if (-not $key) { $key = $keys | Where-Object { $_.Name -like "*p520*" } | Select-Object -First 1 }
if (-not $key) { $key = $keys | Select-Object -First 1 }

$newKey = $false
if (-not $key) {
    Write-Host "  none found. Generating a new one (no passphrase, for unattended use)..."
    $path = Join-Path $sshDir "id_ed25519_p520"
    ssh-keygen -t ed25519 -f $path -N '""' -C "$env:USERNAME@$($env:COMPUTERNAME.ToLower())-p520" | Out-Null
    $key = Get-Item -LiteralPath $path
    $newKey = $true
}
Write-Host "  using: $($key.FullName)"

$block = @"

# BEGIN P520 (managed by fix-ssh-to-hlab.ps1)
Host hlab p520
    HostName $TailscaleHost
    User $RemoteUser
    IdentityFile $($key.FullName)
    IdentitiesOnly yes
    ServerAliveInterval 30

Host hlab-lan
    HostName $LanHost
    User $RemoteUser
    IdentityFile $($key.FullName)
    IdentitiesOnly yes
# END P520
"@

$existing = ""
if (Test-Path -LiteralPath $config) { $existing = Get-Content -LiteralPath $config -Raw }
if ($existing -match "(?s)# BEGIN P520.*?# END P520") {
    Write-Host "Updating the existing P520 block in $config"
    $existing = [regex]::Replace($existing, "(?s)\r?\n?# BEGIN P520.*?# END P520\r?\n?", "")
    Set-Content -LiteralPath $config -Value ($existing.TrimEnd() + "`r`n" + $block) -NoNewline
} else {
    Write-Host "Adding a P520 block to $config"
    Add-Content -LiteralPath $config -Value $block
}

if ($newKey) {
    Write-Host ""
    Write-Host "A NEW key was generated, so hlab does not trust it yet." -ForegroundColor Yellow
    Write-Host "Send this single line to Claude on the P520 and it will install it:" -ForegroundColor Yellow
    Write-Host ""
    Get-Content -LiteralPath "$($key.FullName).pub"
    Write-Host ""
    exit 2
}

Write-Host ""
Write-Host "Testing 'ssh hlab'..."
$out = ssh -o BatchMode=yes -o ConnectTimeout=10 hlab "hostname; whoami" 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  OK: $out" -ForegroundColor Green
    Write-Host ""
    Write-Host "ssh, scp and the export scripts now work from this laptop."
    exit 0
}
Write-Host "  Still failing:" -ForegroundColor Yellow
Write-Host "  $out"
Write-Host ""
Write-Host "The key on this laptop is probably not the one hlab trusts. Send this"
Write-Host "line to Claude on the P520 and it will install it:" -ForegroundColor Yellow
Write-Host ""
Get-Content -LiteralPath "$($key.FullName).pub" -ErrorAction SilentlyContinue
exit 1
