<#

  Autor : Miguel Santiago


  Mit diesem Script kann eine Liste der vorhandenen Benutzer Postfächer exportiert werden.
    

#>


Install-Module -Name Get-MailboxDatabase

Install-Module -Name Get-MailboxStatistics

Install-Module ExchangeOnlineManagement


Get-Module -ListAvailable -Name ExchangeOnlineManagement

Update-Module ExchangeOnlineManagement


Get-MailboxDatabase | Get-MailboxStatistics | Where-Object{ $_.DisconnectDate -ne $null } |Format-List DisplayName, Database, Identity, DisconnectReason


Connect-ExchangeOnline
