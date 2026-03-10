# SPDX-License-Identifier: MIT
# =============================================================================
# Quête 19 - Les Autres Forges - Verification script
# Project : Git Chronicles (Les Chroniques du Versionneur)
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\common.ps1"
_Parse-LangFlag $args
_Load-ThemeMessages

$script:QuestTitle = "Quête 19 - Les Autres Forges"
Show-Banner $script:QuestTitle

# ---- Step 1 : Est-on dans un dépôt Git ? ----
Check-Step 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Step 2 : Le fichier GitHub Actions existe ----
Check-Step 2 "Le fichier .github/workflows/ci.yml existe" {
    $files = Get-ChildItem -Path ".github/workflows" -Filter "*.yml" -ErrorAction SilentlyContinue
    $null -ne $files -and ($files | Measure-Object).Count -ge 1
}

# ---- Step 3 : Le fichier GitLab CI existe ----
Check-Step 3 "Le fichier .gitlab-ci.yml existe" {
    Test-Path ".gitlab-ci.yml"
}

# ---- Step 4 : Le fichier Bitbucket Pipelines existe ----
Check-Step 4 "Le fichier bitbucket-pipelines.yml existe" {
    Test-Path "bitbucket-pipelines.yml"
}

# ---- Step 5 : Le script de test existe ----
Check-Step 5 "Le script de test scripts/test.sh existe" {
    Test-Path "scripts/test.sh"
}

# ---- Step 6 : Au moins un commit a été créé ----
Check-Step 6 "Au moins un commit a été créé" {
    $result = & git log --oneline -1 2>&1
    $LASTEXITCODE -eq 0
}

Show-Score
