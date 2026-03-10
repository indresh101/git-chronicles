# =============================================================================
# verifier.ps1 - Quête 02 : Les Trois Salles du Savoir
# Projet  : Les Chroniques du Versionneur
# Vérifie que l'apprenti a bien compris le flux Working Dir → Staging Area
# =============================================================================

# Chargement des fonctions communes
. "$PSScriptRoot\..\..\lib\verifier-common.ps1"

# Titre de la quête
$script:QueteTitre = "Quête 02 - Les Trois Salles du Savoir"
Afficher-Banniere -Titre $script:QueteTitre

# ── Étape 1 : On est dans un dépôt git ──────────────────────────────────────
Verifier-Etape -Numero 1 `
    -Description "Tu te trouves dans un dépôt git (git init a été fait)" `
    -CommandeTest {
        $result = & git rev-parse --is-inside-work-tree 2>&1
        return ($LASTEXITCODE -eq 0)
    }

# ── Étape 2 : Le fichier parchemin.txt existe ───────────────────────────────
Verifier-Etape -Numero 2 `
    -Description "Le fichier parchemin.txt existe dans la Salle de Travail" `
    -CommandeTest {
        return (Test-Path "parchemin.txt")
    }

# ── Étape 3 : parchemin.txt est dans le staging area ────────────────────────
Verifier-Etape -Numero 3 `
    -Description "parchemin.txt est dans la Salle de Préparation (staging area)" `
    -CommandeTest {
        $staged = & git diff --cached --name-only 2>&1
        return ($staged -match "parchemin\.txt")
    }

# ── Étape 4 : Pas encore de commit (pas de HEAD valide) ─────────────────────
Verifier-Etape -Numero 4 `
    -Description "Aucun parchemin n'a encore été scellé (pas de commit)" `
    -CommandeTest {
        & git rev-parse HEAD 2>&1 | Out-Null
        return ($LASTEXITCODE -ne 0)
    }

# ── Score final ──────────────────────────────────────────────────────────────
Afficher-Score
