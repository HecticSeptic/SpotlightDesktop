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
$backgroundLocation = "$($env:UserProfile)\AppData\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper";
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
Add-Type @"
using System;
using System.Drawing;
using System.Runtime.InteropServices;
using Microsoft.Win32;
namespace Wallpaper
{
   public enum Style : int
   {
       Tile, Center, Stretch, Fill, NoChange
   }
   public class Setter {
      public const int SetDesktopWallpaper = 20;
      public const int UpdateIniFile = 0x01;
      public const int SendWinIniChange = 0x02; 

      [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
      private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
      
      public static void RemoveWallPaper() {
         SystemParametersInfo( SetDesktopWallpaper, 0, "", UpdateIniFile | SendWinIniChange );
         RegistryKey key = Registry.CurrentUser.OpenSubKey("Control Panel\\Desktop", true);
         key.SetValue(@"WallPaper", 0);
         key.Close();
      }


      public static void SetWallpaper ( string path, Wallpaper.Style style ) {
         SystemParametersInfo( SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange );
         RegistryKey key = Registry.CurrentUser.OpenSubKey("Control Panel\\Desktop", true);
         switch( style )
         {
            case Style.Stretch :
               key.SetValue(@"WallpaperStyle", "2") ; 
               key.SetValue(@"TileWallpaper", "0") ;
               break;
            case Style.Center :
               key.SetValue(@"WallpaperStyle", "1") ; 
               key.SetValue(@"TileWallpaper", "0") ; 
               break;
            case Style.Tile :
               key.SetValue(@"WallpaperStyle", "1") ; 
               key.SetValue(@"TileWallpaper", "1") ;
               break;
            case Style.Fill :            
               key.SetValue(@"WallpaperStyle", "10") ; 
               key.SetValue(@"TileWallpaper", "0") ;
               break;
            case Style.NoChange :
               break;
         }
         key.Close();
      }
   }
}
"@

##Main Functionality
##
foreach($file in (Get-Item -Path `
    C:\Users\$($env:username)\Appdata\Local\Packages\$($Package)\LocalState\Assets\* `
    | Sort-Object LastAccessTime,length -Descending))
{
    if ($landscapeOnly -and ((Get-Item $file).length -lt $minSize)) { continue }
    if ((New-Object System.Drawing.Bitmap $file.FullName).Width -lt $width) { continue }
    if ($RegKey.EndsWith($file.Name)) {
        Copy-Item $file.FullName "$($backgroundLocation)";
        if (-not $keepAll){
            ##first update of wallpaper without Fill (no changes will be shown)
            [Wallpaper.Setter]::SetWallpaper( "$($backgroundLocation)", 0 )
            ##
            break;
        }
    }
    else {
        if ($keepAll -and (Test-Path "$($imageLocation)$($file.Name).jpg")){}
        else {Copy-Item $file.FullName "$($imageLocation)$($file.Name).jpg";}    
    }
}
##Second update to refresh with Fill style
[Wallpaper.Setter]::SetWallpaper( "$($backgroundLocation)", 3 )