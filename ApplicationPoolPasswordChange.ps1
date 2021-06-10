# Script to update application pool password

$ServerList = "<Server1>", "<Server2>", "<Server3>"

$task = 
{
 $Hn = Hostname
 iisreset /stop 
 Write-Host "IIS stopped in 				" $Hn "... Step 1 of 3 is complete" -ForegroundColor Green
 Import-Module WebAdministration
 $applicationPools = Get-ChildItem IIS:\AppPools | where { $_.processModel.userName -eq "<Service account>" }
 foreach($pool in $applicationPools)
 {
     $pool.processModel.userName = "<Service account>"
     $pool.processModel.password = "<Password>"
     $pool.processModel.identityType = 3
     $pool | Set-Item
 }
 Write-Host "Application pool password updated in 	" $Hn "... Step 2 of 3 is complete" -ForegroundColor Green
 iisreset /start 
 Write-Host "IIS started in 				" $Hn "... Step 3 of 3 is complete" -ForegroundColor Green
 Read-Host -Prompt "Press Enter to continue"
}

foreach ($computer in $ServerList)
{
Invoke-Command -ComputerName $computer -ScriptBlock $task
}

