# SPDX-License-Identifier: MIT
# =============================================================================
# Quête 10 - Le Protocole des Guildes - Verification script
# Project : Git Chronicles (Les Chroniques du Versionneur)
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\common.ps1"
_Parse-LangFlag $args
_Load-ThemeMessages

$script:QuestTitle = "Quête 10 - Le Protocole des Guildes"
Show-Banner $script:QuestTitle

# ---- Step 1 : Est-on dans un dépôt Git ? ----
Check-Step 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Step 2 : La branche main/master existe ----
Check-Step 2 "La branche principale (main ou master) existe" {
    $branches = & git branch --list main master 2>&1
    $LASTEXITCODE -eq 0 -and ($branches -match "main|master")
}

# ---- Step 3 : Au moins 3 commits au total ----
Check-Step 3 "Il y a au moins 3 commits dans l'historique" {
    $commits = & git log --oneline 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($commits | Measure-Object).Count -ge 3
}

# ---- Step 4 : Un commit de merge existe (preuve du --no-ff) ----
Check-Step 4 "Un commit de merge existe (Protocole respecté)" {
    $merges = & git log --merges --oneline 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($merges | Measure-Object).Count -ge 1
}

# ---- Step 5 : Pas de branche de proposition restante (nettoyée) ----
Check-Step 5 "La branche de proposition a été nettoyée" {
    $branches = & git branch 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    $nonMain = $branches | Where-Object { $_ -notmatch "main|master|\*" -and $_.Trim() -ne "" }
    ($nonMain | Measure-Object).Count -eq 0
}

Show-Score
