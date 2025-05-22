
Import-Module AzureAd -ErrorAction SilentlyContinue
 
#Parameters
$UserID = "homa@eulachtal.ch"


#Connect to Azure AD
Connect-AzureAD -Credential (Get-Credential) | Out-Null


Try {
    #Get the User
    $User = Get-AzureADUser -ObjectId $UserID
 
    #Get User's Group Memberships
    $Memberships = Get-AzureADUserMembership -ObjectId $User.ObjectId | Where-object { $_.ObjectType -eq "Group" }
 
    #Export group memberships to a CSV
    $Memberships | Select-Object DisplayName, Mail, ObjectId
}
Catch {
    write-host -f Red "`tError:" $_.Exception.Message
} 
