# TEST Skript : Erstelle Homeshare für Benutzer aus bestimmter OU mit einem spezifischen Laufwerk Buchstaben

# Importiere das Active Directory-Modul
Import-Module ActiveDirectory

# Konfiguration
$targetOU = "OU=Computer_Users,OU=Ambulant,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"  # OU anpassen
$homeFolderRoot = "\\netapp01\Data\Benutzerdaten\"      # Freigabepfad anpassen
$driveLetter = "P:"                         # Laufwerkbuchstabe

# Benutzer in der OU abrufen
$users = Get-ADUser -Filter * -SearchBase $targetOU

Write-Host "=== TESTMODUS ===" -ForegroundColor Yellow
Write-Host "Es werden KEINE Änderungen in Active Directory vorgenommen!" -ForegroundColor Yellow
Write-Host "Betroffene OU: $targetOU"
Write-Host "Anzahl Benutzer: $($users.Count)`n"

# Vorschau der geplanten Änderungen
foreach ($user in $users) {
    $username = $user.SamAccountName
    $homeFolderPath = $homeFolderRoot + $username



    # Aktuelle Homefolder-Einstellungen abrufen (falls gesetzt)
    $currentHomeDrive = $user.HomeDrive
    $currentHomeDir = $user.HomeDirectory

    Write-Host "Benutzer: $username" -ForegroundColor Cyan
    Write-Host "Aktuelle Einstellung: Laufwerk $currentHomeDrive -> $currentHomeDir"
    Write-Host "Neue Einstellung:     Laufwerk $driveLetter -> $homeFolderPath"
    Write-Host "---"
}

# Zusammenfassung
Write-Host "`n=== ZUSAMMENFASSUNG ===" -ForegroundColor Green
Write-Host "Geplante Änderungen für $($users.Count) Benutzer:"
Write-Host " - HomeDrive:    Auf '$driveLetter' gesetzt"
Write-Host " - HomeDirectory: Pfad '$homeFolderRoot<username>'"
Write-Host "`nHinweis: Führen Sie das Skript ohne Testmodus aus, um die Änderungen zu übernehmen." -ForegroundColor Yellow