# Script Path leeren

# Importiere das ActiveDirectory-Modul
Import-Module ActiveDirectory

# Ziel-OU (Beispiel aus Ihrer Umgebung)
$OU = "OU=_Computer_Users,OU=Ambulant,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"
$LogFile = "C:\temp\LoginScript_Cleanup_$(Get-Date -Format 'yyyyMMdd-HHmmss').log"

# Log-Funktion
function Write-Log {
    param ([string]$Message)
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "[$Timestamp] $Message"
    Add-Content -Path $LogFile -Value $LogEntry
    Write-Output $LogEntry
}

Write-Log "START: Lösche scriptPath für Benutzer in OU $OU"

try {
    $Users = Get-ADUser -Filter * -SearchBase $OU -Properties scriptPath
    $Counter = 0

    foreach ($User in $Users) {
        if ($User.scriptPath) {
            Write-Log "Benutzer $($User.SamAccountName): Lösche scriptPath '$($User.scriptPath)'"
            Set-ADUser -Identity $User.SamAccountName -Clear scriptPath -ErrorAction Stop
            $Counter++
            Write-Log "Erfolgreich gelöscht."
        }
    }

    Write-Log "FERTIG: $Counter Benutzer aktualisiert."
}
catch {
    Write-Log "FEHLER: $_"
}