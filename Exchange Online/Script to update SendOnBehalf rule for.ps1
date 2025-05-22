# Script  to update SendOnBehalf rule for new share mailboxes



# Mit Exchange Online verbinden
Connect-ExchangeOnline -UserPrincipalName informatik@eulachtal.ch

# Alle freigegebenen Postfächer abrufen (einschließlich neu erstellter)
$SharedMailboxes = Get-Mailbox -RecipientTypeDetails SharedMailbox

# Gesendete Elemente für jedes freigegebene Postfach aktivieren
foreach ($Mailbox in $SharedMailboxes) {
    # Falls die Einstellung nicht bereits aktiv ist, wird sie aktiviert
    if (-not $Mailbox.MessageCopyForSentAsEnabled) {
        Set-Mailbox -Identity $Mailbox.Identity -MessageCopyForSentAsEnabled $true -MessageCopyForSendOnBehalfEnabled $true
        Write-Host "Gesendete Elemente für $($Mailbox.DisplayName) wurden aktiviert"
    }
}

