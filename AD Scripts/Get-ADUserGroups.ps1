<#
.SYNOPSIS
    Dieses Script listet alle Active Directory-Gruppen auf, in denen ein bestimmter Benutzer Mitglied ist.
.DESCRIPTION
    Das Script benötigt den SamAccountName eines AD-Benutzers und gibt alle direkten und verschachtelten Gruppenmitgliedschaften aus.
.PARAMETER Benutzername
    Der SamAccountName des zu überprüfenden AD-Benutzers
.EXAMPLE
    .\Get-ADUserGroups.ps1 -Benutzername "jdoe"
.NOTES
    Autor: Ihr Name
    Datum: $(Get-Date -Format "dd.MM.yyyy")
    Version: 1.0
#>

param (
    [Parameter(Mandatory=$true, HelpMessage="Geben Sie den Benutzernamen (SamAccountName) ein")]
    [string]$Benutzername
)

# Überprüfen, ob das AD-Modul verfügbar ist
if (-not (Get-Module -Name ActiveDirectory -ErrorAction SilentlyContinue)) {
    try {
        Import-Module ActiveDirectory -ErrorAction Stop
    } catch {
        Write-Host "Das ActiveDirectory-Modul konnte nicht geladen werden. Stellen Sie sicher, dass die RSAT-Tools installiert sind." -ForegroundColor Red
        exit 1
    }
}

# Benutzer überprüfen
try {
    $user = Get-ADUser -Identity $Benutzername -ErrorAction Stop
} catch {
    Write-Host "Benutzer '$Benutzername' wurde nicht gefunden." -ForegroundColor Red
    exit 1
}

Write-Host "`nGruppenmitgliedschaften für $($user.Name) ($Benutzername):`n" -ForegroundColor Cyan

# Direkte Gruppenmitgliedschaften abrufen
try {
    $groups = Get-ADPrincipalGroupMembership -Identity $Benutzername | Select-Object Name, DistinguishedName | Sort-Object Name
    
    if ($groups) {
        Write-Host "Direkte Gruppenmitgliedschaften:" -ForegroundColor Green
        $groups | Format-Table -AutoSize
    } else {
        Write-Host "Der Benutzer ist kein direktes Mitglied einer Gruppe." -ForegroundColor Yellow
    }
} catch {
    Write-Host "Fehler beim Abrufen der Gruppenmitgliedschaften: $_" -ForegroundColor Red
    exit 1
}

# Optionale Abfrage der verschachtelten Gruppenmitgliedschaften
$antwort = Read-Host "`nMöchten Sie auch verschachtelte Gruppenmitgliedschaften anzeigen? (j/n)"
if ($antwort -eq 'j' -or $antwort -eq 'y') {
    try {
        Write-Host "`nAlle Gruppenmitgliedschaften (inkl. verschachtelt):" -ForegroundColor Green
        Get-ADUser -Identity $Benutzername -Properties MemberOf | 
            Select-Object -ExpandProperty MemberOf |
            Get-ADGroup | Select-Object Name, DistinguishedName | Sort-Object Name | Format-Table -AutoSize
    } catch {
        Write-Host "Fehler beim Abrufen der verschachtelten Gruppen: $_" -ForegroundColor Red
    }
}

Write-Host "`nSkript abgeschlossen.`n" -ForegroundColor Cyan