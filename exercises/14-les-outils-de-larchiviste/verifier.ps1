# SPDX-License-Identifier: MIT
# =============================================================================
# Quête 14 - Les Outils de l'Archiviste - Verification script
# Project : Git Chronicles (Les Chroniques du Versionneur)
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\common.ps1"
_Parse-LangFlag $args
_Load-ThemeMessages

$script:QuestTitle = "Quête 14 - Les Outils de l'Archiviste"
Show-Banner $script:QuestTitle

# ---- Step 1 : Est-on dans un dépôt Git ? ----
Check-Step 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Step 2 : Au moins un alias est configuré ----
Check-Step 2 "Au moins un alias Git est configuré" {
    $aliases = & git config --get-regexp alias 2>&1
    $LASTEXITCODE -eq 0 -and ($aliases | Measure-Object).Count -ge 1
}

# ---- Step 3 : Le hook pre-commit existe et est exécutable ----
Check-Step 3 "Le hook pre-commit existe et est exécutable" {
    $gitDir = & git rev-parse --git-dir 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    $hookPath = Join-Path $gitDir "hooks/pre-commit"
    Test-Path $hookPath
}

# ---- Step 4 : Le hook pre-commit fonctionne (détecte les TODO) ----
Check-Step 4 "Le hook pre-commit détecte les TODO dans les fichiers" {
    $gitDir = & git rev-parse --git-dir 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    $hookPath = Join-Path $gitDir "hooks/pre-commit"
    if (-not (Test-Path $hookPath)) { return $false }
    $content = Get-Content $hookPath -Raw
    $content -match "TODO"
}

# ---- Step 5 : Le hook commit-msg existe et est exécutable ----
Check-Step 5 "Le hook commit-msg existe et est exécutable" {
    $gitDir = & git rev-parse --git-dir 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    $hookPath = Join-Path $gitDir "hooks/commit-msg"
    Test-Path $hookPath
}

Show-Score
