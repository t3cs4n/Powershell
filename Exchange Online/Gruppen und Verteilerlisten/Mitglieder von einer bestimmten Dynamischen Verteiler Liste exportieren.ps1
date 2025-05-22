# Importieren des ExchangeOnline Managment Moduls


Import-Module ExchangeOnlineManagement


# An Exchange Online via Powershell anmelden. Passwort findest du im Passwort Tool


Connect-ExchangeOnline -UserPrincipalName admin@pflegeeulachtal.onmicrosoft.com


<#
 
 Führe nun erst die Zeile mit der Variable aus > $DynamischeGruppeMitglieder = Get-DynamicDistributionGroup Kader Pflege Stationär      
  
#>

$DynamischeGruppeMitglieder = Get-DynamicDistributionGroup "Kader Pflege Stationär"


Get-Recipient -RecipientPreviewFilter $DynamischeGruppeMitglieder.RecipientFilter | Select-Object Name,PrimarySmtpAddress,RecipientType | Out-GridView

Get-Recipient -RecipientPreviewFilter $DynamischeGruppeMitglieder.RecipientFilter | Select-Object Name,PrimarySmtpAddress,RecipientType | Export-Csv \\netapp01\daten\03_IT\000._AADS_UND_ADS_EXPORTE_CLEANING__\EULACHTAL\AAD_UND_AD_Exporte\Proxy_Adressen_Mitarbeiter_Eulachtal.csv -Encoding UTF8 -NoTypeInformation





# Get-Recipient -RecipientPreviewFilter $DynamischeGruppeMitglieder.RecipientFilter | Select Name,PrimarySmtpAddress,RecipientType | Export-Csv "Gib hier den Pfad und Namen der CSV-Datei an" -NoTypeInformation