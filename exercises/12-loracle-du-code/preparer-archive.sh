#!/usr/bin/env bash
# =============================================================================
# Quête 12 - L'Oracle du Code - Script de préparation de l'archive
# Projet  : Les Chroniques du Versionneur
#
# USAGE   : bash preparer-archive.sh
# RÔLE    : Crée un dépôt Git avec ~10 commits dont un introduit un "bug"
#           (le mot CORROMPU dans grimoire.txt), plus une branche "correctif"
#           avec le fix. Exporte le tout en bundle.
#
# CE SCRIPT EST RÉSERVÉ AU FORMATEUR - il n'est pas distribué aux élèves.
# Idempotent : peut être relancé sans risque.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUNDLE_NAME="archive.bundle"
BUNDLE_DEST="${SCRIPT_DIR}/${BUNDLE_NAME}"
TEMP_DIR="$(mktemp -d)"

# Nettoyage automatique du répertoire temporaire
cleanup() {
    rm -rf "${TEMP_DIR}"
}
trap cleanup EXIT

echo "=== Préparation de l'archive pour la Quête 12 ==="
echo "Répertoire temporaire : ${TEMP_DIR}"

# -----------------------------------------------------------------------------
# Initialisation du dépôt
# -----------------------------------------------------------------------------
cd "${TEMP_DIR}"
git init -b main loracle-du-code
cd loracle-du-code

# Désactiver les éventuels hooks et configs globales qui pourraient interférer
git config commit.gpgsign false

# -----------------------------------------------------------------------------
# Fonction utilitaire : commit avec auteur et date personnalisés
# -----------------------------------------------------------------------------
faire_commit() {
    local auteur="$1"
    local email="$2"
    local message="$3"
    local date="$4"

    GIT_AUTHOR_NAME="${auteur}" \
    GIT_AUTHOR_EMAIL="${email}" \
    GIT_COMMITTER_NAME="${auteur}" \
    GIT_COMMITTER_EMAIL="${email}" \
    GIT_AUTHOR_DATE="${date}" \
    GIT_COMMITTER_DATE="${date}" \
    git commit -m "${message}"
}

# -----------------------------------------------------------------------------
# Construction de l'historique - 10 commits sur main
# Le commit 6 introduit le bug (mot CORROMPU dans une formule)
# -----------------------------------------------------------------------------

# --- Commit 1 : Fondation du grimoire ---
cat > grimoire.txt << 'EOF'
+=====================================================+
|     GRIMOIRE DES SORTILEGES DU ROYAUME              |
|     Compilé par les Mages de la Tour Blanche         |
+=====================================================+

=== Chapitre I : Sortilèges de Protection ===

Formule 001 - Bouclier de Lumière
  Incantation : "Lux Protego Aeternum"
  Effet : Crée une barrière lumineuse impénétrable
  Durée : 1 heure
  Difficulté : Intermédiaire
EOF

cat > index-formules.txt << 'EOF'
+=====================================================+
|     INDEX DES FORMULES MAGIQUES                      |
+=====================================================+

001 - Bouclier de Lumière (Protection)
EOF

git add grimoire.txt index-formules.txt
faire_commit "Archimède le Mage" "archimede@tour-blanche.roy" \
    "Fonder le Grimoire des Sortilèges" \
    "2024-03-01 09:00:00 +0100"

# --- Commit 2 : Ajout d'un sort de guérison ---
cat >> grimoire.txt << 'EOF'

Formule 002 - Souffle de Guérison
  Incantation : "Sano Vitalis Corpus"
  Effet : Soigne les blessures légères à modérées
  Durée : Instantané
  Difficulté : Facile
EOF

sed -i '/^001/a 002 - Souffle de Guérison (Guérison)' index-formules.txt

git add grimoire.txt index-formules.txt
faire_commit "Séraphine la Guérisseuse" "seraphine@tour-blanche.roy" \
    "Ajouter le sort de Souffle de Guérison" \
    "2024-03-03 10:30:00 +0100"

