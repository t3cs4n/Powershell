# Importieren des ExchangeOnline Managment Moduls


Import-Module ExchangeOnlineManagement


# An Exchange Online via Powershell anmelden. Passwort findest du im Passwort Tool


Connect-ExchangeOnline -UserPrincipalName  Informatik_Eulachtal@spitex-eulachtal.ch


<#
 
 Führe nun erst die Zeile mit der Variable aus > $DynamischeGruppeMitglieder = Get-DynamicDistributionGroup Kader Pflege Stationär      
  
#>

$DynamischeGruppeMitglieder = Get-DynamicDistributionGroup "Kader Pflege Stationär"


Get-Recipient -RecipientPreviewFilter $DynamischeGruppeMitglieder.RecipientFilter | Select Name,PrimarySmtpAddress,RecipientType | Out-GridView

Get-Recipient -RecipientPreviewFilter $DynamischeGruppeMitglieder.RecipientFilter | Select Name,PrimarySmtpAddress,RecipientType | Export-Csv "Gib hier den Pfad und Namen der CSV-Datei an" -NoTypeInformation