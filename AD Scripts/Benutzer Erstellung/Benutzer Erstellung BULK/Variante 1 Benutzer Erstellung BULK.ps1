$Import = Import-CSV ".\users.csv" -Delimiter ";"
$Password = ConvertTo-SecureString "Initpass" -AsPlainText -Force
    
foreach ($user in $Import) {
  # A try-catch statement is used here, if an error is returned from Get-ADOrganisationUnit then it will run the code in the Catch segment.
  try {
    # Try to get info on this OU. If it exists then it will output information, which we then delete by piping into Out-Null.
    # If it fails, it will create an error and trigger the Catch statement.
    Get-ADOrganizationalUnit $user.OU -ErrorAction Stop | Out-Null
  }
  catch {
    # Here in the catch statement we create the OU based on the $user.OU value.
    New-ADOrganizationalUnit $user.OU
  }
  # This code is the same, except the path has been replaced with $User.OU.
  New-ADUser 
  # Here you can add as much properties as you want, they just must be in the CSV.
  -SamAccountName $user.SamAccountName
  -UserPrincipalName $users.UserPrincipalName
  -Path $User.OU
  -GivenName $user.GivenName 
  -Surname $user.Surname
  -Initials $user.Initials
  -UserPrincipalName $user.UserPrincipalName
  -AccountPassword $($User.Password | ConvertTo-SecureString -AsPlainText -Force) 
  -ChangePasswordAtLogon $True -Enabled $True 
  
}
