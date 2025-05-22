# Prüfe ob ein Benutzer mit Azure AD gesynct wird.


# Wenn es nicht funktioniert, installiere erst das folgende Modul MSOnline (siehe nächste Zeile)

# Install-Module -Name MSOnline -Force -AllowClobber -Scope AllUsers



Connect-MsolService


# Benutzername anpassen
$UserPrincipalName = "miguel.santiago@eulachtal.ch"

# Prüfen, ob der Benutzer synchronisiert wird
$User = Get-MsolUser -UserPrincipalName $UserPrincipalName

# Ergebnis ausgeben
if ($User) {
    $isSynced = $User.IsDirSyncEnabled
    Write-Output "Is synced to Azure AD: $isSynced"
} else {
    Write-Output "User not found in Azure AD"
}