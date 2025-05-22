# Set SendOnBehalf rule for all shared mailboxes with login prompt (User must have )


<#

Um das Skript erfolgreich auszuführen und die Set-Mailbox-Befehle auf freigegebene Postfächer in Exchange Online anzuwenden, benötigt der Benutzer die entsprechenden Berechtigungen. Folgende Rollen oder Gruppen müssen dem Benutzer zugewiesen werden:

1. Exchange-Administrator (Exchange Admin Role)

Der Benutzer muss eine der Exchange-Administratorenrollen haben, um Änderungen an Mailboxen in Exchange Online vorzunehmen. Die notwendigen Rollen umfassen:
	•	Exchange-Administrator (Exchange Administrator): Diese Rolle gewährt dem Benutzer vollständige Berechtigungen für das Verwalten von Exchange Online. Sie ist erforderlich, um alle Mailbox-Einstellungen (einschließlich freigegebener Postfächer) zu ändern.

Um diese Rolle zuzuweisen, kannst du dies über das Microsoft 365 Admin Center oder per PowerShell tun.

#>


Connect-ExchangeOnline -UserPrincipalName informatik@eulachtal.ch

# Hole alle freigegebenen Postfächer
$SharedMailboxes = Get-Mailbox -RecipientTypeDetails SharedMailbox

# Zeige die Liste der freigegebenen Postfächer an
$SharedMailboxes | Select-Object DisplayName, PrimarySmtpAddress

# Aktivieren der gesendeten Elemente-Regeln für alle freigegebenen Postfächer
$SharedMailboxes | ForEach-Object {
  $SharedMailbox = $_.PrimarySmtpAddress
  Write-Host "Aktiviere Regeln für: $SharedMailbox"
  Set-Mailbox -Identity $SharedMailbox -MessageCopyForSentAsEnabled $true -MessageCopyForSendOnBehalfEnabled $true
}

# Überprüfen der Einstellungen nach der Änderung
$SharedMailboxes | ForEach-Object {
  $SharedMailbox = $_.PrimarySmtpAddress
  Get-Mailbox -Identity $SharedMailbox | Select-Object DisplayName, MessageCopyForSentAsEnabled, MessageCopyForSendOnBehalfEnabled
}

Disconnect-ExchangeOnline -Confirm:$false



# Script for updating newer shared mailboxes and activate SendOnBehalf rule for all boxes that has the rule set


# Mit Exchange Online verbinden

<#


Connect-ExchangeOnline -UserPrincipalName <DeinAdminKonto>

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


#>