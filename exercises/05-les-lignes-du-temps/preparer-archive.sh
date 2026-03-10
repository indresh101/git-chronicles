#!/usr/bin/env bash
# =============================================================================
# Quête 05 - Les Lignes du Temps - Script de préparation de l'archive
# Projet  : Les Chroniques du Versionneur
#
# USAGE   : bash preparer-archive.sh
# RÔLE    : Crée un dépôt Git thématisé avec un historique riche, puis
#           l'exporte en bundle distribuable aux élèves.
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

echo "=== Préparation de l'archive pour la Quête 05 ==="
echo "Répertoire temporaire : ${TEMP_DIR}"

# -----------------------------------------------------------------------------
# Initialisation du dépôt
# -----------------------------------------------------------------------------
cd "${TEMP_DIR}"
git init les-archives-du-royaume
cd les-archives-du-royaume

# Désactiver les éventuels hooks et configs globales qui pourraient interférer
git config commit.gpgsign false

# -----------------------------------------------------------------------------
# Fonction utilitaire : commit avec auteur et date personnalisés
# -----------------------------------------------------------------------------
# Usage : faire_commit "Auteur" "email" "message" "date"
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
# Construction de l'historique - 18 commits racontant l'histoire des archives
# -----------------------------------------------------------------------------

# --- Commit 1 : Aldric fonde les archives ---
cat > registre.txt << 'EOF'
╔══════════════════════════════════════════════╗
║   REGISTRE DES CRÉATURES DU ROYAUME         ║
╚══════════════════════════════════════════════╝

Entrée 001 - Griffon des Hautes Tours
  Habitat : Sommets de la Citadelle
  Dangerosité : Modérée
  Notes : Créature loyale, utilisée comme monture par les éclaireurs.
EOF
git add registre.txt
faire_commit "Aldric le Scribe" "aldric@citadelle.roy" \
    "Ajouter le registre des créatures du nord" \
    "2024-01-15 09:00:00 +0100"

# --- Commit 2 : Aldric ajoute la carte ---
cat > carte.txt << 'EOF'
╔══════════════════════════════════════════════╗
║         CARTE DES FRONTIÈRES DU ROYAUME      ║
╚══════════════════════════════════════════════╝

NORD  : Montagnes de Givre - col gardé par les Sentinelles
SUD   : Forêt de Brumesombre - frontière naturelle
EST   : Fleuve Doré - commerce avec les Terres Libres
OUEST : Côte des Naufrages - ports de la Guilde Marchande
EOF
git add carte.txt
faire_commit "Aldric le Scribe" "aldric@citadelle.roy" \
    "Ajouter la carte des frontières du royaume" \
    "2024-01-16 10:30:00 +0100"

# --- Commit 3 : Elara commence l'inventaire ---
cat > inventaire.txt << 'EOF'
╔══════════════════════════════════════════════╗
║     INVENTAIRE DES ARTEFACTS MAGIQUES        ║
╚══════════════════════════════════════════════╝

001 - Amulette de Clairvoyance
  Localisation : Coffre-fort du Conseil
  Pouvoir : Vision à travers les murs
  État : Fonctionnel

002 - Bâton de Givre
  Localisation : Armurerie royale
  Pouvoir : Projette un souffle glacé
  État : Fissuré - à réparer
EOF
git add inventaire.txt
faire_commit "Elara la Sage" "elara@citadelle.roy" \
    "Créer l'inventaire des artefacts magiques" \
    "2024-01-18 14:15:00 +0100"

# --- Commit 4 : Thorin - mauvais message ---
cat > journal.txt << 'EOF'
Journal de bord des Archives - Année 1024

Jour 1 : Les archives sont officiellement ouvertes.
Jour 2 : Aldric a commencé le registre des créatures.
Jour 3 : Elara a rejoint l'équipe. Elle apporte son expertise en artefacts.
EOF
git add journal.txt
faire_commit "Thorin le Gardien" "thorin@citadelle.roy" \
    "trucs" \
    "2024-01-20 08:45:00 +0100"

