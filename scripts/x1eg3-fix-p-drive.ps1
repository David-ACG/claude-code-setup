<#
.SYNOPSIS
  Permanent fix for the P: -> \\hlab\P520Projects mapped drive on x1eg3.

.DESCRIPTION
  Fixes three separate faults that together cause:
    - "An error occurred while reconnecting P: ... network path was not found"
    - a slow / hanging boot ("Restoring Network Connections")
    - the saved password being forgotten on every reboot

  1. Credential amnesia: clears the LSA policy that blocks Windows from
     persisting network credentials, then stores the Samba credential
     permanently for the hostname, FQDN AND IP (Windows keys them separately).
  2. Boot race: Windows restores persistent drive mappings before the
     Tailscale tunnel exists, so the mapping always fails and blocks logon.
     We drop the persistent mapping and turn off logon restore entirely.
  3. Replacement: a per-user scheduled task maps P: *after* Tailscale is up,
     retries on failure, and re-checks every 5 minutes so a Tailscale drop
     self-heals instead of leaving a dead drive letter.

  Idempotent - safe to re-run.

.NOTES
  Run in an ELEVATED PowerShell as David:
      powershell -ExecutionPolicy Bypass -File .\x1eg3-fix-p-drive.ps1
#>

[CmdletBinding()]
param(
    [string]$DriveLetter = 'P',
    [string]$Share       = 'P520Projects',
    [string]$HostShort   = 'hlab',
    [string]$HostFqdn    = 'hlab.taila51191.ts.net',
    [string]$HostIp      = '100.79.248.39',
    [string]$SambaUser   = 'david',
    # Re-run only the scheduled-task step (skips the password prompt).
    [switch]$TaskOnly
)

$ErrorActionPreference = 'Stop'
$Drive = "${DriveLetter}:"

function Say([string]$m, [string]$c = 'Gray') { Write-Host $m -ForegroundColor $c }
function Head([string]$m) { Write-Host ""; Write-Host "== $m" -ForegroundColor Cyan }

# --- 0. must be elevated ------------------------------------------------------
$isAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Say "This must run in an ELEVATED PowerShell (right-click > Run as administrator)." Red
    exit 1
}
Say "Running as $env:USERNAME (elevated)." Green

# The Windows account and the Samba account are deliberately different things:
# the drive letter and credential vault belong to the Windows user ($env:USERNAME,
# e.g. 'ducce'), while the share authenticates as $SambaUser ('david'). Only a UAC
# prompt that switched to a DIFFERENT Windows profile is a problem - that would
# put the mapping somewhere David never sees.
Say "  Windows profile receiving the mapping : $env:USERDOMAIN\$env:USERNAME"
Say "  Samba account used to authenticate    : $SambaUser"
if ($env:USERNAME -in @('Administrator', 'Admin', 'DefaultAccount')) {
    Say ""
    Say "WARNING: '$env:USERNAME' looks like a separate admin account, not David's" Yellow
    Say "everyday profile. Drive letters are per-profile, so P: would appear only" Yellow
    Say "here. Re-run from David's own account and elevate when prompted." Yellow
    $go = Read-Host "  Continue anyway? (y/N)"
    if ($go -ne 'y') { exit 1 }
}

# Steps 1-4 are the one-time system fixes. -TaskOnly skips them so a failed
# task registration can be retried without re-entering the password.
if ($TaskOnly) { Say ""; Say "-TaskOnly: skipping steps 1-4 (system fixes already applied)." Yellow }

if (-not $TaskOnly) {

# --- 1. make Tailscale come up at boot, not at login -------------------------
Head "1/6  Ensuring Tailscale connects before login"

# Without --unattended, Tailscale only connects AFTER a user logs in. The drive
# mapping would then race the tunnel on every single boot, no matter what else
# we fix. This is the difference between "works" and "works permanently".
$ts = @(
    "$env:ProgramFiles\Tailscale\tailscale.exe",
    "${env:ProgramFiles(x86)}\Tailscale\tailscale.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if ($ts) {
    try {
        & $ts set --unattended=true 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) { Say "  Tailscale set to run unattended (connects at boot)." Green }
        else { & $ts up --unattended 2>&1 | Out-Null; Say "  Tailscale unattended mode requested via 'up'." Green }
    } catch {
        Say "  Could not set unattended mode: $($_.Exception.Message)" Yellow
        Say "  Set it by hand: Tailscale tray icon > Preferences > Run unattended." Yellow
    }
} else {
    Say "  tailscale.exe not found - enable 'Run unattended' from the tray icon." Yellow
}

# --- 2. stop the credential amnesia ------------------------------------------
Head "2/6  Allowing Windows to remember network credentials"

