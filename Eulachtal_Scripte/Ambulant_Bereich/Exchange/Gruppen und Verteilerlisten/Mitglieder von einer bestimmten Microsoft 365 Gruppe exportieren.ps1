# Importieren des ExchangeOnline Managment Moduls


Import-Module ExchangeOnlineManagement


# An Exchange Online via Powershell anmelden. Passwort findest du im Passwort Tool


Connect-ExchangeOnline -UserPrincipalName  Informatik_Eulachtal@spitex-eulachtal.ch


<#
     
  
#>


Get-UnifiedGroup -Identity KaderPE1@eulachtal.ch | Get-UnifiedGroupLinks -LinkType Member | Select DisplayName,PrimarySmtpAddress | Export-CSV cC:\Downloads\spitex_eulachtal_KaderPE1_eulachtal.ch_memberslist.csv -NoTypeInformation


