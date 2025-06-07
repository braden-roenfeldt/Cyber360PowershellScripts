function Format-Songs {
    [CmdletBinding()]
    param([string]$DatabasePath,[string]$OutputPath)
    
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
    if ($OutputPath) {
        try {
            $reportText | Out-File -FilePath $OutputPath -Encoding UTF8 -ErrorAction Stop
            Write-Host "Report saved to: $OutputPath"
        }
        catch {
            throw "Failed to write report file: $($_.Exception.Message)"
        }
    }
    
    return $reportText
}

 Format-Songs -DatabasePath "RushSongs.txt"
 Format-Songs -DatabasePath "RushSongs.txt" -OutputPath "SongReport.txt"