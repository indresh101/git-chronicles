# =============================================================================
# Quête 05 - Les Lignes du Temps - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\verifier-common.ps1"

$script:QueteTitre = "Quête 05 - Les Lignes du Temps"
Afficher-Banniere $script:QueteTitre

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
Verifier-Etape 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Étape 2 : Le .gitignore existe ----
Verifier-Etape 2 "Le fichier .gitignore existe" {
    Test-Path ".gitignore"
}

# ---- Étape 3 : Le .gitignore contient un pattern pour les .log ----
Verifier-Etape 3 "Le .gitignore ignore les fichiers .log" {
    if (-not (Test-Path ".gitignore")) { return $false }
    $contenu = Get-Content ".gitignore" -Raw
    $contenu -match '\*\.log' -or $contenu -match 'debug\.log'
}

# ---- Étape 4 : debug.log n'est plus tracké ----
Verifier-Etape 4 "debug.log n'est plus suivi par Git" {
    & git ls-files --error-unmatch "debug.log" 2>&1 | Out-Null
    $LASTEXITCODE -ne 0
}

# ---- Étape 5 : Le dernier commit a un message d'au moins 10 caractères ----
Verifier-Etape 5 "Le dernier commit a un message descriptif (>= 10 caractères)" {
    $msg = & git log -1 --format="%s" 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    $msg.Length -ge 10
}

Afficher-Score
