<#
    .SYNOPSIS
    Export-ADUsers.ps1

    .DESCRIPTION
    Export Active Directory users to CSV file.

    .LINK
    alitajran.com/export-ad-users-to-csv-powershell

    .NOTES
    Written by: ALI TAJRAN
    Website:    alitajran.com
    LinkedIn:   linkedin.com/in/alitajran

    .CHANGELOG
    V1.00, 05/24/2021 - Initial version
    V1.10, 04/01/2023 - Added progress bar, user created date, and OU info
    V1.20, 05/19/2023 - Added function for OU path extraction
#>

# Split path
$Path = Split-Path -Parent "C:\scripts\*.*"

# Create variable for the date stamp in log file
$LogDate = Get-Date -f yyyyMMddhhmm

# Define CSV and log file location variables
# They have to be on the same location as the script
$Csvfile = $Path + "\AllADUsers_$LogDate.csv"

# Import Active Directory module
Import-Module ActiveDirectory

# Function to extract OU from DistinguishedName
function Get-OUFromDistinguishedName {
    param(
        [string]$DistinguishedName
    )

    $ouf = ($DistinguishedName -split ',', 2)[1]
    if (-not ($ouf.StartsWith('OU') -or $ouf.StartsWith('CN'))) {
        $ou = ($ouf -split ',', 2)[1]
    }
    else {
        $ou = $ouf
    }
    return $ou
}

# Set distinguishedName as searchbase, you can use one OU or multiple OUs
# Or use the root domain like DC=exoip,DC=local
$DNs = @(
    "OU=Sales,OU=Users,OU=Company,DC=exoip,DC=local",
    "OU=IT,OU=Users,OU=Company,DC=exoip,DC=local",
    "OU=Finance,OU=Users,OU=Company,DC=exoip,DC=local"
)

# Create empty array
$AllADUsers = @()

# Loop through every DN
foreach ($DN in $DNs) {
    $Users = Get-ADUser -SearchBase $DN -Filter * -Properties * 

    # Add users to array
    $AllADUsers += $Users

    # Display progress bar
    $progressCount = 0
    for ($i = 0; $i -lt $AllADUsers.Count; $i++) {

        Write-Progress `
            -Id 0 `
            -Activity "Retrieving User " `
            -Status "$progressCount of $($AllADUsers.Count)" `
            -PercentComplete (($progressCount / $AllADUsers.Count) * 100)

        $progressCount++
    }      
}

# Create list
$AllADUsers | Sort-Object Name | Select-Object `
@{Label = "First name"; Expression = { $_.GivenName } },
@{Label = "Last name"; Expression = { $_.Surname } },
@{Label = "Display name"; Expression = { $_.DisplayName } },
@{Label = "User logon name"; Expression = { $_.SamAccountName } },
@{Label = "User principal name"; Expression = { $_.UserPrincipalName } },
@{Label = "Street"; Expression = { $_.StreetAddress } },
@{Label = "City"; Expression = { $_.City } },
@{Label = "State/province"; Expression = { $_.State } },
@{Label = "Zip/Postal Code"; Expression = { $_.PostalCode } },
@{Label = "Country/region"; Expression = { $_.Country } },
@{Label = "Job Title"; Expression = { $_.Title } },
@{Label = "Department"; Expression = { $_.Department } },
@{Label = "Company"; Expression = { $_.Company } },
@{Label = "Manager"; Expression = { (Get-AdUser $_.Manager -Properties DisplayName).DisplayName } },
@{Label = "OU"; Expression = { Get-OUFromDistinguishedName $_.DistinguishedName } },
@{Label = "Description"; Expression = { $_.Description } },
@{Label = "Office"; Expression = { $_.Office } },
@{Label = "Telephone number"; Expression = { $_.telephoneNumber } },
@{Label = "Other Telephone"; Expression = { $_.otherTelephone -join ";"} },
@{Label = "E-mail"; Expression = { $_.Mail } },
@{Label = "Mobile"; Expression = { $_.mobile } },
@{Label = "Pager"; Expression = { $_.pager } },
@{Label = "Notes"; Expression = { $_.info } },
@{Label = "Account status"; Expression = { if (($_.Enabled -eq 'TRUE') ) { 'Enabled' } Else { 'Disabled' } } },
@{Label = "User created date"; Expression = { $_.WhenCreated } },
@{Label = "Last logon date"; Expression = { $_.lastlogondate } } |

# Export report to CSV file
Export-Csv -Encoding UTF8 -Path $Csvfile -NoTypeInformation #-Delimiter ";"