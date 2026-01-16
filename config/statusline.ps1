$ESC = [char]27
$input_json = $input | Out-String
try { $data = $input_json | ConvertFrom-Json } catch { Write-Host "parse error"; exit 0 }

$cwd = $data.cwd
$model = if ($data.model.display_name) { $data.model.display_name } else { "Claude" }
$ctx_pct = $data.context_window.remaining_percentage
$ctx_size = $data.context_window.context_window_size
$total_input = $data.context_window.total_input_tokens
$total_output = $data.context_window.total_output_tokens
$cost = if ($data.cost.total_cost_usd) { $data.cost.total_cost_usd } else { 0 }
$lines_added = if ($data.cost.total_lines_added) { $data.cost.total_lines_added } else { 0 }
$lines_removed = if ($data.cost.total_lines_removed) { $data.cost.total_lines_removed } else { 0 }

$CYAN = "$ESC[36m"; $GREEN = "$ESC[32m"; $YELLOW = "$ESC[33m"; $RED = "$ESC[31m"; $MAGENTA = "$ESC[35m"; $DIM = "$ESC[2m"; $RESET = "$ESC[0m"

$short_dir = $cwd -replace ".*[/\\]Projects[/\\]", "~/Projects/" -replace "\\", "/"

$git_branch = ""
if ($cwd -and (Test-Path $cwd -ErrorAction SilentlyContinue)) {
    Push-Location $cwd
    $branch = git symbolic-ref --short HEAD 2>$null
    if ($branch) { $git_branch = " ${MAGENTA}${branch}${RESET}" }
    Pop-Location
}

$ctx_color = if ($ctx_pct -lt 20) { $RED } elseif ($ctx_pct -lt 40) { $YELLOW } else { $GREEN }
$used_k = [math]::Round(($total_input + $total_output) / 1000)
$total_k = [math]::Round($ctx_size / 1000)
$context = "${ctx_color}${ctx_pct}%${RESET} ${DIM}${used_k}k/${total_k}k${RESET}"

$cost_str = ""
if ($cost -gt 0) { $cost_str = " ${DIM}`$${RESET}$([math]::Round($cost, 2))" }

$lines_str = ""
if ($lines_added -gt 0 -or $lines_removed -gt 0) {
    $lines_str = " ${GREEN}+${lines_added}${RESET}${DIM}/${RESET}${RED}-${lines_removed}${RESET}"
}

$status = "${CYAN}${short_dir}${RESET}${git_branch} ${DIM}|${RESET} $model ${DIM}ctx:${RESET}$context$cost_str$lines_str"
Write-Host $status