# --- Commit 3 : Ajout d'un sort de feu ---
cat >> grimoire.txt << 'EOF'

Formule 003 - Lance de Feu
  Incantation : "Ignis Hasta Volantis"
  Effet : Projette une lance de feu à haute vélocité
  Durée : Instantané
  Difficulté : Avancée
EOF

sed -i '/^002/a 003 - Lance de Feu (Combat)' index-formules.txt

git add grimoire.txt index-formules.txt
faire_commit "Voltar le Pyromancien" "voltar@tour-blanche.roy" \
    "Ajouter le sort de Lance de Feu" \
    "2024-03-05 14:00:00 +0100"

# --- Commit 4 : Ajout d'un chapitre sur les sortilèges de divination ---
cat >> grimoire.txt << 'EOF'

=== Chapitre II : Sortilèges de Divination ===

Formule 004 - Oeil du Voyant
  Incantation : "Oculus Futuri Revelum"
  Effet : Permet de voir les événements récents d'un lieu
  Durée : 10 minutes
  Difficulté : Avancée
EOF

sed -i '/^003/a 004 - Oeil du Voyant (Divination)' index-formules.txt

git add grimoire.txt index-formules.txt
faire_commit "Oracle Thandril" "thandril@tour-blanche.roy" \
    "Ajouter le chapitre de Divination et l'Oeil du Voyant" \
    "2024-03-08 09:00:00 +0100"

# --- Commit 5 : Ajout d'un sort de téléportation ---
cat >> grimoire.txt << 'EOF'

Formule 005 - Pas de l'Ombre
  Incantation : "Umbra Transitum Spatii"
  Effet : Téléporte le lanceur sur une courte distance
  Durée : Instantané
  Difficulté : Expert
EOF

sed -i '/^004/a 005 - Pas de l'\''Ombre (Déplacement)' index-formules.txt

git add grimoire.txt index-formules.txt
faire_commit "Nyx la Vagabonde" "nyx@tour-blanche.roy" \
    "Ajouter le sort de Pas de l'Ombre" \
    "2024-03-10 11:00:00 +0100"

# --- Commit 6 : LE BUG - corruption d'une formule ---
# On corrompt la formule 003 (Lance de Feu) en remplaçant l'incantation
sed -i 's/Ignis Hasta Volantis/CORROMPU - Ignis Hasta Corruptus/' grimoire.txt

# On ajoute aussi un sort légitime pour masquer le bug
cat >> grimoire.txt << 'EOF'

Formule 006 - Mur de Givre
  Incantation : "Glacies Murus Fortis"
  Effet : Érige un mur de glace solide
  Durée : 30 minutes
  Difficulté : Intermédiaire
EOF

sed -i '/^005/a 006 - Mur de Givre (Défense)' index-formules.txt

git add grimoire.txt index-formules.txt
faire_commit "Korvin le Suspect" "korvin@tour-blanche.roy" \
    "Ajouter le sort de Mur de Givre et corrections mineures" \
    "2024-03-12 16:00:00 +0100"

# --- Commit 7 : Ajout d'un sort de communication ---
cat >> grimoire.txt << 'EOF'

=== Chapitre III : Sortilèges Utilitaires ===

Formule 007 - Murmure du Vent
  Incantation : "Ventus Verbum Portare"
  Effet : Transmet un message à une personne éloignée
  Durée : Jusqu'à réception
  Difficulté : Facile
EOF

sed -i '/^006/a 007 - Murmure du Vent (Communication)' index-formules.txt

git add grimoire.txt index-formules.txt
faire_commit "Séraphine la Guérisseuse" "seraphine@tour-blanche.roy" \
    "Ajouter le sort de Murmure du Vent" \
    "2024-03-15 10:00:00 +0100"

# --- Commit 8 : Ajout d'un sort d'invisibilité ---
cat >> grimoire.txt << 'EOF'

