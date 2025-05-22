$OUPath = "OU=Perskontos_Premium,OU=Ambulant,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh"  # Replace with your actual OU path
$DomainName = "eulachtal.ch"              # Replace with your email domain

# Import Active Directory module if not already imported
Import-Module ActiveDirectory

# Fetch all user accounts in the specified OU
$users = Get-ADUser -Filter * -SearchBase $OUPath -Properties EmailAddress, SamAccountName

foreach ($user in $users) {
    # Define the email address pattern, e.g., SamAccountName@domain.com
    $email = "$($user.SamAccountName)@$DomainName"

    # Update the user's email address if not already set or if you want to override
    if (-not $user.EmailAddress) {
        Set-ADUser -Identity $user.SamAccountName -EmailAddress $email
        Write-Host "Updated email for user $($user.SamAccountName) to $email"
    } else {
        Write-Host "User $($user.SamAccountName) already has an email address: $($user.EmailAddress)"
    }
}

Write-Host "Email update process completed for all users in the OU."