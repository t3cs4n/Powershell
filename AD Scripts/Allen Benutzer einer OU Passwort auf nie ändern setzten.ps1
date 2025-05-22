# -----------------------------------------
# PowerShell-Skript zum Hinzufügen von Benutzern einer OU zu einer AD-Gruppe
# UTF-8-fähig, mit Fehlerbehandlung und optimierter Ausführung
# -----------------------------------------

# Zeichencodierung auf UTF-8 setzen (für Windows PowerShell 5.1 relevant)
[System.Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Define the Distinguished Name (DN) of the OU you want to target and the group name
$OU = "OU=Perskontos_Premium,OU=Ambulant,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"    # Replace with the DN of your OU
$GroupName = "365_Perigon"           # Replace with the name of your target group
$LogFilePath = "C:\Logs\ADGroupAdditions.log"  # Logfile-Pfad

# Funktion für Logging
function Write-Log {
    param (
        [string]$Message,
        [string]$LogFile = $LogFilePath
    )
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $runUser   = $env:USERNAME
    $logEntry  = "$timestamp [$runUser] $Message"
    try {
        Add-Content -Path $LogFile -Value $logEntry
        Write-Host $logEntry
    } catch {
        Write-Host "Fehler beim Schreiben ins Logfile: $_" -ForegroundColor Red
    }
}

# Prüfen, ob das Active Directory Modul installiert ist
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Write-Log "Das Active Directory-Modul ist nicht installiert. Bitte installiere die RSAT-AD-Tools."
    exit
}

Import-Module ActiveDirectory -ErrorAction Stop

# Gruppe abrufen
try {
    $Group = Get-ADGroup -Identity $GroupName -ErrorAction Stop
    Write-Log "Gruppe $GroupName erfolgreich abgerufen."
} catch {
    Write-Log "Fehler beim Abrufen der Gruppe $GroupName : $_"
    exit
}

# Alle Benutzer aus der OU abrufen
try {
    $Users = Get-ADUser -Filter * -SearchBase $OU -SearchScope Subtree -Properties SamAccountName, DistinguishedName -ErrorAction Stop
    Write-Log "Benutzer aus OU $OU erfolgreich abgerufen."
} catch {
    Write-Log "Fehler beim Abrufen der Benutzer aus $OU : $_"
    exit
}

# Gruppenmitglieder einmalig abrufen
try {
    $GroupMembers = Get-ADGroupMember -Identity $Group -ErrorAction Stop | Select-Object -ExpandProperty DistinguishedName
    Write-Log "Aktuelle Gruppenmitglieder abgerufen."
} catch {
    Write-Log "Fehler beim Abrufen der Gruppenmitglieder: $_"
    exit
}

# Benutzer zur Gruppe hinzufügen
foreach ($User in $Users) {
    if ($GroupMembers -notcontains $User.DistinguishedName) {
        try {
            Add-ADGroupMember -Identity $Group -Members $User -ErrorAction Stop
            Write-Log "Benutzer $($User.SamAccountName) wurde zur Gruppe $GroupName hinzugefügt." -ForegroundColor Green
        } catch {
            Write-Log "Fehler beim Hinzufügen von $($User.SamAccountName) zur Gruppe $GroupName : $_" -ForegroundColor Red
        }
    } else {
        Write-Log "Benutzer $($User.SamAccountName) ist bereits Mitglied der Gruppe $GroupName." -ForegroundColor Yellow
    }
}

Write-Log "Skript erfolgreich abgeschlossen." -ForegroundColor Green

