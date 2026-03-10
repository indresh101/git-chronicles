# SPDX-License-Identifier: MIT
# =============================================================================
# Quête 11 - Le Tisseur de Temps - Verification script
# Project : Git Chronicles (Les Chroniques du Versionneur)
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\common.ps1"
_Parse-LangFlag $args
_Load-ThemeMessages

$script:QuestTitle = "Quête 11 - Le Tisseur de Temps"
Show-Banner $script:QuestTitle

# ---- Step 1 : Est-on dans un dépôt Git ? ----
Check-Step 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Step 2 : Au moins 2 branches existent ----
Check-Step 2 "Au moins 2 branches existent" {
    $branches = & git branch -a 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($branches | Measure-Object).Count -ge 2
}

# ---- Step 3 : Le reflog montre une activité de stash ----
Check-Step 3 "Le reflog montre une activité de stash" {
    $stashLog = & git reflog show stash 2>&1
    if ($LASTEXITCODE -eq 0 -and ($stashLog | Measure-Object).Count -ge 1) { return $true }
    $reflog = & git reflog 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($reflog | Where-Object { $_ -match "stash" } | Measure-Object).Count -ge 1
}

# ---- Step 4 : Au moins 3 commits existent ----
Check-Step 4 "Il y a au moins 3 commits dans l'historique" {
    $commits = & git log --all --oneline 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($commits | Measure-Object).Count -ge 3
}

Show-Score
