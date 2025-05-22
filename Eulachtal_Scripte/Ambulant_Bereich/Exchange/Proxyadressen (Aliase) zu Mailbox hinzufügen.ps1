

Import-Module ExchangeOnlineManagement


# An Exchange Online via Powershell anmelden. Passwort findest du im Passwort Tool


Connect-ExchangeOnline -UserPrincipalName  Informatik_Eulachtal@spitex-eulachtal.ch




Set-Mailbox "systemmails@eulachtal.ch" -EmailAddresses @{add="abacus@eulachtal.ch"}

Set-Mailbox "systemmails@eulachtal.ch" -EmailAddresses @{add="noreply@eulachtal.ch"}

Set-Mailbox "systemmails@eulachtal.ch" -EmailAddresses @{add="misa@eulachtal.ch"}