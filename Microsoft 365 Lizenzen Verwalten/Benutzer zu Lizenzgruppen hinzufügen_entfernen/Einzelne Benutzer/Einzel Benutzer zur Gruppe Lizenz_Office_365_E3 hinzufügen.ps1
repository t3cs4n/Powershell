<#

Autor : Miguel Santiago

Dieses Script kannst du nutzen um mehrere Benutzer der Gruppe Lizenz_Office_365_E3 hinzuzufügen.
Liste dazu die betroffenen Benutzer nach dem -Members auf. Siehe Beispiel in Zeile 8

Add-ADGroupMember -Identity Lizenz_Office_365_E3 -Members sami, tsra, heca usw


#>



Add-ADGroupMember -Identity Lizenz_Office_365_E3 -Members tsadminoffice,tsadminoffice_2,tsadminoffice_3,tsadminoffice_4,tsadminoffice_5