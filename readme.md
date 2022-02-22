# Azure-Automation 



- Start Powershell Terminal 
- Copy & Paste to download in your session 
- Happy Automation

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force;
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Jalalhejazi/azure-automation/main/Manage-Azure.ps1'))

help set-azResourceGroup -ShowWindow

```