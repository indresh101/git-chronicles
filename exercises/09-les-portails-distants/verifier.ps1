# SPDX-License-Identifier: MIT
# =============================================================================
# Quête 09 - Les Portails Distants - Verification script
# Project : Git Chronicles (Les Chroniques du Versionneur)
#
# Usage   : .\verifier.ps1
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\common.ps1"
_Parse-LangFlag $args
_Load-ThemeMessages

$script:QuestTitle = "Quête 09 - Les Portails Distants"
Show-Banner $script:QuestTitle

# ---- Step 1 : Est-on dans un dépôt Git ? ----
Check-Step 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Step 2 : Au moins un remote est configuré ----
Check-Step 2 "Au moins un remote est configuré" {
    $remotes = & git remote 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    $lines = ($remotes | Measure-Object -Line).Lines
    $lines -ge 1
}

# ---- Step 3 : Un push a été effectué ----
Check-Step 3 "Tu as poussé au moins une fois vers un remote" {
    # Vérifie l'existence de refs de suivi distant
    $refs = & git for-each-ref refs/remotes --format="%(refname)" 2>&1
    if ($LASTEXITCODE -eq 0 -and $refs) { return $true }
    # Alternative : chercher dans le reflog
    $reflog = & git reflog show --all 2>&1
    if ($reflog -match "push") { return $true }
    return $false
}

# ---- Step 4 : Un fetch ou pull a été effectué ----
Check-Step 4 "Tu as récupéré des changements depuis un remote" {
    # Cherche des traces de fetch/pull dans le reflog
    $reflog = & git reflog show --all 2>&1
    if ($reflog -match "fetch|pull") { return $true }
    # Alternative : plus de commits sur les branches distantes que locales
    $allCount = (& git log --all --oneline 2>&1 | Measure-Object -Line).Lines
    $localCount = (& git log --oneline 2>&1 | Measure-Object -Line).Lines
    if ($allCount -gt $localCount) { return $true }
    return $false
}

Show-Score
