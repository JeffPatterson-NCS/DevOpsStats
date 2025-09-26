param (
    #[string]$PSRepo = "$env:USERPROFILE\Documents\PowerShell"
    [string]$PSRepo = "$env:OneDrive\Documents\PowerShell"
)

if (Test-Path $PSRepo) {
    Set-Location $PSRepo
    Write-Output "Changed to $PSRepo"
} else {
    Write-Host "The path $PSRepo does not exist."
}
