#!/usr/bin/env bash
# =============================================================================
# Quête 07 - Le Conflit des Royaumes - Script de préparation de l'archive
# Projet  : Les Chroniques du Versionneur
#
# USAGE   : bash preparer-archive.sh
# RÔLE    : Crée un dépôt Git avec trois branches dont deux créent un conflit,
#           puis l'exporte en bundle distribuable aux élèves.
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

echo "=== Préparation de l'archive pour la Quête 07 ==="
echo "Répertoire temporaire : ${TEMP_DIR}"

# -----------------------------------------------------------------------------
# Initialisation du dépôt
# -----------------------------------------------------------------------------
cd "${TEMP_DIR}"
git init -b main le-conflit-des-royaumes
cd le-conflit-des-royaumes

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
# Construction de l'historique
# -----------------------------------------------------------------------------

# --- Commit 1 : Le Maître Archiviste fonde les chroniques ---
cat > chroniques.txt << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║     CHRONIQUES UNIFIÉES DU ROYAUME - ANNÉE 1024            ║
╚══════════════════════════════════════════════════════════════╝

=== Chapitre I : La Fondation ===

Le Royaume Unifié fut fondé en l'an 800 par le roi Thalion,
qui rassembla les peuples de l'Est et de l'Ouest sous une
même bannière. La paix régna pendant deux siècles.

=== Chapitre II : Les Alliances ===

En l'an 1020, le Conseil des Sages établit des alliances
commerciales entre les provinces. Le Fleuve Doré devint la
principale voie de commerce, reliant l'Est et l'Ouest.

=== Chapitre III : La Bataille du Pont de Pierre ===

En l'an 1023, une bataille décisive eut lieu au Pont de Pierre,
à la frontière entre les provinces de l'Est et de l'Ouest.

[Section en attente - les chroniqueurs sont en mission]

=== Chapitre IV : Les Conséquences ===

Les conséquences de la bataille restent à documenter.
Les chroniqueurs Elowen et Gareth sont attendus sous peu.
EOF

cat > carte-batailles.txt << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║     CARTE DES BATAILLES DU ROYAUME                         ║
╚══════════════════════════════════════════════════════════════╝

Batailles recensées :
  - An 812 : Siège de la Tour Nord (victoire défensive)
  - An 955 : Escarmouche des Collines Grises (indécise)
  - An 1023 : Bataille du Pont de Pierre (en cours de documentation)
EOF

git add chroniques.txt carte-batailles.txt
faire_commit "Maître Archiviste" "archiviste@citadelle.roy" \
    "Fonder les chroniques unifiées du royaume" \
    "2024-06-01 09:00:00 +0100"

# --- Commit 2 : Ajout du registre des témoins ---
cat > temoins.txt << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║     REGISTRE DES TÉMOINS OFFICIELS                          ║
╚══════════════════════════════════════════════════════════════╝

Témoins enregistrés pour la Bataille du Pont de Pierre :
  - Capitaine Roderic (garde royale)
  - Marchande Lysara (présente au pont le jour de la bataille)
  - Mage Thandril (observateur depuis la Tour de Guet)
EOF

git add temoins.txt
faire_commit "Maître Archiviste" "archiviste@citadelle.roy" \
    "Ajouter le registre des témoins officiels" \
    "2024-06-02 10:00:00 +0100"

# =============================================================================
# Branche chroniques-ouest (Gareth - merge propre, pas de conflit)
# =============================================================================
git branch chroniques-ouest

# =============================================================================
# Branche chroniques-est (Elowen - va créer un conflit)
# =============================================================================
git branch chroniques-est

# --- Continuer sur main : ajouter une note neutre ---
cat >> carte-batailles.txt << 'EOF'

Notes cartographiques :
  - Le Pont de Pierre enjambe le Fleuve Doré au point le plus étroit
  - Accès par la Route Royale depuis les deux provinces
  - Position stratégique : contrôle le commerce fluvial
EOF

git add carte-batailles.txt
faire_commit "Maître Archiviste" "archiviste@citadelle.roy" \
    "Ajouter des notes cartographiques sur le Pont de Pierre" \
    "2024-06-03 11:00:00 +0100"

# =============================================================================
# Commits sur chroniques-ouest (Gareth)
# Gareth ajoute un NOUVEAU fichier + modifie carte-batailles.txt
# PAS de modification de la section conflit dans chroniques.txt
# =============================================================================
git switch chroniques-ouest

# Gareth ajoute son rapport de mission
cat > rapport-ouest.txt << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║     RAPPORT DE MISSION - GARETH, CHRONIQUEUR DE L'OUEST    ║
╚══════════════════════════════════════════════════════════════╝

Date de départ : 1er jour de la Lune de Feu, an 1024
Destination : Province de l'Ouest, Royaume du Couchant

Observations :
  - Les habitants de l'Ouest considèrent la bataille comme une victoire.
  - Le commerce a repris normalement sur le Fleuve Doré.
  - Le Pont de Pierre a été réparé et renforcé.
  - Les soldats de l'Ouest parlent avec fierté de leur résistance.

