# Importieren des ExchangeOnline Managment Moduls


Import-Module ExchangeOnlineManagement


# An Exchange Online via Powershell anmelden. Passwort findest du im Passwort Tool


Connect-ExchangeOnline -UserPrincipalName  Informatik_Eulachtal@spitex-eulachtal.ch


$CSVFilePath = "C:\Downloads\spitex_eulachtal_MicrosoftGroups-Members.csv"

$Result=@()
$groups = Get-UnifiedGroup -ResultSize Unlimited
$totalmbx = $groups.Count
$i = 1 
$groups | ForEach-Object {
Write-Progress -activity "Processing $_.DisplayName" -status "$i out of $totalmbx completed"
$group = $_
Get-UnifiedGroupLinks -Identity $group.id -LinkType Member | ForEach-Object {
$member = $_
$Result += New-Object PSObject -property @{ 
GroupName = $group.DisplayName
Member = $member.Name
EmailAddress = $member.PrimarySMTPAddress
RecipientType= $member.RecipientType
}}
$i++
}
 
#Get Microsoft Group Members and Exports to CSV

$Result | Export-CSV $CSVFilePath -NoTypeInformation -Encoding UTF8