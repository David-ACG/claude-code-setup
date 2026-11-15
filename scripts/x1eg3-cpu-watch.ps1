# Live CPU speed + power watch for x1eg3, one line per 2 s. Run from hlab:
#   scripts/x1eg3-run.sh scripts/x1eg3-cpu-watch.ps1 200
# "Perf %" = % Processor Performance: 100 = rated 2.6 GHz, ~190 = full turbo (5.0 GHz).
$Samples = 45
$ctrs = '\Processor Information(_Total)\% Processor Performance','\Processor Information(_Total)\% Performance Limit','\Processor(_Total)\% Processor Time'
"{0,-9} {1,7} {2,8} {3,7} {4,6} {5,9} {6,8}" -f 'time','perf%','limit%','busy%','tempC','AC','charging'
for ($i = 0; $i -lt $Samples; $i++) {
    $s = (Get-Counter $ctrs -SampleInterval 2 -MaxSamples 1).CounterSamples
    $b = Get-CimInstance -Namespace root/wmi -ClassName BatteryStatus
    $t = (Get-CimInstance -Namespace root/wmi -ClassName MSAcpi_ThermalZoneTemperature -EA SilentlyContinue | Select -First 1).CurrentTemperature / 10 - 273.15
    "{0,-9} {1,7:N0} {2,8:N0} {3,7:N0} {4,6:N0} {5,9} {6,8}" -f (Get-Date -Format HH:mm:ss), $s[0].CookedValue, $s[1].CookedValue, $s[2].CookedValue, $t, $b.PowerOnline, $b.Charging
}
