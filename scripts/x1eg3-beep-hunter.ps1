<#
.SYNOPSIS
  Identifies WHICH Windows event sound is causing the repeated beeping on x1eg3.

.DESCRIPTION
  Windows plays event sounds (Device Connect, Default Beep, Critical Battery
  Alarm, ...) through a single "System sounds" audio session, so nothing in the
  volume mixer or the event log tells you which event actually fired. Setting
  the sound scheme to "No Sounds" silences them all - which stops the noise but
  hides the culprit.

  This script makes Windows name the culprit out loud:

    -Label    Records a short spoken WAV for each candidate event ("device
              connect", "default beep", ...) and assigns it to that event.
              Every other event stays silent. The next beep SAYS what it is.

    -Restore  Puts every sound assignment back exactly as it was before -Label
              (restores from the JSON backup written by -Label).

    -Silence  Sets every event sound to none - same effect as choosing the
              "No Sounds" scheme, but per-event so -Restore can undo it.

    -Report   Collects the supporting evidence (flapping USB/PnP devices,
              battery state, USB power settings, repeated system errors) into a
              text file for review. Combine with any other mode.

  Nothing here needs a reboot and nothing needs admin rights - it is all
  per-user (HKCU) sound assignments.

.EXAMPLE
  # Find the culprit: label the events, then just use the laptop normally.
  powershell -ExecutionPolicy Bypass -File .\x1eg3-beep-hunter.ps1 -Label -Report

.EXAMPLE
  # Once identified, put everything back the way it was.
  powershell -ExecutionPolicy Bypass -File .\x1eg3-beep-hunter.ps1 -Restore

.NOTES
  Run as David in a NORMAL (non-elevated) PowerShell - event sounds are
  per-user, so an elevated shell would label the wrong account's sounds.
#>

[CmdletBinding()]
param(
    [switch]$Label,
    [switch]$Restore,
    [switch]$Silence,
    [switch]$Report,
    [switch]$Watch,
    [switch]$Trace,
    [switch]$Tree,
    # How long -Watch runs for, in minutes.
    [int]$Minutes = 30,
    # How long -Trace runs for, in seconds.
    [int]$Seconds = 60,
    # Where the spoken WAVs and the backup live.
    [string]$WorkDir = (Join-Path $env:LOCALAPPDATA 'beep-hunter'),
    # Report destination. P: is the hlab share, so Claude can read it directly.
    [string]$ReportDir = 'P:\_beep-reports'
)

$ErrorActionPreference = 'Stop'
$SchemeRoot = 'HKCU:\AppEvents\Schemes\Apps'
$BackupFile = Join-Path $WorkDir 'sound-backup.json'

# Candidate events, keyed by "<AppKey>\<EventKey>" = spoken label.
# These are every event that can fire repeatedly on its own; anything not
# listed here is silenced so it cannot muddy the test.
$Candidates = [ordered]@{
    '.Default\.Default'                  = 'default beep'
    '.Default\SystemAsterisk'            = 'asterisk'
    '.Default\SystemExclamation'         = 'exclamation'
    '.Default\SystemHand'                = 'critical stop'
    '.Default\SystemNotification'        = 'notification'
    '.Default\Notification.Default'      = 'toast notification'
    '.Default\Notification.Reminder'     = 'calendar reminder'
    '.Default\Notification.Mail'         = 'new mail'
    '.Default\Notification.IM'           = 'instant message'
    '.Default\DeviceConnect'             = 'device connect'
    '.Default\DeviceDisconnect'          = 'device disconnect'
    '.Default\DeviceFail'                = 'device failed'
    '.Default\LowBatteryAlarm'           = 'low battery'
    '.Default\CriticalBatteryAlarm'      = 'critical battery'
    '.Default\WindowsUAC'                = 'user account control'
    '.Default\ProximityConnection'       = 'proximity connection'
    '.Default\SystemQuestion'            = 'question'
    '.Default\AppGPFault'                = 'program crash'
    '.Default\PrintComplete'             = 'print complete'
    '.Default\WindowsLogon'              = 'logon'
    '.Default\WindowsLogoff'             = 'logoff'
    '.Default\WindowsUnlock'             = 'unlock'
    '.Default\SystemNoDisk'              = 'no disk'
}

function Write-Head($text) {
    Write-Host ''
    Write-Host "== $text" -ForegroundColor Cyan
}

function Get-EventSound($appKey, $eventKey) {
    $path = Join-Path $SchemeRoot "$appKey\$eventKey\.Current"
    if (-not (Test-Path $path)) { return $null }
    return (Get-ItemProperty -Path $path -Name '(default)' -ErrorAction SilentlyContinue).'(default)'
}

function Set-EventSound($appKey, $eventKey, $wav) {
    $path = Join-Path $SchemeRoot "$appKey\$eventKey\.Current"
    if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
    $type = if ($wav -like '*%*') { 'ExpandString' } else { 'String' }
    New-ItemProperty -Path $path -Name '(default)' -PropertyType $type -Value $wav -Force | Out-Null
}

# Snapshot every event assignment under every app so -Restore is exact.
function Backup-AllSounds {
    $snapshot = @{}
    foreach ($app in Get-ChildItem -Path $SchemeRoot -ErrorAction SilentlyContinue) {
        foreach ($evt in Get-ChildItem -Path $app.PSPath -ErrorAction SilentlyContinue) {
            $cur = Join-Path $evt.PSPath '.Current'
            if (Test-Path $cur) {
                $val = (Get-ItemProperty -Path $cur -Name '(default)' -ErrorAction SilentlyContinue).'(default)'
                $snapshot["$($app.PSChildName)\$($evt.PSChildName)"] = [string]$val
            }
        }
    }
    New-Item -ItemType Directory -Path $WorkDir -Force | Out-Null
    $snapshot | ConvertTo-Json -Depth 3 | Set-Content -Path $BackupFile -Encoding UTF8
    Write-Host "Backed up $($snapshot.Count) sound assignments to $BackupFile" -ForegroundColor Green
}

function Refresh-SoundScheme {
    # Nudges Windows to re-read the per-user sound assignments immediately.
    Start-Process rundll32.exe 'user32.dll,UpdatePerUserSystemParameters' -WindowStyle Hidden -Wait -ErrorAction SilentlyContinue
}

function Invoke-Label {
    Write-Head 'Recording spoken labels'
    New-Item -ItemType Directory -Path $WorkDir -Force | Out-Null

    if (-not (Test-Path $BackupFile)) { Backup-AllSounds }
    else { Write-Host "Existing backup kept: $BackupFile" -ForegroundColor Yellow }

    Add-Type -AssemblyName System.Speech
    $synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $synth.Rate = 1

    # Silence everything first, so only labelled events can make a noise.
    foreach ($app in Get-ChildItem -Path $SchemeRoot -ErrorAction SilentlyContinue) {
        foreach ($evt in Get-ChildItem -Path $app.PSPath -ErrorAction SilentlyContinue) {
            $cur = Join-Path $evt.PSPath '.Current'
            if (Test-Path $cur) {
                New-ItemProperty -Path $cur -Name '(default)' -PropertyType String -Value '' -Force | Out-Null
            }
        }
    }

    $n = 0
    foreach ($key in $Candidates.Keys) {
        $appKey, $eventKey = $key -split '\\', 2
        $label = $Candidates[$key]
        $wav   = Join-Path $WorkDir ("{0}_{1}.wav" -f $appKey.TrimStart('.'), $eventKey)
        try {
            $synth.SetOutputToWaveFile($wav)
            $synth.Speak($label)
            $synth.SetOutputToNull()
            Set-EventSound $appKey $eventKey $wav
            $n++
            Write-Host ("  {0,-34} -> `"{1}`"" -f $key, $label)
        } catch {
            Write-Host ("  {0,-34} -> SKIPPED ({1})" -f $key, $_.Exception.Message) -ForegroundColor Yellow
        }
    }
    $synth.Dispose()
    Refresh-SoundScheme

    Write-Host ''
    Write-Host "$n events labelled. Every other sound is silent." -ForegroundColor Green
    Write-Host 'Now use the laptop normally and wait for the noise.' -ForegroundColor Green
    Write-Host 'Instead of a beep you will hear a VOICE saying the event name - that is the culprit.'
    Write-Host ''
    Write-Host 'Undo with:  powershell -ExecutionPolicy Bypass -File .\x1eg3-beep-hunter.ps1 -Restore'
}

function Invoke-Silence {
    Write-Head 'Silencing all event sounds'
    if (-not (Test-Path $BackupFile)) { Backup-AllSounds }
    $count = 0
    foreach ($app in Get-ChildItem -Path $SchemeRoot -ErrorAction SilentlyContinue) {
        foreach ($evt in Get-ChildItem -Path $app.PSPath -ErrorAction SilentlyContinue) {
            $cur = Join-Path $evt.PSPath '.Current'
            if (Test-Path $cur) {
                New-ItemProperty -Path $cur -Name '(default)' -PropertyType String -Value '' -Force | Out-Null
                $count++
            }
        }
    }
    Refresh-SoundScheme
    Write-Host "$count event sounds set to none." -ForegroundColor Green
}

function Invoke-Restore {
    Write-Head 'Restoring original sound assignments'
    if (-not (Test-Path $BackupFile)) {
        Write-Host "No backup found at $BackupFile - nothing to restore." -ForegroundColor Red
        Write-Host 'Pick a scheme manually in Settings > System > Sound > More sound settings > Sounds.'
        return
    }
    $snapshot = Get-Content -Path $BackupFile -Raw | ConvertFrom-Json
    $count = 0
    foreach ($prop in $snapshot.PSObject.Properties) {
        $appKey, $eventKey = $prop.Name -split '\\', 2
        Set-EventSound $appKey $eventKey ([string]$prop.Value)
        $count++
    }
    Refresh-SoundScheme
    Write-Host "$count sound assignments restored from backup." -ForegroundColor Green
}

function Invoke-Report {
    Write-Head 'Collecting evidence'
    # Native tools (powercfg) write to stderr on any complaint, which under
    # ErrorActionPreference='Stop' would abort the whole script - including a
    # -Watch queued behind this one. Downgrade for the duration of the report.
    $savedEAP = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    $stamp = Get-Date -Format 'yyyy-MM-dd_HHmmss'
    $dir = $ReportDir
    try { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    catch {
        $dir = Join-Path $env:USERPROFILE 'Desktop'
        Write-Host "P: not available, writing to $dir instead" -ForegroundColor Yellow
    }
    $file = Join-Path $dir "x1eg3-beep-$stamp.txt"
    $out = New-Object System.Text.StringBuilder
    function Add-Section($title, $body) {
        [void]$out.AppendLine('')
        [void]$out.AppendLine('=' * 72)
        [void]$out.AppendLine($title)
        [void]$out.AppendLine('=' * 72)
        [void]$out.AppendLine(($body | Out-String))
    }

    Add-Section 'HOST' $(Get-CimInstance Win32_ComputerSystem |
        Select-Object Name, Manufacturer, Model, TotalPhysicalMemory)

    $assignments = foreach ($key in $Candidates.Keys) {
        $appKey, $eventKey = $key -split '\\', 2
        $snd = Get-EventSound $appKey $eventKey
        [pscustomobject]@{
            Event = $key
            Sound = if ([string]::IsNullOrWhiteSpace($snd)) { '(none)' } else { Split-Path $snd -Leaf }
        }
    }
    Add-Section 'CURRENT EVENT SOUND ASSIGNMENTS (candidates only)' ($assignments | Format-Table -AutoSize)

    Add-Section 'DEVICES NOT IN AN OK STATE' $(
        Get-PnpDevice | Where-Object Status -ne 'OK' |
        Select-Object Status, Class, FriendlyName, InstanceId, Problem |
        Sort-Object Status, Class | Format-Table -AutoSize -Wrap)

    Add-Section 'PnP CONNECT/DISCONNECT EVENTS, LAST 24H, BY DEVICE (flapping = high count)' $(
        try {
            Get-WinEvent -FilterHashtable @{
                LogName   = 'Microsoft-Windows-Kernel-PnP/Configuration'
                StartTime = (Get-Date).AddHours(-24)
            } -ErrorAction Stop |
            ForEach-Object {
                $id = ($_.Message -split "`n")[0]
                [pscustomobject]@{ Id = $_.Id; Device = $id.Trim() }
            } |
            Group-Object Device, Id | Sort-Object Count -Descending |
            Select-Object -First 25 Count, Name | Format-Table -AutoSize -Wrap
        } catch { "No PnP configuration events in the last 24h ($($_.Exception.Message))" })

    Add-Section 'SYSTEM LOG WARNINGS/ERRORS, LAST 24H, MOST FREQUENT FIRST' $(
        try {
            Get-WinEvent -FilterHashtable @{
                LogName = 'System'; Level = 1, 2, 3
                StartTime = (Get-Date).AddHours(-24)
            } -ErrorAction Stop |
            Group-Object ProviderName, Id | Sort-Object Count -Descending |
            Select-Object -First 25 Count, Name | Format-Table -AutoSize -Wrap
        } catch { "No matching System events ($($_.Exception.Message))" })

    Add-Section 'BATTERY' $(
        Get-CimInstance Win32_Battery |
        Select-Object Name, BatteryStatus, EstimatedChargeRemaining, DesignVoltage)

    # The USB subgroup has no powercfg alias, so it must be named by GUID.
    Add-Section 'USB POWER SETTINGS (active power scheme)' $(
        powercfg /query SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 2>&1)

    Add-Section 'USB HUBS ALLOWED TO POWER DOWN' $(
        Get-CimInstance -ClassName MSPower_DeviceEnable -Namespace root\wmi -ErrorAction SilentlyContinue |
        Where-Object { $_.InstanceName -match 'USB' } |
        Select-Object Enable, InstanceName | Format-Table -AutoSize -Wrap)

    Add-Section 'AUDIO ENDPOINTS' $(
        Get-PnpDevice -Class AudioEndpoint -ErrorAction SilentlyContinue |
        Select-Object Status, FriendlyName | Format-Table -AutoSize -Wrap)

    Add-Section 'SETUPAPI DEVICE LOG - LAST 80 LINES' $(
        $sp = Join-Path $env:SystemRoot 'INF\setupapi.dev.log'
        if (Test-Path $sp) { Get-Content -Path $sp -Tail 80 -ErrorAction SilentlyContinue }
        else { 'setupapi.dev.log not found' })

    $out.ToString() | Set-Content -Path $file -Encoding UTF8
    $ErrorActionPreference = $savedEAP
    Write-Host "Report written to: $file" -ForegroundColor Green
    if ($file -like 'P:\*') {
        Write-Host "Tell Claude: read $($file -replace '^P:\\','/home/david/projects/' -replace '\\','/')" -ForegroundColor Green
    }
}

function Bump($table, $key) {
    if ($table.ContainsKey($key)) { $table[$key]++ } else { $table[$key] = 1 }
}

function Invoke-Watch {
    Write-Head "Watching for device churn for $Minutes minute(s)"

    $stamp = Get-Date -Format 'yyyy-MM-dd_HHmmss'
    $dir = $ReportDir
    try { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    catch { $dir = Join-Path $env:USERPROFILE 'Desktop' }
    $logFile = Join-Path $dir "x1eg3-watch-$stamp.log"

    function Say-Line($text, $colour) {
        Write-Host $text -ForegroundColor $colour
        Add-Content -Path $logFile -Value $text -Encoding UTF8
    }

    # Status is part of the key on purpose. A device that cycles OK -> Error ->
    # OK never leaves the present-device list, so a presence-only diff reports
    # "no change" while the machine is chiming its head off.
    function Get-DeviceSnapshot {
        $h = @{}
        foreach ($d in (Get-PnpDevice -PresentOnly -ErrorAction SilentlyContinue)) {
            $h[$d.InstanceId] = '{0} / {1} [{2}]' -f $d.Class, $d.FriendlyName, $d.Status
        }
        return $h
    }

    Say-Line "# x1eg3 device watch, started $(Get-Date -Format 's')" 'Cyan'
    $before = Get-DeviceSnapshot
    Say-Line "# baseline: $($before.Count) devices present" 'Gray'
    Say-Line '' 'Gray'

    $setupApi  = Join-Path $env:SystemRoot 'INF\setupapi.dev.log'
    $setupSize = if (Test-Path $setupApi) { (Get-Item $setupApi).Length } else { -1 }

    $ids = @()
    try {
        Register-CimIndicationEvent -Query 'SELECT * FROM Win32_DeviceChangeEvent' `
            -SourceIdentifier 'BeepDevChange' -ErrorAction Stop | Out-Null
        $ids += 'BeepDevChange'
        Register-CimIndicationEvent -Query 'SELECT * FROM Win32_VolumeChangeEvent' `
            -SourceIdentifier 'BeepVolChange' -ErrorAction Stop | Out-Null
        $ids += 'BeepVolChange'
    } catch {
        Say-Line "Could not subscribe to device events: $($_.Exception.Message)" 'Red'
        return
    }

    $eventTypes = @{ 1 = 'CONFIG CHANGED'; 2 = 'ARRIVAL'; 3 = 'REMOVAL'; 4 = 'DOCK' }
    $deadline   = (Get-Date).AddMinutes($Minutes)
    $tally      = @{}   # device -> how many times it changed
    $typeCount  = @{}   # raw broadcast type -> count
    $lastDiff   = [DateTime]::MinValue
    $lastReport = Get-Date

    Write-Host ''
    Write-Host 'Watching. Leave this window open and use the laptop normally.' -ForegroundColor Green
    Write-Host 'Only real changes print; the raw broadcast rate is summarised every 15s.' -ForegroundColor Gray
    Write-Host 'Press Ctrl+C to stop early.' -ForegroundColor Gray
    Write-Host ''

    try {
        while ((Get-Date) -lt $deadline) {
            $queued = @(Get-Event -SourceIdentifier 'Beep*' -ErrorAction SilentlyContinue)

            foreach ($evt in $queued) {
                $inst = $evt.SourceEventArgs.NewEvent
                $kind = $eventTypes[[int]$inst.EventType]
                if (-not $kind) { $kind = "TYPE $($inst.EventType)" }
                Bump $typeCount $kind

                if ($evt.SourceIdentifier -eq 'BeepVolChange') {
                    Say-Line "$(Get-Date -f 'HH:mm:ss')  VOLUME $kind  drive $($inst.DriveName)" 'Yellow'
                }
                Remove-Event -EventIdentifier $evt.EventIdentifier -ErrorAction SilentlyContinue
            }

            # Re-enumerating is the expensive part, so diff at most once a second.
            if ($queued.Count -gt 0 -and ((Get-Date) - $lastDiff).TotalMilliseconds -ge 1000) {
                $lastDiff = Get-Date
                $now      = Get-Date -Format 'HH:mm:ss'
                $after    = Get-DeviceSnapshot

                foreach ($k in $before.Keys) {
                    if (-not $after.ContainsKey($k)) {
                        Say-Line "$now  REMOVED  $($before[$k])`n           $k" 'Red'
                        Bump $tally $before[$k]
                    } elseif ($after[$k] -ne $before[$k]) {
                        Say-Line "$now  CHANGED  $($before[$k])  ->  $($after[$k])`n           $k" 'Magenta'
                        Bump $tally $after[$k]
                    }
                }
                foreach ($k in $after.Keys) {
                    if (-not $before.ContainsKey($k)) {
                        Say-Line "$now  ARRIVED  $($after[$k])`n           $k" 'Green'
                        Bump $tally $after[$k]
                    }
                }
                $before = $after
            }

            if (((Get-Date) - $lastReport).TotalSeconds -ge 15) {
                $lastReport = Get-Date
                $sum = ($typeCount.GetEnumerator() | Sort-Object Value -Descending |
                        ForEach-Object { "$($_.Key)=$($_.Value)" }) -join '   '
                Say-Line "$(Get-Date -f 'HH:mm:ss')  -- broadcasts so far: $sum" 'DarkCyan'
            }

            if ($queued.Count -eq 0) { Start-Sleep -Milliseconds 250 }
        }
    } finally {
        foreach ($id in $ids) { Unregister-Event -SourceIdentifier $id -ErrorAction SilentlyContinue }
    }

    Say-Line '' 'Gray'
    Say-Line '# ---- SUMMARY ----------------------------------------------------' 'Cyan'
    Say-Line "# finished $(Get-Date -Format 's')" 'Cyan'
    foreach ($kv in ($typeCount.GetEnumerator() | Sort-Object Value -Descending)) {
        Say-Line ("# raw broadcasts  {0,-16} {1}" -f $kv.Key, $kv.Value) 'Cyan'
    }
    if ($tally.Count -eq 0) {
        Say-Line '# no device changed state - the churn is below the 1s sampling floor.' 'Yellow'
        Say-Line '# Run with -Trace to capture it in the kernel instead.' 'Yellow'
    } else {
        Say-Line '# devices that changed, most churn first:' 'Cyan'
        foreach ($kv in ($tally.GetEnumerator() | Sort-Object Value -Descending)) {
            Say-Line ("#   {0,5}x  {1}" -f $kv.Value, $kv.Key) 'Cyan'
        }
    }
    if ($setupSize -ge 0 -and (Test-Path $setupApi)) {
        $grew = (Get-Item $setupApi).Length - $setupSize
        Say-Line "# setupapi.dev.log grew by $grew bytes during the watch" 'Cyan'
    }

    Write-Host ''
    Write-Host "Log written to: $logFile" -ForegroundColor Green
    if ($logFile -like 'P:\*') {
        Write-Host ("Tell Claude: read " + ($logFile -replace '^P:\\', '/home/david/projects/' -replace '\\', '/')) -ForegroundColor Green
    }
}

function Show-DeviceBranch($instanceId, $depth) {
    $d = Get-PnpDevice -InstanceId $instanceId -ErrorAction SilentlyContinue
    if ($d) {
        $colour = switch ($d.Status) {
            'OK'      { 'Gray' }
            'Error'   { 'Red' }
            'Unknown' { 'DarkGray' }
            default   { 'Yellow' }
        }
        $line = ('  ' * $depth) + ('{0,-8} {1} / {2}' -f $d.Status, $d.Class, $d.FriendlyName)
        Write-Host $line -ForegroundColor $colour
        Add-Content -Path $script:TreeLog -Value $line -Encoding UTF8
    }
    # Recursion depth is capped: a malfunctioning controller can report a device
    # tree with cycles, and this is a diagnostic, not something to hang on.
    if ($depth -ge 6) { return }
    $kids = (Get-PnpDeviceProperty -InstanceId $instanceId -KeyName 'DEVPKEY_Device_Children' `
             -ErrorAction SilentlyContinue).Data
    foreach ($k in $kids) { if ($k) { Show-DeviceBranch $k ($depth + 1) } }
}

function Invoke-Tree {
    Write-Head 'Devices behind the Thunderbolt controller'

    $stamp = Get-Date -Format 'yyyy-MM-dd_HHmmss'
    $dir = $ReportDir
    try { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    catch { $dir = Join-Path $env:USERPROFILE 'Desktop' }
    $script:TreeLog = Join-Path $dir "x1eg3-tree-$stamp.txt"

    # Every function of the Titan Ridge chip: NHI, PCIe downstream ports, and
    # the xHCI USB controller that actually carries the USB devices.
    $roots = Get-PnpDevice -ErrorAction SilentlyContinue | Where-Object {
        $_.InstanceId -match 'PCI\\VEN_8086&DEV_15(E[0-9A-F]|F[0-9A-F])'
    } | Sort-Object InstanceId

    if (-not $roots) {
        Write-Host 'No Titan Ridge Thunderbolt functions found.' -ForegroundColor Yellow
        return
    }

    foreach ($r in $roots) {
        Add-Content -Path $script:TreeLog -Value '' -Encoding UTF8
        Write-Host ''
        Write-Host "ROOT: $($r.InstanceId)" -ForegroundColor Cyan
        Add-Content -Path $script:TreeLog -Value "ROOT: $($r.InstanceId)" -Encoding UTF8
        Show-DeviceBranch $r.InstanceId 0
    }

    # Same again for the PCH's USB controllers, to prove which side each port is on.
    Write-Host ''
    Write-Host 'For comparison - USB controllers NOT part of the Thunderbolt chip:' -ForegroundColor Cyan
    Add-Content -Path $script:TreeLog -Value "`nNON-THUNDERBOLT USB CONTROLLERS" -Encoding UTF8
    $others = Get-PnpDevice -Class USB -ErrorAction SilentlyContinue | Where-Object {
        $_.FriendlyName -match 'Host Controller' -and $_.InstanceId -notmatch 'DEV_15E|DEV_15F'
    }
    foreach ($o in $others) {
        Write-Host ''
        Write-Host "ROOT: $($o.InstanceId)" -ForegroundColor Cyan
        Add-Content -Path $script:TreeLog -Value "ROOT: $($o.InstanceId)" -Encoding UTF8
        Show-DeviceBranch $o.InstanceId 0
    }

    Write-Host ''
    Write-Host "Tree written to: $script:TreeLog" -ForegroundColor Green
}

function Invoke-Trace {
    Write-Head "Kernel PnP trace for $Seconds second(s)"

    $isAdmin = ([Security.Principal.WindowsPrincipal] `
        [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Host 'ETW tracing needs an ELEVATED PowerShell. Re-run this as administrator.' -ForegroundColor Red
        return
    }

    $savedEAP = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'

    $stamp = Get-Date -Format 'yyyy-MM-dd_HHmmss'
    $dir = $ReportDir
    try { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    catch { $dir = Join-Path $env:USERPROFILE 'Desktop' }

    $etl  = Join-Path $env:TEMP 'pnp-beep.etl'
    $xml  = Join-Path $env:TEMP 'pnp-beep.xml'
    $out  = Join-Path $dir "x1eg3-trace-$stamp.txt"

    # Anything left over from a previous run would make 'create' fail.
    logman stop  pnpbeep -ets 2>&1 | Out-Null
    Remove-Item $etl, $xml -Force -ErrorAction SilentlyContinue

    Write-Host 'Starting kernel trace...' -ForegroundColor Gray
    $start = logman create trace pnpbeep -ets -p Microsoft-Windows-Kernel-PnP 0xffffffffffffffff 0xff -o $etl 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host ($start | Out-String) -ForegroundColor Red
        $ErrorActionPreference = $savedEAP
        return
    }

    Write-Host "Tracing for $Seconds seconds - use the laptop normally." -ForegroundColor Green
    Start-Sleep -Seconds $Seconds
    logman stop pnpbeep -ets 2>&1 | Out-Null
    Write-Host 'Decoding...' -ForegroundColor Gray
    tracerpt $etl -o $xml -y 2>&1 | Out-Null

    if (-not (Test-Path $xml)) {
        Write-Host 'tracerpt produced no output.' -ForegroundColor Red
        $ErrorActionPreference = $savedEAP
        return
    }

    # Device instance ids are the only thing we need out of the decode, and a
    # regex over the text survives schema differences between Windows builds.
    # tracerpt escapes '&' as '&amp;', and instance ids are full of them
    # (PCI\VEN_8086&DEV_15EB&SUBSYS_...), so decode before matching or every id
    # gets truncated at its first ampersand.
    $text = (Get-Content -Path $xml -Raw) -replace '&amp;', '&'
    $rx   = [regex]'(?i)\b(USB|PCI|HID|SWD|BTH|ACPI|HDAUDIO|ROOT|STORAGE|DISPLAY|UMB)\\[^<"\s]{4,160}'
    $tally = @{}
    foreach ($m in $rx.Matches($text)) { Bump $tally $m.Value }

    $report = New-Object System.Text.StringBuilder
    [void]$report.AppendLine("x1eg3 kernel PnP trace - $Seconds seconds from $stamp")
    [void]$report.AppendLine("total device references in trace: $($rx.Matches($text).Count)")
    [void]$report.AppendLine('')
    [void]$report.AppendLine('MOST-REFERENCED DEVICES (the churn source is at the top):')
    foreach ($kv in ($tally.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 40)) {
        [void]$report.AppendLine(('{0,6}x  {1}' -f $kv.Value, $kv.Key))
    }

    # Resolve the top offenders to friendly names.
    [void]$report.AppendLine('')
    [void]$report.AppendLine('FRIENDLY NAMES FOR THE TOP 15:')
    foreach ($kv in ($tally.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 15)) {
        $d = Get-PnpDevice -InstanceId $kv.Key -ErrorAction SilentlyContinue
        $name = if ($d) { "$($d.Class) / $($d.FriendlyName) [$($d.Status)]" } else { '(not a current device instance)' }
        [void]$report.AppendLine(('{0,6}x  {1}' -f $kv.Value, $name))
        [void]$report.AppendLine('        ' + $kv.Key)
    }

    $report.ToString() | Set-Content -Path $out -Encoding UTF8
    $ErrorActionPreference = $savedEAP

    Write-Host ''
    Get-Content $out -Head 25 | Write-Host
    Write-Host ''
    Write-Host "Full trace report: $out" -ForegroundColor Green
    if ($out -like 'P:\*') {
        Write-Host ("Tell Claude: read " + ($out -replace '^P:\\', '/home/david/projects/' -replace '\\', '/')) -ForegroundColor Green
    }
}

if (-not ($Label -or $Restore -or $Silence -or $Report -or $Watch -or $Trace -or $Tree)) {
    Write-Host 'Nothing to do. Pick a mode:' -ForegroundColor Yellow
    Write-Host '  -Label    give each event a spoken name so the next beep identifies itself'
    Write-Host '  -Watch    log every device arrival/removal/state change live, by name'
    Write-Host '  -Trace    kernel ETW trace (needs admin) - catches churn too fast for -Watch'
    Write-Host '  -Tree     show every device hanging off the Thunderbolt controller'
    Write-Host '  -Report   collect supporting evidence to a text file'
    Write-Host '  -Restore  put all sound assignments back'
    Write-Host '  -Silence  set every event sound to none (reversible with -Restore)'
    exit 1
}

function Invoke-Mode($name, $fn) {
    try { & $fn }
    catch {
        Write-Host "$name failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host 'Continuing with the remaining modes.' -ForegroundColor Yellow
    }
}

if ($Restore) { Invoke-Mode 'Restore' ${function:Invoke-Restore} }
if ($Silence) { Invoke-Mode 'Silence' ${function:Invoke-Silence} }
if ($Label)   { Invoke-Mode 'Label'   ${function:Invoke-Label}   }
if ($Report)  { Invoke-Mode 'Report'  ${function:Invoke-Report}  }
if ($Watch)   { Invoke-Mode 'Watch'   ${function:Invoke-Watch}   }
if ($Trace)   { Invoke-Mode 'Trace'   ${function:Invoke-Trace}   }
if ($Tree)    { Invoke-Mode 'Tree'    ${function:Invoke-Tree}    }
