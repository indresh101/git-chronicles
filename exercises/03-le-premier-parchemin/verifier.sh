#!/usr/bin/env bash
# =============================================================================
# Quête 03 - Le Premier Parchemin - Script de vérification
# Projet  : Les Chroniques du Versionneur
#
# Usage   : Lancer DEPUIS le dossier mon-archive/
#           bash ../verifier.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quête 03 - Le Premier Parchemin"
afficher_banniere "$QUETE_TITRE"

# --- Étape 1 : On est dans un dépôt git ---
verifier_etape 1 "Tu es dans un dépôt Git" \
    'verifier_dans_repo'

# --- Étape 2 : Au moins 2 commits ---
verifier_etape 2 "Tu as au moins 2 commits" \
    '[ "$(git rev-list --count HEAD 2>/dev/null)" -ge 2 ]'

# --- Étape 3 : mission.txt est tracké ---
verifier_etape 3 "Le fichier mission.txt est suivi par Git" \
    'git ls-files --error-unmatch mission.txt'

# --- Étape 4 : Le premier message de commit n'est pas générique ---
verifier_etape 4 "Ton premier commit a un message personnalisé" \
    '
    premier_msg="$(git log --reverse --format=%s | head -n1)"
    [ -n "$premier_msg" ] \
        && [ "$premier_msg" != "Initial commit" ] \
        && [ "$premier_msg" != "initial commit" ] \
        && [ "$premier_msg" != "first commit" ] \
        && [ "$premier_msg" != "init" ]
    '

afficher_score
