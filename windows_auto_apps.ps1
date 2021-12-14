# Show art and about 

$art = @"
 __      __          _      __   _   _       
 \ \    / /         | |    /_ | | | (_)      
  \ \  / /   _   _  | | __  | | | |  _   ___ 
   \ \/ /   | | | | | |/ /  | | | | | | / __|
    \  /    | |_| | |   <   | | | | | | \__ \
     \/      \__,_| |_|\_\  |_| |_| |_| |___/

"@

for ($i=0;$i -lt $art.length;$i++) {
	if ($i%2) {
		$ch = "Magenta"
	}
	elseif ($i%5) {
		$ch = "Cyan"
	}
	elseif ($i%7) {
		$ch = "DarkRed"
	}
	else {
		$ch = "DarkMagenta"
	}
	write-host $art[$i] -NoNewline -ForegroundColor $ch
}

write-host `n" - This is a script to automate software installation - 
 - Github link: https://github.com/vukilis/Windows10AppScript - " -ForegroundColor DarkMagenta

#######################################SCRIPT START###############################################################
# Y or N to start script
While($continue -ne "Y" ){
	$continue = $(Write-Host `n"Do you want to continue? [Yy]/[Nn]: " -NoNewLine -ForegroundColor White) + $(Read-Host) 
	Switch ($continue.ToLower()) 
		{ 
			Y {
				Continue
			} 
			N {Write-Host "Goodbye" -ForegroundColor Red;Return} 
			default {Write-Host "Only [Yy]/[Nn] are Valid responses" -ForegroundColor DarkRed}
		} 
}
########################################END START SCRIPT##########################################################
# Check if winget is installed
if (Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe){
    Write-Host `n'Winget Already Installed' -ForegroundColor Green
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
# "https://raw.githubusercontent.com/vukilis/Windows10AppScript/main/package.json"
# package.json
do {
	$setUrl = $(Write-Host `n"Enter your JSON file [URL or Local]: " -NoNewLine -ForegroundColor White) + $(Read-Host) 
	if ($setUrl -like '*https*' -or $setUrl -like '*http*'){
		Write-Host 'Your JSON file is good!' -ForegroundColor Green
		$url = Invoke-WebRequest -Uri $setUrl -UseBasicParsing
		$packages = ConvertFrom-Json $url.content
	}
	elseif (Test-Path -Path "$setUrl"){
		Write-Host 'Your JSON file is good!' -ForegroundColor Green
		$packages = Get-Content $setUrl | ConvertFrom-Json
	}
	else{
		Write-Host "Please enter correct URL or Local path!" -ForegroundColor Red
	}
}
Until ($setUrl -like '*https*' -or $setUrl -like '*http*' -or (Test-Path -Path "$setUrl")) 

# Count packages
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
While($answer -ne "Y" ){
	$answer = $(Write-Host `n"Do you want to proceed instalation? [Yy]/[Nn]: " -NoNewLine -ForegroundColor White) + $(Read-Host) 
	Switch ($answer.ToLower()) 
		{ 
			Y {
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
				Break
			} 
			N {Write-Host "Goodbye" -ForegroundColor Red;Return} 
			default {Write-Host "Only [Yy]/[Nn] are Valid responses" -ForegroundColor DarkRed}
		} 
}

