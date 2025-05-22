



# Import Exchange Online Management Module
Import-Module ExOnlineManagement

# Set CSV file path (adjust as needed)
$csvFile = "C:\SharedMailboxes.csv"

# Read user data from CSV
$mailboxData = Import-Csv -Path $csvFile

# Loop through each mailbox entry
foreach ($mailbox in $mailboxData) {
  # Extract mailbox name and user list
  $mailboxName = $mailbox.MailboxName
  $displayName = $mailbox.DisplayName
  $users = $mailbox.Users -split ','

  # Create the shared mailbox with default 50GB storage
  New-Mailbox -Name $mailboxName -Type Shared -StorageQuota 50GB

  # Assign FullControl permission to each user
  foreach ($user in $users) {
    Add-MailboxPermission -Identity $mailboxName -DisplayName $DisplayName -User $user -AccessRights FullControl
  }

  # (Optional) Assign Send As permission (uncomment to enable)
  #foreach ($user in $users)
  Add-DistributionGroupMember -Identity $mailboxName -Member $user -SendAsPermission $true
  

  Write-Host "Shared mailbox '$mailboxName' created and permissions assigned."
}



<#

CSV Example


Code-Snippet
MailboxName,DisplayName,Users
MarketingTeam,user1@contoso.com,user3@contoso.com
SalesDepartment,user2@contoso.com,user4@contoso.com
Finance,user5@contoso.com

#>