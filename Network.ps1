<# Program Name : brenner-Network.psm1 
Date: 11-JUL-2025 Author: Brenner

Academic Course: CYBER 360 
I, Brenner M., affirm that I wrote this script 
as original work completed by me. 


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
Export-ModuleMember -class MAC