<#
$i = 5
while ( $i -le 10 ) {
    Write-Host 'Number' $i
    $i+=1
}
#>
<#
$i = 100
do {
    Write-Host 'Number' $i
    $i+=10
} while ( $i -le 150 ) 
#>
<#
$i = 128
do {
    Write-Host 'Number' $i
$i+=128
} until ( $i -gt 768 ) 
#>
<#
for ($k=-9; $k -ge -24; $k -=3) {
    Write-Host 'Number' $k
} 
#>
<#
$listing = Get-ChildItem
#Write-Host $listing
foreach ( $file in $listing ) {
    Write-Host $file
    $file.Name
    $file.length
} 
#>

$skip = 1
for ($k=3; $k -le 12; $k +=1) {
    Write-Host 'Number' $k
    if (($skip % 3) -ne 0){
        Write-Host 'Confirm' $k
        $skip+=1
    }
    $skip+=1
}