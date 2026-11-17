$dir = Join-Path $env:LOCALAPPDATA 'p520-map'; $tmp = Join-Path $dir 'cred.tmp'; $log = Join-Path $dir 'cred-install.log'
$pw = (Get-Content $tmp -Raw).Trim(); Remove-Item $tmp -Force
foreach($t in 'hlab','hlab.taila51191.ts.net','100.79.248.39'){ cmdkey.exe "/delete:$t" | Out-Null; $r = cmdkey.exe "/add:$t" "/user:david" "/pass:$pw" 2>&1; "$(Get-Date -f s) $t exit=$LASTEXITCODE" | Add-Content $log }
$pw = $null
cmd.exe /c "net use P: /delete /y >nul 2>&1"
cmd.exe /c "net use \\100.79.248.39\IPC$ /delete /y >nul 2>&1"; cmd.exe /c "net use \\hlab.taila51191.ts.net\IPC$ /delete /y >nul 2>&1"
"$(Get-Date -f s) done" | Add-Content $log
