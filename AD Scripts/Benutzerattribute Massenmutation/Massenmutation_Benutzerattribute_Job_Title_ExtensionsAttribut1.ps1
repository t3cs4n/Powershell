


Import-Module ActiveDirectory

$CSVFilePath = "C:\powershell_importe\Benutzerattribute_Job_Title_ExtensionsAttribut2.csv"
$Users = Import-Csv -Path $CSVFilePath

foreach ($User in $Users) {
  Set-ADUser -Identity $User.SamAccountName -Replace @{
    ExtensionAttribute1 = $User.ExtensionAttribute1
    Title = $User.Title
  }
}