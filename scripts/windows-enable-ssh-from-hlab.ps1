<#
.SYNOPSIS
  Lets hlab (and only hlab) SSH into this Windows laptop, so Claude can manage it
  directly. Generic version of x1eg3-enable-ssh.ps1 (used for david-t14s, 2026-11-16).

.DESCRIPTION
  - Installs Windows OpenSSH Server (Windows optional feature; winget fallback).
  - Key-only: password logins are turned off. The only key allowed is hlab's
    ~/.ssh/id_ed25519.
  - Firewall: port 22 answers ONLY hlab's Tailscale address (100.79.248.39).
    Microsoft's default "allow from anywhere" rule is disabled.
  - Default SSH shell = Windows PowerShell.
  - Writes a log next to this script's report folder so Claude can read it.

  -Remove undoes it: stops and disables sshd, deletes the firewall rule and
  hlab's key. (The OpenSSH feature itself stays installed but switched off.)

.EXAMPLE
  # From an ADMIN PowerShell (elevated sessions can't see P:, so use the UNC path):
  powershell -ExecutionPolicy Bypass -File \\hlab.taila51191.ts.net\P520Projects\claude-code-setup\scripts\windows-enable-ssh-from-hlab.ps1
  powershell -ExecutionPolicy Bypass -File \\hlab.taila51191.ts.net\P520Projects\claude-code-setup\scripts\windows-enable-ssh-from-hlab.ps1 -Remove
#>

[CmdletBinding()]
param([switch]$Remove)

$ErrorActionPreference = 'Stop'
$HlabKey   = 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL61z6ZYm6u9z+JKGrcMuRqsz1wutLGHPCrCrPTkwQsk hlab-claude'
$HlabKeyId = 'AAAAC3NzaC1lZDI1NTE5AAAAIL61z6ZYm6u9z+JKGrcMuRqsz1wutLGHPCrCrPTkwQsk'
$HlabIp    = '100.79.248.39'
$RuleName  = 'OpenSSH-hlab-Tailscale-only'
$SshDir    = Join-Path $env:ProgramData 'ssh'
$AdminKeys = Join-Path $SshDir 'administrators_authorized_keys'
$Config    = Join-Path $SshDir 'sshd_config'
$LogDir    = '\\hlab.taila51191.ts.net\P520Projects\_slow-reports'

$log = New-Object System.Collections.Generic.List[string]
function Say($m) { Write-Host $m; $log.Add("$(Get-Date -Format 'HH:mm:ss') $m") }
function Save-Log {
    $name = "$($env:COMPUTERNAME.ToLower())-ssh-setup-$(Get-Date -Format 'yyyy-MM-dd_HHmmss').txt"
    foreach ($d in @($LogDir, (Join-Path $env:PUBLIC 'Desktop'))) {
        try { $log | Set-Content -Path (Join-Path $d $name) -Encoding UTF8; Write-Host "Log: $(Join-Path $d $name)"; return } catch {}
    }
}

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) { Write-Host 'Run this from an ADMIN PowerShell (right-click > Run as administrator).' -ForegroundColor Red; exit 1 }

