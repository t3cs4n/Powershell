<#

 Create Shortcut to other Computer Profile based on the logged user. 


#>



$WScriptShell = New-Object -ComObject WScript.Shell
$ShortcutPath = "$env:USERPROFILE\Desktop\Meine Daten Terminal Server.lnk"
$TargetPath = "\\terminal\users\%username%\"

$Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = $TargetPath
$Shortcut.Save()