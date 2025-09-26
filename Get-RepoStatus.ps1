<#
.SYNOPSIS
    This script checks for changes in all repositories from Azure DevOps and GitLab.
.DESCRIPTION
    The script will output the number of repositories in each system and the number
    of changes in each repository along with the SHA, committer, date, and message.
.PARAMETER days
    The number of previous days to query for changes. Default is 1, which will return
    all changes since yesterday. (Note that on the beginning of the week and holidays 
    this might not return the expected changes.)
.PARAMETER h -OR help
    Display the help message.
.PARAMETER verbose -or v
    Display verbose output.
.EXAMPLE
    PS> .\Get-RepoStatus.ps1 -days 3
    This example will check for changes in all repositories from Azure DevOps and GitLab
    in the previous 3 days
.EXAMPLE
    PS> .\Get-RepoStatus.ps1 -verbose
.EXAMPLE
    PS> .\Get-RepoStatus.ps1 -v
.EXAMPLE
    PS> .\Get-RepoStatus.ps1 -help
.EXAMPLE
    PS> .\Get-RepoStatus.ps1 -h

.NOTES
    File Name      : Get-RepoStatus.ps1
    Author         : Jeff Patterson
    Prerequisite   : PowerShell V7
    Date           : 2024-11-27
#>

param (
    [int]$days = 1,
    [switch]$help,
    [switch]$h,
    [switch]$verbose,
    [switch]$v
)

if($h -or $help) {
    Get-Help -Full $MyInvocation.MyCommand.Path
    exit
}

if($v -or $verbose) {
    $showall = $true
    Write-Host "Verbose output is enabled."
}

Clear-Host

# & $env:USERPROFILE\Documents\PowerShell\Write-SearchCriteria.ps1 -repo "AzD" -searchDays $days
# if ($showall) {
#     AzD -verbose -days $days
# } else {
#     AzD -days $days
# }

# Run the script Search Criteria
# & C:\Users\JPatterson\Documents\PowerShell\Write-SearchCriteria.ps1 -repo "GitLab" -searchDays $days
& $env:OneDrive\Documents\PowerShell\Write-SearchCriteria.ps1 -repo "GitLab" -searchDays $days
if($showall) {
    gitlab -verbose -days $days
} else {
    gitlab -days $days
}

Write-Host "--------------------------------------------------------------------------------"
Write-Host "Checking is complete."
Write-Host "--------------------------------------------------------------------------------"
Write-Host ""
Write-Host ""

