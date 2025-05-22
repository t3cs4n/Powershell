# LIVE Skript : Erstelle Homeshare für Benutzer aus bestimmter OU mit einem spezifischen Laufwerk Buchstaben

# Homefolder-Konfiguration mit E-Mail-Benachrichtigung
# WICHTIG: SMTP-Serverdaten anpassen!

# Konfiguration
$targetOU = "OU=Computer_Users,OU=Ambulant,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"
$homeFolderRoot = "\\netapp01\Data\Benutzerdaten\"
$driveLetter = "P:"

# E-Mail-Einstellungen
$mailParams = @{
    SmtpServer = "mail.eulachtal.zh"      # SMTP-Server
    From = "scripts@eulachtal.zh"         # Absender
    To = "IT-Admins@eulachtal.zh"         # Empfänger
    Subject = "Homefolder-Konfiguration abgeschlossen"
    Body = ""                             # Wird später befüllt
    ErrorAction = "Stop"
}

# Log-Vorbereitung
$log = New-Object System.Text.StringBuilder
$log.AppendLine("=== Homefolder-Konfiguration ===") | Out-Null
$log.AppendLine("Startzeit: $(Get-Date -Format 'dd.MM.yyyy HH:mm:ss')") | Out-Null
$log.AppendLine("Ziel-OU: $targetOU`n") | Out-Null

# Benutzer abrufen
$users = Get-ADUser -Filter {Enabled -eq $true} -SearchBase $targetOU
$totalUsers = $users.Count
$successCount = 0
$errorCount = 0

# Bestätigung
Write-Host "=== LIVE-AUSFÜHRUNG ===" -ForegroundColor Red
Write-Host "Es werden Homefolder für $totalUsers Benutzer konfiguriert!" -ForegroundColor Red
$confirmation = Read-Host "Fortfahren? (J/N)"
if ($confirmation -ne "J") { exit }

# Verarbeitung
foreach ($user in $users) {
    $username = $user.SamAccountName
    $homeFolderPath = $homeFolderRoot + $username

    try {
        # AD-Konfiguration
        Set-ADUser -Identity $username -HomeDirectory $homeFolderPath -HomeDrive $driveLetter -ErrorAction Stop
        
        # Ordner erstellen
        if (-not (Test-Path $homeFolderPath)) {
            New-Item -Path $homeFolderPath -ItemType Directory -ErrorAction Stop | Out-Null
            $log.AppendLine("[ERFOLG] Ordner erstellt für $username") | Out-Null
        }
        
        $successCount++
        Write-Host "[OK] $username" -ForegroundColor Green
    }
    catch {
        $errorCount++
        $log.AppendLine("[FEHLER] $username - $($_.Exception.Message)") | Out-Null
        Write-Host "[FEHLER] $username - $($_.Exception.Message)" -ForegroundColor Red
    }
}

# E-Mail zusammenstellen
$mailParams.Body = @"
Homefolder-Konfiguration abgeschlossen:
- Erfolgreich: $successCount von $totalUsers
- Fehler: $errorCount
- OU: $targetOU

Details:
$($log.ToString())
"@

# E-Mail versenden
try {
    Send-MailMessage @mailParams
    Write-Host "Bericht wurde per E-Mail versendet." -ForegroundColor Cyan
}
catch {
    Write-Host "Fehler beim Mailversand: $($_.Exception.Message)" -ForegroundColor Red
    $log.AppendLine("FEHLER MAILVERSAND: $($_.Exception.Message)") | Out-Null
}

# Log speichern
$logPath = "C:\Logs\Homefolder_$(Get-Date -Format 'yyyyMMdd').log"
$log.ToString() | Out-File -FilePath $logPath -Encoding UTF8

Write-Host "`n=== ZUSAMMENFASSUNG ===" -ForegroundColor Green
Write-Host "Logfile gespeichert unter: $logPath"
Write-Host "Erfolgreich: $successCount | Fehler: $errorCount"