# =============================================================================
# Quête 09 - Les Portails Distants - Script de vérification
# Projet  : Les Chroniques du Versionneur
#
# Usage   : .\verifier.ps1
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\verifier-common.ps1"

$script:QueteTitre = "Quête 09 - Les Portails Distants"
Afficher-Banniere $script:QueteTitre

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
Verifier-Etape 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Étape 2 : Au moins un remote est configuré ----
Verifier-Etape 2 "Au moins un remote est configuré" {
    $remotes = & git remote 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    $lines = ($remotes | Measure-Object -Line).Lines
    $lines -ge 1
}

# ---- Étape 3 : Un push a été effectué ----
Verifier-Etape 3 "Tu as poussé au moins une fois vers un remote" {
    # Vérifie l'existence de refs de suivi distant
    $refs = & git for-each-ref refs/remotes --format="%(refname)" 2>&1
    if ($LASTEXITCODE -eq 0 -and $refs) { return $true }
    # Alternative : chercher dans le reflog
    $reflog = & git reflog show --all 2>&1
    if ($reflog -match "push") { return $true }
    return $false
}

# ---- Étape 4 : Un fetch ou pull a été effectué ----
Verifier-Etape 4 "Tu as récupéré des changements depuis un remote" {
    # Cherche des traces de fetch/pull dans le reflog
    $reflog = & git reflog show --all 2>&1
    if ($reflog -match "fetch|pull") { return $true }
    # Alternative : plus de commits sur les branches distantes que locales
    $allCount = (& git log --all --oneline 2>&1 | Measure-Object -Line).Lines
    $localCount = (& git log --oneline 2>&1 | Measure-Object -Line).Lines
    if ($allCount -gt $localCount) { return $true }
    return $false
}

Afficher-Score
