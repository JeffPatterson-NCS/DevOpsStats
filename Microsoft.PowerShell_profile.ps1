# Snippet to test for the current user
if ($env:USERNAME -eq "JPatterson") { }

# Test if an extension is installed and if not install it.
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    # This line is used for the CLI Extension oh-my-posh
    # that adds useful info and color to the prompt.
    oh-my-posh init pwsh | Invoke-Expression

    # This DOES NOT ACTUALLY WORK. DUMB ChatGPT!
    # Instead of using Invoke-Expression, you could use the following line:
    # $omp = .\oh-my-posh init pwsh
    # & $omp
}
else {
    Write-Host "oh-my-posh not initialized."
}

# Simplify the path to the PowerSehll scripts and make the lines shorter.
$ScriptLocation = Join-Path $env:USERPROFILE "\Documents\PowerShell\"

# Aliases are not case sensitive in Windows.
# These are aliases used to change directories quickly to the most common ones I use.
# Set-Alias -Name Source $env:USERPROFILE\Documents\PowerShell\Get-SourceFolder.ps1 -Option AllScope
Set-Alias -Name Source $ScriptLocation\Get-FolderSource.ps1 -Option AllScope
Set-Alias -Name Training $ScriptLocation\Get-FolderTraining.ps1 -Option AllScope
Set-Alias -Name Repos $ScriptLocation\Get-FolderRepo.ps1 -Option AllScope
Set-Alias -Name Tunnel $ScriptLocation\Get-FolderTunnel.ps1 -Option AllScope
Set-Alias -Name Startup $ScriptLocation\Get-FolderAutoStartup.ps1 -Option AllScope
Set-Alias -Name PSR $ScriptLocation\Get-FolderPSRepo.ps1 -Option AllScope
Set-Alias -Name plc $ScriptLocation\Get-FolderPLC -Option AllScope

# *****************************************************************************
# Lets do some cool stuff
# *****************************************************************************

# Azure DevOps Repo Changes
Set-Alias -Name Azd $ScriptLocation\Get-RepoChangesAzD.ps1 -Option AllScope
Set-Alias -Name gitLab $ScriptLocation\Get-RepoChangesGitLab.ps1 -Option AllScope
Set-Alias -Name changes $ScriptLocation\Get-RepoStatus.ps1 -Option AllScope

# Command Aliases to make it easier to enter CLI commands
# List all files in the current directory including hidden
Set-Alias -Name lsf $ScriptLocation\Get-ChildItem-Force.ps1 -Option AllScope 

# If there is a user on the calling machine that matches the string, then
# create the aliases for that user.
if($env:USERNAME -eq "JPatterson") {
    Write-Host "The user $env:USERNAME has aliases assigned."
    Set-Alias -Name webdev $ScriptLocation\Get-FolderWebDev.ps1 -Option AllScope

    # Git Shortcut Aliases
    function Get-GitStatus { & git status $args}
    Set-Alias -Name status Get-GitStatus -Option AllScope

    function Get-GitFetchAll { & git fetch --all}
    Set-Alias -name fetch Get-GitFetchAll -Option AllScope

    function Get-GitAddAll { & git add .}
    Set-Alias -Name addall Get-GitAddAll -Option AllScope

    function Get-GitPull { & git pull $args}
    Set-Alias -Name pull Get-GitPull -Option AllScope

    function Get-GitPush { & git push $args}
    Set-Alias -Name push Get-GitPush -Option AllScope

    function Get-GitCommit { & git commit $args}
    Set-Alias -name commit Get-GitCommit -Option AllScope

    function Get-GitSwitch { & git switch $args}
    Set-Alias -name gswitch Get-GitSwitch -Option AllScope

    # GitHub aliases
    function Get-gh-create { & gh repo create --private --source=. --remote=origin & git push -u --all & gh browse }
    Set-Alias -Name ghcreate Get-Gh-Create -Option AllScope

    function Get-FolderConfig { & Set-Location $env:Repos\Tunnel\setup}
    Set-Alias -Name config Get-FolderConfig -Option AllScope
} 
else {
    Write-Host "The user $env:USERNAME does not have aliases assigned."
}

Write-Host "`e[1;36mCommand Aliases for $env:USERNAME`e[0m"
Write-Host "`e[1;33mREPOs`e[0m"
Write-Host "`e[33mAdd an integer to the command ""changes 3"", to list the commits from the`e[0m"
Write-Host "`e[33mprevious 3 days. To see changes from only one repo add the switch -days 2 `e[0m"
Write-Host "`e[33mto the command ""gitlab -days 3"" or ommit the switch and number to see`e[0m"
Write-Host "`e[33mcommits from the previous 24 hours. ""azd"" or ""gitlab""`e[0m"
Write-Host "changes : Status of both repos"
Write-Host "Azd     : Show the Azure DevOps Repo Changes."
Write-Host "gitLab  : Show the GitLab Repo Changes."
Write-Host ""
Write-Host "`e[1;33mGIT`e[0m"
Write-Host "status  : git status"
Write-Host "gswitch : git switch"
Write-Host "fetch   : git fetch --all"
Write-Host "pull    : git pull"
Write-Host "addall  : git add . (all)"
Write-Host "commit  : git commit"
Write-Host "push    : git push"
Write-Host "ghcreate: Create a new GitHub repo and push the current directory to it."
Write-Host "          This folder must alrady have a repo initialized."
Write-Host ""
Write-Host "`e[1;33mFOLDERS:`e[0m"
Write-Host "Source  : Source folder"
Write-Host "Repos   : Repos folder"
Write-Host "Startup : Startup folder"
Write-Host "PSR     : PSRepo folder"
Write-Host "Training: Training folder"
Write-Host "webdev  : WebDev training folder"
Write-Host "tunnel  : Tunnel folder"
Write-Host "alpha   : Alpha Tunnel Controller PLC Repo folder"
Write-Host "beta    : Beta Tunnel Controller PLC Repo folder"
Write-Host "config  : Tunnel Controller Setup Repo folder"
Write-Host "lsf     : List all files in the current directory including hidden."
Write-Host ""
# *****************************************************************************