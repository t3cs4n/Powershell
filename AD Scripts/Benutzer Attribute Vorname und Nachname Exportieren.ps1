
$OU = 'OU=BENUTZER,OU=EULACHTAL_SPITEX,DC=EULACHTAL,DC=ZH'


Get-ADUser -Filter * -SearchBase $OU | Select-Object -Property GivenName,Surname | Out-GridView


Get-ADUser -Filter * -SearchBase $OU | Select-Object -Property GivenName,Surname | Export-Csv -Path \\netapp01\daten\03_IT\000.__AADS_UND_ADS_EXPORTE_CLEANING__\SPITEX\AAD_UND_AD_Exporte\CSV\Benutzer_Vorname_Nachname.csv -NoTypeInformation -Encoding UTF8