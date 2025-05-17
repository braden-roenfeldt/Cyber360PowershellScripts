<#
$yours=Read-Host "What is your favorite color?"
$mine='blue'
if ($yours -eq $mine ){
    Write-Host 'Our favorite colors are the same!'
} else {
    Write-Host "We dont have the same favorite color"
}
#>
<#
$answer=Get-Random -Minimum 1 -Maximum 10
$guess=Read-Host "What is your guess?"

if ($answer -gt $guess){
    "higher"
} elseif ($answer -lt $guess) {
    "lower"
} else {
    "correct"
}
#>
<#
$command=Read-Host @'
What would you like to do?
1. Start
2. Stop
3. Continue
4. Quit
Enter Choice: 
'@
switch -Wildcard ($command) {
{$_ -eq '1' -or $_ -like 'sta*'} {'Starting'}
{$_ -eq '2' -or $_ -like 'sto*'} {'Stopping'}
{$_ -eq '3' -or $_ -like 'c*'} {'Continuing'}
{$_ -eq '4' -or $_ -like 'q*'} {'Quitting'}
Default {'Invalid Command'}
}
#>

switch (1){
    1 {'this matches'
        break}
    2 {'this doesn''t'}
    1 {'so does this'}
}