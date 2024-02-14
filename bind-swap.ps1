$Account1 = (Read-Host "First Account Directory?").Trim('"')
$Account2 = (Read-Host "Second Account Directory?").Trim('"')

$files1 = Get-ChildItem -Path $Account1 | Select-Object -ExpandProperty Name
$files2 = Get-ChildItem -Path $Account2 | Select-Object -ExpandProperty Name


Write-Host "$files1"
Write-Host "$files2"

foreach ($file in $files1) {
if ($file -eq 'bindings-cache.wtf') {
    $found = $true
    break
    }
    $count++
}

if ($found) { 
    $bindings1 = $files1[$count]
} else {
    Write-Output "File 'bindings.wtf' not found."
}

$count = 0

foreach ($file in $files2) {
if ($file -eq 'bindings-cache.wtf') {
    $found = $true
    break
    }
    $count++
}

if ($found) {
    $bindings2 = $files2[$count]
} else {
    Write-Output "File 'bindings.wtf' not found."
}


$pathParts1 = $Account1 -split '\\'

# Find the index of "Account" directory
$accountIndex = $pathParts1.IndexOf("Account")

if ($accountIndex -ge 0 -and $accountIndex -lt ($pathParts1.Count - 1)) {
    # If "Account" directory is found and there is a directory after it
    # Capture the directory immediately after "Account" into a variable
    $accountName1 = $pathParts1[$accountIndex + 1]
    Write-Host "Account Name: $accountName1"
} else {
    Write-Host "Account directory not found or no directory after it."
}

$pathParts2 = $Account2 -split '\\'

# Find the index of "Account" directory
$accountIndex = $pathParts2.IndexOf("Account")

if ($accountIndex -ge 0 -and $accountIndex -lt ($pathParts1.Count - 1)) {
    # If "Account" directory is found and there is a directory after it
    # Capture the directory immediately after "Account" into a variable
    $accountName2 = $pathParts2[$accountIndex + 1]
    Write-Host "Account Name: $accountName2"
} else {
    Write-Host "Account directory not found or no directory after it."
}


if (!(Test-Path "C:\Users\$env:USERNAME\Desktop\BackupBinds\$accountName1")){
New-Item -ItemType Directory -Path "C:\Users\$env:USERNAME\Desktop\BackupBinds\$accountName1"
}
else {
$userResponse = Read-Host "Do you want to overwrite the existing backup? (Y/N)"
if ($userResponse -eq "Y") {
    New-Item -ItemType Directory -Path "C:\Users\$env:USERNAME\Desktop\BackupBinds\$accountName1" -Force
}
else {
    Write-Host "Backup not created."
    exit

}
}

if (!(Test-Path "C:\Users\$env:USERNAME\Desktop\BackupBinds\$accountName2")){
New-Item -ItemType Directory -Path "C:\Users\$env:USERNAME\Desktop\BackupBinds\$accountName2"
else {
    $userResponse = Read-Host "Do you want to overwrite the existing backup? (Y/N)"
    if ($userResponse -eq "Y") {
        New-Item -ItemType Directory -Path "C:\Users\$env:USERNAME\Desktop\BackupBinds\$accountName1" -Force
    }
    else {
        Write-Host "Backup not created."
        exit
    }
}
}

Copy-Item -Path ($Account1 + "\bindings-cache.wtf") -Destination "C:\Users\$env:USERNAME\Desktop\BackupBinds\$accountName1"
$copiedBind = Copy-Item -Path ($Account2 + "\bindings-cache.wtf") -Destination "C:\Users\$env:USERNAME\Desktop\BackupBinds\$accountName2" -PassThru

Copy-Item -Path $copiedBind -Destination $Account1 -Verbose