# Skript zum Hinzufügen aller Benutzer einer Quellgruppe zu einer Zielgruppe

# Parameter definieren
$sourceGroupName = "M365_Workplace_Access"  # Ersetzen mit dem Namen der Quellgruppe
$targetGroupName = "Terminalfarm_Access_Local"   # Ersetzen mit dem Namen der Zielgruppe

# ActiveDirectory-Modul laden
try {
    Import-Module ActiveDirectory -ErrorAction Stop
    
    # Benutzer der Quellgruppe abrufen
    $sourceGroupMembers = Get-ADGroupMember -Identity $sourceGroupName -Recursive | 
                         Where-Object {$_.objectClass -eq 'user'}
    
    # Zielgruppe abrufen
    $targetGroup = Get-ADGroup -Identity $targetGroupName
    
    # Zähler für Erfolgsmeldungen
    $count = 0
    
    # Jeden Benutzer zur Zielgruppe hinzufügen
    foreach ($user in $sourceGroupMembers) {
        try {
            Add-ADGroupMember -Identity $targetGroup -Members $user
            Write-Host "Benutzer $($user.Name) erfolgreich zur Gruppe $targetGroupName hinzugefügt."
            $count++
        }
        catch {
            Write-Warning "Fehler beim Hinzufügen von $($user.Name): $_"
        }
    }
    
    Write-Host "`nVorgang abgeschlossen. $count Benutzer wurden zur Gruppe $targetGroupName hinzugefügt."
}
catch {
    Write-Error "Fehler: $_"
}