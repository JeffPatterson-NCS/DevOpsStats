# PowerShell Aliases Configuration
# This script contains all the custom aliases for the PowerShell profile

# Simplify the path to the PowerShell scripts
$ScriptLocation = Join-Path $env:OneDrive "Documents\PowerShell"

# When not using OneDrive
# $ScriptLocation = Join-Path $env:USERPROFILE "\Documents\PowerShell\"

# Display the alias help when the script is loaded
# Show-AliasHelp

# *****************************************************************************
# COMMON ALIASES (Available for all users)
# *****************************************************************************
# Write-Host ""
Write-Host "`e[1;33mGIT Commands that will work for anyone`e[0m"

# Git Shortcut Functions and Aliases
function Get-GitStatus { & git status $args }
Write-Host "  gst, status       -> git status" -ForegroundColor DarkGray
Set-Alias -Name gst Get-GitStatus -Option AllScope
Set-Alias -Name status Get-GitStatus -Option AllScope

function Get-GitFetchAll { & git fetch --all }
Write-Host "  fa, fetch         -> git fetch --all" -ForegroundColor DarkGray
Set-Alias -name fa Get-GitFetchAll -Option AllScope
Set-Alias -name fetch Get-GitFetchAll -Option AllScope

function Get-GitAddAll { & git add . }
Write-Host "  aa, addall        -> git add . (all files)" -ForegroundColor DarkGray
Set-Alias -Name aa Get-GitAddAll -Option AllScope
Set-Alias -Name addall Get-GitAddAll -Option AllScope

function Get-GitPull { & git pull $args }
Write-Host "  pl, pull          -> git pull" -ForegroundColor DarkGray
Set-Alias -Name pl Get-GitPull -Option AllScope
Set-Alias -Name pull Get-GitPull -Option AllScope

function Get-GitPush { & git push $args }
Write-Host "  psh, push         -> git push" -ForegroundColor DarkGray
Set-Alias -Name psh Get-GitPush -Option AllScope
Set-Alias -Name push Get-GitPush -Option AllScope


# function Get-GitCommit { & git commit $args }
# Write-Host "  gc                -> git commit -m" ForegroundColor DarkGray
# Set-Alias -Name commit Get-GitCommit -Option AllScope
function Get-GitCommit { 
    param([Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)][string[]]$Message)
    & git commit -m ($Message -join " ")
}
Write-Host "  cm, commit        -> git commit -m \"message\"" -ForegroundColor DarkGray
Set-Alias -Name cm Get-GitCommit -Option AllScope
Set-Alias -Name commit Get-GitCommit -Option AllScope

function Get-GitSwitch { & git switch $args }
Write-Host "  gsw, switch       -> git switch" -ForegroundColor DarkGray
Set-Alias -Name gsw Get-GitSwitch -Option AllScope
Set-Alias -Name gswitch Get-GitSwitch -Option AllScope

function Get-GitDeleteUnstaged { git checkout . $args }
Write-Host "  undo              -> git checkout . (discard unstaged)" -ForegroundColor DarkGray
Set-Alias -Name undo -Value Get-GitDeleteUnstaged -Option AllScope

function Get-GitforcePush { git push --force-with-lease $args }
Write-Host "  gpf               -> git push --force-with-lease (Preferred PUSH method)" -ForegroundColor DarkGray
Set-Alias -Name gpf -Value Get-GitforcePush -Option AllScope

# Directory Navigation Aliases
Write-Host "  Startup           -> Startup folder navigation" -ForegroundColor DarkGray
Set-Alias -Name Startup $ScriptLocation\Get-FolderAutoStartup.ps1 -Option AllScope
#"C:\Users\JPatterson\OneDrive - National Carwash Solutions, Inc\Documents\PowerShell\Get-FolderAutoStartup.ps1"
Write-Host "  PSR               -> PSRepo folder navigation" -ForegroundColor DarkGray
Set-Alias -Name PSR $ScriptLocation\Get-FolderPSRepo.ps1 -Option AllScope

# Repository Management Aliases
# Write-Host "  Azd               -> Azure DevOps repo changes" -ForegroundColor DarkGray
# Set-Alias -Name Azd $ScriptLocation\Get-RepoChangesAzD.ps1 -Option AllScope
Write-Host "  gitLab            -> GitLab repo changes" -ForegroundColor DarkGray
Set-Alias -Name gitLab $ScriptLocation\Get-RepoChangesGitLab.ps1 -Option AllScope
Write-Host "  changes <?#>      -> Repository status check (add integer to list previous # days)" -ForegroundColor DarkGray
Set-Alias -Name changes $ScriptLocation\Get-RepoStatus.ps1 -Option AllScope

# File System Aliases
Write-Host "  lsf               -> List all files including hidden" -ForegroundColor DarkGray
Set-Alias -Name lsf $ScriptLocation\Get-ChildItem-Force.ps1 -Option AllScope

# *****************************************************************************
# ALIAS HELP DISPLAY
# *****************************************************************************

# function Show-AliasHelp {
#     Write-Host "`e[1;36mCommand Aliases for $env:USERNAME`e[0m"
#     Write-Host "`e[1;33mREPOs`e[0m"
#     Write-Host "`e[33mAdd an integer to the command ""changes 3"", to list the commits from the`e[0m"
#     Write-Host "`e[33mprevious 3 days. To see changes from only one repo add the switch -days 2 `e[0m"
#     Write-Host "`e[33mto the command ""gitlab -days 3"" or ommit the switch and number to see`e[0m"
#     Write-Host "`e[33mcommits from the previous 24 hours. ""gitlab""`e[0m"
#     Write-Host "changes : Status of GitLab Engineering Repo"
#     Write-Host ""
#     Write-Host "ghcreate: Create a new GitHub repo and push the current directory to it."
#     Write-Host "          The local folder must alrady have a repo initialized."
#     Write-Host ""
#     Write-Host "`e[1;33mFOLDERS:`e[0m"

# }


