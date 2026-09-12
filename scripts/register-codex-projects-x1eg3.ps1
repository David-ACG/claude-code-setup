$ErrorActionPreference = "Stop"

$configPath = Join-Path $env:USERPROFILE ".codex\config.toml"
$projectRoot = "C:\Projects"

if (-not (Test-Path -LiteralPath $configPath)) {
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $configPath) | Out-Null
    Set-Content -LiteralPath $configPath -Value @'
model = "gpt-5.5"
model_reasoning_effort = "high"

[windows]
sandbox = "elevated"
'@ -Encoding UTF8
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
Copy-Item -LiteralPath $configPath -Destination "$configPath.bak-register-projects-$stamp"

$content = Get-Content -LiteralPath $configPath -Raw
$existingProjects = @{}
[regex]::Matches($content, "\[projects\.'([^']+)'\]") | ForEach-Object {
    $existingProjects[$_.Groups[1].Value.ToLowerInvariant()] = $true
}

$projectDirs = Get-ChildItem -LiteralPath $projectRoot -Directory -Force |
    Where-Object {
        $_.Name -notlike ".*" -and
        $_.Name -notlike ".tmp*" -and
        $_.Name -notin @("_tools", "OLD-SUPERCEDED", "SCREENSHOTS-ALL")
    } |
    Sort-Object Name

$additions = New-Object System.Collections.Generic.List[string]

foreach ($dir in $projectDirs) {
    $path = $dir.FullName.ToLowerInvariant()
    if ($path.Contains("'")) {
        Write-Host "Skipping path with single quote: $path"
        continue
    }
    if (-not $existingProjects.ContainsKey($path)) {
        $additions.Add("")
        $additions.Add("[projects.'$path']")
        $additions.Add('trust_level = "trusted"')
        $existingProjects[$path] = $true
        Write-Host "Registered Codex project: $path"
    }
}

if ($additions.Count -gt 0) {
    Add-Content -LiteralPath $configPath -Value ($additions -join [Environment]::NewLine) -Encoding UTF8
    Write-Host "Added $($additions.Count / 3) project trust entries to $configPath"
} else {
    Write-Host "No new project trust entries needed."
}

Write-Host "Restart Codex Desktop after this script if it was open."
