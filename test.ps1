[ipaddress] "192.168.3.4"
[ipaddress] "255.255.255.0"

$i32_Addr = ([IPAddress] "192.168.3.4").Address
$i32_Mask = ([IPAddress] "255.255.255.0").Address
Write-Host $i32_Addr -band $i32_Mask
[ipaddress] "$convert"