$subnet = "255.255.255.0"  # Change this to match your subnet
for ($i=1; $i -le 254; $i++) {
    $ip = "$subnet.$i"
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
        Write-Host "$ip is reachable"
    }
}
