## 🖥️ Windows 10+ Script
> This is a script to automate software installation using [winget](https://docs.microsoft.com/en-us/windows/package-manager/winget/), [download here](https://aka.ms/getwinget).

## Requirements
* Windows 10+

## How to use
- Run Windows Terminal, cmd or PowerShell, recommended with **admin** privileges
```bash
iex ((New-Object System.Net.WebClient).DownloadString('https://git.io/JDBpN'))
```

## What script do 
* Show start page and ask to continue
* Check if **winget** is installed, if not, installing **winget** from the Microsoft Store
* Asks you to enter a **json** file, can be **url** or **local** - _**script expect packages name in file!!!**_
* List all packages
* Asks for installation proceed
* Install packages 