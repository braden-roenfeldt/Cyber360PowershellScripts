function Get-MACVendor {
    <#
    .SYNOPSIS
    Looks up MAC address vendor information from a tshark manufacturer database.
    
    .DESCRIPTION
    This function takes a MAC address and/or database path to return vendor information.
    If no MAC address is provided, it discovers local network adapters and returns all their vendors.
    
    .PARAMETER MACAddress
    The MAC address to look up (optional). Can be in various formats (XX:XX:XX:XX:XX:XX, XX-XX-XX-XX-XX-XX, etc.)
    
    .PARAMETER DatabasePath
    The path to the manufacturer database file created by 'tshark -G manuf > MACDatabase.txt' (mandatory)
    
    .EXAMPLE
    Get-MACVendor -MACAddress "00:50:56:C0:00:01" -DatabasePath "MACDatabase.txt"
    Returns the vendor for the specified MAC address
    
    .EXAMPLE
    Get-MACVendor -DatabasePath "MACDatabase.txt"
    Returns an array of vendors for all local network adapters
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$MACAddress,
        
        [Parameter(Mandatory=$true)]
        [string]$DatabasePath
    )
    
    # Check if database file exists
    if (-not (Test-Path -Path $DatabasePath)) {
        throw "Database file not found: $DatabasePath"
    }
    
    # Function to normalize MAC address format
    function Normalize-MACAddress {
        param([string]$MAC)
        
        # Remove common separators and convert to uppercase
        $cleanMAC = $MAC -replace '[:-]', '' -replace '\.', ''
        $cleanMAC = $cleanMAC.ToUpper()
        
        # Ensure we have at least 6 characters for OUI lookup
        if ($cleanMAC.Length -lt 6) {
            throw "Invalid MAC address format: $MAC"
        }
        
        # Return first 6 characters (OUI - Organizationally Unique Identifier)
        return $cleanMAC.Substring(0, 6)
    }
    
    # Function to lookup vendor from database
    function Get-VendorFromDatabase {
        param([string]$OUI)
        
        try {
            # Read the database file
            $databaseContent = Get-Content -Path $DatabasePath -ErrorAction Stop
            
            # Look for the OUI in the database
            # The tshark manuf format is: OUI<tab>ShortName<tab>LongName
            foreach ($line in $databaseContent) {
                # Skip comments and empty lines
                if ($line -match '^#' -or $line.Trim() -eq '') {
                    continue
                }
                
                # Split by tab
                $fields = $line -split '\t'
                if ($fields.Count -ge 3) {
                    $dbOUI = $fields[0].Trim()
                    $longName = $fields[2].Trim()
                    
                    # Check if OUI matches (case-insensitive)
                    if ($dbOUI -eq $OUI) {
                        return $longName
                    }
                }
            }
            
            # If no exact match found, return "Unknown"
            return "Unknown"
        }
        catch {
            throw "Error reading database file: $_"
        }
    }
    
    # Main logic
    if ($MACAddress) {
        # Single MAC address lookup
        try {
            $normalizedOUI = Normalize-MACAddress -MAC $MACAddress
            $vendor = Get-VendorFromDatabase -OUI $normalizedOUI
            return $vendor
        }
        catch {
            throw "Error processing MAC address '$MACAddress': $_"
        }
    }
    else {
        # Discover local network adapters and get their vendors
        try {
            $adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" -and $null -ne $_.MacAddress }
            
            if ($adapters.Count -eq 0) {
                throw "No active network adapters found"
            }
            
            $vendors = @()
            foreach ($adapter in $adapters) {
                try {
                    $normalizedOUI = Normalize-MACAddress -MAC $adapter.MacAddress
                    $vendor = Get-VendorFromDatabase -OUI $normalizedOUI
                    $vendors += $vendor
                }
                catch {
                    Write-Warning "Could not process adapter '$($adapter.Name)' with MAC '$($adapter.MacAddress)': $_"
                    $vendors += "Unknown"
                }
            }
            
            return $vendors
        }
        catch {
            throw "Error discovering network adapters: $_"
        }
    }
}

# Example usage:
# First, create the database file by running in command prompt:
# tshark -G manuf > MACDatabase.txt

# Then use the function:
 Get-MACVendor -MACAddress "00:50:56:C0:00:01" -DatabasePath "MACDatabase.txt"
 Get-MACVendor -DatabasePath "MACDatabase.txt"