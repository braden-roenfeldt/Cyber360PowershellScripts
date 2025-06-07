<#
Script name: manipulate.ps1
Course: CIT 361
Date: 07 JUN 2025
Authors: Brenner, Braden
Affidavit: I, (We) affirm this script is my (our) original work.
Citations: We leveraged ideas and help from the following sources:
    -- Microsoft Copilot
#> 

function get-OS{
    if ($IsLinux) {
    Write-Output "Running on Linux"
    } 
    elseif ($IsWindows) {
    Write-Output "Running on Windows"
    } 
    else {
    Write-Output "Unknown OS?"
    }
}

function get-MACAddress{
    # Define the file path
    $filePath = "MACDatabase.txt"

    # Define the MAC address to search for
    $searchMac = "00:1A:2B:3C:4D:5E"  # Example

    # Read all lines from the file and 
    #filter based on the search string
    $macMatch = Get-Content $filePath | Where-Object { 
        $_ -match $searchMac }

    # Output result
    if ($macMatch) {
        Write-Output "MAC Address Found: $macMatch"
        Return $macMatch
    }
    else {
    Write-Output "MAC Address '$searchMac' not found."
    throw "Error Occured.  MAC Address '$searchMac' not found."
    }
}

function get-MACAddressMult{
    #TODO Returns MAC Adress String
    # Define the file path
    $filePath = "MACDatabase.txt"

    # Read all lines from the file
    $macList = Get-Content $filePath | 
        Where-Object {
        $_ -match "([0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}" }

    # Remove duplicates & format output
    $uniqueMacs = $macList | Sort-Object | Get-Unique

    # Display MAC addresses
    Write-Output "Extracted MAC Addresses:"
    $uniqueMacs
    }


function get-NetMacs{
    #param()
    # Get MAC addresses
    $macAddresses = if ($IsWindows) {
        Get-NetAdapter | Select-Object -ExpandProperty MacAddress
    } else {
        (ip link show | Select-String -Pattern "link/ether").Line.Split(" ")[1]
    }

    # Lookup vendors
    $vendorList = @()
    foreach ($mac in $macAddresses) {
        $vendor = Get-OnlineVendors -macAddress $mac
        if ($vendor) { $vendorList += $vendor }
    }
    return $vendorList
}

function Get-OnlineVendors {
    param ([string]$macAddress)
    $url = "https://api.maclookup.app/v2/macs/$macAddress"
    $response = Invoke-RestMethod -Uri $url -Method Get
    return $response.vendor
}

function Get-MACVendor {
    param (
        [string]$vendorName,
        [string]$filePath
        )
    If ($vendorName = ''){
        Get-NetMacs
    }
    If ($filePath=$Null){
        throw "filepath database not found."
    }
    else{
    # Read all lines and filter based on the vendor name
    $macMatches = Get-Content $filePath | Where-Object { 
        $_ -match $vendorName }

    # Extract MAC addresses from matched lines
    $macList = $macMatches | ForEach-Object {
        if ($_ -match 
        "([0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}") {
            $matches[0]  # Extracts the MAC address
        }
    }
    }

    # Return results
    if ($macList) {
        Write-Output "MAC Addresses for Vendor '$vendorName':"
        return $macList
    } else {
        Write-Output "No MAC addresses found for vendor '$vendorName'."
    }
}

<#function Get-MACVendor {
    param (<#MACAddress DatabasePath#>
    #TODO
    #param MacAddress     String 
    #param DatabasePath   file containing database
    #Needs to Throw an Error if database cannot be found.  (Use THROW)
    #If a Mac Address is specified, return the full vendor's name.
    #Else, discover MAC Adress on computer network adapters
        #look up the vendor of each address, 
        #need to return an array containing each vendor name
        #TIP Use Get-NetAdapter to list ip addresses.  


#>


#get-MACAddressMult
#get-MACAddress
$vendorSearch = Read-Host "Enter vendor name to search"
$dataPath = "MACDatabase.txt"
$foundMacs = Get-MACVendor -vendorName $vendorSearch -filePath $dataPath
$foundMacs | ForEach-Object { Write-Output $_ }

# Example usage
#$vendors = get-NetMacs
#Write-Output "Discovered Vendors: $vendors"


