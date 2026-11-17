<#
.SYNOPSIS
  Read-only inventory of a Windows laptop, for comparing two machines and
  finding clutter: installed apps, Store apps, startup items, non-Microsoft
  services and scheduled tasks (with whether their program still exists),
  dev tools, SSH/Claude/Codex config, mapped drives, Tailscale. Changes nothing.
  Run over SSH from hlab:  scripts/win-run.sh <host> scripts/win-inventory.ps1 300
#>
$ErrorActionPreference = 'SilentlyContinue'
function Sec($t) { "`n===== $t =====" }
function Resolve-Exe([string]$cmd) {
    if (-not $cmd) { return $null }
    $c = [Environment]::ExpandEnvironmentVariables($cmd.Trim())
    if ($c -match '^"([^"]+)"') { return $matches[1] }
    if ($c -match '^(.+?\.(exe|cmd|bat|ps1|vbs|com))\b') { return $matches[1] }
    return ($c -split ' ')[0]
}
function Exists([string]$p) {
    if (-not $p) { return '?' }
    if ($p -match '^(rundll32|cmd|powershell|pwsh|wscript|cscript|msiexec|schtasks|sc|reg)(\.exe)?$') { return 'sys' }
    if (Test-Path $p) { return 'ok' }
    if (Get-Command $p -ErrorAction SilentlyContinue) { return 'ok' }
    return 'MISSING'
}

Sec 'machine'
$os = Get-CimInstance Win32_OperatingSystem; $cs = Get-CimInstance Win32_ComputerSystem
"{0} | {1} {2} build {3} | {4} {5} | RAM {6:N0} GB | boot {7}" -f $env:COMPUTERNAME, $os.Caption, $os.OSArchitecture, $os.BuildNumber, $cs.Manufacturer, $cs.Model, ($cs.TotalPhysicalMemory/1GB), $os.LastBootUpTime
Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | ForEach-Object { "disk {0} {1:N0}/{2:N0} GB free" -f $_.DeviceID, ($_.FreeSpace/1GB), ($_.Size/1GB) }

Sec 'installed programs (name | version | publisher | installed)'
$keys = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
Get-ItemProperty $keys | Where-Object { $_.DisplayName -and -not $_.SystemComponent -and -not $_.ParentKeyName } |
  Sort-Object DisplayName -Unique | ForEach-Object { "{0} | {1} | {2} | {3}" -f $_.DisplayName, $_.DisplayVersion, $_.Publisher, $_.InstallDate }

Sec 'store apps (non-Microsoft or notable)'
Get-AppxPackage | Where-Object { -not $_.IsFramework -and $_.SignatureKind -ne 'System' -and $_.Name -notmatch '^Microsoft\.(VCLibs|NET|UI\.Xaml|WindowsAppRuntime|Services\.Store|DesktopAppInstaller)' } |
  Sort-Object Name | ForEach-Object { "{0} | {1}" -f $_.Name, $_.Version }

