# Windows 11 Registry add registry settings by menu

# PowerShell Script für Menü-basierte Einstellungen
# Funktionen definieren
function Enable-FullContextMenu {
    Write-Host "Aktiviere volles Kontextmenü..." -ForegroundColor Yellow
    New-Item -Path "HKCU:\Software\Classes\CLSID" -Name "{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Force | Out-Null
    New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Name "InprocServer32" -Force | Out-Null
    Write-Host "Volles Kontextmenü aktiviert. Bitte abmelden oder neu starten, um die Änderungen zu sehen." -ForegroundColor Green
}

function Enable-NumLockOnBoot {
    Write-Host "Aktiviere NumLock beim Start..." -ForegroundColor Yellow
    Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Value "2"
    Write-Host "NumLock beim Start wurde aktiviert." -ForegroundColor Green
}

function Enable-TLS12 {
    Write-Host "Aktiviere TLS 1.2..." -ForegroundColor Yellow
    # Aktivierung für den aktuellen Benutzer
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\SecureProtocols" -Force | Out-Null
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "SecureProtocols" -Value 0xA00
    # Aktivierung für das System (optional)
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp" -Name "DefaultSecureProtocols" -Value 0xA00
    Write-Host "TLS 1.2 wurde aktiviert." -ForegroundColor Green
}

# Menü anzeigen
function Show-Menu {
    Clear-Host
    Write-Host "Bitte wähle eine Option:" -ForegroundColor Cyan
    Write-Host "1. Volles Kontextmenü unter Windows 11 aktivieren"
    Write-Host "2. NumLock beim Start aktivieren"
    Write-Host "3. TLS 1.2 aktivieren"
    Write-Host "4. Beenden"
}

# Hauptschleife
do {
    Show-Menu
    $choice = Read-Host "Deine Auswahl (1-4)"
    switch ($choice) {
        "1" { Enable-FullContextMenu }
        "2" { Enable-NumLockOnBoot }
        "3" { Enable-TLS12 }
        "4" { Write-Host "Programm beendet." -ForegroundColor Cyan }
        default { Write-Host "Ungültige Auswahl. Bitte erneut versuchen." -ForegroundColor Red }
    }
    if ($choice -ne "4") {
        Read-Host "Drücke [Enter], um zum Menü zurückzukehren."
    }
} while ($choice -ne "4")