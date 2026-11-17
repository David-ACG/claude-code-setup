$dir = Join-Path $env:LOCALAPPDATA 'p520-map'; New-Item -ItemType Directory -Force $dir | Out-Null
$me = "$env:COMPUTERNAME\$env:USERNAME"
$tmp = Join-Path $dir 'cred.tmp'
icacls $tmp /inheritance:r /grant:r "${me}:(R,D)" | Out-Null
$a = New-ScheduledTaskAction -Execute powershell.exe -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$dir\share-cred-user.ps1`""
$p = New-ScheduledTaskPrincipal -UserId $me -LogonType Interactive -RunLevel Limited
Register-ScheduledTask -TaskName 'p520-cred-once' -Action $a -Principal $p -Force | Out-Null
Start-ScheduledTask 'p520-cred-once'
for($i=0;$i -lt 30;$i++){ Start-Sleep 2; $st = Get-ScheduledTask 'p520-cred-once' -ErrorAction SilentlyContinue; if(-not $st -or ($st.State -ne 'Running' -and -not (Test-Path $tmp))){ break } }
Unregister-ScheduledTask 'p520-cred-once' -Confirm:$false
Remove-Item "$dir\share-cred-user.ps1" -Force -ErrorAction SilentlyContinue
"temp password file left: " + (Test-Path $tmp)
Get-Content (Join-Path $dir 'cred-install.log') -Tail 4
"vault entries: " + ((cmdkey /list | Select-String 'Target:.*(hlab|100\.79)' | ForEach-Object { $_.Line.Trim() }) -join ' | ')
