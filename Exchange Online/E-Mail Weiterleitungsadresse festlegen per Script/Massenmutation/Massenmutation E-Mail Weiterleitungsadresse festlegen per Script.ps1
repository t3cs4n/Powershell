# Import the CSV file containing user information
$users = Import-Csv -Path "C:\path\to\users.csv"

# Process each user in the CSV file
foreach ($user in $users) {
    # Get the user's email address and forwarding email address from the CSV file
    $userEmail = $user.Email
    $forwardingEmail = $user.ForwardingEmail

    # Set the forwarding SMTP address for the user
    Set-Mailbox -Identity $userEmail -ForwardingSmtpAddress $forwardingEmail  -DeliverToMailboxAndForward $True

    # Write a message to the console to indicate that the forwarding address was set
    Write-Output "Forwarding SMTP address set for user: $userEmail"
}