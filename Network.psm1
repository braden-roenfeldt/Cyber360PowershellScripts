<# Program Name : brenner-Network.psm1 
Date: 11-JUL-2025 Author: Brenner, Braden

Academic Course: CYBER 360 
We, Brenner & Braden, affirm that we wrote this script 
as original work completed by us. 


AI Helpers:
Microsoft Copilot
#>

# NOTE: Requires Powershell -Version 5.0 for class support!

class MAC {
    [string] $Address # holds the MAC address
    
    [string] $Vendor # contains vendor's full name

    #constructor; takes MAC address and sets the address property  
    MAC([string] $Address) {
        # fixes the address to use colon format rather than dashes
        $normalized = ($Address -replace '-', ':').ToUpper()
        $this.Address = $normalized

        # Populate Vendor by querying a public API 
        # NOTE: fallback programmed: “Unknown Vendor”
        try {
            $oui = [MAC]::MACVendorID($this.Address)
            $this.Vendor = Invoke-RestMethod -Uri "https://api.macvendors.com/$oui" -UseBasicParsing
        }
        catch {
            $this.Vendor = "Unknown Vendor"
        }
    }

    # Instance method: returns the vendor portion of the 
    # instance MAC address
    [string] MACVendorID() {
        return [MAC]::MACVendorID($this.Address)
    }

    # Static method: accepts any MAC string 
    # and returns first three octets
    static [string] MACVendorID([string] $Address) {
        $addr = ($Address -replace '-', ':').ToUpper()
        $parts = $addr.Split(':')
        if ($parts.Count -lt 3) {
            throw "Invalid MAC address format: $Address"
        }
        return ($parts[0..2] -join ':')
    }
}

# Exposes the class when the module is imported
# Export-ModuleMember -Class MAC

#functions
function Get-MACVendor {
    <#
    .SYNOPSIS
    Retrieves the vendor name for a given MAC address.

    .DESCRIPTION
    Normalizes the MAC format, extracts the OUI (first 3 octets), 
    then queries a public API for the vendor name.

    .PARAMETER Address
    A MAC address in any common format (colons, dashes, or dots).

    .OUTPUTS
    String  Vendor name or an error message.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Address
    )

    # Normalize MAC to colon-separated uppercase
    $normalized = ($Address -replace '[-\.]', ':').ToUpper()

    # Extract OUI
    $oui = ($normalized -split ':')[0..2] -join ':'

    try {
        $vendor = Invoke-RestMethod -Uri "https://api.macvendors.com/$oui" -UseBasicParsing
    }
    catch {
        $vendor = "Vendor not found or API unreachable"
    }

    return $vendor
}

function Get-IPNetwork {
    <#
    .SYNOPSIS
    Calculates network details from a CIDR notation.

    .DESCRIPTION
    Accepts an IP address in CIDR format (e.g. 192.168.1.10/24), 
    computes the network address, broadcast address, subnet mask, 
    and returns them as a custom object.

    .PARAMETER CIDR
    An IPv4 address with a prefix length (e.g. 10.0.0.5/16).

    .OUTPUTS
    PSCustomObject with properties:
      NetworkAddress
      BroadcastAddress
      Netmask
      PrefixLength
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position=0)]
        [string] $CIDR
    )

    if ($CIDR -notmatch '^(.+)\/(\d{1,2})$') {
        throw "Input must be in CIDR format, e.g. 192.168.1.10/24"
    }

    $ipString   = $matches[1]
    $prefix     = [int]$matches[2]

    # Convert IP to UInt32
    $bytes      = [System.Net.IPAddress]::Parse($ipString).GetAddressBytes()
    [array]::Reverse($bytes) 
    $addrUInt32 = [BitConverter]::ToUInt32($bytes, 0)

    # Build subnet mask as UInt32
    $maskUInt32    = ((0xFFFFFFFF -shl (32 - $prefix)) -band 0xFFFFFFFF)
    $networkUInt32 = $addrUInt32 -band $maskUInt32
    $bcastUInt32   = $networkUInt32 -bor ($maskUInt32 -band 0xFFFFFFFF)

    # Convert back to dotted-decimal
    $nwBytes = [BitConverter]::GetBytes($networkUInt32); [array]::Reverse($nwBytes)
    $bcBytes = [BitConverter]::GetBytes($bcastUInt32);   [array]::Reverse($bcBytes)
    $maskBytes = [BitConverter]::GetBytes($maskUInt32);  [array]::Reverse($maskBytes)

    [PSCustomObject] @{
        NetworkAddress   = [System.Net.IPAddress]::Parse(($nwBytes -join '.'))
        BroadcastAddress = [System.Net.IPAddress]::Parse(($bcBytes -join '.'))
        Netmask          = [System.Net.IPAddress]::Parse(($maskBytes -join '.'))
        PrefixLength     = $prefix
    }
}

function Test-IPNetwork {
    <#
    .SYNOPSIS
    Tests whether an IP address belongs to a specified network.

    .DESCRIPTION
    Given an IP (e.g. 192.168.1.50) and a network in CIDR 
    (e.g. 192.168.1.0/24), returns True if the IP is in that range.

    .PARAMETER IPAddress
    The IPv4 address to test.

    .PARAMETER Subnet
    The target network in CIDR format.

    .OUTPUTS
    Boolean
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $IPAddress,

        [Parameter(Mandatory)]
        [string] $Subnet
    )

    # Convert test IP to UInt32
    $ipBytes      = [System.Net.IPAddress]::Parse($IPAddress).GetAddressBytes()
    [array]::Reverse($ipBytes)
    $testUInt32   = [BitConverter]::ToUInt32($ipBytes, 0)

    # Get network info
    $net = Get-IPNetwork -CIDR $Subnet

    # Convert network & broadcast to UInt32
    $nwBytes    = [System.Net.IPAddress]::Parse($net.NetworkAddress).GetAddressBytes(); [array]::Reverse($nwBytes)
    $bcBytes    = [System.Net.IPAddress]::Parse($net.BroadcastAddress).GetAddressBytes(); [array]::Reverse($bcBytes)
    $nwUInt32   = [BitConverter]::ToUInt32($nwBytes, 0)
    $bcUInt32   = [BitConverter]::ToUInt32($bcBytes, 0)

    return ($testUInt32 -ge $nwUInt32) -and ($testUInt32 -le $bcUInt32)
}

