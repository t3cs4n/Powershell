<# 

 Mit diesem Script kann du Nachrichten an angemeldete Benutzer senden.
 Wenn du es ausführst wirst du zur EIngabe folgender Angaben aufgefordert:
 
 Benutzernamen: Den Benutzernamen des Empfängers (in unserer Umgebung ist dies das Kürzel)
 Computernamen: Den Computernamen des Computers auf dem er arbeitet (eventuell der Terminalserver).
                Du kannst mehrere Computernamen angeben getrennt durch Kommas. Beispiel PC1,PC2,PC3 etc.
                oder du kannst den Pfad zu einem Textfile angeben in welchem du alle Computernamen angibts.
                Pro Zeile einen Computernamen
                PC1
                PC2
                PC3 
                etc

 Nachricht:     Gib hier die Nachricht ein welche du den Benutzern senden möchtest.

#>

# Variable declaration
$Benutzernamen         =       Read-Host -Prompt “Type the username here”      
$ComputerName     =       Read-Host -Prompt “Type the computername here”      
$Nachricht          =       Read-Host -Prompt “Type the message here”




msg $Benutzernamen /Server:$ComputerName "$Nachricht"
