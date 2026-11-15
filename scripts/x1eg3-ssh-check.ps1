<#
.SYNOPSIS
  Read-only: why can't hlab reach sshd on x1eg3? Writes a report to
  P:\_slow-reports (UNC fallback) for Claude to read. Changes nothing.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File \\hlab.taila51191.ts.net\P520Projects\claude-code-setup\scripts\x1eg3-ssh-check.ps1
#>
$ErrorActionPreference = 'Continue'
$out = New-Object System.Text.StringBuilder
function Sec($t, [scriptblock]$b) {
    [void]$out.AppendLine("`n===== $t =====")
    try { [void]$out.AppendLine(((& $b) | Out-String -Width 200).TrimEnd()) } catch { [void]$out.AppendLine("ERROR: $($_.Exception.Message)") }
}
$ts = 'C:\Program Files\Tailscale\tailscale.exe'

Sec 'whoami / elevated' { whoami; ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) }
Sec 'sshd service' { Get-Service sshd | Format-List Name,Status,StartType }
Sec 'listening on :22' { netstat -ano | Select-String ':22\s' }
Sec 'local connect 127.0.0.1:22' { Test-NetConnection 127.0.0.1 -Port 22 -WarningAction SilentlyContinue | Format-List TcpTestSucceeded }
Sec 'local connect tailscale IP:22' { Test-NetConnection 100.114.161.65 -Port 22 -WarningAction SilentlyContinue | Format-List TcpTestSucceeded }
Sec 'tailscale prefs (ShieldsUp etc.)' { & $ts debug prefs | Select-String 'ShieldsUp|RunSSH|WantRunning|CorpDNS' }
Sec 'tailscale status (self + hlab)' { & $ts status | Select-String 'x1eg3|hlab' }
Sec 'network profiles per interface' { Get-NetConnectionProfile | Format-Table InterfaceAlias,NetworkCategory,IPv4Connectivity -AutoSize }
Sec 'firewall profiles' { Get-NetFirewallProfile | Format-Table Name,Enabled,DefaultInboundAction,AllowInboundRules,AllowLocalFirewallRules -AutoSize }
Sec 'firewall profiles from Group Policy' { Get-NetFirewallProfile -PolicyStore ActiveStore | Format-Table Name,Enabled,DefaultInboundAction,AllowInboundRules,AllowLocalFirewallRules -AutoSize }
Sec 'our ssh rule' {
    $r = Get-NetFirewallRule -Name 'OpenSSH-hlab-Tailscale-only'
    $r | Format-List Name,Enabled,Direction,Action,Profile,PrimaryStatus,EnforcementStatus
    $r | Get-NetFirewallAddressFilter | Format-List RemoteAddress,LocalAddress
    $r | Get-NetFirewallPortFilter | Format-List Protocol,LocalPort
    $r | Get-NetFirewallInterfaceFilter | Format-List InterfaceAlias
}
Sec 'any rules touching port 22' { Get-NetFirewallPortFilter | Where-Object LocalPort -eq '22' | Get-NetFirewallRule | Format-Table Name,Enabled,Direction,Action,Profile -AutoSize }
Sec 'block rules for Tailscale / inbound blocks (first 30)' { Get-NetFirewallRule -Direction Inbound -Action Block -Enabled True | Select-Object -First 30 | Format-Table Name,DisplayName,Profile -AutoSize }
Sec 'third-party firewall / AV products' {
    Get-CimInstance -Namespace root/SecurityCenter2 -ClassName FirewallProduct -ErrorAction SilentlyContinue | Select-Object displayName
    Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct -ErrorAction SilentlyContinue | Select-Object displayName
}
Sec 'sshd_config (non-comment lines)' { Get-Content "$env:ProgramData\ssh\sshd_config" | Where-Object { $_ -and $_ -notmatch '^\s*#' } }
Sec 'OpenSSH log, last 15 events' { Get-WinEvent -LogName 'OpenSSH/Operational' -MaxEvents 15 -ErrorAction SilentlyContinue | Format-Table TimeCreated,Id,Message -AutoSize -Wrap }

$name = "x1eg3-ssh-check-$(Get-Date -Format 'yyyy-MM-dd_HHmmss').txt"
foreach ($d in @('P:\_slow-reports', '\\hlab.taila51191.ts.net\P520Projects\_slow-reports', (Join-Path $env:USERPROFILE 'Desktop'))) {
    try { $out.ToString() | Set-Content -Path (Join-Path $d $name) -Encoding UTF8 -ErrorAction Stop; Write-Host "Report: $(Join-Path $d $name)"; Write-Host 'Tell Claude "done".'; break } catch {}
}
