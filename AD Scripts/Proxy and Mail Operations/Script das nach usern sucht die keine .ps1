# Script das nach usern sucht die keine proxy adresse definiert haben

# Importiere das Active Directory Modul
Import-Module ActiveDirectory

# OU, die du durchsuchen möchtest (DN der OU)
$OU = "OU=Perskontos_Alle,OU=Ambulant,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"

# Alle Benutzer in der OU abrufen
$users = Get-ADUser -Filter * -SearchBase $OU -Properties proxyAddresses, mail, userPrincipalName

# Benutzer filtern, die gar keine Proxy-Adressen haben
$usersWithoutProxy = $users | Where-Object {
    -not $_.proxyAddresses
}

# Ergebnisse anzeigen
if ($usersWithoutProxy.Count -gt 0) {
    Write-Host "Benutzer ohne definierte Proxy-Adressen:"
    foreach ($user in $usersWithoutProxy) {
        Write-Host "Name: $($user.Name) | Mail: $($user.mail) | UPN: $($user.userPrincipalName)"
    }
} else {
    Write-Host "Alle Benutzer in der OU haben mindestens eine Proxy-Adresse definiert."
}

