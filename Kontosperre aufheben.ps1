<#

 Mit diesem Script kannst du für ein spezifisches Konto die Sperrung aufheben.

 Bei mehreren Benutzern nutze die Befehlszeile mit der Schleife (deaktivierte Zeile),
 und füge alle zu entsperrenden Konto Kürzel ein.

#>

# "heca","sami","lema"|%{Enable-ADAccount $_}


Unlock-ADAccount -Identity zs