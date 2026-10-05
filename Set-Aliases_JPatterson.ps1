# PowerShell Aliases Configuration
# This script contains all the custom aliases for the PowerShell profile

# Simplify the path to the PowerShell scripts
$ScriptLocation = Split-Path -Parent $MyInvocation.MyCommand.Path

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

# Paths config for neuronwork/work — edit this file to change which folders open
$workSettingsPath = Join-Path $ScriptLocation 'work-open-paths.json'

function Invoke-NeuronWork {
    <#
    .SYNOPSIS
        Opens all configured working directories as File Explorer tabs.
        Requires ExplorerTabUtility (tray app) to be running for tab conversion.
    #>
    if (-not (Test-Path $workSettingsPath)) {
        Write-Warning "Work settings not found at $workSettingsPath"
        return
    }

    $settings = Get-Content $workSettingsPath -Raw | ConvertFrom-Json
    $paths    = $settings.Paths
    # Hardcoded delay — long enough for ExplorerTabUtility to intercept each window
    # before the next one opens. Adjust in work-open-paths.json if needed.
    $delayMs  = 700

    foreach ($path in $paths) {
        # CLM-safe: use -replace operator (no .NET method calls)
        $expanded = $path -replace '/', '\'
        foreach ($envVar in (Get-ChildItem Env:)) {
            $expanded = $expanded -replace ("%$($envVar.Name)%"), $envVar.Value
        }
        if ($expanded -and (Test-Path $expanded -PathType Container)) {
            & explorer.exe $expanded
        } else {
            Write-Warning "Path not found, skipping: $expanded"
        }
        Start-Sleep -Milliseconds $delayMs
    }
}
Write-Host "  neuronwork, work  -> Open working directories as Explorer tabs" -ForegroundColor DarkGray
Set-Alias -Name neuronwork -Value Invoke-NeuronWork -Option AllScope -Force
Set-Alias -Name work       -Value Invoke-NeuronWork -Option AllScope -Force

# Wrap claude so a bare `claude` invocation always uses --agent basic (red theme).
# Capture the real executable path at load time to avoid recursive self-calls.
$script:_claudeExe = (Get-Command claude -CommandType Application -ErrorAction SilentlyContinue)?.Source
function claude {
    if ($script:_claudeExe) {
        & $script:_claudeExe --agent default @args
    } else {
        Write-Error "Claude executable not found in PATH"
    }
}
Write-Host "  Claude            -> claude --agent default (Sonnet 4.6 Medium Effort Red theme)" -ForegroundColor DarkGray
Write-Host ""

# Claude Code Agent Launchers
# Resolve the real claude.exe directly (not the `claude` function above) so the
# --agent value we pass isn't overridden by the bare-invocation default wrapper.
function Start-ClaudeAgentTab {
    <#
    .SYNOPSIS
        Opens a Windows Terminal tab running Claude Code under the given agent.
    #>
    param(
        [Parameter(Mandatory)][string]$Title,
        [Parameter(Mandatory)][string]$Agent
    )

    if (-not $script:_claudeExe) { Write-Error "Claude executable not found in PATH"; return }

    # Claude Code only runs the configured statusLine when it has a shell parent. Handing wt the
    # bare claude.exe makes it a direct child of wt.exe and the status bar never renders, so go
    # through pwsh instead. -NoProfile keeps the alias banner out of the new tab.
    # wt also ignores the caller's location and uses the profile's startingDirectory, so pass -d.
    # --permission-mode is passed explicitly so the tab starts in acceptEdits regardless of how the
    # agent frontmatter and the global defaultMode happen to resolve.
    $wtArgs = @(
        '--title', $Title,
        '--suppressApplicationTitle',
        '-d', "$PWD",
        '--',
        'pwsh', '-NoLogo', '-NoProfile', '-Command', "Remove-Item Env:\CLAUDE_CODE_CHILD_SESSION -ErrorAction SilentlyContinue; & '$script:_claudeExe' --agent $Agent --permission-mode acceptEdits"
    )
    & wt @wtArgs
}

function Start-Agent86 {
    Start-ClaudeAgentTab -Title "Agent 86 - Neuron" -Agent 86
}
Write-Host "  agent86           -> Agent 86 (Neuron)     — Opus latest, Medium effort" -ForegroundColor DarkGray
Set-Alias -Name agent86 -Value Start-Agent86 -Option AllScope -Force

function Start-Agent99 {
    Start-ClaudeAgentTab -Title "Agent 99 - Review" -Agent 99
}
Write-Host "  agent99           -> Agent 99 (Review)     — Sonnet latest, Medium effort" -ForegroundColor DarkGray
Set-Alias -Name agent99 -Value Start-Agent99 -Option AllScope -Force

function Start-Agent13 {
    Start-ClaudeAgentTab -Title "agent13 - Agent 13" -Agent 13
}
Write-Host "  agent13           -> Agent 13 (B Murray)   — Fable latest, XHigh effort" -ForegroundColor DarkGray
Set-Alias -Name agent13 -Value Start-Agent13 -Option AllScope -Force

function Start-Agent23 {
    Start-ClaudeAgentTab -Title "Agent 23 - AI" -Agent 23
}
Write-Host "  agent23           -> Agent 23 (AI)         — Sonnet latest, High effort" -ForegroundColor DarkGray
Set-Alias -Name agent23 -Value Start-Agent23 -Option AllScope -Force
