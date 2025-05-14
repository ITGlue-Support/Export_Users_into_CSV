$newcsv = {} | Select-Object 'Name', 'Email','Role','CreatedAt','MyGlueUser','LastLogin' | Export-Csv -NoTypeInformation userlist.csv
$csvfile = Import-Csv userlist.csv
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
 
$headers.Add("Content-Type", "application/vnd.api+json")
 
$headers.Add("x-api-key", "ITG.5feb2d3811d61c01e54bb51f21cdcf61.rTMNharnGFPTGH5UehCztTIu_q1IhP1rDdnh16iXbUecTQ2exGEOU-ali-kzj55V")
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
$getlastlogin = $item.attributes | ConvertTo-Json | Select-String -Pattern 'last-sign-in-at=(\d*-\d*-\d*[A-Z]\d*:\d*:\d*)' | ForEach-Object {$_.matches.groups[1].value}
$getmyglueinfo = $item.attributes | ConvertTo-Json | Select-String -Pattern 'my-glue=(\w*)' | ForEach-Object {$_.matches.groups[1].value}

$csvfile | select @{N="Name";E={$getname}},@{N="email";E={$getemail}},@{N="Role";E={$getrole}},@{N="CreatedAt";E={$getcreateat}},@{N="MyGlueUser";E={$getmyglueinfo}}, @{N="LastLogin";E={$getlastlogin}}
 
$csvfile | select @{N="Name";E={$getname}},@{N="email";E={$getemail}},@{N="Role";E={$getrole}},@{N="CreatedAt";E={$getcreateat}},@{N="MyGlueUser";E={$getmyglueinfo}}, @{N="LastLogin";E={$getlastlogin}} | export-CSV userlist.csv -Append -NoTypeInformation
}
