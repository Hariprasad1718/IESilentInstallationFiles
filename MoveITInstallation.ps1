$Server = "Servername"

$MoveITinstallationpath = "D:\Installables\MoveIT_Installable"

$Softwareexe = "MOVEit-2018.3-FullInstall_SN6BRJHMVH31524M4ENGNG62G.exe"


# Copying MoveIT Installtion Files
    
Write-Host "Copying the Moveit Installation files to $Server Server" -ForegroundColor white -BackgroundColor green -Newline

Copy-Item "$MoveITinstallationpath" -Destination "\\$Server\D$\Installables\MoveIT_Installable"  -Recurse

start-sleep -s 5

Write-Host "Moveit Installation files are moved to $Server Server" -ForegroundColor white -BackgroundColor green -Newline 


# Installing MoveIT in the server


Write-Host "Starting the MoveIT installation in $Server Server" -ForegroundColor white -BackgroundColor green -Newline 

$MainScriptBlock = {param($MoveITinstallationpath,$Softwareexe)`

Invoke-Expression -Command: "cmd.exe /c '$MoveITinstallationpath\$Softwareexe' -L1033 ResponseFile=$MoveITinstallationpath\ResponseFile.txt"}

Invoke-Command $MainScriptBlock -ComputerName $Server -ArgumentList $MoveITinstallationpath,$Softwareexe

Write-Host "Moveit is installed in $Server Server" -ForegroundColor white -BackgroundColor green -NoNewline