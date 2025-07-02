#take human readable string and turn into base 64 encoding to be executed
[Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes("Write-Host test"))

#executing base64 encoded text
#powershell.exe -e "<base 64 text>"

#Take 64 encoding and turn into human readable text
[System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String("VwByAGkAdABlAC0ASABvAHMAdAAgAHQAZQBzAHQA"))