<#

 Set customes time servers on Domain Controller


#>


# Stop the Windows Time service
Stop-Service w32time

# Set the NTP mode to manual and configure the peer list with your custom servers
w32tm /config /syncfromflags:manual /manualpeerlist:"ntp11.metas.ch, ntp12.metas.ch, ntp13.metas.ch"

# Set the time service to use a reliable connection
w32tm /config /reliable:yes

# Start the Windows Time service
Start-Service w32time




