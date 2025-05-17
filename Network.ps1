Get-IPNetwork -SubnetMask "255.255.255.0"-IPAddr "192.168.3.4"
Test-IPNetwork "192.168.3.4" "192.168.3.1" "255.255.255.0" 
Test-IPNetwork "10.10.49.121" "10.10.56.254" "255.255.248.0" 
Test-IPNetwork "10.10.49.121" "10.10.55.254" "255.255.248.0" 
Get-Help Get-IPNetwork
Get-Help Get-IPNetwork -Examples
Get-Help Get-IPNetwork -Parameter IPAddr 
    Test-IPNetwork -IPAddr1 "192.168.3.4" -IPAddr2 "192.168.15.5" -SubnetMask "255.255.255.0"
function Get-IPNetwork {
         <#
    .SYNOPSIS
    Given an IP address and a subnet mask, return its subnet ID
    .DESCRIPTION
    Given an IP address and a subnet mask, return the subnet ID
    of the network on which that address resides.
    .PARAMETER IPAddr
    The IPv4 address as a "dotted-quad" string
    .PARAMETER SubnetMask
    The subnet mask as a "dotted-quad" string
    .EXAMPLE
    Get-IPNetwork -IPAddr "192.168.3.4" -SubnetMask "255.255.255.0"
    returns "192.168.3.0"
    #>
    param($IPAddr, $SubnetMask)
    $i32_Addr = ([IPAddress]$IPAddr).Address
    $i32_Mask = ([IPAddress]$SubnetMask).Address
    $i32_SubnetId = $i32_Addr -band $i32_Mask
    $SubnetId = [IPAddress]$i32_SubnetId
    return $SubnetId.IPAddressToString
} 

function Test-IPNetwork {
    <#
    .SYNOPSIS
    Intakes 2 Ip adresses and a subnet mask and tests if they are on the same subnet
    .DESCRIPTION
    Intakes 2 Ip adresses and a subnet mask and tests if they are on the same subnet
    .PARAMETER IPAddr1
    The IPv4 address as a "dotted-quad" string
    .PARAMETER IPAddr2
    The IPv4 address as a "dotted-quad" string
    .PARAMETER SubnetMask
    The subnet mask as a "dotted-quad" string
    .EXAMPLE
    Test-IPNetwork -IPAddr1 "192.168.3.4" -IPAddr2 "192.168.15.5" -SubnetMask "255.255.255.0"
    returns "False"
    #>
    param ($IPAddr1, $IPAddr2, $SubnetMask)
    $SubnetId1 = Get-IPNetwork -IPAddr $IPAddr1 -SubnetMask $SubnetMask
    $SubnetId2 = Get-IPNetwork -IPAddr $IPAddr2 -SubnetMask $SubnetMask
    if ($SubnetId1 -eq $SubnetId2) {
        return $true
    }
    else {
        return $false
    }
}