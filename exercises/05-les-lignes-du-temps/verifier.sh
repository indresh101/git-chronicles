#!/usr/bin/env bash
# =============================================================================
# Quête 05 - Les Lignes du Temps - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quête 05 - Les Lignes du Temps"
afficher_banniere "$QUETE_TITRE"

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
verifier_etape 1 "Tu es dans un dépôt Git" \
    'git rev-parse --is-inside-work-tree'

# ---- Étape 2 : Le .gitignore existe ----
verifier_etape 2 "Le fichier .gitignore existe" \
    '[ -f .gitignore ]'

# ---- Étape 3 : Le .gitignore contient un pattern pour les .log ----
verifier_etape 3 "Le .gitignore ignore les fichiers .log" \
    'grep -qE "^\*\.log$|^debug\.log$" .gitignore'

# ---- Étape 4 : debug.log n'est plus tracké ----
verifier_etape 4 "debug.log n'est plus suivi par Git" \
    '! git ls-files --error-unmatch debug.log 2>/dev/null'

# ---- Étape 5 : Le dernier commit a un message d'au moins 10 caractères ----
verifier_etape 5 "Le dernier commit a un message descriptif (≥ 10 caractères)" \
    '[ "$(git log -1 --format=%s | wc -c)" -ge 10 ]'

afficher_score
