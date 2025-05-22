<# 

  Change UPN of users from a specific OU to GivenName.Surname
  Append a List of users which could not be changed at the end

#>

# Importiere das Active Directory Modul
Import-Module ActiveDirectory

# Definiere die Distinguished Name (DN) der OU
$ou = "OU=Stationaer,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"  # Ersetze dies durch die DN deiner OU

# Initialisiere eine Liste für Benutzer, bei denen der UPN nicht aktualisiert werden konnte
$failedUsers = @()

# Hole alle Benutzer aus der angegebenen OU
$users = Get-ADUser -Filter * -SearchBase $ou -Properties GivenName, Surname, UserPrincipalName

# Durchlaufe jeden Benutzer und setze den UPN
foreach ($user in $users) {
    $vorname = $user.GivenName
    $nachname = $user.Surname

    # Überprüfe, ob Vorname und Nachname vorhanden sind
    if (-not $vorname -or -not $nachname) {
        $failedUsers += [PSCustomObject]@{
            SamAccountName = $user.SamAccountName
            Reason         = "Vorname oder Nachname fehlt"
        }
        continue
    }

    # Erstelle den neuen UPN im Format vorname.nachname
    $newUPN = "$vorname.$nachname@domain.com"  # Ersetze "domain.com" durch deine Domain

    # Versuche, den UPN zu aktualisieren
    try {
        Set-ADUser -Identity $user -UserPrincipalName $newUPN -ErrorAction Stop
        Write-Host "UPN für $($user.SamAccountName) wurde auf $newUPN gesetzt."
    } catch {
        # Füge den Benutzer zur Liste der fehlgeschlagenen Aktualisierungen hinzu
        $failedUsers += [PSCustomObject]@{
            SamAccountName = $user.SamAccountName
            Reason         = $_.Exception.Message
        }
    }
}

# Gib die Liste der Benutzer aus, bei denen der UPN nicht aktualisiert werden konnte
if ($failedUsers.Count -gt 0) {
    Write-Host "`nDie folgenden Benutzer konnten nicht aktualisiert werden:"
    $failedUsers | Format-Table -AutoSize
} else {
    Write-Host "`nAlle Benutzer wurden erfolgreich aktualisiert."
}

Write-Host "`nUPN-Update abgeschlossen."