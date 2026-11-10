<#
.SYNOPSIS
Installeert de skills uit deze repo in een doelrepo en vult de plaatshouders in.

.DESCRIPTION
Kopieert de skills naar .github/skills en/of .claude/skills van de doelrepo, kopieert docs/definition-of-done.md
en vult de plaatshouders <ado-project>, <solution> en <excluded-category> in. Bestaande bestanden worden niet
overschreven, tenzij -Force is opgegeven. Er wordt niets gecommit.

.EXAMPLE
.\install.ps1 ..\mijn-repo -AdoProject "Mijn Project" -Solution "Acme.Shop" -ExcludedCategory "Slow" -Templates
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$TargetRepo,

    [string]$AdoProject = '',
    [string]$Solution = '',
    [string]$ExcludedCategory = '',

    [ValidateSet('copilot', 'claude', 'both')]
    [string]$Target = 'both',

    # Maak ook ontbrekende bestanden aan: .github/copilot-instructions.md, CLAUDE.md en .vscode/mcp.json
    [switch]$Templates,

    # Overschrijf bestaande bestanden en mappen
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$SourceRoot = $PSScriptRoot
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

if (-not (Test-Path -LiteralPath $TargetRepo -PathType Container)) {
    throw "Doelmap bestaat niet: $TargetRepo"
}
$TargetRepo = (Resolve-Path -LiteralPath $TargetRepo).Path

if ($TargetRepo.TrimEnd('\', '/') -eq $SourceRoot.TrimEnd('\', '/')) {
    throw 'De doelrepo is dezelfde als de bronrepo.'
}

if (-not (Test-Path -LiteralPath (Join-Path $TargetRepo '.git'))) {
    Write-Host "Let op: $TargetRepo lijkt geen git-repo (geen .git gevonden). Ik ga toch door."
}

$Installed = New-Object System.Collections.Generic.List[string]
$Skipped = New-Object System.Collections.Generic.List[string]

# Bestanden waarin de plaatshouders ingevuld horen te worden (niet in de README's, daar worden ze uitgelegd).
$FillNames = @('SKILL.md', 'definition-of-done.md', 'copilot-instructions.md')
$PlaceholderPattern = '<(ado-project|solution|excluded-category)>'

function Get-FillFiles([string]$Path) {
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        $item = Get-Item -LiteralPath $Path
        if ($FillNames -contains $item.Name) { return , $item }
        return @()
    }
    return Get-ChildItem -LiteralPath $Path -Recurse -File | Where-Object { $FillNames -contains $_.Name }
}

function Set-Placeholders([string]$Path) {
    $map = [ordered]@{}
    if ($AdoProject) { $map['<ado-project>'] = $AdoProject }
    if ($Solution) { $map['<solution>'] = $Solution }
    if ($ExcludedCategory) { $map['<excluded-category>'] = $ExcludedCategory }
    if ($map.Count -eq 0) { return }

    foreach ($file in Get-FillFiles $Path) {
        $text = [System.IO.File]::ReadAllText($file.FullName, $Utf8NoBom)
        foreach ($key in $map.Keys) {
            $text = $text.Replace($key, $map[$key])   # letterlijke vervanging, geen regex
        }
        [System.IO.File]::WriteAllText($file.FullName, $text, $Utf8NoBom)
    }
}

function Copy-Directory([string]$Source, [string]$Destination) {
    if (Test-Path -LiteralPath $Destination) {
        if (-not $Force) {
            $Skipped.Add($Destination)
            return $false
        }
        Remove-Item -LiteralPath $Destination -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Destination) | Out-Null
    Copy-Item -LiteralPath $Source -Destination $Destination -Recurse
    $Installed.Add($Destination)
    return $true
}

function Copy-OneFile([string]$Source, [string]$Destination) {
    if ((Test-Path -LiteralPath $Destination) -and -not $Force) {
        $Skipped.Add($Destination)
        return $false
    }
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Destination) | Out-Null
    Copy-Item -LiteralPath $Source -Destination $Destination -Force
    $Installed.Add($Destination)
    return $true
}

# Skills
$copilotRoot = Join-Path $TargetRepo '.github/skills'
$claudeRoot = Join-Path $TargetRepo '.claude/skills'
$destinations = @()
if ($Target -in 'copilot', 'both') { $destinations += $copilotRoot }
if ($Target -in 'claude', 'both') { $destinations += $claudeRoot }

