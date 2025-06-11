<#
Script name: manipulate.ps1
Course: CIT 361
Date: 07 JUN 2025
Authors: Brenner, Braden
Affidavit: I, (We) affirm this script is my (our) original work.
Citations: We leveraged ideas and help from the following sources:
    -- Microsoft Copilot
#> 

#prints out all the info from the database file
function get-MACAddressMult{
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
        Start-Sleep -Seconds 2.5 #delay to prevent api 'too many requests' error
        $vendor = Get-OnlineVendors -macAddress $mac
        if ($vendor) { $vendorList += $vendor }
    }
    return $vendorList
}

function Get-OnlineVendors {
    param ([string]$macAddress)
    $url = "https://api.maclookup.app/v2/macs/" 
    $url += $macAddress
    $response = Invoke-RestMethod -Uri $url -Method Get
    return $response.company
}

function Get-MACVendor {
    param ([string]$vendorName,[string]$filePath)
    If ($vendorName -eq ''){
        $vendor_names = @()
        $vendor_names = Get-NetMacs
        return $vendor_names
    }
    If ($filePath -eq $Null){
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

#Braden's Code!
function Format-Songs  {
    [CmdletBinding()]
    param([string]$DatabasePath,[string]$OutPath)
    
    #Check if file exists
    if (-not (Test-Path -Path $DatabasePath)) {
        throw "Database file not found: $DatabasePath"
    }
    #Assign file to variable
    $songData = Get-Content -Path $DatabasePath -ErrorAction Stop

    #loop throught the file, deliminate at tabs and add to array
    $songs = @()
    foreach ($line in $songData) {
        if ($line.Trim() -ne "") {
            $fields = $line -split '\t' | ForEach-Object { $_.Trim() }
            if ($fields.Count -ge 3) {
                $songs += [PSCustomObject]@{
                    Title = $fields[0]
                    Album = $fields[1]
                    Year = $fields[2]
                }
            }
        }
    }

    #sort all the songs by album
    $sortedSongs = $songs | Group-Object -Property Album | Sort-Object { [int]($_.Group[0].Year) }
    

    #Create report header
    $report = @()
    $report += "Song Report"
    $report += "=" * 50
    $report += ""

    #loop through each song and add to end of report
    foreach ($albumGroup in $sortedSongs) {
        $albumYear = $albumGroup.Group[0].Year
        $albumHeader = "ALBUM: $($albumGroup.Name)"
        if ($albumYear) {
            $albumHeader += " ($albumYear)"
        }
        
        #spacer between albums
        $report += $albumHeader
        $report += "-" * 30
        
        #sort album songs
        $sortedSongs = $albumGroup.Group | Sort-Object Title
        
        foreach ($song in $sortedSongs) {
            $report += "  $($song.Title)"
        }
        
        $report += ""
    }
    
    #convert array to string
    $reportText = $report -join "`n"
    
    # save to file if requested
    if ($OutPath) {
        try {
            $reportText | Out-File -FilePath $OutPath -Encoding UTF8 -ErrorAction Stop
            Write-Host "Report saved to: $OutPath"
        }
        catch {
            throw "Failed to write report file: $($_.Exception.Message)"
        }
    }
    
    return $reportText
}



$vendorSearch = Read-Host "Enter vendor name to search"
$dataPath = "MACDatabase.txt"
$foundMacs = Get-MACVendor -vendorName $vendorSearch -filePath $dataPath
$foundMacs | ForEach-Object { Write-Output $_ }
Format-Songs -DatabasePath "RushSongs.txt"
Format-Songs -DatabasePath "RushSongs.txt" -OutPath "SongReport.txt"

#Example usage
#$vendors = get-NetMacs
#Write-Output "Discovered Vendors: $vendors"