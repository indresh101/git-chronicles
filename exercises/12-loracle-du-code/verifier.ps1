# =============================================================================
# Quête 12 - L'Oracle du Code - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\verifier-common.ps1"

$script:QueteTitre = "Quête 12 - L'Oracle du Code"
Afficher-Banniere $script:QueteTitre

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
Verifier-Etape 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Étape 2 : git bisect a été utilisé ----
# bisect laisse des traces dans le reflog : checkouts multiples entre hashes
# détachés (typique d'une recherche binaire).
Verifier-Etape 2 "git bisect a été utilisé (trace dans le reflog)" {
    $reflog = & git reflog 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    $reflogText = $reflog | Out-String
    $matches = [regex]::Matches($reflogText, "checkout: moving from [0-9a-f]{7,} to [0-9a-f]{7,}")
    $matches.Count -ge 2
}

# ---- Étape 3 : git cherry-pick a été utilisé (trace dans le reflog) ----
Verifier-Etape 3 "git cherry-pick a été utilisé (trace dans le reflog)" {
    $reflog = & git reflog 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($reflog | Out-String) -match "cherry-pick"
}

# ---- Étape 4 : Le grimoire ne contient plus le mot CORROMPU ----
Verifier-Etape 4 "Le grimoire ne contient plus le mot CORROMPU" {
    if (-not (Test-Path "grimoire.txt")) { return $false }
    $contenu = Get-Content "grimoire.txt" -Raw -ErrorAction SilentlyContinue
    -not ($contenu -match "CORROMPU")
}

Afficher-Score
