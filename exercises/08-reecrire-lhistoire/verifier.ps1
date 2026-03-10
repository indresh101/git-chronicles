# SPDX-License-Identifier: MIT
# =============================================================================
# Quête 08 - Réécrire l'Histoire - Verification script
# Project : Git Chronicles (Les Chroniques du Versionneur)
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\common.ps1"
_Parse-LangFlag $args
_Load-ThemeMessages

$script:QuestTitle = "Quête 08 - Réécrire l'Histoire"
Show-Banner $script:QuestTitle

# ---- Step 1 : Est-on dans un dépôt Git ? ----
Check-Step 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Step 2 : Le reflog contient un amend ----
Check-Step 2 "Tu as utilisé git commit --amend (visible dans le reflog)" {
    $reflog = & git reflog 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($reflog | Out-String) -match "(?i)amend"
}

# ---- Step 3 : Le reflog contient un rebase ----
Check-Step 3 "Tu as effectué un rebase (visible dans le reflog)" {
    $reflog = & git reflog 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($reflog | Out-String) -match "(?i)rebase"
}

# ---- Step 4 : Au moins 3 commits existent ----
Check-Step 4 "Au moins 3 commits existent dans l'historique" {
    $count = & git rev-list --count HEAD 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    [int]$count -ge 3
}

Show-Score
