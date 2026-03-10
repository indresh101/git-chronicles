# SPDX-License-Identifier: MIT
# =============================================================================
# Quête 06 - L'Arbre des Possibles - Verification script
# Project : Git Chronicles (Les Chroniques du Versionneur)
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\common.ps1"
_Parse-LangFlag $args
_Load-ThemeMessages

$script:QuestTitle = "Quête 06 - L'Arbre des Possibles"
Show-Banner $script:QuestTitle

# ---- Step 1 : Est-on dans un dépôt Git ? ----
Check-Step 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Step 2 : La branche expedition-nord existe ----
Check-Step 2 "La branche expedition-nord existe" {
    $branches = & git branch --list expedition-nord 2>&1
    $LASTEXITCODE -eq 0 -and $branches -match "expedition-nord"
}

# ---- Step 3 : La branche expedition-sud existe ----
Check-Step 3 "La branche expedition-sud existe" {
    $branches = & git branch --list expedition-sud 2>&1
    $LASTEXITCODE -eq 0 -and $branches -match "expedition-sud"
}

# ---- Step 4 : expedition-nord a au moins un commit propre ----
Check-Step 4 "La branche expedition-nord contient un commit propre" {
    $commits = & git log main..expedition-nord --oneline 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($commits | Measure-Object -Line).Lines -ge 1
}

# ---- Step 5 : expedition-sud a au moins un commit propre ----
Check-Step 5 "La branche expedition-sud contient un commit propre" {
    $commits = & git log main..expedition-sud --oneline 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($commits | Measure-Object -Line).Lines -ge 1
}

# ---- Step 6 : Au moins 3 branches au total ----
Check-Step 6 "Il y a au moins 3 branches" {
    $branches = & git branch 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($branches | Measure-Object).Count -ge 3
}

Show-Score
