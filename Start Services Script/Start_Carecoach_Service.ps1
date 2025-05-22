# Start CareCoach Service

$computer = "srvapp03"  
$dienstname = "careCoachServerPEE"  

$service = Get-Service -ComputerName $computer -Name $dienstname

if ($service.Status -match "Running"){  
    Write-Host Dienst  läuft -ForegroundColor Green
    } else {
    Write-Host Dienst läuft nicht -ForegroundColor Red
    Set-Service -ComputerName $computer -Name $dienstname -Status Running
    }