try {
    if ($Remove) {
        Say 'Removing SSH access for hlab...'
        if (Get-Service sshd -ErrorAction SilentlyContinue) {
            Stop-Service sshd -Force -ErrorAction SilentlyContinue
            Set-Service sshd -StartupType Disabled
            Say 'sshd stopped and disabled.'
        }
        Get-NetFirewallRule -Name $RuleName -ErrorAction SilentlyContinue | Remove-NetFirewallRule
        Say "Firewall rule $RuleName removed."
        if (Test-Path $AdminKeys) {
            $keep = Get-Content $AdminKeys | Where-Object { $_ -notmatch [regex]::Escape($HlabKeyId) }
            Set-Content -Path $AdminKeys -Value $keep -Encoding ascii
            Say 'hlab key removed from administrators_authorized_keys.'
        }
        Say 'DONE: SSH access removed.'
        Save-Log; exit 0
    }

    # 1. Install OpenSSH Server
    if (-not (Get-Service sshd -ErrorAction SilentlyContinue)) {
        Say 'Installing OpenSSH Server (Windows optional feature, can take a few minutes)...'
        try {
            Add-WindowsCapability -Online -Name 'OpenSSH.Server~~~~0.0.1.0' | Out-Null
        } catch {
            Say "Optional feature failed ($($_.Exception.Message)); trying winget Microsoft.OpenSSH.Preview..."
            winget install --id Microsoft.OpenSSH.Preview -e --accept-source-agreements --accept-package-agreements --silent
        }
        if (-not (Get-Service sshd -ErrorAction SilentlyContinue)) { throw 'OpenSSH Server did not install.' }
    }
    Say 'OpenSSH Server is installed.'

    # 2. First start creates host keys and the default sshd_config
    Set-Service sshd -StartupType Automatic
    Start-Service sshd
    Start-Sleep -Seconds 2

    # 3. Key-only login, PowerShell as the shell
    $cfg = Get-Content $Config
    $cfg = $cfg | Where-Object { $_ -notmatch '^\s*#?\s*(PasswordAuthentication|PubkeyAuthentication|KbdInteractiveAuthentication)\b' }
    # settings must come before any Match block
    $matchAt = ($cfg | Select-String -Pattern '^\s*Match\s' | Select-Object -First 1).LineNumber
    $add = @('PubkeyAuthentication yes', 'PasswordAuthentication no', 'KbdInteractiveAuthentication no')
    if ($matchAt) { $cfg = @($cfg[0..($matchAt - 2)]) + $add + @($cfg[($matchAt - 1)..($cfg.Count - 1)]) }
    else { $cfg = @($cfg) + $add }
    if (-not ($cfg | Select-String -Pattern '^\s*Match Group administrators')) {
        $cfg += @('Match Group administrators', '       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys')
    }
    Set-Content -Path $Config -Value $cfg -Encoding ascii
    Say 'sshd_config: key-only login (passwords off).'
    New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -Force -PropertyType String `
        -Value "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" | Out-Null
    Say 'Default shell: Windows PowerShell.'

    # 4. hlab's key (admins use administrators_authorized_keys; ACL must be SYSTEM + Administrators only)
    $existing = if (Test-Path $AdminKeys) { Get-Content $AdminKeys } else { @() }
    if (-not ($existing | Select-String -SimpleMatch $HlabKeyId)) { Add-Content -Path $AdminKeys -Value $HlabKey -Encoding ascii }
    icacls.exe $AdminKeys /inheritance:r /grant '*S-1-5-32-544:F' /grant '*S-1-5-18:F' | Out-Null
    Say 'hlab key installed (administrators_authorized_keys, locked to SYSTEM + Administrators).'
    # non-admin fallback, in case this account is not an administrator
    $userSsh = Join-Path $env:USERPROFILE '.ssh'
    New-Item -ItemType Directory -Path $userSsh -Force | Out-Null
    $userKeys = Join-Path $userSsh 'authorized_keys'
    $ue = if (Test-Path $userKeys) { Get-Content $userKeys } else { @() }
    if (-not ($ue | Select-String -SimpleMatch $HlabKeyId)) { Add-Content -Path $userKeys -Value $HlabKey -Encoding ascii }

    # 5. Firewall: hlab's Tailscale IP only
    Get-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -ErrorAction SilentlyContinue | Disable-NetFirewallRule
    Get-NetFirewallRule -Name $RuleName -ErrorAction SilentlyContinue | Remove-NetFirewallRule
    New-NetFirewallRule -Name $RuleName -DisplayName 'OpenSSH Server (hlab over Tailscale only)' `
        -Direction Inbound -Protocol TCP -LocalPort 22 -RemoteAddress $HlabIp -Action Allow -Profile Any | Out-Null
    Say "Firewall: port 22 open to $HlabIp only; the default allow-anywhere rule is disabled."

    # 6. Apply
    Restart-Service sshd
    $svc = Get-Service sshd
    Say "sshd: $($svc.Status), start type $($svc.StartType). User: $env:USERNAME. Admin group: $isAdmin."
    Say 'DONE: tell Claude "ssh ready".'
} catch {
    Say "FAILED: $($_.Exception.Message)"
}
Save-Log
