# Simulation Add addtional Email alias p.name@domain.ch

# Importiere das Active Directory Modul
Import-Module ActiveDirectory

# OU definieren
$ouPath = "OU=Stationaer,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"

# Listen für Simulation
$simulatedAdds = [System.Collections.Generic.List[string]]::new()
$invalidUsers = [System.Collections.Generic.List[string]]::new()

# Benutzer abrufen (mit Vorname/Nachname)
$users = Get-ADUser -Filter * -SearchBase $ouPath -Properties ProxyAddresses, GivenName, Surname

foreach ($user in $users) {
    # Prüfe, ob Vorname/Nachname vorhanden sind
    if (-not $user.GivenName -or -not $user.Surname) {
        $invalidUsers.Add("$($user.SamAccountName) - Fehlende Attribute (Vorname/Nachname)")
        continue
    }

    # Neue Proxy-Adresse erstellen (erstes Zeichen des Vornamens + Nachname)
    $newProxyAddress = "smtp:" + $user.GivenName[0].ToString().ToLower() + "." + $user.Surname.ToLower() + "@eulachtal.ch"

    # Simulation: Nur ausgeben, was geändert würde
    if ($user.ProxyAddresses -contains $newProxyAddress) {
        $simulatedAdds.Add("$($user.SamAccountName) - Würde NICHT hinzugefügt (existiert bereits): $newProxyAddress")
    }
    else {
        $simulatedAdds.Add("$($user.SamAccountName) - Würde HINZUGEFÜGT: $newProxyAddress")
    }
}

# Simulationsergebnis anzeigen
Write-Host "`n=== SIMULATION (Keine Änderungen in AD!) ===" -ForegroundColor Cyan
Write-Host "`nWürde folgende Proxy-Adressen hinzufügen:" -ForegroundColor Yellow
$simulatedAdds | ForEach-Object { Write-Host "  - $_" }

if ($invalidUsers.Count -gt 0) {
    Write-Host "`nProblemfälle (fehlende Daten):" -ForegroundColor Red
    $invalidUsers | ForEach-Object { Write-Host "  - $_" }
}

Write-Host "`nHinweis: Dies ist nur eine Simulation. Um die Änderungen durchzuführen, das Original-Script verwenden." -ForegroundColor Green