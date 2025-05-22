<#


E-Mail Weiterleitungsadresse festlegen per Script


#>


Connect-ExchangeOnline


Set-Mailbox -Identity "informatik.testbox@spitex-eulachtal.ch" -ForwardingSmtpAddress "it.testbox@eulachtal.ch" -DeliverToMailboxAndForward $True



