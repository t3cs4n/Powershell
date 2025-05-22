

# Define an array of users with their details
$users = @(
    @{UserName = "tve1"; Name = "Tagesverantwortlicher"; Surname = "Elgg01"},
    @{UserName = "tve2"; Name = "Tagesverantwortlicher"; Surname = "Elgg02"},
    @{UserName = "tve3"; Name = "Tagesverantwortlicher"; Surname = "Elgg03"},
    @{UserName = "tve4"; Name = "Tagesverantwortlicher"; Surname = "Elgg04"}
)

# Loop through each user and update their properties
foreach ($user in $users) {
    # Update user's Name (GivenName) and Surname
    Set-ADUser -Identity $user.UserName `
               -GivenName $user.Name `
               -Surname $user.Surname `
               -DisplayName "$($user.Name) $($user.Surname)"  # Optional: Update DisplayName if needed

    # Output the updated information for verification
    Write-Output "Updated user: $($user.Name) $($user.Surname)"
}