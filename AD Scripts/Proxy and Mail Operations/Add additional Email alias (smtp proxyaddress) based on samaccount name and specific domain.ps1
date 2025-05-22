# Add addtional Email alias (smtp proxyaddress) from SamAccountName + specific Domain

# Importiere das Active Directory Modul
Import-Module ActiveDirectory

# Definiere die OU (Organizational Unit), deren Benutzer bearbeitet werden sollen
# Ersetze "OU=Users,DC=deineDomain,DC=ch" mit dem DistinguishedName deiner OU
$ouPath = "OU=Stationaer,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"

# Listen für Erfolge und Fehler initialisieren
$processedUsers = [System.Collections.Generic.List[string]]::new()
$failedUsers = [System.Collections.Generic.List[PSObject]]::new()

# Alle Benutzer aus der angegebenen OU abrufen
$users = Get-ADUser -Filter * -SearchBase $ouPath -Properties ProxyAddresses

# Überprüfen, ob Benutzer gefunden wurden
if ($users.Count -eq 0) {
    Write-Host "Keine Benutzer in der angegebenen OU gefunden!" -ForegroundColor Red
    exit
}

# Jeden Benutzer durchlaufen
foreach ($user in $users) {
    try {
        # Neue smtp-Proxy-Adresse (Alias) erstellen
        $newProxyAddress = "smtp:" + $user.SamAccountName + "@eulachtal.ch"  # Ändere hier die Domain nach Wunsch

        # Überprüfen, ob die Proxy-Adresse bereits existiert
        if ($user.ProxyAddresses -contains $newProxyAddress) {
            Write-Host "Die Proxy-Adresse für $($user.SamAccountName) existiert bereits!" -ForegroundColor Yellow
            $processedUsers.Add("$($user.SamAccountName) - Proxy-Adresse existierte bereits")
        } else {
            # Proxy-Adresse hinzufügen
            $user.ProxyAddresses += $newProxyAddress

            # Aktualisierte Proxy-Adressen in Active Directory speichern
            Set-ADUser -Identity $user -Replace @{ProxyAddresses = $user.ProxyAddresses}

            Write-Host "Erfolgreich hinzugefügt für $($user.SamAccountName): $newProxyAddress" -ForegroundColor Green
            $processedUsers.Add("$($user.SamAccountName) - Proxy-Adresse hinzugefügt")
        }
    }
    catch {
        Write-Host "Fehler bei $($user.SamAccountName): $_" -ForegroundColor Red
        $failedUsers.Add([PSCustomObject]@{
            SamAccountName = $user.SamAccountName
            ErrorMessage   = $_.Exception.Message
        })
    }
}

# Zusammenfassung der Ergebnisse ausgeben
Write-Host "`n=== VERARBEITUNGSZUSAMMENFASSUNG ===" -ForegroundColor Cyan
Write-Host "Bearbeitete Benutzer: $($processedUsers.Count)" -ForegroundColor Green
foreach ($entry in $processedUsers) {
    Write-Host "  - $entry"
}

Write-Host "`nFehlerhafte Benutzer: $($failedUsers.Count)" -ForegroundColor Red
if ($failedUsers.Count -gt 0) {
    foreach ($failed in $failedUsers) {
        Write-Host "  - $($failed.SamAccountName): $($failed.ErrorMessage)"
    }
} else {
    Write-Host "  - Keine Fehler aufgetreten" -ForegroundColor Green
}