Formule 008 - Voile d'Invisibilité
  Incantation : "Invisibilis Corpus Totum"
  Effet : Rend le lanceur invisible pendant une courte durée
  Durée : 5 minutes
  Difficulté : Expert
EOF

sed -i '/^007/a 008 - Voile d'\''Invisibilité (Furtivité)' index-formules.txt

git add grimoire.txt index-formules.txt
faire_commit "Nyx la Vagabonde" "nyx@tour-blanche.roy" \
    "Ajouter le sort de Voile d'Invisibilité" \
    "2024-03-18 14:30:00 +0100"

# --- Commit 9 : Ajout d'un sort de lévitation ---
cat >> grimoire.txt << 'EOF'

Formule 009 - Plume de Lévitation
  Incantation : "Levis Corpus Ascendens"
  Effet : Fait léviter une personne ou un objet
  Durée : 15 minutes
  Difficulté : Intermédiaire
EOF

sed -i '/^008/a 009 - Plume de Lévitation (Déplacement)' index-formules.txt

git add grimoire.txt index-formules.txt
faire_commit "Archimède le Mage" "archimede@tour-blanche.roy" \
    "Ajouter le sort de Plume de Lévitation" \
    "2024-03-20 09:00:00 +0100"

# --- Commit 10 : Ajout d'un sort de lumière et note finale ---
cat >> grimoire.txt << 'EOF'

Formule 010 - Sphère de Lumière
  Incantation : "Lux Orbis Perpetuus"
  Effet : Crée une sphère lumineuse qui suit le lanceur
  Durée : 8 heures
  Difficulté : Facile

+=====================================================+
|     FIN DU GRIMOIRE - 10 FORMULES RECENSEES          |
+=====================================================+
EOF

sed -i '/^009/a 010 - Sphère de Lumière (Utilitaire)' index-formules.txt

git add grimoire.txt index-formules.txt
faire_commit "Oracle Thandril" "thandril@tour-blanche.roy" \
    "Ajouter la Sphère de Lumière et finaliser le grimoire" \
    "2024-03-22 16:00:00 +0100"

# =============================================================================
# Branche correctif - contient le fix pour la formule corrompue
# On la crée depuis main pour que l'élève puisse cherry-pick le commit
# =============================================================================
git branch correctif
git switch correctif

# Le correctif restaure la formule originale
sed -i 's/CORROMPU - Ignis Hasta Corruptus/Ignis Hasta Volantis/' grimoire.txt

git add grimoire.txt
faire_commit "Archimède le Mage" "archimede@tour-blanche.roy" \
    "Corriger la formule corrompue de la Lance de Feu" \
    "2024-03-23 10:00:00 +0100"

# =============================================================================
# Revenir sur main
# =============================================================================
git switch main

# -----------------------------------------------------------------------------
# Vérification de l'historique
# -----------------------------------------------------------------------------
echo ""
echo "=== Historique créé ==="
git log --oneline --all --graph
echo ""
echo "Branches :"
git branch -a
echo ""
echo "Nombre de commits sur main : $(git rev-list --count HEAD)"
echo ""
echo "Vérification du bug :"
grep "CORROMPU" grimoire.txt && echo "  -> Bug présent sur main (OK)" || echo "  -> ERREUR : bug absent de main"
echo ""

# -----------------------------------------------------------------------------
# Export en bundle
# -----------------------------------------------------------------------------
git bundle create "${BUNDLE_DEST}" --all
echo ""
echo "=== Bundle créé : ${BUNDLE_DEST} ==="
ls -lh "${BUNDLE_DEST}"
echo ""
echo "Les élèves pourront cloner avec :"
echo "  git clone archive.bundle loracle-du-code"
echo ""
echo "Scénario prévu :"
echo "  1. git blame grimoire.txt               -> examiner les auteurs"
echo "  2. git bisect start/bad/good             -> trouver le commit du bug"
echo "  3. git cherry-pick <hash-du-correctif>   -> appliquer le fix depuis la branche correctif"
echo ""
echo "Terminé !"
