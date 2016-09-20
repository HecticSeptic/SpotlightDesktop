##Referenced for background width checking
##
Add-Type -AssemblyName System.Drawing;
Add-Type -AssemblyName System.Windows.Forms;
##

##User Defined
##               Note: this script only works for horizontal/landscape images or both
$landscapeOnly = $TRUE; #$TRUE or $FALSE    | whether to omit vertical/portrait images
$keepAll = $TRUE;       #$TRUE or $FALSE    | retain all images satisfying minSize
$minSize = 450kb;       #any valid filesize | point at which images are ignored
$imageLocation = "$($env:UserProfile)\Pictures\Saved Pictures\";
$backgroundLocation = "$($env:UserProfile)\Pictures\Saved Pictures\Spotlight\";
##                      #any valid location | where to save the images. Default includes
##                      #including quotes   | environment variable for Home. Keep (\)
##

##System Defined
##
$width = (([System.Windows.Forms.Screen]::AllScreens `
    | Where-Object {$_.Primary -eq 'True'} | Select-Object WorkingArea) `
    -split ',')[2].Substring(6);
$SID = (Get-WmiObject -Class Win32_UserAccount  -Filter `
    "Domain = '$env:userdomain' AND Name = '$env:username'").SID;
$RegKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey(`
        [Microsoft.Win32.RegistryHive]::Users, $strIPAddrTmp).OpenSubKey(`
        "$SID\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative"`
        ).GetValue("LandscapeAssetPath");
$Package = "Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy";
##

##Main Functionality
##
foreach($file in (Get-Item -Path `
    C:\Users\$($env:username)\Appdata\Local\Packages\$($Package)\LocalState\Assets\* `
    | Sort-Object LastAccessTime,length -Descending))
{
    if ($landscapeOnly -and ((Get-Item $file).length -lt $minSize)) { continue }
    if ((New-Object System.Drawing.Bitmap $file.FullName).Width -lt $width) { continue }
    if ($RegKey.EndsWith($file.Name)) {
        Copy-Item $file.FullName "$($backgroundLocation)background.jpg";
        if (-not $keepAll){
            break;
        }
    }
    else {
        if ($keepAll -and (Test-Path "$($imageLocation)$($file.Name).jpg")){}
        else {Copy-Item $file.FullName "$($imageLocation)$($file.Name).jpg";}    
    }
}
##