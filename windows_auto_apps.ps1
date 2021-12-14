# Check if winget is installed
if (Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe){
    'Winget Already Installed'
}  
else{
    # Installing winget from the Microsoft Store
	Write-Host "Winget not found, installing it now."
    $ResultText.text = "`r`n" +"`r`n" + "Installing Winget... Please Wait"
	Start-Process "ms-appinstaller:?source=https://aka.ms/getwinget"
	$nid = (Get-Process AppInstaller).Id
	Wait-Process -Id $nid
	Write-Host Winget Installed
    $ResultText.text = "`r`n" +"`r`n" + "Winget Installed - Ready for Next Task"
}

# loop thought package and install them
# package file name and how many packages
# $url = "https://raw.githubusercontent.com/vukilis/Windows10AppScript/main/packages.config"
# $packages = Invoke-WebRequest -Uri $url -UseBasicParsing

# dir -Include *.config -Recurse | 
#     % { $_ | select name, @{n="Total";e={
#         get-content $_ | 
#             measure-object -line |
#                 select -expa lines }
#                         } 
#     } | ft -AutoSize

# foreach ($letter in $packages)
# {   
#     $m = $letter | measure
#     $m.Count
# }

$webData = Invoke-WebRequest -Uri "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"

echo "Packages:"
# $letterArray = "SumatraPDF.SumatraPDF","Microsoft.PowerToys"
# foreach ($letter in $letterArray)
# {
#     winget install -e $letter | Out-Host
#     Write-Host $letter
# }

foreach ($name in $packages)
{
    try {
		winget install -e $name | Out-Host
        Write-Host $name
	}
	catch {
		Write-Output "  $name - $($_.Exception.Message)"
	}
}