# --- Commit 5 : Aldric ajoute le dragon des marais ---
cat >> registre.txt << 'EOF'

Entrée 002 - Dragon des Marais
  Habitat : Marécages de l'Est
  Dangerosité : Élevée
  Notes : Crache un venin acide. Éviter tout contact.
  Dernière observation : Lune de Givre, an 1023.
EOF
git add registre.txt
faire_commit "Aldric le Scribe" "aldric@citadelle.roy" \
    "Ajouter l'entrée du dragon des marais au registre" \
    "2024-02-01 11:00:00 +0100"

# --- Commit 6 : Elara - mauvais message ---
cat >> inventaire.txt << 'EOF'

003 - Miroir des Anciens
  Localisation : Salle du Conseil
  Pouvoir : Montre les événements passés
  État : Intact
EOF
git add inventaire.txt
faire_commit "Elara la Sage" "elara@citadelle.roy" \
    "modif" \
    "2024-02-05 16:30:00 +0100"

# --- Commit 7 : Thorin ajoute un fichier debug (parasite) ---
cat > debug.log << 'EOF'
[DEBUG] 2024-02-10 08:00:01 - Chargement du système d'archives...
[DEBUG] 2024-02-10 08:00:02 - Connexion à la base de données...
[DEBUG] 2024-02-10 08:00:03 - 247 entrées chargées.
[WARN]  2024-02-10 08:00:04 - Entrée corrompue détectée : ID 042
[ERROR] 2024-02-10 08:00:05 - Impossible de lire le parchemin #128
EOF
git add debug.log
faire_commit "Thorin le Gardien" "thorin@citadelle.roy" \
    "fix" \
    "2024-02-10 09:00:00 +0100"

# --- Commit 8 : Aldric corrige le dragon ---
sed -i 's/Crache un venin acide/Crache un venin corrosif/' registre.txt
sed -i 's/Éviter tout contact/Ne jamais approcher seul/' registre.txt
git add registre.txt
faire_commit "Aldric le Scribe" "aldric@citadelle.roy" \
    "Corriger l'entrée du dragon des marais" \
    "2024-02-12 10:00:00 +0100"

# --- Commit 9 : Elara met à jour la carte ---
sed -i 's/col gardé par les Sentinelles/col gardé par les Sentinelles (renforcé depuis la bataille de Givre)/' carte.txt
cat >> carte.txt << 'EOF'

ZONES DANGEREUSES :
  - Marécages de l'Est (dragons)
  - Forêt de Brumesombre (créatures nocturnes)
  - Ruines de l'Ancien Temple (magie instable)
EOF
git add carte.txt
faire_commit "Elara la Sage" "elara@citadelle.roy" \
    "Mettre à jour la carte des frontières" \
    "2024-02-15 14:00:00 +0100"

# --- Commit 10 : Thorin - mauvais message + fichiers parasites ---
printf "" > .DS_Store
printf "" > Thumbs.db
git add .DS_Store Thumbs.db
faire_commit "Thorin le Gardien" "thorin@citadelle.roy" \
    "oups" \
    "2024-02-18 17:00:00 +0100"

# --- Commit 11 : Aldric met à jour le journal ---
cat >> journal.txt << 'EOF'

Jour 15 : Le registre des créatures compte maintenant 2 entrées.
Jour 20 : Elara a catalogué 3 artefacts magiques.
Jour 25 : Thorin a tenté de "réparer" quelque chose. Personne ne sait quoi.
EOF
git add journal.txt
faire_commit "Aldric le Scribe" "aldric@citadelle.roy" \
    "Ajouter les notes des jours 15 à 25 au journal" \
    "2024-02-20 09:30:00 +0100"

# --- Commit 12 : Elara ajoute des créatures ---
cat >> registre.txt << 'EOF'

Entrée 003 - Loup Spectral
  Habitat : Forêt de Brumesombre
  Dangerosité : Élevée
  Notes : Invisible à l'oeil nu. Se manifeste uniquement les nuits sans lune.

