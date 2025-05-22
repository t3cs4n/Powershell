<#

 Autor : Miguel Santiago

 Mit diesem Script kannst Massenmutationen (Zuweisung/Entzug) von spezifischen Lizenzen bei Benutzern durchführen.

 Der Übersichtshalber, habe ich das Script in verschiedene Teile gegliedert.
  

 Quelle für das Script : https://stackoverflow.com/questions/77366845/powershell-assign-specific-license-to-users-bulk  


 
#>


# Teil 1: Verbinden mit der Azure AD und anzeigen der SkuID's der vorhandenen Lizenzen.



Connect-AzureAD


Get-AzureADSubscribedSku | Select-Object SkuPartNumber, SkuId


<# 

 Teil 2: 

 Einer Liste von Benutzer (ensprechende CSV-Datei) eine bestimmte Lizenz zuweisen (in diesem Beispiel die Microsoft 365 Business Basic)
  
 Das CSV-File Muster findest du im Ordner CSV_Import. In die UPN Spalte muss der UserPrincipalName aller Benutzer die du verarbeiten möchtest. 
 (Den UPN findest du du in den Atrributen > AD oder beim exportieren der Benutzer aus M365)

 Um den Lizenz Typ zu ändern, trage die SkuID bei $License.Skuid zwischen den " " ein. Die SkuID's unserer Produkte
 findest du hier : \\netapp01\daten\03_IT\01. Powershell Scripts\Eulachtal Scripte\Microsoft Lizenzen AccountSkuId Übersetzung zum angezeigten Namen auf Microsoft 354 Admin Portal.xlsx

#>



$users = Import-Csv C:\Powershell_Importe\VORLAGE_Microsoft_Lizenz_Massenmutation_Users.csv

# iterate over list 
foreach($user in $users) {
  # grab upn value from the CSV record instead of using a hard-coded value
  $UPN = $user.UserPrincipalName

  # everything else remains the same
  $User = Get-AzureADUser -ObjectId $UPN
  $License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
  $License.SkuId = "3b555118-da6a-4418-894f-7df1e2096870"  #Setzte hier Links die richtige SkuID ein
  $LicensesToAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
  $LicensesToAssign.AddLicenses = $License
Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $LicensesToAssign
}


<# 

 Teil 3: 

 Einer Liste von Benutzer (ensprechende CSV-Datei) eine bestimmte Lizenz entziehen (in diesem Beispiel die Microsoft 365 Business Basic)
  
 Das CSV-File Muster findest du im Ordner CSV_Import. In die UPN Spalte muss der UserPrincipalName aller Benutzer die du verarbeiten möchtest. 
 (Den UPN findest du du in den Atrributen > AD oder beim exportieren der Benutzer aus M365)

 Um den Lizenz Typ zu ändern, trage die SkuID bei $License.Skuid zwischen den " " ein. Die SkuID's unserer Produkte
 findest du hier : \\netapp01\daten\03_IT\01. Powershell Scripts\Eulachtal Scripte\Microsoft Lizenzen AccountSkuId Übersetzung zum angezeigten Namen auf Microsoft 354 Admin Portal.xlsx

#>


$users = Import-Csv C:\Powershell_Importe\Premium_und_Standard.csv

# iterate over list 
foreach($user in $users) {
  # grab upn value from the CSV record instead of using a hard-coded value
  $UPN = $user.UserPrincipalName

  # everything else remains the same
  $User = Get-AzureADUser -ObjectId $UPN
  $License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
  $License.SkuId = "f245ecc8-75af-4f8e-b61f-27d8114de5f3" #Setzte hier Links die richtige SkuID ein
  $LicensesToAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
  $LicensesToAssign.RemoveLicenses = $License.SkuId
  Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $LicensesToAssign
 }