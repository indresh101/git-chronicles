# =============================================================================
# Quête 14 - Les Outils de l'Archiviste - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\verifier-common.ps1"

$script:QueteTitre = "Quête 14 - Les Outils de l'Archiviste"
Afficher-Banniere $script:QueteTitre

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
Verifier-Etape 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Étape 2 : Au moins un alias est configuré ----
Verifier-Etape 2 "Au moins un alias Git est configuré" {
    $aliases = & git config --get-regexp alias 2>&1
    $LASTEXITCODE -eq 0 -and ($aliases | Measure-Object).Count -ge 1
}

# ---- Étape 3 : Le hook pre-commit existe et est exécutable ----
Verifier-Etape 3 "Le hook pre-commit existe et est exécutable" {
    $gitDir = & git rev-parse --git-dir 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    $hookPath = Join-Path $gitDir "hooks/pre-commit"
    Test-Path $hookPath
}

# ---- Étape 4 : Le hook pre-commit fonctionne (détecte les TODO) ----
Verifier-Etape 4 "Le hook pre-commit détecte les TODO dans les fichiers" {
    $gitDir = & git rev-parse --git-dir 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    $hookPath = Join-Path $gitDir "hooks/pre-commit"
    if (-not (Test-Path $hookPath)) { return $false }
    $content = Get-Content $hookPath -Raw
    $content -match "TODO"
}

# ---- Étape 5 : Le hook commit-msg existe et est exécutable ----
Verifier-Etape 5 "Le hook commit-msg existe et est exécutable" {
    $gitDir = & git rev-parse --git-dir 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    $hookPath = Join-Path $gitDir "hooks/commit-msg"
    Test-Path $hookPath
}

Afficher-Score
