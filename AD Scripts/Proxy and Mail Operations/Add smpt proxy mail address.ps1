# Add smpt proxy mail address in name konvention x.xxxx@domain.ch

# Organisationseinheit und neue Proxy-Adresse
$OU = "OU=OU=Perskontos_Basic_PC,OU=Ambulant,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"
$NewDomain = "spitex-eulachtal.ch"

# Benutzer abrufen
$Users = Get-ADUser -Filter * -SearchBase $OU -Properties ProxyAddresses

foreach ($User in $Users) {
    # Bestehende Proxy-Adressen abrufen
    $ProxyAddresses = $User.ProxyAddresses
    
    # Neue Adresse erstellen (primär oder sekundär)
    $NewProxy = "smtp:" + $User.SamAccountName + "@" + $NewDomain

    if (-not ($ProxyAddresses -contains $NewProxy)) {
        # Neue Proxy-Adresse hinzufügen
        $ProxyAddresses += $NewProxy
        Set-ADUser -Identity $User.DistinguishedName -Add @{ProxyAddresses = $ProxyAddresses}
        Write-Host "Proxy-Adresse $NewProxy für $($User.Name) hinzugefügt."
    } else {
        Write-Host "Proxy-Adresse $NewProxy existiert bereits für $($User.Name)."
    }
}