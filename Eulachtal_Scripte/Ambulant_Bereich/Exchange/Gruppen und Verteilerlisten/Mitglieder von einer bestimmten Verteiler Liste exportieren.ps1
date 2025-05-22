# Importieren des ExchangeOnline Managment Moduls


Import-Module ExchangeOnlineManagement


# An Exchange Online via Powershell anmelden. Passwort findest du im Passwort Tool


Connect-ExchangeOnline -UserPrincipalName  Informatik_Eulachtal@spitex-eulachtal.ch


<#
     
  
#>
  


Get-DistributionGroupMember -Identity KaderPE1@eulachtal.ch -ResultSize Unlimited | Select Name, PrimarySMTPAddress, RecipientType | Export-Csv C:\Downloads\spitex_eulachtal_KaderPE1_eulachtal.ch_memberslist.csv


 
