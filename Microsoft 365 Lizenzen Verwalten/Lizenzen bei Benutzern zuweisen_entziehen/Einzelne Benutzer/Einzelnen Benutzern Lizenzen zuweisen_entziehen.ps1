<#

 Autor : Miguel Santiago

 Mit diesem Script kannst Benutzern Microsoft Lizenzen zuweisen oder auch entziehen.

 Der Übersichtshalber, habe ich das Script in verschiedene Teile gegliedert.
 
 Solltest du Fragen dazu haben, zögere nicht mich anzusprechen. 
 

 Quelle für das Script : https://blog.icewolf.ch/archive/2021/10/28/hinzufugen-und-entfernen-von-m365-lizenzen-mit-powershell/  

 
#>


# Teil 1: Verbinden mit der Azure AD und anzeigen der SkuID's der vorhandenen Lizenzen.


Connect-AzureAD


Get-AzureADSubscribedSku | Select-Object SkuPartNumber, SkuId


<# 

 Teil 2: 

 Einem Benutzer eine bestimmte Lizenz zuweisen (in diesem Beispiel die Microsoft 365 Business Basic)
  
 Den Benutzer bei $UPN eintragen (da muss der UserPrincipalName rein, denn findest du in den Atrributen > AD)

 Um den Lizenz Typ zu ändern, trage die SkuID bei $License.Skuid zwischen den " " ein. Die SkuID's unserer Produkte
 findest du hier : \\netapp01\daten\03_IT\01. Powershell Scripts\Eulachtal Scripte\Microsoft Lizenzen AccountSkuId Übersetzung zum angezeigten Namen auf Microsoft 354 Admin Portal.xlsx

#>

$UPN = "miguel.santiago@eulachtal.ch"
$User = Get-AzureADUser -ObjectId $UPN
$License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$License.SkuId = "3b555118-da6a-4418-894f-7df1e2096870"
$LicensesToAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$LicensesToAssign.AddLicenses = $License
Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $LicensesToAssign




<# 

 Teil 3: 

 Einem Benutzer eine bestimmte Lizenz entziehen (in diesem Beispiel die Microsoft 365 Business Basic)
  
 Den Benutzer bei $UPN eintragen (da muss der UserPrincipalName rein, denn findest du in den Atrributen > AD)

 Um den Lizenz Typ zu ändern, trage die SkuID bei $License.Skuid zwischen den " " ein. Die SkuID's unserer Produkte
 findest du hier : \\netapp01\daten\03_IT\01. Powershell Scripts\Eulachtal Scripte\Microsoft Lizenzen AccountSkuId Übersetzung zum angezeigten Namen auf Microsoft 354 Admin Portal.xlsx

#>

$UPN = "miguel.santiago@eulachtal.ch"
$User = Get-AzureADUser -ObjectId $UPN
$License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$License.SkuId = "3b555118-da6a-4418-894f-7df1e2096870"
$LicensesToAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$LicensesToAssign.RemoveLicenses = $License.SkuId
Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $LicensesToAssign
