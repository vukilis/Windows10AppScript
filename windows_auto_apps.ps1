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
dir -Include *.config -Recurse | 
    % { $_ | select name, @{n="Total";e={
        get-content $_ | 
            measure-object -line |
                select -expa lines }
                        } 
    } | ft -AutoSize

# C# (.NET) file reader reads each line one by one
# best performance, faster then Get-Content(bad perforamance)
echo "Packages: "
foreach($name in [System.IO.File]::ReadLines("packages.config")){
    # winget install -e $name | Out-Host
    $name
}