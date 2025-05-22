 <#
 
  Exportiere folgende Attribute (SamAccountName, Vorname und Nachname) Benutzern in einer bestimmten Organisationseinheit.

 #>



Get-ADUser -Filter * -SearchBase "OU=NoMail,OU=Benutzer_Intern_ALLE,OU=Benutzer,OU=eulachtal,DC=eulachtal,DC=zh" -Properties samaccountname, name, surname | Select-Object samaccountname, name, surname | Out-GridView


Get-ADUser -Filter * -SearchBase "OU=NoMail,OU=Benutzer_Intern_ALLE,OU=Benutzer,OU=eulachtal,DC=eulachtal,DC=zh" -Properties samaccountname, name, surname | Select-Object samaccountname, name, surname | Export-Csv -Path C:\Powershell_Importe\Empty_Mail_Attribute_Users.csv -Encoding UTF8 -NoTypeInformation
 
