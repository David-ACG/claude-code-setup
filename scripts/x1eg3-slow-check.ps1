<#
.SYNOPSIS
  Finds out why x1eg3 feels sluggish (slow mouse, laggy UI) when Task Manager
  only shows 20-30% CPU.

.DESCRIPTION
  A 20-30% total CPU figure hides the usual culprits of a laggy mouse:
    - one core pegged at 100% (on a 12-thread CPU that is only ~8% "total")
    - interrupt / DPC storms from a faulty driver (the Thunderbolt fault)
    - the CPU being clocked down (thermal, firmware or power-plan throttling)
    - memory pressure (hard page faults), a saturated disk, or a busy GPU/DWM
  This script samples all of those for ~20 seconds and writes a plain-text
  report to P:\_slow-reports (the hlab share) so Claude can read it.

  Read-only: it changes nothing. Works non-elevated; a few extras (thermal
  zone via WMI) only appear when elevated.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File P:\claude-code-setup\scripts\x1eg3-slow-check.ps1
#>

[CmdletBinding()]
param(
    [int]$Seconds = 20,
    [string]$ReportDir = 'P:\_slow-reports'
)

$ErrorActionPreference = 'Continue'
$stamp = Get-Date -Format 'yyyy-MM-dd_HHmmss'
$dir = $ReportDir
try { New-Item -ItemType Directory -Path $dir -Force -ErrorAction Stop | Out-Null }
catch {
    $dir = '\\hlab.taila51191.ts.net\P520Projects\_slow-reports'
    try { New-Item -ItemType Directory -Path $dir -Force -ErrorAction Stop | Out-Null }
    catch { $dir = Join-Path $env:USERPROFILE 'Desktop' }
}
$file = Join-Path $dir "x1eg3-slow-$stamp.txt"
$out = New-Object System.Text.StringBuilder
function Add-Section($title, $body) {
    [void]$out.AppendLine('')
    [void]$out.AppendLine('=' * 72)
    [void]$out.AppendLine($title)
    [void]$out.AppendLine('=' * 72)
    [void]$out.AppendLine(($body | Out-String -Width 220))
}
function Try-Run([scriptblock]$sb) {
    try { & $sb } catch { "ERROR: $($_.Exception.Message)" }
}

Write-Host "Sampling the machine for $Seconds seconds - just leave it running (move the mouse normally)..." -ForegroundColor Cyan

# ---- Timed counter sample (the heart of the check) ---------------------------
$counters = @(
    '\Processor(*)\% Processor Time'
    '\Processor(_Total)\% Interrupt Time'
    '\Processor(_Total)\% DPC Time'
    '\Processor(_Total)\Interrupts/sec'
    '\Processor Information(_Total)\% Processor Performance'
    '\Processor Information(_Total)\Processor Frequency'
    '\Processor Information(_Total)\% of Maximum Frequency'
    '\System\Processor Queue Length'
    '\System\Context Switches/sec'
    '\Memory\Available MBytes'
    '\Memory\% Committed Bytes In Use'
    '\Memory\Pages/sec'
    '\Memory\Page Reads/sec'
    '\PhysicalDisk(_Total)\% Idle Time'
    '\PhysicalDisk(_Total)\Avg. Disk sec/Transfer'
    '\PhysicalDisk(_Total)\Current Disk Queue Length'
    '\Thermal Zone Information(*)\Temperature'
    '\Thermal Zone Information(*)\% Passive Limit'
    '\Thermal Zone Information(*)\Throttle Reasons'
)
$samples = $null
try {
    $samples = Get-Counter -Counter $counters -SampleInterval 1 -MaxSamples $Seconds -ErrorAction SilentlyContinue
} catch { }
if ($samples) {
    $stats = $samples.CounterSamples | Group-Object Path | ForEach-Object {
        $v = $_.Group.CookedValue
        [pscustomobject]@{
            Counter = ($_.Name -replace '^\\\\[^\\]+', '')
            Avg     = [math]::Round(($v | Measure-Object -Average).Average, 2)
            Max     = [math]::Round(($v | Measure-Object -Maximum).Maximum, 2)
        }
    } | Sort-Object Counter
    Add-Section "PERFORMANCE COUNTERS over $Seconds s (per-core lines show a single pegged core)" ($stats | Format-Table -AutoSize)
} else {
    Add-Section 'PERFORMANCE COUNTERS' 'Get-Counter returned nothing (counters may be disabled or localised).'
}

