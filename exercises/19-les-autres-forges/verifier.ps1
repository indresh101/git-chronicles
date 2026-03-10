# =============================================================================
# Quête 19 - Les Autres Forges - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\verifier-common.ps1"

$script:QueteTitre = "Quête 19 - Les Autres Forges"
Afficher-Banniere $script:QueteTitre

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
Verifier-Etape 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Étape 2 : Le fichier GitHub Actions existe ----
Verifier-Etape 2 "Le fichier .github/workflows/ci.yml existe" {
    $files = Get-ChildItem -Path ".github/workflows" -Filter "*.yml" -ErrorAction SilentlyContinue
    $null -ne $files -and ($files | Measure-Object).Count -ge 1
}

# ---- Étape 3 : Le fichier GitLab CI existe ----
Verifier-Etape 3 "Le fichier .gitlab-ci.yml existe" {
    Test-Path ".gitlab-ci.yml"
}

# ---- Étape 4 : Le fichier Bitbucket Pipelines existe ----
Verifier-Etape 4 "Le fichier bitbucket-pipelines.yml existe" {
    Test-Path "bitbucket-pipelines.yml"
}

# ---- Étape 5 : Le script de test existe ----
Verifier-Etape 5 "Le script de test scripts/test.sh existe" {
    Test-Path "scripts/test.sh"
}

# ---- Étape 6 : Au moins un commit a été créé ----
Verifier-Etape 6 "Au moins un commit a été créé" {
    $result = & git log --oneline -1 2>&1
    $LASTEXITCODE -eq 0
}

Afficher-Score
