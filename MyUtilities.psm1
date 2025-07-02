#variable to hold the utilities module preference
$UtilitiesProgress='SilentlyContinue'


function Get-UtilitiesProgressPreference {
    $UtilitiesProgress    
}
function Set-UtilitiesProgressPreference {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('SilentlyContinue', 'Continue')]
        $preference
    )
    $Script:UtilitiesProgress=$preference
}
Function Get-WebFile{
    param(
        [Parameter(Mandatory)]
        [string]$Uri,
        [Parameter(Mandatory)]
        [string]$OutFile
    )
    #save current preference
    $pref=$Global:ProgressPreference
    #Use modeule preference
    $Global:ProgressPreference=$UtilitiesProgress
    Invoke-WebRequest -Uri $Uri -OutFile $OutFile
    #Restore Preference
    $Global:ProgressPreference=$pref
}
