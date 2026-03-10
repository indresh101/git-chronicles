# =============================================================================
# Quête 06 - L'Arbre des Possibles - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\verifier-common.ps1"

$script:QueteTitre = "Quête 06 - L'Arbre des Possibles"
Afficher-Banniere $script:QueteTitre

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
Verifier-Etape 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Étape 2 : La branche expedition-nord existe ----
Verifier-Etape 2 "La branche expedition-nord existe" {
    $branches = & git branch --list expedition-nord 2>&1
    $LASTEXITCODE -eq 0 -and $branches -match "expedition-nord"
}

# ---- Étape 3 : La branche expedition-sud existe ----
Verifier-Etape 3 "La branche expedition-sud existe" {
    $branches = & git branch --list expedition-sud 2>&1
    $LASTEXITCODE -eq 0 -and $branches -match "expedition-sud"
}

# ---- Étape 4 : expedition-nord a au moins un commit propre ----
Verifier-Etape 4 "La branche expedition-nord contient un commit propre" {
    $commits = & git log main..expedition-nord --oneline 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($commits | Measure-Object -Line).Lines -ge 1
}

# ---- Étape 5 : expedition-sud a au moins un commit propre ----
Verifier-Etape 5 "La branche expedition-sud contient un commit propre" {
    $commits = & git log main..expedition-sud --oneline 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($commits | Measure-Object -Line).Lines -ge 1
}

# ---- Étape 6 : Au moins 3 branches au total ----
Verifier-Etape 6 "Il y a au moins 3 branches" {
    $branches = & git branch 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($branches | Measure-Object).Count -ge 3
}

Afficher-Score
