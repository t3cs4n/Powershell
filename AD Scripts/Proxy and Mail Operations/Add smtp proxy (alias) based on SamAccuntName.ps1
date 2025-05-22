# Add smtp proxy (alias) based on SamAccountName and Suffic

# Active Directory Modul importieren
Import-Module ActiveDirectory

# OU festlegen
$OU = "OU=Stationaer,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"

# Suffix für die neue smtp-Adresse
$suffix = "@eulachtal.ch"  # Change Domain suffix if needed

# Array für bearbeitete Benutzer initialisieren
$processedUsers = @()

# Benutzer aus der OU abrufen mit proxyAddresses-Eigenschaft
$users = Get-ADUser -Filter * -SearchBase $OU -Properties proxyAddresses, SamAccountName -ErrorAction Stop

# Durch jeden Benutzer iterieren
foreach ($user in $users) {
    try {
        # Neue smtp-Proxy-Adresse erstellen (klein "smtp:" für Alias)
        $newSMTPProxy = "smtp:" + $user.SamAccountName + $suffix

        # Bestehende Proxy-Adressen abrufen (als String-Array sicherstellen)
        $existingProxies = [string[]]$user.proxyAddresses

        # Primäre SMTP-Adresse (groß "SMTP:") beibehalten
        $primarySMTP = $existingProxies | Where-Object {$_ -like "SMTP:*"}

        # Bestehende smtp-Aliase (klein "smtp:") zum Ersetzen finden
        $oldSMTPAliases = $existingProxies | Where-Object {$_ -like "smtp:*"}

        # Nicht-smtp/SMTP-Adressen (z. B. X500) beibehalten
        $otherProxies = $existingProxies | Where-Object {$_ -notlike "smtp:*" -and $_ -notlike "SMTP:*"}

        # Neue Proxy-Adressen-Liste erstellen, explizit als String-Array
        $newProxyAddresses = New-Object 'System.Collections.Generic.List[string]'
        
        # Primäre SMTP-Adresse hinzufügen, falls vorhanden
        if ($primarySMTP) {
            foreach ($addr in $primarySMTP) {
                $newProxyAddresses.Add($addr)
            }
        }
        
        # Neue smtp-Alias-Adresse hinzufügen
        $newProxyAddresses.Add($newSMTPProxy)
        
        # Andere Proxy-Adressen hinzufügen, falls vorhanden
        if ($otherProxies) {
            foreach ($addr in $otherProxies) {
                $newProxyAddresses.Add($addr)
            }
        }

        # Aktualisierte Proxy-Adressen im AD setzen (ohne WhatIf)
        Set-ADUser -Identity $user -Replace @{proxyAddresses=$newProxyAddresses.ToArray()} -ErrorAction Stop

        # Benutzer zur Liste der bearbeiteten hinzufügen
        $processedUsers += [PSCustomObject]@{
            Name = $user.Name
            AddedSMTP = $newSMTPProxy
            ReplacedSMTP = if ($oldSMTPAliases) { ($oldSMTPAliases -join ", ") } else { "Keine vorherigen smtp-Aliase" }
        }

        Write-Host "smtp-Alias für $($user.Name) hinzugefügt: $newSMTPProxy"
    }
    catch {
        Write-Warning "Fehler bei der Verarbeitung von $($user.Name): $_"
    }
}

# Ergebnisse der bearbeiteten Benutzer anzeigen
if ($processedUsers.Count -gt 0) {
    Write-Host "`nBearbeitete Benutzer:" -ForegroundColor Green
    $processedUsers | Format-Table -Property Name, AddedSMTP, ReplacedSMTP -AutoSize
    $processedUsers | Out-GridView -Title "Benutzer mit aktualisierten smtp-Alias-Adressen"
} else {
    Write-Host "Keine Benutzer wurden bearbeitet." -ForegroundColor Yellow
}