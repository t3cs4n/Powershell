


$OU1 = "OU=spitex,OU=benutzer_intern_alle,OU=benutzer,OU=eulachtal,DC=eulachtal,DC=zh"
$OU2 = "OU=,OU=,OU=benutzer,OU=spitex,DC=eulachtal,DC=zh"

Get-ADUser -Filter * -SearchBase $OU1 | Move-ADObject -TargetPath $OU2