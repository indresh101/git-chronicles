# =============================================================================
# Quête 17 - Les Épreuves Automatiques - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\verifier-common.ps1"

$script:QueteTitre = "Quête 17 - Les Épreuves Automatiques"
Afficher-Banniere $script:QueteTitre

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
Verifier-Etape 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Étape 2 : Le dossier .github/workflows existe ----
Verifier-Etape 2 "Le dossier .github/workflows existe" {
    Test-Path ".github/workflows" -PathType Container
}

# ---- Étape 3 : Un workflow YAML contient une stratégie de matrice ----
Verifier-Etape 3 "Un workflow contient une stratégie de matrice (matrix)" {
    $fichiers = Get-ChildItem -Path ".github/workflows" -Include "*.yml","*.yaml" -ErrorAction SilentlyContinue
    if (-not $fichiers -or ($fichiers | Measure-Object).Count -eq 0) { return $false }
    foreach ($f in $fichiers) {
        $content = Get-Content $f.FullName -Raw
        if ($content -match "matrix:") { return $true }
    }
    return $false
}

# ---- Étape 4 : Le workflow contient plusieurs étapes (steps) ----
Verifier-Etape 4 "Le workflow contient plusieurs étapes (steps)" {
    $fichiers = Get-ChildItem -Path ".github/workflows" -Include "*.yml","*.yaml" -ErrorAction SilentlyContinue
    if (-not $fichiers -or ($fichiers | Measure-Object).Count -eq 0) { return $false }
    $fichier = $fichiers | Select-Object -First 1
    $content = Get-Content $fichier.FullName -Raw
    $matches = [regex]::Matches($content, "- name:")
    $matches.Count -ge 2
}

# ---- Étape 5 : Au moins un script de test existe ----
Verifier-Etape 5 "Au moins un script de test existe" {
    $testFiles = @()
    $testFiles += Get-ChildItem -Path "." -Filter "test-*.sh" -ErrorAction SilentlyContinue
    $testFiles += Get-ChildItem -Path "." -Filter "test-*.bash" -ErrorAction SilentlyContinue
    if (Test-Path "tests" -PathType Container) {
        $testFiles += Get-ChildItem -Path "tests" -Include "*.sh","*.bash" -ErrorAction SilentlyContinue
    }
    ($testFiles | Measure-Object).Count -ge 1
}

Afficher-Score