# ---- Per-process CPU over a short window ------------------------------------
Add-Section 'TOP PROCESSES BY CPU over 5 s (% of ONE core; 100 = one core flat out)' (Try-Run {
    $a = Get-Process | Select-Object Id, ProcessName, @{n='Cpu';e={$_.CPU}}
    Start-Sleep -Seconds 5
    $b = Get-Process | Select-Object Id, ProcessName, @{n='Cpu';e={$_.CPU}}, WorkingSet64
    $ha = @{}; foreach ($p in $a) { $ha[$p.Id] = $p.Cpu }
    $b | ForEach-Object {
        $prev = $ha[$_.Id]
        if ($null -ne $prev -and $null -ne $_.Cpu) {
            [pscustomobject]@{
                Pct   = [math]::Round((($_.Cpu - $prev) / 5) * 100, 1)
                Id    = $_.Id
                Name  = $_.ProcessName
                RAMMB = [math]::Round($_.WorkingSet64 / 1MB)
            }
        }
    } | Sort-Object Pct -Descending | Select-Object -First 25 | Format-Table -AutoSize
})

Add-Section 'PROCESS FAMILIES (count, total RAM) - Electron apps, browsers, AV' (Try-Run {
    Get-Process | Group-Object ProcessName | ForEach-Object {
        [pscustomobject]@{
            Name   = $_.Name
            Count  = $_.Count
            RAMMB  = [math]::Round((($_.Group | Measure-Object WorkingSet64 -Sum).Sum) / 1MB)
            CPUsec = [math]::Round((($_.Group | Measure-Object CPU -Sum).Sum), 0)
        }
    } | Sort-Object RAMMB -Descending | Select-Object -First 25 | Format-Table -AutoSize
})

Add-Section 'GPU ENGINE USE BY PROCESS (one sample)' (Try-Run {
    $g = (Get-Counter '\GPU Engine(*)\Utilization Percentage' -ErrorAction Stop).CounterSamples |
        Where-Object CookedValue -gt 0.5
    $g | ForEach-Object {
        $procId = if ($_.InstanceName -match 'pid_(\d+)') { [int]$Matches[1] } else { 0 }
        $eng = if ($_.InstanceName -match 'engtype_(\w+)') { $Matches[1] } else { '?' }
        [pscustomobject]@{
            Pct  = [math]::Round($_.CookedValue, 1)
            Pid  = $procId
            Name = (Get-Process -Id $procId -ErrorAction SilentlyContinue).ProcessName
            Engine = $eng
        }
    } | Sort-Object Pct -Descending | Select-Object -First 15 | Format-Table -AutoSize
})

# ---- Static state -----------------------------------------------------------
Add-Section 'HOST, UPTIME, CPU' (Try-Run {
    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor
    [pscustomobject]@{
        Model        = (Get-CimInstance Win32_ComputerSystem).Model
        OS           = "$($os.Caption) $($os.Version)"
        LastBoot     = $os.LastBootUpTime
        UptimeDays   = [math]::Round(((Get-Date) - $os.LastBootUpTime).TotalDays, 1)
        CPU          = $cpu.Name
        Cores        = "$($cpu.NumberOfCores) cores / $($cpu.NumberOfLogicalProcessors) threads"
        CurrentMHz   = $cpu.CurrentClockSpeed
        MaxMHz       = $cpu.MaxClockSpeed
        RAMGB        = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
        FreeRAMGB    = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
        CommitGB     = "$([math]::Round(($os.TotalVirtualMemorySize - $os.FreeVirtualMemory) / 1MB, 1)) of $([math]::Round($os.TotalVirtualMemorySize / 1MB, 1))"
    } | Format-List
})

