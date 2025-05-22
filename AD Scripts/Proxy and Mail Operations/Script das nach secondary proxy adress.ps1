# Script das nach secondary proxy adressen mit einer bestimmten Domain sucht.


# Importiere das Active Directory Modul
Import-Module ActiveDirectory

# OU, die du durchsuchen möchtest (DN der OU)
$OU = "OU=Perskontos_Alle,OU=Ambulant,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"

# Domain, nach der gefiltert werden soll
$TargetDomain = "spitex-eulachtal.ch"

# Alle Benutzer in der OU abrufen
$users = Get-ADUser -Filter * -SearchBase $OU -Properties proxyAddresses, mail, userPrincipalName

# Benutzer filtern, denen die sekundäre smtp-Adresse mit der gewünschten Domain fehlt
$usersMissingAlias = $users | Where-Object {
    # Keine Proxy-Adressen vorhanden ODER keine sekundäre smtp-Adresse mit der gewünschten Domain
    -not $_.proxyAddresses -or `
    -not ($_.proxyAddresses -match "smtp:.*@$TargetDomain$")
}

# Ergebnisse anzeigen
if ($usersMissingAlias.Count -gt 0) {
    Write-Host "Benutzer ohne sekundäre smtp-Adresse mit der Domain ${TargetDomain}:"
    foreach ($user in $usersMissingAlias) {
        Write-Host "Name: $($user.Name) | Mail: $($user.mail) | UPN: $($user.userPrincipalName) | ProxyAddresses: $($user.proxyAddresses -join '; ')"
    }
} else {
    Write-Host "Alle Benutzer in der OU haben eine sekundäre smtp-Adresse mit der Domain ${TargetDomain}."
}