Entrée 004 - Phénix de Cendre
  Habitat : Volcan de Solarith
  Dangerosité : Faible (pacifique)
  Notes : Renaît de ses cendres tous les 100 ans. Prochain cycle : an 1089.
EOF
git add registre.txt
faire_commit "Elara la Sage" "elara@citadelle.roy" \
    "Ajouter le loup spectral et le phénix de cendre au registre" \
    "2024-02-25 11:00:00 +0100"

# --- Commit 13 : Thorin - mauvais message ---
cat >> journal.txt << 'EOF'

Jour 30 : Découverte d'un passage secret sous les archives.
EOF
git add journal.txt
faire_commit "Thorin le Gardien" "thorin@citadelle.roy" \
    "wip" \
    "2024-03-01 08:00:00 +0100"

# --- Commit 14 : Aldric ajoute un secret (erreur !) ---
cat > secret-du-royaume.txt << 'EOF'
╔══════════════════════════════════════════════╗
║     DOCUMENT CONFIDENTIEL - YEUX DU ROI     ║
╚══════════════════════════════════════════════╝

Le trésor royal est caché sous la troisième pierre
du couloir ouest de la Salle du Trône.

Mot de passe du coffre : "dracarys-1024"

NE JAMAIS ARCHIVER CE DOCUMENT.
EOF
git add secret-du-royaume.txt
faire_commit "Aldric le Scribe" "aldric@citadelle.roy" \
    "Ajouter des notes (à trier plus tard)" \
    "2024-03-05 15:00:00 +0100"

# --- Commit 15 : Elara - fichier __pycache__ (parasite) ---
mkdir -p __pycache__
cat > __pycache__/cache.pyc << 'EOF'
FAKE_BYTECODE_CONTENT_NOT_REAL
EOF
git add __pycache__/
faire_commit "Elara la Sage" "elara@citadelle.roy" \
    "Ajouter le script de tri automatique" \
    "2024-03-08 10:00:00 +0100"

# --- Commit 16 : Aldric récapitule ---
cat >> journal.txt << 'EOF'

Jour 45 : Les archives grandissent. 4 créatures, 3 artefacts, 1 carte complète.
Jour 46 : Le Maître Archiviste demande un apprenti pour explorer les archives.
EOF
git add journal.txt
faire_commit "Aldric le Scribe" "aldric@citadelle.roy" \
    "Compléter le journal avec les entrées récentes" \
    "2024-03-10 09:00:00 +0100"

# --- Commit 17 : Elara met à jour l'inventaire ---
cat >> inventaire.txt << 'EOF'

004 - Cape d'Ombre
  Localisation : Vestiaire de la Guilde des Éclaireurs
  Pouvoir : Invisibilité temporaire (30 secondes)
  État : Usée - efficacité réduite

005 - Boussole des Âmes
  Localisation : Bureau du Nécromancien Royal (retraité)
  Pouvoir : Pointe vers la personne la plus proche
  État : Fonctionnel mais inquiétant
EOF
git add inventaire.txt
faire_commit "Elara la Sage" "elara@citadelle.roy" \
    "Ajouter la cape d'ombre et la boussole des âmes" \
    "2024-03-12 14:30:00 +0100"

# --- Commit 18 : Thorin - dernier bon commit ---
cat >> carte.txt << 'EOF'

POINTS D'INTÉRÊT :
  - Citadelle du Savoir (siège des Archives)
  - Tour de l'Oracle (consultations magiques)
  - Marché des Guildes (commerce inter-guildes)
  - Porte des Anciens (ruines - accès interdit)
EOF
git add carte.txt
faire_commit "Thorin le Gardien" "thorin@citadelle.roy" \
    "Ajouter les points d'intérêt à la carte" \
    "2024-03-15 16:00:00 +0100"

# -----------------------------------------------------------------------------
# Vérification de l'historique
# -----------------------------------------------------------------------------
echo ""
echo "=== Historique créé ==="
git log --oneline --all
echo ""
echo "Nombre de commits : $(git rev-list --count HEAD)"
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
echo "  git clone archive.bundle les-lignes-du-temps"
echo ""
echo "Terminé !"