Add-Section 'POWER: AC/battery, plan, battery health' (Try-Run {
    Add-Type -AssemblyName System.Windows.Forms
    $ps = [System.Windows.Forms.SystemInformation]::PowerStatus
    "PowerLine: $($ps.PowerLineStatus)   Charge: $([math]::Round($ps.BatteryLifePercent*100))%   Status: $($ps.BatteryChargeStatus)"
    powercfg /getactivescheme 2>&1
    $full = (Get-CimInstance -Namespace root\wmi -ClassName BatteryFullChargedCapacity -ErrorAction SilentlyContinue).FullChargedCapacity
    $design = (Get-CimInstance -Namespace root\wmi -ClassName BatteryStaticData -ErrorAction SilentlyContinue).DesignedCapacity
    if ($full -and $design) { "Battery health: $full / $design mWh = $([math]::Round(100*$full/$design))% of design" }
    "Power-mode overlay (registry): " + (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes' -ErrorAction SilentlyContinue).ActiveOverlayAcPowerScheme
    'Max processor state AC/DC (hex %):'
    powercfg /query SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 2>&1 | Select-String 'Current'
})

Add-Section 'THERMAL ZONES via WMI (elevated only; Kelvin*10 -> C)' (Try-Run {
    Get-CimInstance -Namespace root\wmi -ClassName MSAcpi_ThermalZoneTemperature -ErrorAction Stop |
        Select-Object InstanceName, @{n='TempC';e={[math]::Round($_.CurrentTemperature/10 - 273.15,1)}} |
        Format-Table -AutoSize
})

Add-Section 'CPU THROTTLING EVENTS, LAST 7 DAYS (Kernel-Processor-Power 37 = firmware limiting speed)' (Try-Run {
    $ev = Get-WinEvent -FilterHashtable @{
        LogName = 'System'; ProviderName = 'Microsoft-Windows-Kernel-Processor-Power'
        StartTime = (Get-Date).AddDays(-7)
    } -ErrorAction Stop
    $ev | Group-Object Id | Select-Object Count, Name | Format-Table -AutoSize
    $ev | Where-Object Id -eq 37 | Select-Object -First 5 TimeCreated, Message | Format-List
})

Add-Section 'THUNDERBOLT / USB FAULT: nhi events last hour + last 24 h, devices not OK' (Try-Run {
    foreach ($h in 1, 24) {
        $n = (Get-WinEvent -FilterHashtable @{ LogName='System'; ProviderName='nhi'; StartTime=(Get-Date).AddHours(-$h) } -ErrorAction SilentlyContinue | Measure-Object).Count
        "nhi events in last $h h: $n"
    }
    Get-PnpDevice | Where-Object Status -ne 'OK' |
        Select-Object Status, Class, FriendlyName, InstanceId | Format-Table -AutoSize -Wrap
})

Add-Section 'SYSTEM LOG WARNINGS/ERRORS, LAST 24 H, MOST FREQUENT FIRST' (Try-Run {
    Get-WinEvent -FilterHashtable @{ LogName='System'; Level=1,2,3; StartTime=(Get-Date).AddHours(-24) } -ErrorAction Stop |
        Group-Object ProviderName, Id | Sort-Object Count -Descending |
        Select-Object -First 20 Count, Name | Format-Table -AutoSize -Wrap
})

Add-Section 'WHEA HARDWARE ERRORS, LAST 7 DAYS' (Try-Run {
    $w = Get-WinEvent -FilterHashtable @{ LogName='System'; ProviderName='Microsoft-Windows-WHEA-Logger'; StartTime=(Get-Date).AddDays(-7) } -ErrorAction SilentlyContinue
    "Count: $(($w | Measure-Object).Count)"
    $w | Select-Object -First 3 TimeCreated, Id, Message | Format-List
})

Add-Section 'DISKS: free space and health' (Try-Run {
    Get-Volume | Where-Object DriveLetter |
        Select-Object DriveLetter, FileSystemLabel, @{n='FreeGB';e={[math]::Round($_.SizeRemaining/1GB,1)}}, @{n='SizeGB';e={[math]::Round($_.Size/1GB,1)}} |
        Format-Table -AutoSize
    Get-PhysicalDisk | Select-Object FriendlyName, MediaType, HealthStatus, OperationalStatus | Format-Table -AutoSize
})

Add-Section 'DEFENDER: scan running? (MsMpEng load)' (Try-Run {
    Get-MpComputerStatus -ErrorAction Stop |
        Select-Object RealTimeProtectionEnabled, QuickScanAge, FullScanAge, QuickScanStartTime, QuickScanEndTime, FullScanStartTime, FullScanEndTime |
        Format-List
})

Add-Section 'BACKGROUND SERVICES THAT OFTEN CAUSE LAG (state)' (Try-Run {
    Get-Service WSearch, SysMain, wuauserv, UsoSvc, DiagTrack, WaaSMedicSvc -ErrorAction SilentlyContinue |
        Select-Object Name, Status, StartType | Format-Table -AutoSize
})

Add-Section 'DISPLAY + GPU DRIVERS' (Try-Run {
    Get-CimInstance Win32_VideoController |
        Select-Object Name, DriverVersion, DriverDate, CurrentHorizontalResolution, CurrentVerticalResolution, CurrentRefreshRate, Status |
        Format-List
})

Add-Section 'POINTING DEVICES' (Try-Run {
    Get-PnpDevice -Class Mouse, HIDClass -ErrorAction SilentlyContinue | Where-Object { $_.FriendlyName -match 'mouse|pointer|track|touch|receiver|unifying|bolt' } |
        Select-Object Status, FriendlyName, InstanceId | Format-Table -AutoSize -Wrap
})

$out.ToString() | Set-Content -Path $file -Encoding UTF8
Write-Host "Done. Report written to: $file" -ForegroundColor Green
Write-Host 'Tell Claude "done" and it will read the report.' -ForegroundColor Green
