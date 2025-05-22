<# 

   Mit diesem Script wird der Benutzer erstell mit allen Angaben (Attributen) 
   und automatisch in die richtige Organisationseinheit abgelegt (OU). 
   Zusätzlich kann er auch spezifischen Gruppen hinzugefügt werden (Siehe Gruppen Strings).
   Um dies zu machen, müssen am Schluss einfach noch die betreffenden Gruppen angegeben werden.
   Nach dem eingeben der letzten Gruppe, einfach zweimal ENTER drücken, dann endet die Schleife.
   Gruppen in die er verschoben werden soll, die benötigten Parameter angepasst werden, 
   Das Home Drive Verzeichnis wird ebenfalls erstellt und die nötigen (richtigen) Berechtigungen
   für das Verzeichnis werden erteilt. 

   Starte das Script und folger einfach den Anweisungen. Bei Fragen wende dich einfach an das IT Team.

#>
 
  param
(
[Parameter(Mandatory=$true)][String]$Vorname_Abstand_Nachname,
[Parameter(Mandatory=$true)][String]$Vorname,
[Parameter(Mandatory=$true)][String]$Initialen_Beispiel_Miguel_Santiago_MSA,
[Parameter(Mandatory=$true)][String]$Nachname,
[Parameter(Mandatory=$true)][String]$Standort,
[Parameter(Mandatory=$true)][String]$TelefonBüro,
[Parameter(Mandatory=$true)][String]$Emailadresse,
[Parameter(Mandatory=$true)][String]$Homepage,
[Parameter(Mandatory=$true)][String]$Strasse_Abstand_Hausnummer,
[Parameter(Mandatory=$true)][String]$Kantons_Kürzel,
[Parameter(Mandatory=$true)][String]$Postleitzahl,
[Parameter(Mandatory=$true)][String]$Handynummer,
[Parameter(Mandatory=$true)][String]$Job_Titel,
[Parameter(Mandatory=$true)][String]$Abteilung,
[Parameter(Mandatory=$true)][String]$Firmenname_Abstand_AG,
[Parameter(Mandatory=$true)][String]$Vorname_Punkt_Nachname,
[Parameter(Mandatory)][String[]] $Gruppen
) 

$Gruppen # Output for diagnostic purposes


New-ADUser 
-Name "$Vorname_Abstand_Nachname" 
-GivenName "$Vorname" 
-Initials "$Initialen_Beispiel_Miguel_Santiago_MSA" 
-Surname "$Nachname" -DisplayName "$Vorname_Abstand_Nachname" 
-Description "Login: $Vorname_Punkt_Nachname" 
-Office "$Standort" 
-OfficePhone "$TelefonBüro" 
-EmailAddress "$Emailadresse" 
-HomePage "$HomePage" 
-StreetAddress "$Strasse_Abstand_Hausnummer" 
-City "$Standort" 
-State "$Kantons_kürzel" 
-PostalCode "$Postleitzahl" 
-UserPrincipalName "$Emailadresse" 
-SamAccountName "$vorname_Punkt_Nachname" 
-PasswordNeverExpires $true 
-ScriptPath "genKIXTART.exe" 
-HomeDirectory \\vDC20\Users$\$vorname_Punkt_Nachname 
-HomeDrive H 
-MobilePhone "$Handynummer" 
-Title "$Job_Titel" 
-Department "$Abteilung" 
-Company "$Firmenname_Abstand_AG" 
-Manager "CN=Beat Nagel,OU=Intern,OU=Benutzer,OU=QBIC,DC=qbic,DC=local" 
-Path "OU=Intern,OU=Benutzer,OU=QBIC,dc=qbic,dc=local" 
-AccountPassword (Read-Host -AsSecureString "Gib ein Passwort an. Muss mindestens 8 Zeichen lang sein. Darf weder Vor- noch Nachnamen des Benutzers beinhalten, muss Gross- und Kleinbuchstaben als auch Zahlen und Sonderzeichen enthalten") 
-Enabled $true



# Dieser Teil des Script setzt in der Registerkarte Dial-in die Einstellung Network Access Permission auf den Wert "Allow access" 


Set-ADUser -Identity $Vorname_Punkt_Nachname -replace @{msNPAllowDialIn=$TRUE}



<# Diese Script Zeile setzt alle nötigen Parameter, damit die Länderbezeichnung in den Attributen korrekt ist. 
   Je nach Land ändere die drei Einstellungen (c= / co= / countryCode= ). co= einfach der engl. Schreibweise des jeweiligen Landes.
   Die verschiedenen Codes findest du hier https://www.iban.com/country-codes   
#>

Get-ADUser -SearchBase 'OU=Intern,OU=Benutzer,OU=QBIC,DC=QBIC,DC=LOCAL' -filter * | Set-ADUser -Replace @{c="CH";co="Switzerland";countryCode="756"}



# Dieser Teil des Scripts fügt den Benutzer in die angegebene(n) Gruppe(n) ( Add-ADPrincipalGroupMembership max.muster -MemberOf VPN-Zugang,glbMitarbeiter,glbBitwarden,etc)


Add-ADPrincipalGroupMembership $Vorname_Punkt_Nachname -MemberOf $Gruppen



# Dieser Teil des Scripts erstellt das Home Drive Verzeichnis und vergibt die Zugriffsberechtigungen 


$NewFolder = New-Item -Path "\\vdc20.qbic.local\Users$\$vorname_Punkt_Nachname" -ItemType "directory"
$acl = get-acl  $NewFolder
$ar = new-object system.security.accesscontrol.filesystemaccessrule($vorname_Punkt_Nachname,"Modify","ObjectInherit","None","Allow")
$acl.SetAccessRule($ar)
$ar2 = new-object system.security.accesscontrol.filesystemaccessrule($vorname_Punkt_Nachname,"Modify","ContainerInherit","None","Allow")
$acl.AddAccessRule($ar2)
$acl | Set-acl \\vdc20.qbic.local\Users$\$vorname_Punkt_Nachname

Write-Output "Das Script hat alle Aufgaben erledigt!" -ForegroundColor Green

Write-Output "Drücke die Enter Taste um das Fenster zu schliessen!" -ForegroundColor Green

Pause 
