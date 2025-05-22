# Set rule save copy of sendonbehalf messages in shared mailbox sent folder for a single box



Install-Module -Name ExchangeOnlineManagement -Force

Import-Module ExchangeOnlineManagement


Connect-ExchangeOnline -UserPrincipalName informatik@eulachtal.ch

# Definiere das freigegebene Postfach
$SharedMailbox = "test.box@domain.com"

# Aktivieren der gesendeten Elemente-Regeln
Set-Mailbox -Identity $SharedMailbox -MessageCopyForSentAsEnabled $true -MessageCopyForSendOnBehalfEnabled $true

# Überprüfen der Einstellungen
Get-Mailbox -Identity $SharedMailbox | Select-Object DisplayName, MessageCopyForSentAsEnabled, MessageCopyForSendOnBehalfEnabled


