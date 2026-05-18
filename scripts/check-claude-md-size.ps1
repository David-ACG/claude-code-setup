<#
.SYNOPSIS
    Audits the size of CLAUDE.md and CLAUDE.local.md files under a project root.

.DESCRIPTION
    Walks the given path (default C:\Projects) up to a depth of 5 looking for
    CLAUDE.md and CLAUDE.local.md files, then reports each file's line count
    and KB size with an OK/WARN/ALERT status.

    Status thresholds:
      OK     - <= 200 lines AND <= 20 KB
      WARN   - >  200 lines OR  >  20 KB (under hard limits)
      ALERT  - >  600 lines OR  >  35 KB (approaching Anthropic's 40 KB threshold)

    A file containing the marker '<!-- audit-ignore: oversized -->' is reported
    as IGNORED regardless of size.

    Exit code: 0 if every file is OK or IGNORED, 1 if any WARN/ALERT.

.PARAMETER Path
    Root to scan. Defaults to C:\Projects.

.PARAMETER Verbose
    Lists exclusion hits (paths skipped because they live under an excluded dir).

.EXAMPLE
    pwsh ./scripts/check-claude-md-size.ps1

.EXAMPLE
    pwsh ./scripts/check-claude-md-size.ps1 -Path C:/Projects/GWTH_V2 -Verbose
#>
[CmdletBinding()]
param(
    [string]$Path = 'C:\Projects'
)

$ErrorActionPreference = 'Stop'

$excludedDirs = @(
    'node_modules', '.git', '.next', 'dist', 'build', 'out',
    'coverage', '.venv', '__pycache__', '.stversions', '.stfolder'
)

$started = Get-Date

# Prune excluded directories during traversal to keep the walk fast.
function Get-ClaudeMdFiles {
    param(
        [string]$Root,
        [int]$MaxDepth,
        [string[]]$Excluded
    )

    $results = New-Object System.Collections.Generic.List[System.IO.FileInfo]
    $skipped = New-Object System.Collections.Generic.List[string]

    $stack = New-Object System.Collections.Generic.Stack[object]
    $stack.Push([pscustomobject]@{ Dir = [System.IO.DirectoryInfo]$Root; Depth = 0 })

    while ($stack.Count -gt 0) {
        $node = $stack.Pop()
        $dir   = $node.Dir
        $depth = $node.Depth

        try {
            foreach ($file in $dir.EnumerateFiles()) {
                if ($file.Name -eq 'CLAUDE.md' -or $file.Name -eq 'CLAUDE.local.md') {
                    $results.Add($file)
                }
            }
        } catch {
            # Skip directories we can't read
            continue
        }

        if ($depth -ge $MaxDepth) { continue }

        try {
            foreach ($sub in $dir.EnumerateDirectories()) {
                if ($Excluded -contains $sub.Name) {
                    $skipped.Add($sub.FullName)
                    continue
                }
                $stack.Push([pscustomobject]@{ Dir = $sub; Depth = $depth + 1 })
            }
        } catch {
            continue
        }
    }

    [pscustomobject]@{
        Files   = $results
        Skipped = $skipped
    }
}

$walk = Get-ClaudeMdFiles -Root $Path -MaxDepth 5 -Excluded $excludedDirs
$kept = $walk.Files

if ($PSBoundParameters['Verbose']) {
    foreach ($s in $walk.Skipped) {
        Write-Verbose "Excluded: $s"
    }
}

$rows = foreach ($file in $kept) {
    $lineCount = (Get-Content -LiteralPath $file.FullName).Count
    $kb        = [math]::Round($file.Length / 1KB, 1)
    $ignored   = Select-String -Path $file.FullName -SimpleMatch -Pattern 'audit-ignore: oversized' -Quiet

    $status = if ($ignored) {
        'IGNORED'
    } elseif ($lineCount -gt 600 -or $kb -gt 35) {
        'ALERT'
    } elseif ($lineCount -gt 200 -or $kb -gt 20) {
        'WARN'
    } else {
        'OK'
    }

    [pscustomobject]@{
        Path   = $file.FullName
        Lines  = $lineCount
        KB     = $kb
        Status = $status
    }
}

$rows = @($rows | Sort-Object -Property Lines -Descending)

$timestamp = $started.ToString('yyyy-MM-dd HH:mm')
Write-Host ""
Write-Host "Project CLAUDE.md size audit -- $timestamp"
Write-Host ""

$header = '{0,-70} {1,7} {2,6}  {3}' -f 'PATH', 'LINES', 'KB', 'STATUS'
Write-Host $header

foreach ($row in $rows) {
    $line = '{0,-70} {1,7} {2,6}  {3}' -f $row.Path, $row.Lines, $row.KB, $row.Status
    switch ($row.Status) {
        'ALERT'   { Write-Host $line -ForegroundColor Red }
        'WARN'    { Write-Host $line -ForegroundColor Yellow }
        'IGNORED' { Write-Host $line -ForegroundColor DarkGray }
        default   { Write-Host $line }
    }
}

$alertCount   = @($rows | Where-Object Status -eq 'ALERT').Count
$warnCount    = @($rows | Where-Object Status -eq 'WARN').Count
$okCount      = @($rows | Where-Object Status -eq 'OK').Count
$ignoredCount = @($rows | Where-Object Status -eq 'IGNORED').Count
$total        = $rows.Count

$elapsed = ((Get-Date) - $started).TotalSeconds
$elapsedFmt = [math]::Round($elapsed, 1)

$summary = "$total files scanned. $alertCount ALERT, $warnCount WARN, $okCount OK"
if ($ignoredCount -gt 0) { $summary += ", $ignoredCount IGNORED" }
$summary += ". (${elapsedFmt}s)"

Write-Host ""
Write-Host $summary

if (($alertCount + $warnCount) -gt 0) {
    exit 1
} else {
    exit 0
}
