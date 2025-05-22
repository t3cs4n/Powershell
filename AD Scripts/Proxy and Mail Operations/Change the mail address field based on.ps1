# Change the mail address field based on the primary proxy address


# Define the OU where the users are located
$OU = "OU=TV_User,OU=Ambulant,OU=_Mitarbeiter,OU=Benutzer,OU=Eulachtal,DC=eulachtal,DC=zh" # Replace with your target OU

Import-Module ActiveDirectory

# Get all users in the specified OU
$users = Get-ADUser -Filter * -SearchBase $OU -Properties proxyAddresses, EmailAddress

# Loop through each user
foreach ($user in $users) {
    try {
        # Get the user's proxyAddresses attribute
        $proxyAddresses = $user.proxyAddresses

        # Check if the user has proxyAddresses defined
        if ($proxyAddresses -ne $null -and $proxyAddresses.Count -gt 0) {
            # Extract the primary SMTP address (starts with "SMTP:" in uppercase)
            $primarySMTP = ($proxyAddresses | Where-Object { $_ -cmatch "^SMTP:" }) -replace "^SMTP:", ""

            if ($primarySMTP -is [string] -and $primarySMTP) {
                # Update the user's mail attribute with the primary SMTP address
                Set-ADUser -Identity $user.DistinguishedName -EmailAddress $primarySMTP
                Write-Host "Updated mail attribute for user: $($user.SamAccountName) to $primarySMTP" -ForegroundColor Green
            } else {
                Write-Host "No primary SMTP address found for user: $($user.SamAccountName)" -ForegroundColor Yellow
            }
        } else {
            Write-Host "No proxyAddresses attribute found for user: $($user.SamAccountName)" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error processing user: $($user.SamAccountName). Error: $_" -ForegroundColor Red
    }
}