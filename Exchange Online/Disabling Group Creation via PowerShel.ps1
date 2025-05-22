# Disabling Group Creation via PowerShell

# For detailed instructions, refer to the official documentation here.

# To disable group creation for your tenant using PowerShell:


# Install the latest version of the AzureAD preview PowerShell module from the gallery
Install-module azureadpreview -AllowClobber -Force

# Specify the display name of the security group to exempt (if needed)
$groupException = "GroupCreationExceptions" # Change to your Group name

# Set to $false to disable group creation in your tenant; set to $true to enable group creation again.
$allowGroupCreation = $false

AzureADPreview\Connect-AzureAD

$settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id
if(!$settingsObjectID)
{
	$template = Get-AzureADDirectorySettingTemplate | Where-object {$_.displayname -eq "group.unified"}
    $settingsCopy = $template.CreateDirectorySetting()
    New-AzureADDirectorySetting -DirectorySetting $settingsCopy
    $settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id
}

$settingsCopy = Get-AzureADDirectorySetting -Id $settingsObjectID
$settingsCopy["EnableGroupCreation"] = $allowGroupCreation

if (![String]::IsNullOrWhiteSpace($groupException)) {
   $settingsCopy["GroupCreationAllowedGroupId"] = (Get-AzureADGroup -SearchString $groupException).objectid
}

Set-AzureADDirectorySetting -Id $settingsObjectID -DirectorySetting $settingsCopy

(Get-AzureADDirectorySetting -Id $settingsObjectID).Values