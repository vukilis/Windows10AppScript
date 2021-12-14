# Check if winget is installed
if (Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe){
    Write-Host 'Winget Already Installed' -ForegroundColor Green
}  
else{
    # Installing winget from the Microsoft Store
	Write-Host "Winget not found, installing it now." -ForegroundColor DarkRed
    $ResultText.text = "`r`n" +"`r`n" + "Installing Winget... Please Wait"
	Start-Process "ms-appinstaller:?source=https://aka.ms/getwinget"
	$nid = (Get-Process AppInstaller).Id
	Wait-Process -Id $nid
	Write-Host `n"Winget Installed" -ForegroundColor Green
    $ResultText.text = Write-Host "`r`n" +"`r`n" + "Winget Installed - Ready for Next Task" -ForegroundColor Cyan
}
# Write-Host ""
#get file from web and parse json
# loop thought package and install them
# package file name and how many packages
$url = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/vukilis/Windows10AppScript/main/package.json" -UseBasicParsing
$packages = ConvertFrom-Json $url.content

$number = ($packages).Length
Write-Host `n"Number of packages: $number" -ForegroundColor DarkMagenta

# List all packages
Write-Host `n"Packages:" -ForegroundColor Magenta
Write-Host ""
foreach ($name in $packages)
{
    try {
        Write-Host $name.package -ForegroundColor Yellow
	}
	catch {
		Write-Output `n"$($name.package) - $($_.Exception.Message)"
	}
}
# Y or N to install packages
$answer = $(Write-Host "Do you want to proceed instalation? [Yy]/[Nn]: " -NoNewLine -ForegroundColor White) + $(Read-Host) 
if ("Y" -eq $answer.ToLower()){
	foreach ($name in $packages)
	{
		try {
			winget install -e $name.package | Out-Host
			# Write-Host $name.package -ForegroundColor Yellow
		}
		catch {
			Write-Output `n"$($name.package) - $($_.Exception.Message)"
		}
	}
}
else{
	Write-Host "Goodbye" -ForegroundColor Red
}