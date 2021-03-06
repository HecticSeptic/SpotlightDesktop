# Spotlight Desktop
####Windows Spotlight on the Desktop

## What it does
Allows you to set a task through the Windows Task Scheduler to replace your Desktop background with the Spotlight background, or alternatively with a number of such backgrounds saved over the course of using this script. In the latter case, the backgrounds are saved to a user configurable folder.

It is now possible to set the wallpaper even when desktop slideshow is enabled. In this configuration the background is set to the current Spotlight image upon login/logout (see 3.) and then continues to change automatically as normal.

Note that if `$removeTips` is enabled, Spotlight tips may only be removed after they are first set (during logout). They are therefore only gone from the second viewing and onward, since they are cached elsewhere.

## Prerequisites
* PowerShell (comes with Windows)
* Visual Basic Script (comes with Windows)

## Steps
1. Place the [`Spotlight.ps1`](./Spotlight.ps1) and [`Spotlight.vbs`](./Spotlight.vbs) files wherever you like
   * (default suggestion is `%UserProfile%/Pictures/Saved Pictures`)  

2. Edit the User Defined variables to your liking (make sure the syntax is retained)
   * `Spotlight.vbs` -> PSLocation must point to the location of your Spotlight.ps1 file
   * `Spotlight.ps1` -> Can be left as default, `$keepAll` does not override `$landscapeOnly`, default paths use `$($env:UserProfile)` which can be replaced with `[`Drive Letter`]\Users\[`You`]` if necessary. [Other $env options](http://www.computerperformance.co.uk/powershell/powershell_environmental_variables.htm).
     * `$landscapeOnly` -> default `$TRUE;` whether to omit vertical/portrait images
     * `$keepAll` -> default `$TRUE;` retain all images satisfying minSize
     * `$removeTips` -> default `$TRUE;` whether to delete Spotlight tips
     * `$minSize` -> default `200kb;` the file size below which images will not be copied
     * `$imageLocation` -> default `"$($env:UserProfile)\Pictures\Saved Pictures\";` where to save images 
     * `$backgroundFolder` -> default `"$($env:UserProfile)\AppData\Roaming\Microsoft\Windows\Themes";` where current wallpaper is stored
     * `$backgroundLocation` -> default `"$($backgroundFolder)\TranscodedWallpaper";` current wallpaper file name

3. Add a task to Windows Task Scheduler
   * Windows/Start -> start typing Scheduler, or run %windir%\system32\taskschd.msc /s
   * Action -> Create Task...
   * Name and Triggers as you like (suggested: on workstation lock)
   * Actions -> New... -> Start a Program
   * Program/Script = `"%SystemRoot%\System32\WScript.exe"`
   * Add arguments = `"%userprofile%\Pictures\Saved Pictures\Spotlight.vbs"` (or whichever location you used)  

4. (Optional) Set your Desktop Background to Slideshow, with the folder of `$imageLocation`
   * Right-click desktop on Windows 8/10 -> Personalize -> Background = Slideshow; Browse -> to location
   * Or, Windows/Start -> start typing Background, then as above 
