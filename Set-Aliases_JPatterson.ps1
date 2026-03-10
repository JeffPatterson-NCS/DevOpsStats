# PowerShell Aliases Configuration
# This script contains all the custom aliases for the PowerShell profile

# Simplify the path to the PowerShell scripts
$ScriptLocation = Join-Path $env:USERPROFILE "\Documents\PowerShell\"

# Display the alias help when the script is loaded
# Show-AliasHelp

# *****************************************************************************
# USER-SPECIFIC ALIASES (JPatterson)
# *****************************************************************************

if($env:USERNAME -ne "JPatterson") {
    Write-Host "The user $env:USERNAME does not have aliases assigned."
    return
} 

Write-Host ""
Write-Host "`e[1mAliases for the user: `e[1;33m$env:USERNAME`e[0m`e[22m — "
Write-Host "`e[1;33mWARNING:`e[0m These aliases contain specific folders and locations,"
Write-Host "and may not work properly for other users and other machines."
# Write-Host ""

# Tunnel Project Navigation
function Get-FolderConfig { & Set-Location $env:Repos\Tunnel\setup }
Write-Host "  config            -> Tunnel setup folder" -ForegroundColor DarkGray
Set-Alias -Name config Get-FolderConfig -Option AllScope

function Get-FolderAlpha { & Set-Location $env:Repos\Tunnel\alpha }
Write-Host "  alpha             -> Alpha PLC folder" -ForegroundColor DarkGray
Set-Alias -Name alpha Get-FolderAlpha -Option AllScope

function Get-FolderBeta { & Set-Location $env:Repos\Tunnel\beta }
Write-Host "  beta              -> Beta PLC folder" -ForegroundColor DarkGray
Set-Alias -Name beta Get-FolderBeta -Option AllScope

function Get-FolderHmi { & Set-Location $env:Repos\Tunnel\hmi }
Write-Host "  hmi               -> HMI folder" -ForegroundColor DarkGray
Set-Alias -Name hmi Get-FolderHmi -Option AllScope

# Neuron Project Navigation
function Get-FolderNeuronController { & Set-Location $env:Repos\Tunnel\Neuron }
Write-Host "  nb, neuronb       -> Neuron Controller Blazor application folder" -ForegroundColor DarkGray
Set-Alias -Name neuronb Get-FolderNeuronController -Option AllScope
Set-Alias -Name nb Get-FolderNeuronController -Option AllScope

function Get-FolderNeuronIO { & Set-Location $env:Repos\Tunnel\io-alpha }
Write-Host "  nio, neuronio     -> Neuron IO folder" -ForegroundColor DarkGray
Set-Alias -Name neuronio Get-FolderNeuronIO -Option AllScope
Set-Alias -Name nio Get-FolderNeuronIO -Option AllScope

# Web Development
Write-Host "  webdev            -> Web development folder" -ForegroundColor DarkGray
Set-Alias -Name webdev $ScriptLocation\Get-FolderWebDev.ps1 -Option AllScope
Write-Host "  Source            -> Source folder navigation" -ForegroundColor DarkGray
Set-Alias -Name Source $ScriptLocation\Get-FolderSource.ps1 -Option AllScope
Write-Host "  Training          -> Training folder navigation" -ForegroundColor DarkGray
Set-Alias -Name Training $ScriptLocation\Get-FolderTraining.ps1 -Option AllScope
Write-Host "  Repos             -> Repos folder navigation" -ForegroundColor DarkGray
Set-Alias -Name Repos $ScriptLocation\Get-FolderRepo.ps1 -Option AllScope
Write-Host "  Tunnel            -> Tunnel folder navigation" -ForegroundColor DarkGray
Set-Alias -Name Tunnel $ScriptLocation\Get-FolderTunnel.ps1 -Option AllScope

# GitHub Aliases
function Get-gh-create { & gh repo create --private --source=. --remote=origin & git push -u --all & gh browse }
Write-Host "  ghcreate          -> Create private GitHub repo from current dir" -ForegroundColor DarkGray
Set-Alias -Name ghcreate Get-Gh-Create -Option AllScope
function Get-GitPush { & git push github }
Write-Host "  ghpsh, ghpush     -> git push github" -ForegroundColor DarkGray
Set-Alias -Name ghpsh Get-GitPush -Option AllScope
Set-Alias -Name ghpush Get-GitPush -Option AllScope


# Special Aliases
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Resolve the Source root. Prefer the environment variable $env:Source when valid,
# otherwise fall back to the repository-relative 'source' folder next to this script.
if ($env:Source -and (Test-Path $env:Source)) {
    $sourceRoot = $env:Source
} else {
    $sourceRoot = Join-Path $scriptDir 'source'
}

# Target executable inside the Source folder's Workfolder subfolder
$exePath = Join-Path $sourceRoot 'Workfile\WorkFile.exe'

function WorkFiles {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        $Args
    )
    if (-not (Test-Path $exePath)) {
        Write-Warning "WorkFiles executable not found at $exePath"
        return
    }
    & $exePath @Args
}
Write-Host "  work              -> Open File Explorer with working directories" -ForegroundColor DarkGray
Set-Alias -Name work -Value WorkFiles -Option AllScope -Force