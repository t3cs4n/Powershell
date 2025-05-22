# Policies Sync between Domain Controllers / From primary to secondary

# Prüfen, ob das Script bereits mit Admin-Rechten läuft
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Dieses Script benötigt Administratorrechte. Starte Erhöhung..." -ForegroundColor Yellow
    # Script mit erhöhten Rechten neu starten
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Wait
    exit
}

# Importiere das Active Directory Modul
Import-Module ActiveDirectory

# Namen der beiden Domain Controller festlegen
$sourceDC = "srvdc01"  # Quell-DC (z. B. der primäre DC) / Wenn nötig passe den Namen an
$targetDC = "srvdc00"  # Ziel-DC (der zu synchronisierende DC) / Wenn nötig passe den Namen an

try {
    # AD-Replikation erzwingen
    Write-Host "Starte AD-Replikation von $sourceDC nach $targetDC..." -ForegroundColor Cyan
    repadmin /syncall $sourceDC /e /A | Out-Null
    Write-Host "AD-Replikation erfolgreich durchgeführt." -ForegroundColor Green

    # SYSVOL-Replikation erzwingen (für GPOs)
    Write-Host "Starte SYSVOL-Synchronisation zwischen $sourceDC und $targetDC..." -ForegroundColor Cyan
    $domain = (Get-ADDomain).DNSRoot
    Invoke-Command -ComputerName $targetDC -ScriptBlock {
        # DFSR-Synchronisation erzwingen (falls DFSR verwendet wird)
        dfsrdiag syncnow /partner:$using:sourceDC /RGName:"Domain System Volume" /Time:15
    }
    Write-Host "SYSVOL-Synchronisation erfolgreich angestoßen." -ForegroundColor Green

    # Überprüfung des Replikationsstatus
    Write-Host "`nÜberprüfe Replikationsstatus..." -ForegroundColor Cyan
    $replStatus = repadmin /replsummary
    Write-Host $replStatus -ForegroundColor Yellow
}
catch {
    Write-Host "Fehler bei der Synchronisation: $_" -ForegroundColor Red
}