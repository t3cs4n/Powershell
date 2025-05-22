<#

 Add multiple users to Azure AD group


#>



# Replace with your Azure AD tenant ID
$TenantId = "abc6c12e-0f5c-49c3-97ac-269d303c08b2"

# Connect to Azure AD
Connect-AzureAD -TenantId $TenantId

# Specify the CSV file path
$csvFile = "E:\03_IT\000.__AADS_UND_ADS_EXPORTE_CLEANING__\365_Standard_Liz_Users.csv"

# Import the CSV file
$users = Import-Csv $csvFile

# Specify the group name
$groupName = "Lizenz_Microsoft_365_Business_Standard"

# Get the group object
$group = Get-AzureADGroup -Filter "DisplayName eq '$groupName'"

foreach ($user in $users) {
    $azureADUser = Get-AzureADUser -Filter "UserPrincipalName eq '$($user.SamAccountName)'"
    if ($azureADUser) {
        Add-AzureADGroupMember -ObjectId $group.ObjectId -ObjectId $azureADUser.ObjectId
        Write-Host "Added $user.SamAccountName to group $groupName"
    } else {
        Write-Host "User $user.SamAccountName not found in Azure AD"
    }
}
