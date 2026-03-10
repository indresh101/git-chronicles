# SPDX-License-Identifier: MIT
# =============================================================================
# Quête 05 - Les Lignes du Temps - Verification script
# Project : Git Chronicles (Les Chroniques du Versionneur)
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\common.ps1"
_Parse-LangFlag $args
_Load-ThemeMessages

$script:QuestTitle = "Quête 05 - Les Lignes du Temps"
Show-Banner $script:QuestTitle

# ---- Step 1 : Est-on dans un dépôt Git ? ----
Check-Step 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Step 2 : Le .gitignore existe ----
Check-Step 2 "Le fichier .gitignore existe" {
    Test-Path ".gitignore"
}

# ---- Step 3 : Le .gitignore contient un pattern pour les .log ----
Check-Step 3 "Le .gitignore ignore les fichiers .log" {
    if (-not (Test-Path ".gitignore")) { return $false }
    $contenu = Get-Content ".gitignore" -Raw
    $contenu -match '\*\.log' -or $contenu -match 'debug\.log'
}

# ---- Step 4 : debug.log n'est plus tracké ----
Check-Step 4 "debug.log n'est plus suivi par Git" {
    & git ls-files --error-unmatch "debug.log" 2>&1 | Out-Null
    $LASTEXITCODE -ne 0
}

# ---- Step 5 : Le dernier commit a un message d'au moins 10 caractères ----
Check-Step 5 "Le dernier commit a un message descriptif (>= 10 caractères)" {
    $msg = & git log -1 --format="%s" 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    $msg.Length -ge 10
}

Show-Score
