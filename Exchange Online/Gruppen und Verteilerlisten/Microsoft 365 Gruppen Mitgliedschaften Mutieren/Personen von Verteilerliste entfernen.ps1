# Muss noch getestet werden 



# Import the Exchange Online Management module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline

# Get the distribution list to which you want to add members
$distributionList = Get-DistributionGroup -Identity "DistributionListName"

# Import the CSV file containing the members to add
$members = Import-Csv -Path "C:\Path\To\CSVFile.csv"

# Add each member to the distribution list
foreach ($member in $members) {
    Remove-DistributionGroupMember -Identity $distributionList -Member $member.EmailAddress
}