Import-Module ExchangeOnlineManagement


Connect-ExchangeOnline -UserPrincipalName Informatik_Eulachtal@spitex-eulachtal.ch

Get-Mailbox -Identity bosu@eulachtal.ch

Set-Mailbox bosu@eulachtal.ch -CustomAttribute1 'Kader Pflege Stationär'