# When OneDrive for Business was installed. MS moved the Documents folder to 
# OneDrive. Breaking all my scripts that referenced the old path. The path to 
#the user alias script needs to be updated.


# Invoke-Expression (& { (jj util completion power-shell | Out-String) })

# Snippet to test for the current user
if ($env:USERNAME -eq "JPatterson") {
    # I have an SSH key setup to deploy the TunnelControlUI application to the
    # Raspberry Pi NGINX server.
    # Write-Host "Adding SSH key for user $env:USERNAME"
    # ssh-add $env:USERPROFILE\.ssh\id_ed25519
 }

function Test-IsAdmin {
    $currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Only run oh-my-posh if NOT in Constrained Language Mode and running as admin
if ($ExecutionContext.SessionState.LanguageMode -ne 'ConstrainedLanguage') {

    Write-Host "Running as Administrator."
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
} else {
    Write-Host "Running as $env:USERNAME."
    Write-Host "Not running as Administrator. "
    Write-Host "While in [Constrained Language Mode], some features may not work as expected."
    Write-Host "oh-my-posh Currently only runs in an elevated (admin) session until CLI is changed."
    Write-Host ""
    # Write-Host "Press any key to continue..."
    # Read-Host
    Clear-Host
}
# *****************************************************************************
# Load custom aliases from separate script

$AliasScript = Join-Path $env:OneDrive "\Documents\PowerShell\Set-Aliases.ps1"
if (Test-Path $AliasScript) {
    . $AliasScript
}

$UserAliasScript = Join-Path $env:OneDrive "\Documents\PowerShell\Set-Aliases_JPatterson.ps1"
if (Test-Path $UserAliasScript) {
    . $UserAliasScript
} else {
    Write-Host "No User Alias files found: $UserAliasScript"
}


# *****************************************************************************
# Lets do some cool stuff
# *****************************************************************************

# *****************************************************************************
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58


function Get-GitBranch {
    try {
        $branch = & git rev-parse --abbrev-ref HEAD 2>$null
        if ($LASTEXITCODE -eq 0) { return $branch }
    } catch {}
    return $null
}

function Get-GitStatus {
    try {
        $branch = Get-GitBranch
        if (-not $branch) { return $null }
        
        # Fetch remote updates silently
        & git fetch 2>$null | Out-Null
        
        # Check if remote branch exists
        $remoteBranch = & git rev-parse --abbrev-ref "@{upstream}" 2>$null
        if ($LASTEXITCODE -ne 0) {
            return @{ Branch = $branch; Status = 'NoRemote' }
        }
        
        # Get commit counts
        $ahead = & git rev-list --count "@{upstream}..HEAD" 2>$null
        $behind = & git rev-list --count "HEAD..@{upstream}" 2>$null
        
        # Get uncommitted changes count
        $statusOutput = & git status --porcelain 2>$null
        $uncommitted = if ($statusOutput) { ($statusOutput | Measure-Object).Count } else { 0 }
        
        if ($ahead -gt 0 -and $behind -gt 0) {
            $status = 'Diverged'
        } elseif ($ahead -gt 0) {
            $status = 'Ahead'
        } elseif ($behind -gt 0) {
            $status = 'Behind'
        } else {
            $status = 'UpToDate'
        }
        
        return @{ Branch = $branch; Status = $status; Ahead = $ahead; Behind = $behind; Uncommitted = $uncommitted }
    } catch {
        return $null
    }
}

# Custom prompt function with git status
# Only use this if oh-my-posh is not running
if ($ExecutionContext.SessionState.LanguageMode -eq 'ConstrainedLanguage' -or !(Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    function prompt {
        $currentFolder = Split-Path -Leaf -Path (Get-Location)
        
        Write-Host $currentFolder -NoNewline -ForegroundColor Cyan
        
        $gitStatus = Get-GitStatus
        if ($gitStatus) {
            $branchColor = switch ($gitStatus.Status) {
                'UpToDate' { 'Green' }
                'Ahead'    { 'Yellow' }
                'Behind'   { 'Red' }
                'NoRemote' { 'Gray' }
                'Diverged' { 'Magenta' }
                default    { 'White' }
            }
            
            Write-Host " [" -NoNewline -ForegroundColor Cyan
            Write-Host $gitStatus.Branch -NoNewline -ForegroundColor $branchColor
            
            # Show ahead/behind indicators with counts
            if ($gitStatus.Ahead -gt 0) {
                Write-Host " ↑$($gitStatus.Ahead)" -NoNewline -ForegroundColor Yellow
            }
            if ($gitStatus.Behind -gt 0) {
                Write-Host " ↓$($gitStatus.Behind)" -NoNewline -ForegroundColor Red
            }
            
            # Show uncommitted changes count
            if ($gitStatus.Uncommitted -gt 0) {
                Write-Host " ±$($gitStatus.Uncommitted)" -NoNewline -ForegroundColor DarkYellow
            }
            
            Write-Host "]" -NoNewline -ForegroundColor Cyan
        }
        
        return "> "
    }
}


# *****************************************************************************
# Do some SSH Stuff
# *****************************************************************************
# Ensure ssh-agent is running
$svc = Get-Service ssh-agent -ErrorAction SilentlyContinue
if ($svc -and $svc.StartType -ne 'Disabled' -and $svc.Status -ne 'Running') {
    Start-Service ssh-agent
}


# Add GitHub key if not already loaded
ssh-add ~/.ssh/github-ncs 2>$null


# *****************************************************************************
# End of Profile
# *****************************************************************************

