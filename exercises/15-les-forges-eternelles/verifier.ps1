# SPDX-License-Identifier: MIT
# =============================================================================
# Quête 15 - Les Forges Éternelles - Verification script
# Project : Git Chronicles (Les Chroniques du Versionneur)
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\common.ps1"
_Parse-LangFlag $args
_Load-ThemeMessages

$script:QuestTitle = "Quête 15 - Les Forges Éternelles"
Show-Banner $script:QuestTitle

# ---- Step 1 : Est-on dans un dépôt Git ? ----
Check-Step 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Step 2 : Au moins un remote est configuré ----
Check-Step 2 "Au moins un remote est configuré" {
    $remotes = & git remote 2>&1
    $LASTEXITCODE -eq 0 -and ($remotes | Measure-Object).Count -ge 1
}

# ---- Step 3 : Au moins un push a été effectué ----
Check-Step 3 "Au moins un push a été effectué (des refs distantes existent)" {
    $branches = & git branch -r 2>&1
    $LASTEXITCODE -eq 0 -and ($branches | Measure-Object).Count -ge 1
}

# ---- Step 4 : Au moins 3 commits dans le dépôt ----
Check-Step 4 "Le dépôt contient au moins 3 commits" {
    $count = & git rev-list --count HEAD 2>&1
    $LASTEXITCODE -eq 0 -and ([int]$count -ge 3)
}

Show-Score
