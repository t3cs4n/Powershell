# Add addtional Email alias (smtp proxyaddress) with format n.surname@eulachtal.ch

# Importiere das Active Directory Modul
Import-Module ActiveDirectory

# OU definieren
$ouPath = "OU=Stationaer,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"

# Listen für Erfolge/Fehler
$processedUsers = [System.Collections.Generic.List[string]]::new()
$failedUsers = [System.Collections.Generic.List[PSObject]]::new()

# Benutzer abrufen (mit Vorname/Nachname)
$users = Get-ADUser -Filter * -SearchBase $ouPath -Properties ProxyAddresses, GivenName, Surname

foreach ($user in $users) {
    try {
        # Neue Proxy-Adresse erstellen (erstes Zeichen des Vornamens + Nachname)
        $newProxyAddress = "smtp:" + $user.GivenName[0] + "." + $user.Surname + "@eulachtal.ch"

        # Überprüfen, ob die Adresse bereits existiert
        if ($user.ProxyAddresses -contains $newProxyAddress) {
            Write-Host "Proxy-Adresse für $($user.SamAccountName) existiert bereits!" -ForegroundColor Yellow
            $processedUsers.Add("$($user.SamAccountName) - Proxy-Adresse existierte bereits")
        } else {
            # Kleinbuchstaben erzwingen (falls Nachname Großbuchstaben enthält)
            $newProxyAddress = $newProxyAddress.ToLower()

            # Proxy-Adresse hinzufügen
            Set-ADUser -Identity $user -Add @{ProxyAddresses = $newProxyAddress}

            Write-Host "Hinzugefügt für $($user.SamAccountName): $newProxyAddress" -ForegroundColor Green
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

# Zusammenfassung (wie im Original)
Write-Host "`n=== ZUSAMMENFASSUNG ===" -ForegroundColor Cyan
Write-Host "Erfolgreich: $($processedUsers.Count)" -ForegroundColor Green
Write-Host "Fehlerhaft: $($failedUsers.Count)" -ForegroundColor Red