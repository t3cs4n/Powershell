<#

  Autor : Miguel Santiago


  Mit diesem Script kann eine Liste der vorhandenen Benutzer Postfächer exportiert werden.
    

#>





Connect-ExchangeOnline




$Maiboxes = Get-Mailbox | Where-Object {$_.RecipientTypeDetails -eq "UserMailbox"}
$Result1 = @()
foreach ($Maibox in $Maiboxes) {
$a = Get-MailboxStatistics $Maibox.Alias | Select-Object TotalItemSize,Displayname
$b = Get-MailboxFolderStatistics $Maibox.Alias | Where-Object {$_.Name -eq "Recoverable Items"} | Select-Object @{Expression={};Label="Name";}, @{Expression={};Label="MailboxSize";}, @{Expression={$_.FolderAndSubfolderSize};Label="RecoverableItemsSize";}
$b.Mailboxsize= $a.TotalItemSize
$b.Name =  $a.Displayname
$Result1 += $b

}
$Result1 | Export-csv -Path \\netapp01\daten\03_IT\000._AADS_UND_ADS_EXPORTE_CLEANING__\EULACHTAL\AAD_UND_AD_Exporte\User_Mailboxes_Eulachtal.csv -NoTypeInformation -Encoding UTF8