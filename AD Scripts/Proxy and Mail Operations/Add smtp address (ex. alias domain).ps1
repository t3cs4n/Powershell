
# Define the Distinguished Name (DN) of the target OU and the SMTP domain to add
$OU = "OU=Perskontos_Basic_Mobile,OU=Ambulant,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"        # Replace with the DN of your target OU
$NewDomain = "spitex-eulachtal.ch"               # Replace with the domain you want to add

# Import the Active Directory module
Import-Module ActiveDirectory

# Get all users in the specified OU
$Users = Get-ADUser -Filter * -SearchBase $OU -Properties proxyAddresses

foreach ($User in $Users) {
    # Define the new SMTP proxy address
    $NewProxyAddress = "smtp:" + $User.SamAccountName + "@" + $NewDomain
    
    # Check if the user already has this proxy address
    if ($User.proxyAddresses -notcontains $NewProxyAddress) {
        # Add the new proxy address to the existing array of addresses
        $UpdatedProxies = $User.proxyAddresses + $NewProxyAddress

        # Update the user's proxyAddresses attribute in Active Directory
        Set-ADUser -Identity $User.DistinguishedName -Replace @{proxyAddresses = $UpdatedProxies}
        Write-Output "Added proxy address $NewProxyAddress to user $($User.SamAccountName)."
    } else {
        Write-Output "User $($User.SamAccountName) already has the proxy address $NewProxyAddress."
    }
}

Write-Output "Script completed successfully."