# DisableDomainCreds=1 makes Credential Manager drop saved network logons on
# reboot. This is the single most likely cause of "it forgets the password".
$lsa = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
$ddc = (Get-ItemProperty -Path $lsa -Name DisableDomainCreds -ErrorAction SilentlyContinue).DisableDomainCreds
if ($ddc -eq 1) {
    Set-ItemProperty -Path $lsa -Name DisableDomainCreds -Value 0 -Type DWord
    Say "  DisableDomainCreds was 1 (credentials were being purged) -> set to 0. THIS WAS THE BUG." Yellow
} else {
    Set-ItemProperty -Path $lsa -Name DisableDomainCreds -Value 0 -Type DWord
    Say "  DisableDomainCreds = 0 (credential storage allowed)." Green
}

# --- 3. tear down the broken persistent mapping ------------------------------
Head "3/6  Removing the broken persistent P: mapping"

cmd.exe /c "net use $Drive /delete /y >nul 2>&1" | Out-Null
Say "  Dropped any existing $Drive mapping."

# Kill the persistent-mapping records so the logon restore never runs again.
$netKey = "HKCU:\Network\$DriveLetter"
if (Test-Path $netKey) {
    Remove-Item $netKey -Recurse -Force
    Say "  Removed persistent mapping record HKCU\Network\$DriveLetter."
}

# Stop the "Restoring Network Connections" dialog blocking logon.
$np = 'HKLM:\SYSTEM\CurrentControlSet\Control\NetworkProvider'
if (-not (Test-Path $np)) { New-Item -Path $np -Force | Out-Null }
Set-ItemProperty -Path $np -Name RestoreConnection -Value 0 -Type DWord
Say "  RestoreConnection = 0 (no more boot-time reconnect hang)." Green

# --- 4. store the credential for all three target names ----------------------
Head "4/6  Storing the Samba credential permanently"

foreach ($t in @($HostShort, $HostFqdn, $HostIp)) {
    cmdkey.exe "/delete:$t" | Out-Null
}

$sec = Read-Host "  Samba password for '$SambaUser' on $HostShort" -AsSecureString
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)
try   { $plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr) }
finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) }

if ([string]::IsNullOrWhiteSpace($plain)) { Say "  No password entered - aborting." Red; exit 1 }

# Windows keys credentials by target string, so store one per name we may use.
# Args go straight to cmdkey.exe - routing them via cmd.exe would break on a
# password containing " & ^ or %, and would expose it to cmd's parser.
foreach ($t in @($HostShort, $HostFqdn, $HostIp)) {
    $r = cmdkey.exe "/add:$t" "/user:$SambaUser" "/pass:$plain" 2>&1
    if ($LASTEXITCODE -eq 0) { Say "  Stored credential for \\$t" Green }
    else                     { Say "  cmdkey failed for $t : $r" Red }
}
$plain = $null
[GC]::Collect()

} # end of -TaskOnly skip block

# --- 5. install the local mapper script --------------------------------------
Head "5/6  Installing the mapper script"

# Deliberately stored on the LOCAL disk - it must not live on the share it maps.
$binDir = Join-Path $env:LOCALAPPDATA 'p520-map'
New-Item -ItemType Directory -Path $binDir -Force | Out-Null
$mapper = Join-Path $binDir 'map-p520.ps1'
$logf   = Join-Path $binDir 'map-p520.log'

# Literal template (no interpolation) + token substitution, so the generated
# script's own $variables survive intact.
$template = @'
# Maps __DRIVE__ -> \\<host>\__SHARE__ once Tailscale is actually up.
# Generated by x1eg3-fix-p-drive.ps1 - re-run that script to regenerate.
$ErrorActionPreference = 'SilentlyContinue'
$log = '__LOG__'
function L($m) { "$(Get-Date -f 'yyyy-MM-dd HH:mm:ss')  $m" | Add-Content $log }

