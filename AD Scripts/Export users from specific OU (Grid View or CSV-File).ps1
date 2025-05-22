<#

 Autor : Miguel Santiago

 Mit diesem Script kannst du die Benutzerobjekte in einer Organisations Einheit (OU) exportieren.
 Die OU aus welcher du die Benutzer exportieren willst kannst du nach belieben anpassen.
 Passe dazu den Pfad der $OU Variable an. Im folgenden Beispiel werden alle Benutzer aus der OU "Benutzer Alle" exportiert. 

 Führe erst die Zeile 16 aus um die Variable zu setzten.


#>


$OU = 'OU=Benutzer,OU=EULACHTAL_SPITEX,DC=EULACHTAL,DC=ZH'


Get-ADUser -Filter * -SearchBase $OU -Properties proxyaddresses,EmailAddress | Select-Object Name,EmailAddress, @{L = "ProxyAddresses"; E = { ($_.ProxyAddresses -like 'smtp:*') -join ";"}} | Out-GridView


# Get-ADUser -Filter * -SearchBase $OU -Properties proxyaddresses,EmailAddress | Select-Object Name,EmailAddress, @{L = "ProxyAddresses"; E = { ($_.ProxyAddresses -like 'smtp:*') -join ";"}} | Export-Csv -Path \\netapp01\daten\03_IT\000.__AADS_UND_ADS_EXPORTE_CLEANING__\SPITEX\AAD_UND_AD_Exporte\CSV\Active_Directory_Spitex_Users.csv -Encoding UTF8




