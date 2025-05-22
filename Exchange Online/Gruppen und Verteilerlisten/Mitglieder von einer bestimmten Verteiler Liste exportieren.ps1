# Importieren des ExchangeOnline Managment Moduls


Import-Module ExchangeOnlineManagement


# An Exchange Online via Powershell anmelden. Passwort findest du im Passwort Tool


Connect-ExchangeOnline -UserPrincipalName admin@pflegeeulachtal.onmicrosoft.com


<#
     
  
#>
  


Get-DistributionGroupMember -Identity todesfall@eulachtal.ch -ResultSize Unlimited | Select-Object Name, PrimarySMTPAddress, RecipientType | Export-Csv \\netapp01\daten\03_IT\000._AADS_UND_ADS_EXPORTE_CLEANING__\EULACHTAL\AAD_UND_AD_Exporte\Todesfall@eulachtal.ch_Mitglieder_Liste.csv -Encoding UTF8


 
 # Original Code : Get-DistributionGroupMember -Identity KaderPE1@eulachtal.ch -ResultSize Unlimited | Select Name, PrimarySMTPAddress, RecipientType | Export-Csv c:\KaderPE1@eulachtal.ch_memberslist.csv