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

#get file from web and parse json
# loop thought package and install them
# package file name and how many packages
$url = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/vukilis/Windows10AppScript/main/package.json" -UseBasicParsing
$packages = ConvertFrom-Json $url.content

# foreach ($letter in $packages)
# {   
#     $m = $letter | measure
#     $m.Count
# }

echo "Packages:"

foreach ($name in $packages)
{
    try {
		# winget install -e $name.package | Out-Host
        Write-Host $name.package 
	}
	catch {
		Write-Output "$($name.package) - $($_.Exception.Message)"
	}
}

