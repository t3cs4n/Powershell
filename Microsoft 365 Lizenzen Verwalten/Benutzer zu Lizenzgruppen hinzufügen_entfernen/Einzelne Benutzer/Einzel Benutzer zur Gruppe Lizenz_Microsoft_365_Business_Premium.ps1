<#

Autor : Miguel Santiago

Dieses Script kannst du nutzen um mehrere Benutzer der Gruppe Lizenz_Microsoft_365_Business_Premium hinzuzufügen.
Liste dazu die betroffenen Benutzer nach dem -Members auf. Siehe Beispiel in Zeile 8

Add-ADGroupMember -Identity Lizenz_Microsoft_365_Business_Premium -Members sami, tsra, heca usw


#>


Einzelne Benutzer hinzufügen : Add-ADGroupMember -Identity Lizenz_Microsoft_365_Business_Premium -Members Benutzer1,Benutzer2 etc


# Massen Zuweisung (Alle Eulachtal Mitarbeiter/Abteilungen/Häuser der Terminalserver Gruppe) : Add-ADGroupMember -Identity Lizenz_Microsoft_365_Business_Premium -Members abt1,abt2,abt3,lc,lb,schulung,staka,zewi,zs,laan,fran,hoan,robe,hobe,bubr,meca,heca,stce,much,sico,scda,gedo,redo,sudo,bies,mofa,scga,flha,geis,maja,brje,shje,scjo,jalo,stlu,mama,bema,hema,anma,homa,lema,miguel.santiago,rami,frmo,mana,wuni,wipr,tsra,scsa,rase,cosi,staka_azubi,bosu,frsu,prsu,trsu,kota,frth,frti,sati,plur,heva,javi,beya,goyu,muyv,yaza