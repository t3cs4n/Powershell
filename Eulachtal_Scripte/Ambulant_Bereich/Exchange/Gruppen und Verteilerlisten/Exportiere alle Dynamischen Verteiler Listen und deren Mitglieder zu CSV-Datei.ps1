# Importieren des ExchangeOnline Managment Moduls


Import-Module ExchangeOnlineManagement


# An Exchange Online via Powershell anmelden. Passwort findest du im Passwort Tool


Connect-ExchangeOnline -UserPrincipalName  Informatik_Eulachtal@spitex-eulachtal.ch


$DDGS = Get-DynamicDistributionGroup 
$results = foreach ($ddg in $DDGS) {Get-Recipient -RecipientPreviewFilter 
(Get-DynamicDistributionGroup $ddg.PrimarySmtpAddress).RecipientFilter 
-RecipientTypeDetails UserMailbox,SharedMailbox,RoomMailbox,EquipmentMailbox,TeamMailbox, DiscoveryMailbox,MailUser, 
MailContact, DynamicDistributionGroup, MailUniversalDistributionGroup,MailUniversalSecurityGroup,RoomList,GuestMailUser,PublicFolder,GroupMailbox | 
Add-Member -MemberType NoteProperty -Name DDG -Value $ddg.PrimarySmtpAddress -PassThru | 
select DDG,DisplayName, PrimarySmtpAddress,RecipientTypeDetails} $results | Export-CSV -path 'C:\Downloads\spitex_eulachtal_DDGList.csv'
 
#Get Microsoft Group Members and Exports to CSV

$Result | Export-CSV $CSVFilePath -NoTypeInformation -Encoding UTF8