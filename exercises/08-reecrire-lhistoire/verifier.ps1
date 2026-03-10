# =============================================================================
# Quête 08 - Réécrire l'Histoire - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\verifier-common.ps1"

$script:QueteTitre = "Quête 08 - Réécrire l'Histoire"
Afficher-Banniere $script:QueteTitre

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
Verifier-Etape 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Étape 2 : Le reflog contient un amend ----
Verifier-Etape 2 "Tu as utilisé git commit --amend (visible dans le reflog)" {
    $reflog = & git reflog 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($reflog | Out-String) -match "(?i)amend"
}

# ---- Étape 3 : Le reflog contient un rebase ----
Verifier-Etape 3 "Tu as effectué un rebase (visible dans le reflog)" {
    $reflog = & git reflog 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($reflog | Out-String) -match "(?i)rebase"
}

# ---- Étape 4 : Au moins 3 commits existent ----
Verifier-Etape 4 "Au moins 3 commits existent dans l'historique" {
    $count = & git rev-list --count HEAD 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    [int]$count -ge 3
}

Afficher-Score
