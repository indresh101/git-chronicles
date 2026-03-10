# =============================================================================
# Quête 13 - Les Sceaux Magiques - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\verifier-common.ps1"

$script:QueteTitre = "Quête 13 - Les Sceaux Magiques"
Afficher-Banniere $script:QueteTitre

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
Verifier-Etape 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Étape 2 : Au moins 2 tags existent ----
Verifier-Etape 2 "Au moins 2 tags existent" {
    $tags = & git tag 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($tags | Measure-Object).Count -ge 2
}

# ---- Étape 3 : Au moins un tag annoté existe ----
Verifier-Etape 3 "Au moins un tag annoté existe" {
    $tags = & git tag 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    $found = $false
    foreach ($t in $tags) {
        $tagType = & git cat-file -t $t.Trim() 2>&1
        if ($LASTEXITCODE -eq 0 -and $tagType.Trim() -eq "tag") {
            $found = $true
            break
        }
    }
    $found
}

# ---- Étape 4 : Les tags suivent le format de versionnage (v*) ----
Verifier-Etape 4 "Les tags suivent le format de versionnage (v*)" {
    $tags = & git tag 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    $found = $false
    foreach ($t in $tags) {
        if ($t.Trim() -match "^v\d+\.\d+\.\d+$") {
            $found = $true
            break
        }
    }
    $found
}

Afficher-Score
