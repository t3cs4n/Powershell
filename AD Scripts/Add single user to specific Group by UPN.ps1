<# 

Füge einzelnen Benutzer zur M365_Workplace_Access Gruppe.
Das Script verlangt die Eingabe des Benutzers. Eingeben
musst den UPN welcher der Emailadresse des Benutzers entspricht.

#>

# Prüfen, ob das Active Directory-Modul geladen ist
if (-not (Get-Module -Name ActiveDirectory)) {
    try {
        Import-Module ActiveDirectory -ErrorAction Stop
    }
    catch {
        Write-Host "Das Active Directory-Modul ist nicht installiert." -ForegroundColor Red
        Write-Host "Installieren Sie die RSAT-Tools (Remote Server Administration Tools) für Active Directory." -ForegroundColor Yellow
        exit
    }
}

# Abfrage des User Principal Name (UPN)
$userUPN = Read-Host "Geben Sie den User Principal Name (UPN) des Benutzers ein, z.B. 'max.mustermann@domain.com'"

# Name der Gruppe
$groupName = "M365_Workplace_Access"

# Benutzer suchen
$user = Get-ADUser -Filter "UserPrincipalName -eq '$userUPN'" -ErrorAction SilentlyContinue
if (-not $user) {
    Write-Host "Benutzer mit dem UPN '$userUPN' wurde nicht gefunden!" -ForegroundColor Red
    exit
}

# Gruppe suchen
$group = Get-ADGroup -Filter "Name -eq '$groupName'" -ErrorAction SilentlyContinue
if (-not $group) {
    Write-Host "Gruppe '$groupName' wurde nicht gefunden!" -ForegroundColor Red
    exit
}

# Benutzer zur Gruppe hinzufügen
Add-ADGroupMember -Identity $group -Members $user

# Erfolgsmeldung
Write-Host "Benutzer '$userUPN' wurde erfolgreich zur Gruppe '$groupName' hinzugefügt." -ForegroundColor Green