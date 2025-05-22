# Change the logon name (keeping pre w2k logon name).

# Define the new UPN domain suffix
$NewUPNSuffix = "eulachtal.ch"

# Define the Organizational Unit
$OU = "OU=Perskontos_Standard_PC,OU=Ambulant,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"

# Fetch all users in the specified OU
$Users = Get-ADUser -Filter * -SearchBase $OU -Properties GivenName, Surname, SamAccountName, UserPrincipalName | 
    Select-Object SamAccountName, GivenName, Surname, UserPrincipalName

# Display the users in a GridView for review
$SelectedUsers = $Users | Out-GridView -Title "Select Users to Update Logon Name" -PassThru

# Proceed only if users are selected
if ($SelectedUsers) {
    foreach ($User in $SelectedUsers) {
        # Ensure the user has a first name and last name
        if ($User.GivenName -and $User.Surname) {
            # Construct the new UPN in firstname.lastname@newdomain.com format
            $NewUPN = "$($User.GivenName).$($User.Surname)@$NewUPNSuffix"
            
            try {
                # Update the UPN
                Set-ADUser -Identity $User.SamAccountName -UserPrincipalName $NewUPN
                Write-Host "Updated UPN for $($User.SamAccountName): $NewUPN"
            } catch {
                Write-Host "Failed to update UPN for $($User.SamAccountName). Error: $_"
            }
        } else {
            Write-Host "Skipping $($User.SamAccountName): Missing GivenName or Surname."
        }
    }
} else {
    Write-Host "No users selected. Exiting script."
}