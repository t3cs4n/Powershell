Import-Csv -Path "C:\Powershell_Importe\RenameSpitexUserTableShortTest.csv" | ForEach-Object {
    
 # Get the user's old name
$oldName = $_.SamAccountName

# Get the user's new name
$newName = $_.NewName


$user = Get-ADUser -Identity $oldName

$user |Rename-ADObject -NewName $newName
    
}