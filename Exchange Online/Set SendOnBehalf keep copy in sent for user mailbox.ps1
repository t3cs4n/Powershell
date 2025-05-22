# Set SendOnBehalf keep copy in sent folder rule for user mailboxes


# Verbindung zu Exchange Online
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName "informatik@eulachtal.ch"

# Definiere das Benutzerpostfach
$UserMailbox = "test.box@eulachtal.ch"

try {
    # Prüfen, ob die Einstellungen bereits aktiviert sind
    $MailboxSettings = Get-Mailbox -Identity $UserMailbox | Select-Object MessageCopyForSentAsEnabled, MessageCopyForSendOnBehalfEnabled

    if (-not $MailboxSettings.MessageCopyForSentAsEnabled -or -not $MailboxSettings.MessageCopyForSendOnBehalfEnabled) {
        # Einstellungen aktivieren
        Set-Mailbox -Identity $UserMailbox -MessageCopyForSentAsEnabled $true -MessageCopyForSendOnBehalfEnabled $true
        Write-Host "Gesendete Elemente-Regeln für ${UserMailbox} wurden aktiviert."
    } else {
        Write-Host "Gesendete Elemente-Regeln für ${UserMailbox} sind bereits aktiviert."
    }
} catch {
    Write-Host "Fehler bei der Verarbeitung von ${UserMailbox}: $($_.Exception.Message)"
}

# Verbindung trennen
Disconnect-ExchangeOnline -Confirm:$false