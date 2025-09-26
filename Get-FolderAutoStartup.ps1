param (

# Default path to the Startup folder
    [string]$Startup = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
)

if (Test-Path $Startup) {
    Set-Location $Startup
    Write-Output "Changed to $Startup"
} else {
    Write-Host "The path $Startup does not exist."
}
