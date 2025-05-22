param([Parameter(Mandatory=$true)][String]$samAccountName)

$NewFolder = New-Item -Path "\\vdc20.qbic.local\Users$\$samAccountName" -ItemType "directory"

$acl = get-acl  $NewFolder

$ar = new-object system.security.accesscontrol.filesystemaccessrule($samAccountName,"Modify","ObjectInherit","None","Allow")

$acl.SetAccessRule($ar)

$ar2 = new-object system.security.accesscontrol.filesystemaccessrule($samAccountName,"Modify","ContainerInherit","None","Allow")

$acl.AddAccessRule($ar2)

$acl | Set-acl \\vdc20.qbic.local\Users$\$samAccountName
