# =============================================================================
# Quête 16 - Les Actions du Royaume - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\verifier-common.ps1"

$script:QueteTitre = "Quête 16 - Les Actions du Royaume"
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

# ---- Étape 3 : Au moins un fichier .yml existe dans .github/workflows ----
Verifier-Etape 3 "Au moins un fichier .yml existe dans .github/workflows" {
    if (-not (Test-Path ".github/workflows")) { return $false }
    $files = Get-ChildItem ".github/workflows" -Filter "*.yml" -ErrorAction SilentlyContinue
    if (-not $files) {
        $files = Get-ChildItem ".github/workflows" -Filter "*.yaml" -ErrorAction SilentlyContinue
    }
    ($files | Measure-Object).Count -ge 1
}

# ---- Étape 4 : Le fichier YAML contient le mot-clé "name:" ----
Verifier-Etape 4 "Le workflow contient le mot-clé 'name:'" {
    if (-not (Test-Path ".github/workflows")) { return $false }
    $files = Get-ChildItem ".github/workflows" -Include "*.yml","*.yaml" -ErrorAction SilentlyContinue
    if (-not $files) { return $false }
    foreach ($f in $files) {
        $content = Get-Content $f.FullName -Raw
        if ($content -match "(?m)^name:") { return $true }
    }
    $false
}

# ---- Étape 5 : Le fichier YAML contient le mot-clé "on:" ----
Verifier-Etape 5 "Le workflow contient le mot-clé 'on:'" {
    if (-not (Test-Path ".github/workflows")) { return $false }
    $files = Get-ChildItem ".github/workflows" -Include "*.yml","*.yaml" -ErrorAction SilentlyContinue
    if (-not $files) { return $false }
    foreach ($f in $files) {
        $content = Get-Content $f.FullName -Raw
        if ($content -match "(?m)^on:") { return $true }
    }
    $false
}

# ---- Étape 6 : Le fichier YAML contient le mot-clé "jobs:" ----
Verifier-Etape 6 "Le workflow contient le mot-clé 'jobs:'" {
    if (-not (Test-Path ".github/workflows")) { return $false }
    $files = Get-ChildItem ".github/workflows" -Include "*.yml","*.yaml" -ErrorAction SilentlyContinue
    if (-not $files) { return $false }
    foreach ($f in $files) {
        $content = Get-Content $f.FullName -Raw
        if ($content -match "(?m)^jobs:") { return $true }
    }
    $false
}

Afficher-Score
