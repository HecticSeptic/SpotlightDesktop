# Spotlight Desktop
####Windows Spotlight on the Desktop

## What it does
Allows you to set a task through the Windows Task Scheduler to update a folder with a single "background.jpg" file which mirrors the Spotlight background, or alternatively a growing directory of Spotlight images as they get added to your PC. This results in Spotlight images on your desktop.

## Prerequisites
* Powershell (comes with Windows)
* Visual Basic Script (comes with Windows)
* Administrative Privileges (probably)

## Steps
1. Place the Spotlight.ps1 and Spotlight.vbs files wherever you like 
   * (default suggestion is %UserProfile%/Pictures/Saved Pictures)
2. Edit the User Defined variables to your liking (make sure the syntax is retained)
   * Spotlight.vbs -> PSLocation must point to the location of your Spotlight.ps1 file
   * Spotlight.ps1 -> Can be left as default, $keepAll does not override $landscapeOnly, default paths use $($env:UserProfile) which can be replaced with [Drive Letter]\Users\[You] if necessary. [Other $env options](http://www.computerperformance.co.uk/powershell/powershell_environmental_variables.htm).
     * $landscapeOnly -> default $TRUE; whether to omit vertical/portrait images
     * $keepAll -> default $TRUE; retain all images satisfying minSize
     * $minSize -> default 450kb; the filesize below which images will not be copied
     * $imageLocation -> default "$($env:UserProfile)\Pictures\Saved Pictures\"; remember your chosen path for step 4 
     * $backgroundLocation = "$($env:UserProfile)\Pictures\Saved Pictures\Spotlight\"; as above
3. Add a task to Windows Task Scheduler
   * Windows/Start -> start typing Scheduler, or run %windir%\system32\taskschd.msc /s
   * Action -> Create Task...
   * Name and Triggers as you like
   * Actions -> New... -> Start a Program
   * Program/Script = "%SystemRoot%\System32\WScript.exe"
   * Add arguments = "%userprofile%\Pictures\Saved Pictures\Spotlight.vbs" (or whichever location you used)
4. Set your Desktop Background to Slideshow, with the folder of either $imageLocation or $backgroundLocation
   * Right-click desktop on Windows 8/10 -> Personalize -> Background = Slideshow; Browse -> to location
   * Or, Windows/Start -> start typing Background, then as above 
