# Remove X500 Proxy adresses from Users in OU

# Active Directory Modul importieren
Import-Module ActiveDirectory

# OU festlegen
$OU = "OU=Stationaer,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"

# Array für bearbeitete Benutzer initialisieren
$processedUsers = @()

# Benutzer aus der OU abrufen mit proxyAddresses-Eigenschaft
$users = Get-ADUser -Filter * -SearchBase $OU -Properties proxyAddresses -ErrorAction Stop

# Durch jeden Benutzer iterieren
foreach ($user in $users) {
    try {
        # Prüfen, ob Proxy-Adressen vorhanden sind
        if ($user.proxyAddresses) {
            # X500-Adressen finden
            $x500Addresses = $user.proxyAddresses | Where-Object {$_ -like "X500:*"}
            
            # Wenn X500-Adressen vorhanden sind, diese entfernen
            if ($x500Addresses) {
                # Neue Proxy-Adressen-Liste erstellen, ohne X500-Adressen, als String-Array
                $newProxyAddresses = [string[]]($user.proxyAddresses | Where-Object {$_ -notlike "X500:*"})
                
                # Aktualisierte Proxy-Adressen im AD setzen
                Set-ADUser -Identity $user -Replace @{proxyAddresses=$newProxyAddresses} -ErrorAction Stop
                
                # Benutzer zur Liste der bearbeiteten hinzufügen
                $processedUsers += [PSCustomObject]@{
                    Name = $user.Name
                    RemovedX500 = ($x500Addresses -join ", ")
                }
                
                Write-Host "X500-Adressen für $($user.Name) entfernt: $($x500Addresses -join ', ')"
            }
        }
    }
    catch {
        Write-Warning "Fehler bei der Verarbeitung von $($user.Name): $_"
    }
}

# Ergebnisse der bearbeiteten Benutzer anzeigen
if ($processedUsers.Count -gt 0) {
    Write-Host "`nBearbeitete Benutzer:" -ForegroundColor Green
    $processedUsers | Format-Table -Property Name, RemovedX500 -AutoSize
    $processedUsers | Out-GridView -Title "Benutzer mit entfernten X500-Adressen"
} else {
    Write-Host "Keine Benutzer mit X500-Adressen gefunden, die bearbeitet werden mussten." -ForegroundColor Yellow
}
