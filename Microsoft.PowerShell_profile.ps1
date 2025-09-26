# When OneDrive for Business was installed. MS moved the Documents folder to 
# OneDrive. Breaking all my scripts that referenced the old path. The path to 
#the user alias script needs to be updated.


Invoke-Expression (& { (jj util completion power-shell | Out-String) })

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

# OLD HOME:
# $AliasScript = Join-Path $env:USERPROFILE "\Documents\PowerShell\Set-Aliases.ps1"

# NEW HOME:
$AliasScript = Join-Path $env:OneDrive "\Documents\PowerShell\Set-Aliases.ps1"
if (Test-Path $AliasScript) {
    . $AliasScript
}

# OLD HOME:
#$UserAliasScript = Join-Path $env:USERPROFILE "\Documents\PowerShell\Set-Aliases_JPatterson.ps1"

# NEW HOME:
$UserAliasScript = Join-Path $env:OneDrive "\Documents\PowerShell\Set-Aliases_JPatterson.ps1"
if (Test-Path $UserAliasScript) {
    . $UserAliasScript
} else {
    Write-Host "No User Alias files found: $UserAliasScript"
}


# *****************************************************************************
# Lets do some cool stuff
# *****************************************************************************

# Custom prompt function to show only the current folder name
# Only use this if oh-my-posh is not running
if ($ExecutionContext.SessionState.LanguageMode -eq 'ConstrainedLanguage' -or !(Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    function prompt {
        $currentFolder = Split-Path -Leaf -Path (Get-Location)
        Write-Host "$currentFolder" -NoNewline -ForegroundColor Green
        Write-Host ">" -NoNewline -ForegroundColor White
        return " "
    }
}

# *****************************************************************************
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58
