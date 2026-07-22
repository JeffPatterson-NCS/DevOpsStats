# Copilot Instructions

## Purpose

A personal PowerShell profile and scripts collection for monitoring code changes across Azure DevOps and GitLab repositories. The primary user-facing command is `changes`, which queries both systems and prints recent commits.

## Prerequisites

- **PowerShell 7** is required for all scripts (uses `ForEach-Object -Parallel` and `$using:` scoping)
- The PowerShell profile (`Microsoft.PowerShell_profile.ps1`) must be loaded — either by placing it at `$PROFILE` or reloading with `. $PROFILE`

## Architecture

### Profile Bootstrap Chain

```
Microsoft.PowerShell_profile.ps1
  ├── loads oh-my-posh (if available and not in ConstrainedLanguage mode)
  ├── dots in Set-Aliases.ps1          ← common aliases for all users
  ├── dots in Set-Aliases_JPatterson.ps1  ← user-specific aliases (gated by $env:USERNAME)
  └── ensures ssh-agent is running + adds ~/.ssh/github-ncs key
```

### The `changes` Command Flow

```
changes [<days>]  →  Get-RepoStatus.ps1
                        ├── Write-SearchCriteria.ps1   (prints header)
                        └── Get-RepoChangesGitLab.ps1  (queries GitLab REST API)
                              └── Get-RepoCount.ps1    (alerts on repo count change)
```

> The Azure DevOps script (`Get-RepoChangesAzD.ps1`) is present but currently commented out of `Get-RepoStatus.ps1`. A Go port of it exists at `Get-RepoChangesAzD.go`.

## Key Conventions

### Authentication — PATs stored outside the repo

Access tokens are **never** committed. They are read from plain-text files in `$env:USERPROFILE\.ssh\`:

| Service | File |
|---|---|
| GitLab (NCS) | `~\.ssh\NCS-GitLab-at.txt` |
| Azure DevOps (Beckhoff) | `~\.ssh\Beckhoff-AzD-pat.txt` |

### Path Handling

- Use `$env:OneDrive` (not `$env:USERPROFILE`) for scripts that live under OneDrive sync. The profile and alias scripts both use this pattern.
- Non-OneDrive fallback paths are left as comments (e.g., `# $ScriptLocation = Join-Path $env:USERPROFILE "\Documents\PowerShell\"`).

### Script Parameters

All scripts follow this switch convention:

```powershell
param (
    [int]$days = 1,
    [switch]$help,
    [switch]$h,
    [switch]$verbose,
    [switch]$v
)
```

`-h`/`-help` calls `Get-Help -Full` on the script itself. `-v`/`-verbose` sets `$showall = $true`.

### Comment-Based Help

Every script has a full comment-based help block at the top with `.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER`, `.EXAMPLE`, and `.NOTES` (author, prerequisite, date).

### Aliases

All aliases use `-Option AllScope` so they work in child scopes:

```powershell
Set-Alias -Name changes $ScriptLocation\Get-RepoStatus.ps1 -Option AllScope
```

### Colored Output

ANSI escape sequences are used directly in strings — not `Write-Host -ForegroundColor`. Example:

```powershell
Write-Host "`e[93m   From branch: $branchName`e[0m"
Write-Host "`e[36m`tCommit ID:  $short_id`e[0m"
```

### Parallel API Calls (GitLab)

`Get-RepoChangesGitLab.ps1` processes repos concurrently using:

```powershell
$indexedProjects | ForEach-Object -Parallel { ... } -ThrottleLimit 5
```

Variables from the outer scope must be accessed with `$using:varName` inside the parallel block.

### Repo Count Persistence

Each API script saves the current repo count to a file in `$env:USERPROFILE` (outside the repo) to detect additions/removals between runs:
- `~/repoCountGitLab.txt`
- `~/repoCountAzD.txt`
