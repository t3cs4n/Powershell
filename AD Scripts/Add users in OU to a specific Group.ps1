

# Define the Distinguished Name (DN) of the OU you want to target and the group name
$OU = "OU=Perskontos_Premium,OU=Ambulant,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"    # Replace with the DN of your OU
$GroupName = "365_Perigon"           # Replace with the name of your target group

# Import the Active Directory module
Import-Module ActiveDirectory

# Retrieve the group object
$Group = Get-ADGroup -Identity $GroupName -ErrorAction Stop

# Get all users in the specified OU
$Users = Get-ADUser -Filter * -SearchBase $OU -SearchScope Subtree

# Iterate over each user and add them to the group
foreach ($User in $Users) {
    # Check if the user is already a member of the group
    if (-not (Get-ADGroupMember -Identity $GroupName | Where-Object { $_.distinguishedName -eq $User.DistinguishedName })) {
        # Add the user to the group
        Add-ADGroupMember -Identity $GroupName -Members $User.DistinguishedName
        Write-Output "Added user $($User.SamAccountName) to group $GroupName."
    } else {
        Write-Output "User $($User.SamAccountName) is already a member of $GroupName."
    }
}

Write-Output "Script completed successfully."