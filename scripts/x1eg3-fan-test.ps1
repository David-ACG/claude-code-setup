# Loads every CPU thread for 45 s so David can listen for the fans spinning up.
# Prints CPU speed and the NVIDIA temperature every 5 s. Run from hlab:
#   scripts/x1eg3-run.sh scripts/x1eg3-fan-test.ps1 120
$n = [Environment]::ProcessorCount
$jobs = 1..$n | % { Start-Job { $e=(Get-Date).AddSeconds(45); while((Get-Date) -lt $e){ $x=[math]::Sqrt(12345) } } }
"time      cpu-perf%  busy%  gpuC"
1..9 | % {
  $s = (Get-Counter '\Processor Information(_Total)\% Processor Performance','\Processor(_Total)\% Processor Time' -SampleInterval 5 -MaxSamples 1).CounterSamples
  $g = (& nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader 2>$null)
  "{0}  {1,8:N0}  {2,5:N0}  {3}" -f (Get-Date -Format HH:mm:ss), $s[0].CookedValue, $s[1].CookedValue, $g
}
$jobs | Stop-Job -PassThru | Remove-Job -Force
