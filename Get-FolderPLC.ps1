param (
    [string] $subFolder
)

$folderMap = @{
    "alpha" = "plc-alpha"
    "beta" = "plc-beta"
    "config" = "Setup"
}

if ($folderMap.ContainsKey($subFolder)) {
    $fullPath = Join-Path -Path $env:Repos\Tunnel\ -ChildPath $folderMap[$subFolder]
    & Set-Location -Path $fullPath
    Write-Host "Changed directory to: $fullPath"
} else {
    Write-Host "Invalid subfolder name. Please use one of the following: $($folderMap.Keys -join ', ')"
    return
}
