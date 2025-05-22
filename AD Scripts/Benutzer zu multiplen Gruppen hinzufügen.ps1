

param
(
[Parameter(Mandatory)][String[]] $Gruppen
) 
$Gruppen # Output for diagnostic purposes

$Username = (Read-Host -Prompt "Enter User Name")



Add-ADPrincipalGroupMembership $Username -MemberOf $Gruppen