$skillsRoot = Join-Path $SourceRoot '.github/skills'
$skillDirs = @()
if (Test-Path -LiteralPath $skillsRoot) {
    $skillDirs = Get-ChildItem -LiteralPath $skillsRoot -Directory |
        Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') }
}
if ($skillDirs.Count -eq 0) {
    throw "Geen skills gevonden in $skillsRoot"
}

foreach ($skill in $skillDirs) {
    foreach ($dest in $destinations) {
        $skillDest = Join-Path $dest $skill.Name
        if (Copy-Directory $skill.FullName $skillDest) {
            Set-Placeholders $skillDest
            # In .claude/skills staat de skill een niveau anders dan in .github/skills: pas de link naar de instructies aan.
            if ($dest -eq $claudeRoot) {
                foreach ($md in Get-ChildItem -LiteralPath $skillDest -Recurse -File -Filter '*.md') {
                    $text = [System.IO.File]::ReadAllText($md.FullName, $Utf8NoBom)
                    $text = $text.Replace('../../copilot-instructions.md', '../../../.github/copilot-instructions.md')
                    [System.IO.File]::WriteAllText($md.FullName, $text, $Utf8NoBom)
                }
            }
        }
    }
}

# Definition of Done
$dodTarget = Join-Path $TargetRepo 'docs/definition-of-done.md'
if (Copy-OneFile (Join-Path $SourceRoot 'docs/definition-of-done.md') $dodTarget) {
    Set-Placeholders $dodTarget
}

# Sjablonen
if ($Templates) {
    $instrTarget = Join-Path $TargetRepo '.github/copilot-instructions.md'
    if (Copy-OneFile (Join-Path $SourceRoot 'templates/copilot-instructions.md') $instrTarget) {
        Set-Placeholders $instrTarget
    }
    [void](Copy-OneFile (Join-Path $SourceRoot 'templates/CLAUDE.md') (Join-Path $TargetRepo 'CLAUDE.md'))
    [void](Copy-OneFile (Join-Path $SourceRoot 'templates/vscode-mcp.json') (Join-Path $TargetRepo '.vscode/mcp.json'))
}

function Get-Relative([string]$Path) {
    return $Path.Substring($TargetRepo.Length).TrimStart('\', '/')
}

Write-Host "Geinstalleerd in ${TargetRepo}:"
if ($Installed.Count -gt 0) {
    foreach ($p in $Installed) { Write-Host "  + $(Get-Relative $p)" }
}
else {
    Write-Host '  (niets nieuw)'
}
if ($Skipped.Count -gt 0) {
    Write-Host 'Overgeslagen omdat ze al bestaan (gebruik -Force om te overschrijven):'
    foreach ($p in $Skipped) { Write-Host "  = $(Get-Relative $p)" }
}

# Plaatshouders die nog openstaan
$open = New-Object System.Collections.Generic.List[string]
$names = New-Object System.Collections.Generic.HashSet[string]
foreach ($p in $Installed) {
    if (-not (Test-Path -LiteralPath $p)) { continue }
    foreach ($file in Get-FillFiles $p) {
        $found = Select-String -LiteralPath $file.FullName -Pattern $PlaceholderPattern -AllMatches
        if ($found) {
            $open.Add($file.FullName)
            foreach ($line in $found) {
                foreach ($m in $line.Matches) { [void]$names.Add($m.Value) }
            }
        }
    }
}
if ($open.Count -gt 0) {
    Write-Host ''
    Write-Host "Nog niet ingevuld: $(($names | Sort-Object) -join ' ')"
    Write-Host 'Gebruik de parameters -AdoProject, -Solution en -ExcludedCategory (met -Force), of vul ze met de hand in. Aanwezig in:'
    foreach ($f in ($open | Sort-Object -Unique)) { Write-Host "  $(Get-Relative $f)" }
}

Write-Host ''
Write-Host 'Volgende stappen:'
Write-Host '  1. Controleer .github/copilot-instructions.md (sjabloon: templates/copilot-instructions.md) en vul docs/definition-of-done.md aan.'
Write-Host "  2. Start de MCP-server 'ado' (sjabloon: templates/vscode-mcp.json) en controleer de toolnamen."
Write-Host '  3. Doe een proefrun op een klein item, bijvoorbeeld: /ado-pickup 12345'
