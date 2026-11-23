<#
.SYNOPSIS
  Turn audio effects ("Audio enhancements") off for one capture endpoint, or undo it.
  Run elevated (hlab: scripts/mic-effects-off.sh <host> <endpoint-guid> [--undo]).

  Why (T14s, 2026-11-23): the built-in mic's FxProperties named 7 effect plug-ins
  (APOs) that are missing or half-removed, so every app got 0x80040154 "class not
  registered" from GetMixFormat and no app could open the mic.

  Gotcha: Administrators may only QUERY/SET values on MMDevices\...\FxProperties
  (no CREATE_SUB_KEY), so New-ItemProperty / reg add fail with "Requested registry
  access is not allowed", even as SYSTEM (SYSTEM is only the owner, with no ACE).
  Opening the key with just QueryValues|SetValue works.

.PARAMETER EndpointId  the {guid} under MMDevices\Audio\Capture
.PARAMETER Undo        remove the value again (it did not exist before)
#>
param(
  [Parameter(Mandatory)] [string] $EndpointId,
  [string] $WorkDir = 'C:\ProgramData\mic-effects-off',
  [switch] $Undo
)
$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Force $WorkDir | Out-Null
$log = Join-Path $WorkDir 'result.txt'
function Log($m) { $m | Add-Content $log; $m }
"$(Get-Date -Format s) start endpoint=$EndpointId undo=$Undo" | Set-Content $log
try {
  $sub = "SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture\$EndpointId\FxProperties"
  $name = '{1da5d803-d492-4edd-8c23-e0c0ffee7f0e},5'      # PKEY_AudioEndpoint_Disable_SysFx
  $backup = Join-Path $WorkDir "FxProperties-$($EndpointId.Trim('{}')).reg"
  if (-not (Test-Path $backup)) {                          # keep the FIRST backup, never overwrite it
    & reg.exe export "HKLM\$sub" $backup /y 2>&1 | Out-Null
    if (-not (Test-Path $backup)) { throw "backup failed" }
    Log "backup $backup"
  }
  $rights = [System.Security.AccessControl.RegistryRights]'QueryValues, SetValue'
  $k = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($sub, [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree, $rights)
  if (-not $k) { throw "endpoint key not found: $sub" }
  if ($Undo) { $k.DeleteValue($name, $false); Log "removed $name" }
  else { $k.SetValue($name, 1, [Microsoft.Win32.RegistryValueKind]::DWord); Log "set $name = $($k.GetValue($name))" }
  $k.Close()
  Restart-Service -Name AudioEndpointBuilder -Force          # also restarts Audiosrv (dependent)
  Start-Service -Name Audiosrv
  Log ("services: " + ((Get-Service AudioEndpointBuilder, Audiosrv | ForEach-Object { "$($_.Name)=$($_.Status)" }) -join ' '))
  Log "OK"
} catch {
  Log "FAILED: $_"
}
