# Import the Active Directory module

 Import-Module ActiveDirectory

 # Define the Organizational Unit (OU) and the new description
 $OU = "OU=Perskontos_Basic_Mobile,OU=Ambulant,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"  # Modify this to match your actual OU
 $NewDescription = "Basic Mobile User"  # The new description to set

 # Get all users from the specified OU
 $Users = Get-ADUser -Filter * -SearchBase $OU

 # Loop through each user and update their description
 foreach ($User in $Users) {
     # Set the new description for each user
     Set-ADUser -Identity $User.SamAccountName -Description $NewDescription

     # Output the result for each user
     Write-Host "Updated description for $($User.SamAccountName) to '$NewDescription'"
 }

 Write-Host "Description updated for all users in $OU."