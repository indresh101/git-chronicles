# =============================================================================
# Quête 10 - Le Protocole des Guildes - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\verifier-common.ps1"

$script:QueteTitre = "Quête 10 - Le Protocole des Guildes"
Afficher-Banniere $script:QueteTitre

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
Verifier-Etape 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Étape 2 : La branche main/master existe ----
Verifier-Etape 2 "La branche principale (main ou master) existe" {
    $branches = & git branch --list main master 2>&1
    $LASTEXITCODE -eq 0 -and ($branches -match "main|master")
}

# ---- Étape 3 : Au moins 3 commits au total ----
Verifier-Etape 3 "Il y a au moins 3 commits dans l'historique" {
    $commits = & git log --oneline 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($commits | Measure-Object).Count -ge 3
}

# ---- Étape 4 : Un commit de merge existe (preuve du --no-ff) ----
Verifier-Etape 4 "Un commit de merge existe (Protocole respecté)" {
    $merges = & git log --merges --oneline 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($merges | Measure-Object).Count -ge 1
}

# ---- Étape 5 : Pas de branche de proposition restante (nettoyée) ----
Verifier-Etape 5 "La branche de proposition a été nettoyée" {
    $branches = & git branch 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    $nonMain = $branches | Where-Object { $_ -notmatch "main|master|\*" -and $_.Trim() -ne "" }
    ($nonMain | Measure-Object).Count -eq 0
}

Afficher-Score
