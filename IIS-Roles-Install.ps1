$RemoteComputers = @("server1","server2")
$password = ConvertTo-SecureString "Password" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ("Username", $password )


function validateIISRoles {

    param([String] $server)
    $list = @()

$list += "Web-server","Web-WebServer","Web-Common-Http","Web-Default-Doc","Web-Dir-Browsing","Web-Http-Errors","Web-Static-Content","Web-Http-Redirect","Web-Health","Web-Http-Logging","Web-Custom-Logging","Web-Log-Libraries","Web-ODBC-Logging","Web-Request-Monitor","Web-Http-Tracing","Web-Performance","Web-Stat-Compression","Web-Dyn-Compression","Web-Security","Web-Filtering","Web-Basic-Auth","Web-Client-Auth","Web-Digest-Auth","Web-Cert-Auth","Web-IP-Security","Web-Url-Auth","Web-Windows-Auth","Web-App-Dev","Web-Net-Ext","Web-Net-Ext45","Web-ASP","Web-Asp-Net","Web-Asp-Net45","Web-ISAPI-Ext","Web-ISAPI-Filter","Web-Ftp-Server","Web-Ftp-Service","Web-Mgmt-Tools","Web-Mgmt-Console","Web-Scripting-Tools","Web-Mgmt-Service"
Get-WindowsFeature *Web* -ComputerName $server | Select Name,InstallState | % {
ForEach( $i in $List )
{
   If ( $i -eq $_.Name) {
       if ($_.InstallState -eq "Installed" )
       {Write-host  $i role is successfully installed on $server -BackgroundColor Green -ForegroundColor Black
         echo `r`n
       }
       
           else
         {Write-host  $i role is not successfully installed on $server -BackgroundColor Red -ForegroundColor White
           echo `r`n
         }
                        }

    else
    {continue}
}
                                                                           }
                 }
$scriptblock={

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

$job = {
  param($feature)

   Write-Host successfully installed $feature Role -BackgroundColor DarkYellow -ForegroundColor Red
   Install-WindowsFeature -Name $feature
   echo `r`n 
 }

$jobs = @()
("Web-server","Web-WebServer","Web-Common-Http","Web-Default-Doc","Web-Dir-Browsing","Web-Http-Errors","Web-Static-Content","Web-Http-Redirect","Web-Health","Web-Http-Logging","Web-Custom-Logging","Web-Log-Libraries","Web-ODBC-Logging","Web-Request-Monitor","Web-Http-Tracing","Web-Performance","Web-Stat-Compression","Web-Dyn-Compression","Web-Security","Web-Filtering","Web-Basic-Auth","Web-Client-Auth","Web-Digest-Auth","Web-Cert-Auth","Web-IP-Security","Web-Url-Auth","Web-Windows-Auth","Web-App-Dev","Web-Net-Ext","Web-Net-Ext45","Web-ASP","Web-Asp-Net","Web-Asp-Net45","Web-ISAPI-Ext","Web-ISAPI-Filter","Web-Ftp-Server","Web-Ftp-Service","Web-Mgmt-Tools","Web-Mgmt-Console","Web-Scripting-Tools","Web-Mgmt-Service") `
| % { $jobs += Start-Job -ArgumentList $_ -ScriptBlock $job }

Wait-Job -Job $jobs | Out-Null

  
#Receive-Job -Job $jobs 


}

 
ForEach ($Computer in $RemoteComputers){
             Write-Host "Installing IIS roles and features on $computer" -BackgroundColor Yellow -ForegroundColor Red
             $session = New-PSSession -ComputerName $Computer -Credential $cred

             if ($session -is [System.Management.Automation.Runspaces.PSSession])
                  {Invoke-Command -ComputerName $Computer -ScriptBlock $scriptblock -ErrorAction Stop}
               else
            {Write-Host "Cannot connect to server: $Computer"} 
              
Write-Host "IIS Roles installation finished now Validating IIS Roles are properly installed or not" -BackgroundColor DarkYellow -ForegroundColor Red
validateIISRoles($Computer)

#Write-Host "IIS Roles are installed successfully on server $Computer" -BackgroundColor Cyan -ForegroundColor Red
}