# Already mapped and answering? Nothing to do (this runs every 5 minutes).
if (Test-Path '__DRIVE__\') { exit 0 }

# Raw TCP probe with a hard 2s timeout. Test-NetConnection is far slower when
# the host is unreachable, which is exactly the case we hit at every boot.
function Probe($h, $ms = 2000) {
    $c = New-Object Net.Sockets.TcpClient
    try {
        if (-not $c.BeginConnect($h, 445, $null, $null).AsyncWaitHandle.WaitOne($ms, $false)) { return $false }
        return $c.Connected
    } catch { return $false } finally { $c.Close() }
}

# Wait for the tailnet: up to 3 minutes for TCP 445 to answer.
$targets = @('__FQDN__','__SHORT__','__IP__')
$live = $null
for ($i = 0; $i -lt 36 -and -not $live; $i++) {
    foreach ($t in $targets) { if (Probe $t) { $live = $t; break } }
    if (-not $live) { Start-Sleep -Seconds 5 }
}

if (-not $live) { L 'no SMB target reachable after 180s - tailnet down?'; exit 1 }

cmd.exe /c "net use __DRIVE__ /delete /y >nul 2>&1" | Out-Null
$unc = "\\" + $live + "\__SHARE__"
$out = cmd.exe /c "net use __DRIVE__ `"$unc`" /persistent:no" 2>&1
if (Test-Path '__DRIVE__\') { L "mapped __DRIVE__ -> $unc" }
else                        { L "FAILED via $unc : $out" }
'@

$mapperBody = $template.
    Replace('__DRIVE__', $Drive).
    Replace('__SHARE__', $Share).
    Replace('__FQDN__',  $HostFqdn).
    Replace('__SHORT__', $HostShort).
    Replace('__IP__',    $HostIp).
    Replace('__LOG__',   $logf)

Set-Content -Path $mapper -Value $mapperBody -Encoding UTF8
Say "  Wrote $mapper" Green

# --- 6. scheduled task: map at logon, re-check every 5 minutes ---------------
Head "6/6  Registering the logon task"

$taskName = 'Map P520Projects'
Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue

$me   = "$env:USERDOMAIN\$env:USERNAME"
$taskArgs = "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$mapper`""

# Registered from raw XML rather than the *-ScheduledTask* cmdlets. To repeat
# forever the schema wants <Repetition> with an Interval and NO Duration; the
# cmdlets cannot express that - [TimeSpan]::MaxValue serialises to
# P99999999DT23H59M59S, which Task Scheduler rejects outright.
$xml = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Description>Maps $Drive to \\$HostShort\$Share once Tailscale is up. Replaces the persistent mapping, which raced the tunnel at boot.</Description>
  </RegistrationInfo>
  <Triggers>
    <LogonTrigger>
      <Enabled>true</Enabled>
      <UserId>$me</UserId>
      <Delay>PT20S</Delay>
      <Repetition>
        <Interval>PT5M</Interval>
        <StopAtDurationEnd>false</StopAtDurationEnd>
      </Repetition>
    </LogonTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>$me</UserId>
      <LogonType>InteractiveToken</LogonType>
      <RunLevel>LeastPrivilege</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>true</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>false</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT10M</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>powershell.exe</Command>
      <Arguments>$taskArgs</Arguments>
    </Exec>
  </Actions>
</Task>
"@

$registered = $false
try {
    Register-ScheduledTask -TaskName $taskName -Xml $xml -Force | Out-Null
    $registered = $true
    Say "  Registered '$taskName' - at logon (+20s), then every 5 min." Green
} catch {
    Say "  XML registration failed: $($_.Exception.Message)" Yellow
    Say "  Falling back to a logon-only task (no 5-minute self-heal)..." Yellow

    # Fallback: drop the repetition entirely. Mapping at logon is the part that
    # actually fixes the boot failure; the repeat only recovers a mid-session
    # Tailscale drop, which a logoff/logon also fixes.
    try {
        $action  = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument $taskArgs
        $trigger = New-ScheduledTaskTrigger -AtLogOn -User $me
        $trigger.Delay = 'PT20S'
        $principal = New-ScheduledTaskPrincipal -UserId $me -LogonType Interactive -RunLevel Limited
        $settings  = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries `
            -DontStopIfGoingOnBatteries -StartWhenAvailable `
            -ExecutionTimeLimit (New-TimeSpan -Minutes 10) -MultipleInstances IgnoreNew
        Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger `
            -Principal $principal -Settings $settings -Force | Out-Null
        $registered = $true
        Say "  Registered '$taskName' - at logon (+20s) only." Green
    } catch {
        Say "  FAILED to register the task: $($_.Exception.Message)" Red
        Say "  Map manually meanwhile:  net use $Drive \\$HostFqdn\$Share /persistent:no" Yellow
    }
}
if (-not $registered) { exit 1 }

# --- verify now ---------------------------------------------------------------
Head "Verifying"
Start-ScheduledTask -TaskName $taskName
Start-Sleep -Seconds 8
for ($i = 0; $i -lt 12 -and -not (Test-Path "$Drive\"); $i++) { Start-Sleep -Seconds 5 }

if (Test-Path "$Drive\") {
    Say ""
    Say "SUCCESS - $Drive is mapped:" Green
    cmd.exe /c "net use $Drive" | Where-Object { $_ -match '\S' } | ForEach-Object { Say "  $_" }
    Say ""
    Say "Reboot to confirm: no 'Restoring Network Connections' dialog, and $Drive" Green
    Say "appears on its own ~20s after you log in. Log: $logf" Green
} else {
    Say ""
    Say "$Drive did not map. Check the log: $logf" Red
    Say "Most likely the Samba password was wrong - re-run this script." Yellow
}
