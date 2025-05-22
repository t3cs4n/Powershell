# Set the primary SMTP address. Name konvention prename.surname@domain.xx


# Define the OU and domain for the new SMTP address
$OU = "OU=Perskontos_Standard_Premium,OU=Ambulant,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"
$NewDomain = "eulachtal.ch"

# Fetch users from the specified OU
$Users = Get-ADUser -Filter * -SearchBase $OU -Properties GivenName, Surname, ProxyAddresses

foreach ($User in $Users) {
    # Ensure the user has a first name and last name
    if ($User.GivenName -and $User.Surname) {
        # Construct the new Primary SMTP address
        $NewPrimarySMTP = "SMTP:$($User.GivenName).$($User.Surname)@$NewDomain"

        # Fetch existing proxy addresses and remove any current primary address
        $ProxyAddresses = @($User.ProxyAddresses | Where-Object { $_ -notmatch "^SMTP:" })

        # Add the new Primary SMTP address at the top
        $ProxyAddresses = @($NewPrimarySMTP) + $ProxyAddresses

        # Update the user object
        Set-ADUser -Identity $User.DistinguishedName -Replace @{ProxyAddresses = $ProxyAddresses}
        Write-Host "Set $NewPrimarySMTP as primary address for $($User.SamAccountName)"
    } else {
        Write-Host "Skipping $($User.SamAccountName): Missing GivenName or Surname."
    }
}