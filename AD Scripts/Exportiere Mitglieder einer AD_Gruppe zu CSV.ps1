<#
.SYNOPSIS
    Exportiert Mitglieder einer AD-Gruppe mit Vor- und Nachnamen in eine CSV-Datei.
.DESCRIPTION
    Dieses Script fragt die Mitglieder einer bestimmten Active Directory-Gruppe ab
    und exportiert deren Vor- und Nachnamen sowie weitere Informationen in eine CSV-Datei.
.PARAMETER GroupName
    Der Name der AD-Gruppe, deren Mitglieder exportiert werden sollen.
.PARAMETER OutputFile
    Der Pfad zur CSV-Ausgabedatei (Standard: "Gruppenmitglieder.csv" im aktuellen Verzeichnis).
.EXAMPLE
    .\Export-ADGroupMembers.ps1 -GroupName "Mitarbeiter" -OutputFile "C:\Export\Mitarbeiter.csv"
.NOTES
    Erfordert das ActiveDirectory-Modul und entsprechende Berechtigungen.
    Der Name der Gruppe wird direkt beim Aufruf des Scripts abgefragt. 
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$GroupName,
    
    [string]$OutputFile = "c:\Terminalserver_Gruppenmitglieder.csv"
)

# ActiveDirectory-Modul laden
try {
    Import-Module ActiveDirectory -ErrorAction Stop
} catch {
    Write-Error "ActiveDirectory-Modul konnte nicht geladen werden. Stellen Sie sicher, dass die RSAT-Tools installiert sind."
    exit 1
}

# Gruppenmitglieder abfragen
try {
    $members = Get-ADGroupMember -Identity $GroupName -Recursive | 
               Where-Object { $_.objectClass -eq 'user' } |
               Get-ADUser -Properties GivenName, Surname, UserPrincipalName, Enabled
} catch {
    Write-Error "Fehler beim Abrufen der Gruppenmitglieder: $_"
    exit 1
}

# Daten für den Export vorbereiten
$exportData = foreach ($member in $members) {
    [PSCustomObject]@{
        Vorname           = $member.GivenName
        Nachname          = $member.Surname
        UPN               = $member.UserPrincipalName
        KontoAktiv        = $member.Enabled
        Gruppenname       = $GroupName
    }
}

# In CSV exportieren
try {
    $exportData | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8 -Delimiter ";" -Force
    Write-Host "Erfolgreich exportiert: $($exportData.Count) Mitglieder der Gruppe '$GroupName' nach '$OutputFile'"
} catch {
    Write-Error "Fehler beim Export in die CSV-Datei: $_"
    exit 1
}