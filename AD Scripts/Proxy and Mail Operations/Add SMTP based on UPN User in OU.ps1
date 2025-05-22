# Active Directory Modul importieren
Import-Module ActiveDirectory

# OU angeben
$OU = "OU=Stationaer,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"

# Domäne für die neue E-Mail-Adresse
$defaultDomain = "@eulachtal.ch"

# Benutzer aus der OU abrufen
$users = Get-ADUser -Filter * -SearchBase $OU -Properties proxyAddresses, SamAccountName -ErrorAction Stop

# Durch jeden Benutzer iterieren
foreach ($user in $users) {
    try {
        # Prüfen, ob eine primäre SMTP-Adresse existiert
        $hasPrimary = $user.proxyAddresses | Where-Object {$_ -clike "SMTP:*"}
        
        if (-not $hasPrimary) {
            # Wenn keine primäre Adresse existiert, eine erstellen
            $newPrimary = "SMTP:" + $user.SamAccountName + $defaultDomain
            
            # Bestehende Proxy-Adressen abrufen (als String-Array sicherstellen)
            $existingProxies = [string[]]$user.proxyAddresses
            
            # Neue Proxy-Adressen-Liste erstellen
            $newProxyAddresses = New-Object 'System.Collections.Generic.List[string]'
            $newProxyAddresses.Add($newPrimary)  # Neue primäre Adresse hinzufügen
            
            # Alle bestehenden Adressen hinzufügen, falls vorhanden
            if ($existingProxies) {
                foreach ($proxy in $existingProxies) {
                    $newProxyAddresses.Add($proxy)
                }
            }
            
            # Neue Proxy-Adressen im AD setzen
            Set-ADUser -Identity $user.DistinguishedName -Replace @{proxyAddresses=$newProxyAddresses.ToArray()} -ErrorAction Stop
            
            Write-Host "Primäre Adresse für $($user.Name) hinzugefügt: $newPrimary"
        }
    }
    catch {
        Write-Warning "Fehler bei der Verarbeitung von $($user.Name): $_"
    }
}

# Ergebnisse nach der Änderung anzeigen
$updatedUsers = Get-ADUser -Filter * -SearchBase $OU -Properties proxyAddresses |
    Select-Object Name, 
        @{Name='PrimaryEmail';Expression={
            ($_.proxyAddresses | Where-Object {$_ -clike "SMTP:*"}) -replace "SMTP:"
        }}

$updatedUsers | Out-GridView -Title "Aktualisierte primäre Proxy-Adressen"