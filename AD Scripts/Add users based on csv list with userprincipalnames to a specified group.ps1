# Add users based on csv list with userprincipalnames to a specified group

# Path to the CSV file
$csvPath = "C:\AzureADExports\Members_365_Premium_Lizenz.csv"

# Name der AD-Gruppe, zu der Benutzer hinzugefügt werden sollen
$groupName = "M365_Premium_Lizenz"

# CSV importieren
$users = Import-Csv -Path $csvPath

# Schleife, um jeden Benutzer hinzuzufügen
foreach ($user in $users) {

    # Benutzerobjekt anhand des UserPrincipalName abrufen
    $userObject = Get-ADUser -Filter "UserPrincipalName -eq '$($user.UserPrincipalName)'"

    if ($userObject) {
        # Benutzer zur Gruppe hinzufügen
        Add-ADGroupMember -Identity $groupName -Members $userObject
        
        # Erfolgsmeldung in Grün
        Write-Host "Benutzer '$($user.UserPrincipalName)' wurde erfolgreich zur Gruppe '$groupName' hinzugefügt." -ForegroundColor Green
    }
    else {
        # Fehlermeldung in Rot
        Write-Host "Benutzer '$($user.UserPrincipalName)' NICHT gefunden!" -ForegroundColor Red
    }
}