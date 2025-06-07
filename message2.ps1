<#
Script name: manipulate.ps1
Course: CIT 361
Date: 07 JUN 2025
Authors: Brenner Mann
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

function Get-MACByVendor {
    param ([string]$vendorName)

    # Define the file path
    $filePath = "MACDatabase.txt"

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

    # Return results
    if ($macList) {
        Write-Output "MAC Addresses for Vendor '$vendorName':"
        return $macList
    } else {
        Write-Output "No MAC addresses found for vendor '$vendorName'."
    }
}

<#
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
#>


function Get-MACVendor {
    param (<#MACAddress DatabasePath#>)
    #TODO
    #param MacAddress     String 
    #param DatabasePath   file containing database
    #Needs to Throw an Error if database cannot be found.  (Use THROW)
    #If a Mac Address is specified, return the full vendor's name.
    #Else, discover MAC Adress on computer network adapters
        #look up the vendor of each address, 
        #need to return an array containing each vendor name
        #TIP Use Get-NetAdapter to list ip addresses.  


}

#NOTE: Script needs to work correctly on both Windows and Linux.  
#Note: When Testing, use Tshark -g manuf > MACDatabase.txt 
    #to create vendor database file.  

function Format-Songs{
    param ()
    #TODO
    #Return formatted text report from RushSongs.txt
    #Param Database Path Path to RushSongs.txt
    #Param (Opt) OutPath
    #Throw Error if Database cannot be found.
    #Throw Error if reprot file cant be written.  

    #File Formatting: Album followed by indented songs, songs sorted alphabetically.
    <# 
    R40 Live (2015)
        The Story so Far
    Clockwork Angels Tour (2013)
        Drumbastica
        Here It Is!
        Peke's Repose
        The Percussor
    Clockwork Angels (2012)
        BU2B
    #>

}
#get-MACAddressMult
#get-MACAddress
$vendorSearch = Read-Host "Enter vendor name to search"
$foundMacs = Get-MACByVendor -vendorName $vendorSearch
$foundMacs | ForEach-Object { Write-Output $_ }