Artefacts collectés :
  - 3 témoignages écrits de soldats
  - 1 carte tactique dessinée par le Capitaine Roderic
  - 2 ballades composées par les bardes locaux

Retour prévu : 15ème jour de la Lune de Moisson
EOF

git add rapport-ouest.txt
faire_commit "Gareth le Chroniqueur" "gareth@citadelle.roy" \
    "Ajouter le rapport de mission de l'Ouest" \
    "2024-06-10 14:00:00 +0100"

# Gareth écrit sa version de la bataille (modifie chroniques.txt)
sed -i 's/\[Section en attente - les chroniqueurs sont en mission\]/La bataille du Pont de Pierre opposa les garnisons de l'\''Est et de l'\''Ouest\ndans un différend territorial sur le contrôle du passage fluvial.\n\nSelon les témoins de l'\''Ouest, le Capitaine Roderic mena une défense\nhéroïque du pont. Ses 200 soldats tinrent la position pendant trois\njours face à 500 assaillants venus de l'\''Est. La cavalerie de l'\''Ouest\nchargea à l'\''aube du troisième jour, forçant la retraite de l'\''ennemi.\n\nLe Pont de Pierre fut endommagé mais tint bon. Les pertes furent\nlégères du côté de l'\''Ouest (30 blessés, aucun mort) et modérées\ndu côté de l'\''Est (environ 50 blessés, 5 disparus)./' chroniques.txt

git add chroniques.txt
faire_commit "Gareth le Chroniqueur" "gareth@citadelle.roy" \
    "Rédiger le récit de la Bataille du Pont de Pierre (version Ouest)" \
    "2024-06-12 16:00:00 +0100"

# =============================================================================
# Commits sur chroniques-est (Elowen)
# Elowen modifie la MÊME section de chroniques.txt -> CONFLIT garanti
# =============================================================================
git switch chroniques-est

# Elowen ajoute son rapport de mission
cat > rapport-est.txt << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║     RAPPORT DE MISSION - ELOWEN, CHRONIQUEUSE DE L'EST     ║
╚══════════════════════════════════════════════════════════════╝

Date de départ : 1er jour de la Lune de Feu, an 1024
Destination : Province de l'Est, Royaume de l'Aurore

Observations :
  - Les habitants de l'Est considèrent la bataille comme injuste.
  - Le commerce a été perturbé pendant plusieurs mois.
  - Le Pont de Pierre porte encore les marques des combats.
  - Les soldats de l'Est parlent d'une embuscade déloyale.

Artefacts collectés :
  - 5 témoignages écrits de civils et de soldats
  - 1 journal de campagne du Commandant Selene
  - 1 fragment du parapet du pont (preuve des dégâts)

Retour prévu : 20ème jour de la Lune de Moisson
EOF

git add rapport-est.txt
faire_commit "Elowen la Chroniqueuse" "elowen@citadelle.roy" \
    "Ajouter le rapport de mission de l'Est" \
    "2024-06-11 15:00:00 +0100"

# Elowen écrit SA version de la bataille (même section -> conflit !)
sed -i 's/\[Section en attente - les chroniqueurs sont en mission\]/La bataille du Pont de Pierre éclata quand les forces de l'\''Ouest\ntentèrent de prendre le contrôle exclusif du passage fluvial,\nviolant les accords commerciaux de l'\''an 1020.\n\nSelon les témoins de l'\''Est, le Commandant Selene organisa une\ndéfense désespérée face à une attaque surprise à l'\''aube. Ses\n150 soldats résistèrent avec courage pendant deux jours avant\nde recevoir des renforts. La contre-attaque de l'\''Est repoussa\nfinalement les forces de l'\''Ouest au-delà du pont.\n\nLe Pont de Pierre fut gravement endommagé. Les pertes furent\nlourdes des deux côtés : environ 40 blessés et 3 morts à l'\''Est,\net des pertes similaires à l'\''Ouest selon les estimations./' chroniques.txt

git add chroniques.txt
faire_commit "Elowen la Chroniqueuse" "elowen@citadelle.roy" \
    "Rédiger le récit de la Bataille du Pont de Pierre (version Est)" \
    "2024-06-13 10:00:00 +0100"

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

# -----------------------------------------------------------------------------
# Export en bundle
# -----------------------------------------------------------------------------
git bundle create "${BUNDLE_DEST}" --all
echo ""
echo "=== Bundle créé : ${BUNDLE_DEST} ==="
ls -lh "${BUNDLE_DEST}"
echo ""
echo "Les élèves pourront cloner avec :"
echo "  git clone archive.bundle le-conflit-des-royaumes"
echo ""
echo "Scénario prévu :"
echo "  1. git switch main && git merge chroniques-ouest  -> merge propre"
echo "  2. git merge chroniques-est                       -> CONFLIT sur chroniques.txt"
echo "  3. L'élève résout le conflit manuellement"
echo ""
echo "Terminé !"
