param (
    [string]$folder = "$env:USERPROFILE\Source\Udemy\WebDev"
)

if (Test-Path $folder) {
    Set-Location $folder
    Write-Output "Changed to $folder"
} else {
    Write-Host "The path $folder does not exist."
}

