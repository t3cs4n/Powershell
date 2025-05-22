# Importieren des ExchangeOnline Managment Moduls


Import-Module ExchangeOnlineManagement


# An Exchange Online via Powershell anmelden. Passwort findest du im Passwort Tool


Connect-ExchangeOnline -UserPrincipalName admin@pflegeeulachtal.onmicrosoft.com


<#
     
  
#>

Get-UnifiedGroup -Identity palliativcare@spitex-eulachtal.ch | Get-UnifiedGroupLinks -LinkType Member | Select-Object DisplayName,PrimarySmtpAddress | Out-Gridview

Get-UnifiedGroup -Identity palliativcare@spitex-eulachtal.ch | Get-UnifiedGroupLinks -LinkType Member | Select-Object DisplayName,PrimarySmtpAddress | Export-CSV \\netapp01\daten\03_IT\000._AADS_UND_ADS_EXPORTE_CLEANING__\SPITEX\AAD_UND_AD_Exporte\CSV\palliativcare_memberslist.csv -Encoding UTF8 -NoTypeInformation



# Original Code : Get-UnifiedGroup -Identity KaderPE1@eulachtal.ch | Get-UnifiedGroupLinks -LinkType Member | Select DisplayName,PrimarySmtpAddress | Export-CSV c:\KaderPE1@eulachtal.ch_memberslist.csv -NoTypeInformation


