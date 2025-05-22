# Import the Active Directory module
Import-Module ActiveDirectory

# Define the Organizational Unit (OU) and the group
$OU = "OU=Perskontos_Basic,OU=Benutzer_Interne,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"  # Modify this to match your actual OU
$Group = "Basic_Users"               # Modify this to the actual group name

# Get all users from the specified OU
$Users = Get-ADUser -Filter * -SearchBase $OU

# Loop through each user and add them to the group
foreach ($User in $Users) {
    # Add the user to the group
    Add-ADGroupMember -Identity $Group -Members $User.SamAccountName
    
    # Output the result for each user
    Write-Host "Added $($User.SamAccountName) to group $Group"
}

Write-Host "All users from $OU have been added to $Group."





# Import the Active Directory module
Import-Module ActiveDirectory

# Define the Organizational Unit (OU) and the group
$OU = "OU=00_TV_User,OU=Benutzer_Spitex,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"  # Modify this to match your actual OU
$Group = "Alle Mitarbeiter"               # Modify this to the actual group name

# Get all users from the specified OU
$Users = Get-ADUser -Filter * -SearchBase $OU

# Loop through each user and remove them from the group
foreach ($User in $Users) {
    # Remove the user from the group
    Remove-ADGroupMember -Identity $Group -Members $User.SamAccountName -Confirm:$false
    
    # Output the result for each user
    Write-Host "Removed $($User.SamAccountName) from group $Group"
}

Write-Host "All users from $OU have been removed from $Group."