<#

 Autor : Miguel Santiago

 Dieses Script kannst du nutzen um X Anzahl Benutzer der Gruppe Lizenz_Microsoft_365_Business_Standard hinzuzufügen.
 Liste dazu die betroffenen Benutzer in einer CSV-Datei. Der Quellcode wurde für Eulachtal Umgebung angepasst.


 Script Quell Code : https://www.alitajran.com/add-users-to-group-powershell/#:~:text=Users%20PowerShell%20script.-,Bulk%20add%20users%20to%20group%20from%20CSV%20file,users%20in%20the%20CSV%20file.


#>



# Start transcript
Start-Transcript -Path C:\Add-ADUsers.log -Append

# Import AD Module
Import-Module ActiveDirectory

# Import the data from CSV file and assign it to variable
$Users = Import-Csv "C:\Temp\Users.csv"

# Specify target group name (pre-Windows 2000) where the users will be added to
# You can add the distinguishedName of the group. For example: CN=Pilot,OU=Groups,OU=Company,DC=exoip,DC=local
$Group = "Lizenz_Microsoft_365_Business_Standard"

foreach ($User in $Users) {
    # Retrieve UPN
    $UPN = $User.UserPrincipalName

    # Retrieve UPN related SamAccountName
    $ADUser = Get-ADUser -Filter "UserPrincipalName -eq '$UPN'" | Select-Object SamAccountName

    # User from CSV not in AD
    if ($null -eq $ADUser) {
        Write-Host "$UPN does not exist in AD" -ForegroundColor Red
    }
    else {
        # Retrieve AD user group membership
        $ExistingGroups = Get-ADPrincipalGroupMembership $ADUser.SamAccountName | Select-Object Name

        # User already member of group
        if ($ExistingGroups.Name -eq $Group) {
            Write-Host "$UPN already exists in $Group" -ForeGroundColor Yellow
        }
        else {
            # Add user to group

            # Solange der -WhatIf Parameter dran ist, wird nur vorgeführt was das Script tut. 
            # Um die Änderungen wirklich durchzuführen, musst du -WhatIf löschen und dann laufen lassen.

            Add-ADGroupMember -Identity $Group -Members $ADUser.SamAccountName -WhatIf
            Write-Host "Added $UPN to $Group" -ForeGroundColor Green
        }
    }
}
Stop-Transcript