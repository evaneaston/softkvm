Set WshShell = CreateObject("WScript.Shell") 
WshShell.Run  "wsl.exe -e /mnt/c/Users/%USERNAME%/bin/softkvm/switch.sh", 0
Set WshShell = Nothing
