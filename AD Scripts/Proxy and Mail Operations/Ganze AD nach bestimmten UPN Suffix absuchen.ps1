<#

 Ganze Active Directory nach Benutzer mit dem UPN Suffix spitex-eulachtal.ch absuchen. Nur wenn es 
 Benutzer mit dem UPN Suffix findet, werden diese angezeigt. Ansonsten ist die Ausgabe leer.

#>



Get-ADUser -Filter {UserPrincipalName -like '*spitex-eulachtal.ch'} | Sort-Object Name | Format-Table Name, UserPrincipalName 