Sec 'startup items (Run keys + Startup folders)'
foreach ($k in 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run','HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run') {
    $p = Get-ItemProperty $k
    if ($p) { $p.PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' } | ForEach-Object { "{0} | {1} | {2} | {3}" -f ($k -replace 'SOFTWARE\\(WOW6432Node\\)?Microsoft\\Windows\\CurrentVersion\\',''), $_.Name, (Exists (Resolve-Exe $_.Value)), $_.Value } }
}
foreach ($d in "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup","$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup") {
    Get-ChildItem $d -File | ForEach-Object { "folder | {0} | {1}" -f $_.Name, $d }
}
"--- disabled in Task Manager (StartupApproved) ---"
foreach ($k in 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run','HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run') {
    $p = Get-ItemProperty $k
    if ($p) { $p.PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' -and $_.Value[0] -ne 2 } | ForEach-Object { "disabled | $($_.Name)" } }
}

Sec 'non-Microsoft services (name | state | start | program-exists | path)'
Get-CimInstance Win32_Service | Where-Object { $_.PathName -and $_.PathName -notmatch '\\Windows\\(system32|SysWOW64)\\(svchost|lsass|services|SearchIndexer|spoolsv|msiexec|dllhost|wbem)' -and $_.PathName -notmatch 'Windows Defender|Microsoft\\Windows Defender|\\WindowsApps\\Microsoft' } |
  Where-Object { $_.PathName -notmatch '^"?C:\\WINDOWS\\' -or $_.PathName -match 'Lenovo|Intel|Realtek|NVIDIA|Dell|Synaptics|Tailscale|OpenSSH|ssh' } |
  Sort-Object Name | ForEach-Object { "{0} | {1} | {2} | {3} | {4}" -f $_.Name, $_.State, $_.StartMode, (Exists (Resolve-Exe $_.PathName)), $_.PathName }

Sec 'scheduled tasks outside \Microsoft\ (path | state | last run | last result | program-exists | action)'
Get-ScheduledTask | Where-Object { $_.TaskPath -notlike '\Microsoft\*' } | ForEach-Object {
    $i = $_ | Get-ScheduledTaskInfo
    $a = ($_.Actions | Select-Object -First 1)
    $exe = if ($a.Execute) { Resolve-Exe $a.Execute } else { 'COM' }
    $res = if ($i.LastTaskResult -eq 0) { 'OK' } elseif ($i.LastTaskResult -eq 267011) { 'never-run' } else { '0x{0:X}' -f $i.LastTaskResult }
    $last = if ($i.LastRunTime -and $i.LastRunTime.Year -gt 2000) { $i.LastRunTime.ToString('yyyy-MM-dd') } else { '-' }
    "{0}{1} | {2} | {3} | {4} | {5} | {6} {7}" -f $_.TaskPath, $_.TaskName, $_.State, $last, $res, $(if ($exe -eq 'COM') {'com'} else {Exists $exe}), $a.Execute, $a.Arguments
}

Sec 'dev tools on PATH'
foreach ($t in 'git','gh','node','npm','pnpm','bun','python','py','uv','pip','code','cursor','claude','codex','ssh','scp','wsl','docker','winget','choco','scoop','pwsh','tailscale','bd','rclone','ffmpeg','7z') {
    $c = Get-Command $t -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($c) {
        $v = ''
        if ($t -notin 'ssh','scp','wsl','tailscale','winget','code','cursor','docker') {
            $j = Start-Job -ScriptBlock { param($s) & $s --version 2>$null | Select-Object -First 1 } -ArgumentList $c.Source
            if (Wait-Job $j -Timeout 10) { $v = Receive-Job $j } else { $v = '(version check timed out)' }
            Remove-Job $j -Force
        }
        "{0} | {1} | {2}" -f $t, $c.Source, $v
    } else { "{0} | -" -f $t }
}

Sec 'WSL distros'
(wsl.exe -l -v 2>$null) -replace "`0",'' | Where-Object { $_.Trim() }

Sec 'mapped drives'
Get-ItemProperty 'HKCU:\Network\*' | ForEach-Object { "{0}: -> {1}" -f $_.PSChildName, $_.RemotePath }
net use 2>$null | Select-String '\\\\'

Sec 'ssh config (hosts)'
Get-Content "$env:USERPROFILE\.ssh\config" | Select-String -Pattern '^\s*(Host|HostName|User|IdentityFile)\s'
Get-ChildItem "$env:USERPROFILE\.ssh" -File | Select-Object -ExpandProperty Name

Sec 'Claude / Codex / tool config dirs'
foreach ($d in "$env:USERPROFILE\.claude","$env:USERPROFILE\.claude.json","$env:APPDATA\Claude","$env:LOCALAPPDATA\AnthropicClaude","$env:USERPROFILE\.codex","$env:USERPROFILE\.gitconfig","$env:USERPROFILE\.config","$env:APPDATA\Code\User\settings.json","$env:APPDATA\Cursor\User\settings.json") {
    if (Test-Path $d) { $it = Get-Item $d -Force; "{0} | {1}" -f $d, $(if ($it.PSIsContainer) { "dir, $((Get-ChildItem $d -Force).Count) entries" } else { "file $($it.Length) bytes" }) } else { "$d | -" }
}
if (Test-Path "$env:USERPROFILE\.claude") { "~/.claude entries: " + ((Get-ChildItem "$env:USERPROFILE\.claude" -Force | Select-Object -ExpandProperty Name) -join ', ') }
if (Test-Path "$env:APPDATA\Claude\claude_desktop_config.json") { "--- claude_desktop_config.json (keys only) ---"; (Get-Content "$env:APPDATA\Claude\claude_desktop_config.json" -Raw | ConvertFrom-Json).PSObject.Properties.Name }

Sec 'git identity'
git config --global user.name; git config --global core.autocrlf

Sec 'tailscale'
$ts = 'C:\Program Files\Tailscale\tailscale.exe'
& $ts version 2>$null | Select-Object -First 1
& $ts debug prefs 2>$null | Select-String 'RunSSH|ShieldsUp|CorpDNS|ExitNodeID|RouteAll|AdvertiseTags|Hostname'

Sec 'power + security'
powercfg /getactivescheme
"HVCI running: " + ((Get-CimInstance -Namespace root\Microsoft\Windows\DeviceGuard -ClassName Win32_DeviceGuard).SecurityServicesRunning -join ',')
"BitLocker C: " + (Get-BitLockerVolume -MountPoint C:).ProtectionStatus
