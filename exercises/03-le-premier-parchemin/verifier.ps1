# =============================================================================
# Quête 03 - Le Premier Parchemin - Script de vérification (PowerShell)
# Projet  : Les Chroniques du Versionneur
#
# Usage   : Lancer DEPUIS le dossier mon-archive/
#           ..\verifier.ps1
# =============================================================================

. "$PSScriptRoot\..\..\lib\verifier-common.ps1"

$script:QueteTitre = "Quête 03 - Le Premier Parchemin"
Afficher-Banniere -Titre $script:QueteTitre

# --- Étape 1 : On est dans un dépôt git ---
Verifier-Etape -Numero 1 -Description "Tu es dans un dépôt Git" -CommandeTest {
    Verifier-DansRepo
}

# --- Étape 2 : Au moins 2 commits ---
Verifier-Etape -Numero 2 -Description "Tu as au moins 2 commits" -CommandeTest {
    $count = & git rev-list --count HEAD 2>$null
    if ($LASTEXITCODE -ne 0) { return $false }
    return ([int]$count -ge 2)
}

# --- Étape 3 : mission.txt est tracké ---
Verifier-Etape -Numero 3 -Description "Le fichier mission.txt est suivi par Git" -CommandeTest {
    & git ls-files --error-unmatch mission.txt 2>$null | Out-Null
    return ($LASTEXITCODE -eq 0)
}

# --- Étape 4 : Le premier message de commit n'est pas générique ---
Verifier-Etape -Numero 4 -Description "Ton premier commit a un message personnalisé" -CommandeTest {
    $premierMsg = (& git log --reverse --format="%s" 2>$null) | Select-Object -First 1
    if ([string]::IsNullOrWhiteSpace($premierMsg)) { return $false }
    $generiques = @("Initial commit", "initial commit", "first commit", "init")
    if ($generiques -contains $premierMsg.Trim()) { return $false }
    return $true
}

Afficher-Score
