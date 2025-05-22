# Change UPN Suffix of users in specific OU to eulachtal.ch


# Importiere das Active Directory Modul
Import-Module ActiveDirectory

# Definiere die Distinguished Name (DN) der OU
$ou = "OU=Ambulant,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"  # Ersetze dies durch die DN deiner OU

# Definiere den neuen UPN-Suffix
$newUPNSuffix = "eulachtal.ch"

# Initialisiere Listen für erfolgreiche und fehlgeschlagene Aktualisierungen
$successfulUsers = @()
$failedUsers = @()

# Hole alle Benutzer aus der angegebenen OU
$users = Get-ADUser -Filter * -SearchBase $ou -Properties UserPrincipalName

# Durchlaufe jeden Benutzer und setze den UPN-Suffix
foreach ($user in $users) {
    # Extrahiere den aktuellen UPN (ohne Suffix)
    $currentUPN = $user.UserPrincipalName.Split('@')[0]

    # Erstelle den neuen UPN mit dem neuen Suffix
    $newUPN = "$currentUPN@$newUPNSuffix"

    # Versuche, den UPN zu aktualisieren
    try {
        Set-ADUser -Identity $user -UserPrincipalName $newUPN -ErrorAction Stop
        # Füge den Benutzer zur Liste der erfolgreichen Aktualisierungen hinzu
        $successfulUsers += [PSCustomObject]@{
            SamAccountName = $user.SamAccountName
            OldUPN         = $user.UserPrincipalName
            NewUPN         = $newUPN
        }
        Write-Host "UPN für $($user.SamAccountName) wurde auf $newUPN gesetzt."
    } catch {
        # Füge den Benutzer zur Liste der fehlgeschlagenen Aktualisierungen hinzu
        $failedUsers += [PSCustomObject]@{
            SamAccountName = $user.SamAccountName
            OldUPN         = $user.UserPrincipalName
            Reason         = $_.Exception.Message
        }
    }
}

# Gib die Liste der erfolgreichen Aktualisierungen aus
if ($successfulUsers.Count -gt 0) {
    Write-Host "`nDie folgenden Benutzer wurden erfolgreich aktualisiert:"
    $successfulUsers | Format-Table -AutoSize
} else {
    Write-Host "`nEs wurden keine Benutzer erfolgreich aktualisiert."
}

# Gib die Liste der fehlgeschlagenen Aktualisierungen aus
if ($failedUsers.Count -gt 0) {
    Write-Host "`nDie folgenden Benutzer konnten nicht aktualisiert werden:"
    $failedUsers | Format-Table -AutoSize
} else {
    Write-Host "`nEs gab keine fehlgeschlagenen Aktualisierungen."
}

Write-Host "`nUPN-Suffix-Update abgeschlossen."

