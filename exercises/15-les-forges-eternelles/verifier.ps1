# =============================================================================
# Quête 15 - Les Forges Éternelles - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\verifier-common.ps1"

$script:QueteTitre = "Quête 15 - Les Forges Éternelles"
Afficher-Banniere $script:QueteTitre

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
Verifier-Etape 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Étape 2 : Au moins un remote est configuré ----
Verifier-Etape 2 "Au moins un remote est configuré" {
    $remotes = & git remote 2>&1
    $LASTEXITCODE -eq 0 -and ($remotes | Measure-Object).Count -ge 1
}

# ---- Étape 3 : Au moins un push a été effectué ----
Verifier-Etape 3 "Au moins un push a été effectué (des refs distantes existent)" {
    $branches = & git branch -r 2>&1
    $LASTEXITCODE -eq 0 -and ($branches | Measure-Object).Count -ge 1
}

# ---- Étape 4 : Au moins 3 commits dans le dépôt ----
Verifier-Etape 4 "Le dépôt contient au moins 3 commits" {
    $count = & git rev-list --count HEAD 2>&1
    $LASTEXITCODE -eq 0 -and ([int]$count -ge 3)
}

Afficher-Score
