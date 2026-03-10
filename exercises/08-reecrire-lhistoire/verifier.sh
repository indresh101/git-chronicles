#!/usr/bin/env bash
# =============================================================================
# Quête 08 - Réécrire l'Histoire - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quête 08 - Réécrire l'Histoire"
afficher_banniere "$QUETE_TITRE"

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
verifier_etape 1 "Tu es dans un dépôt Git" \
    'git rev-parse --is-inside-work-tree'

# ---- Étape 2 : Le reflog contient un amend ----
verifier_etape 2 "Tu as utilisé git commit --amend (visible dans le reflog)" \
    'git reflog | grep -qi "amend"'

# ---- Étape 3 : Le reflog contient un rebase ----
verifier_etape 3 "Tu as effectué un rebase (visible dans le reflog)" \
    'git reflog | grep -qi "rebase"'

# ---- Étape 4 : Au moins 3 commits existent ----
verifier_etape 4 "Au moins 3 commits existent dans l'historique" \
    '[ "$(git rev-list --count HEAD)" -ge 3 ]'

afficher_score
