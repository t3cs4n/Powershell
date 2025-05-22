<#

 Connect to ExchangeOnline without credentials.

#>


Import-Module ExchangeOnlineManagement


Connect-ExchangeOnline -UserPrincipalName eulachtal.global@eulachtal.ch -DelegatedOrganization pflegeeulachtal.onmicrosoft.com

Get-Mailbox -Identity bosu@eulachtal.ch

Set-Mailbox bosu@eulachtal.ch -CustomAttribute1 'Kader Pflege Stationär'


