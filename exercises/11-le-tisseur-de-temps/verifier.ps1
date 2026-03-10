# =============================================================================
# Quête 11 - Le Tisseur de Temps - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\verifier-common.ps1"

$script:QueteTitre = "Quête 11 - Le Tisseur de Temps"
Afficher-Banniere $script:QueteTitre

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
Verifier-Etape 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Étape 2 : Au moins 2 branches existent ----
Verifier-Etape 2 "Au moins 2 branches existent" {
    $branches = & git branch -a 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($branches | Measure-Object).Count -ge 2
}

# ---- Étape 3 : Le reflog montre une activité de stash ----
Verifier-Etape 3 "Le reflog montre une activité de stash" {
    $stashLog = & git reflog show stash 2>&1
    if ($LASTEXITCODE -eq 0 -and ($stashLog | Measure-Object).Count -ge 1) { return $true }
    $reflog = & git reflog 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($reflog | Where-Object { $_ -match "stash" } | Measure-Object).Count -ge 1
}

# ---- Étape 4 : Au moins 3 commits existent ----
Verifier-Etape 4 "Il y a au moins 3 commits dans l'historique" {
    $commits = & git log --all --oneline 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($commits | Measure-Object).Count -ge 3
}

Afficher-Score
