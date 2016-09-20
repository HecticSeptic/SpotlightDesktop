'User Defined | PSLocation is the location of the powershell file in quotes
'
dim PSLocation
PSLocation = "%userprofile%\Pictures\Saved Pictures\Spotlight.ps1"
'
'             | It is needed so that the task scheduler can run this script
'             | and still call the powershell. Set the new task to the below
'             | Program/script = "%SystemRoot%\System32\WScript.exe"
'             | Add arguments = "%userprofile%\Pictures\Saved Pictures\Spotlight.vbs"
'

'For testing add -NoExit to the command (just after .exe) & change command,0 to command,1 
'
set shell = CreateObject("WScript.Shell")
command = "powershell.exe -NoLogo -ExecutionPolicy Bypass -File """ & PSLocation & """"
shell.Run command,0