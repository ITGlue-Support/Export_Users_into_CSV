$newcsv = {} | Select-Object 'Name', 'Email','Role','CreatedAt','MyGlueUser' | Export-Csv -NoTypeInformation userlist.csv
$csvfile = Import-Csv userlist.csv
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
 
$headers.Add("Content-Type", "application/vnd.api+json")
 
$headers.Add("x-api-key", "ITG.f52627ad7268c88f12e313a62e4685d8.MGXpYGDhWGrQ8mv3HqVwd-pES8RJmMsWDbpm9p4gTRRTIwAZsef9DjAT5f9HBRWe")
$response = Invoke-RestMethod 'https://api.itglue.com/users?page[size]=100' -Method 'GET' -Headers $headers
 
$exportresponse = $response | ConvertTo-Json
$fetchattri = $exportresponse | ConvertFrom-Json
ForEach ($item in $fetchattri.data){
$getname = $item.attributes | ConvertTo-Json | Select-String -Pattern 'name=([a-z0-9!#\$%&*+/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)' | ForEach-Object {$_.matches.groups[1].value}
If ($getname -eq $null){
 
	$getname = $item.attributes | ConvertTo-Json | Select-String -Pattern 'name=(\w+ \w+)' | ForEach-Object {$_.matches.groups[1].value}
}
$getemail = $item.attributes | ConvertTo-Json | Select-String -Pattern 'email=([a-z0-9!#\$%&*+/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)' | ForEach-Object {$_.matches.groups[1].value}
$getrole = $item.attributes | ConvertTo-Json | Select-String -Pattern 'role-name=(\w*)' | ForEach-Object {$_.matches.groups[1].value}
$getcreateat = $item.attributes | ConvertTo-Json | Select-String -Pattern 'created-at=(\d*-\d*-\d*[A-Z]\d*:\d*:\d*)' | ForEach-Object {$_.matches.groups[1].value}
 
$getmyglueinfo = $item.attributes | ConvertTo-Json | Select-String -Pattern 'my-glue=(\w*)' | ForEach-Object {$_.matches.groups[1].value}
Write-Host $getname" "$getemail" "$getrole" "$getcreatedat" "$getmyglueinfo
 
$csvfile | select @{N="Name";E={$getname}},@{N="email";E={$getemail}},@{N="Role";E={$getrole}},@{N="CreatedAt";E={$getcreateat}},@{N="MyGlueUser";E={$getmyglueinfo}} | export-CSV userlist.csv -Append -NoTypeInformation
}
