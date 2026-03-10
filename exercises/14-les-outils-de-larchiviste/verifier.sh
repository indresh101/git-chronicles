#!/usr/bin/env bash
# =============================================================================
# Quête 14 - Les Outils de l'Archiviste - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quête 14 - Les Outils de l'Archiviste"
afficher_banniere "$QUETE_TITRE"

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
verifier_etape 1 "Tu es dans un dépôt Git" \
    'git rev-parse --is-inside-work-tree'

# ---- Étape 2 : Au moins un alias est configuré ----
verifier_etape 2 "Au moins un alias Git est configuré" \
    'git config --get-regexp alias 2>/dev/null | grep -q .'

# ---- Étape 3 : Le hook pre-commit existe et est exécutable ----
verifier_etape 3 "Le hook pre-commit existe et est exécutable" \
    '[ -x "$(git rev-parse --git-dir)/hooks/pre-commit" ]'

# ---- Étape 4 : Le hook pre-commit fonctionne (détecte les TODO) ----
verifier_etape 4 "Le hook pre-commit détecte les TODO dans les fichiers" \
    'grep -q "TODO" "$(git rev-parse --git-dir)/hooks/pre-commit"'

# ---- Étape 5 : Le hook commit-msg existe et est exécutable ----
verifier_etape 5 "Le hook commit-msg existe et est exécutable" \
    '[ -x "$(git rev-parse --git-dir)/hooks/commit-msg" ]'

afficher_score
