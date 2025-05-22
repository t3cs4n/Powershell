<#

 DFS Replication commands
 

#>


Get-DfsrBacklog

Get-DfsrState


<#

This provides you with the details Active Directory has about DFS, 
the replication groups, and the folders it belongs to.

#>


DFSRDIAG dumpadcfg /member:SERVERNAME


<#

This has the servers check-in with AD. 
The result of this command should be: “operation succeed”.

#>


DFSRDIAG pollad /member:SERVERNAME

<#

This shows you what is replicating. 
If replication is working, you should see something like this:


Active inbound connection: 1<br>
Connection GUID: BE12378E-123D-41233-1238-123412B7AFD6<br>
Sending member: YOURSERVERNAME<br>
Number of updates: 6
Updates being processed:

[1] Update name: 83b78c9696004f7797f319bfcc314d201.jpg<br>
[2] Update name: d1d86aa38477492680ff14ffffcc3fa61.fla<br>
[3] Update name: b131d9dbffca4b7faa82a3bd172271a72.swf<br>
[4] Update name: 5ac75c7ad2ae4d74931257d605205d441.swf<br>
[5] Update name: 856d568e07644803844988dfd5aab05b1.jpg<br>
[6] Update name: 1ebaa536c0574797a04ba5999e754aff3.swf<br>
Total number of inbound updates being processed: 6
Total number of inbound updates scheduled: 0

#>

FDSRDIAG replicationstate

