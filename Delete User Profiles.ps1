# Benutzerprofile löschen

# Schleife starten
while ($true) {
    # Benutzername im CLI abfragen
    $username = Read-Host "Geben Sie den Benutzernamen des zu entfernenden Profils ein (drücken Sie ENTER, um das Skript zu beenden)"

    # Überprüfen, ob der Benutzer die Eingabe abgebrochen hat (Leere Eingabe)
    if ([string]::IsNullOrWhiteSpace($username)) {
        Write-Host "Keine Eingabe gemacht. Skript wird beendet." -ForegroundColor Yellow
        break
    }

    # Benutzerprofil basierend auf dem eingegebenen Benutzernamen suchen und entfernen
    try {
        # Abrufen des Benutzerprofils
        $userProfile = Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath.Split('\')[-1] -eq $username }

        if ($null -eq $userProfile) {
            Write-Host "Kein Benutzerprofil mit dem Namen '$username' gefunden." -ForegroundColor Yellow
        } else {
            # Entfernen des Benutzerprofils
            $userProfile | Remove-CimInstance
            Write-Host "Das Benutzerprofil '$username' wurde erfolgreich entfernt." -ForegroundColor Green
        }
    } catch {
        Write-Host "Fehler beim Entfernen des Benutzerprofils: $_" -ForegroundColor Red
    }
}
