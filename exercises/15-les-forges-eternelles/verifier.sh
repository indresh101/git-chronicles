#!/usr/bin/env bash
# =============================================================================
# Quête 15 - Les Forges Éternelles - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quête 15 - Les Forges Éternelles"
afficher_banniere "$QUETE_TITRE"

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
verifier_etape 1 "Tu es dans un dépôt Git" \
    'git rev-parse --is-inside-work-tree'

# ---- Étape 2 : Au moins un remote est configuré ----
verifier_etape 2 "Au moins un remote est configuré" \
    'git remote 2>/dev/null | grep -q .'

# ---- Étape 3 : Au moins un push a été effectué ----
verifier_etape 3 "Au moins un push a été effectué (des refs distantes existent)" \
    'git branch -r 2>/dev/null | grep -q .'

# ---- Étape 4 : Au moins 3 commits dans le dépôt ----
verifier_etape 4 "Le dépôt contient au moins 3 commits" \
    '[ "$(git rev-list --count HEAD 2>/dev/null)" -ge 3 ]'

afficher_score
