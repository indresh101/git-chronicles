#!/usr/bin/env bash
# =============================================================================
# Quête 11 - Le Tisseur de Temps - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quête 11 - Le Tisseur de Temps"
afficher_banniere "$QUETE_TITRE"

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
verifier_etape 1 "Tu es dans un dépôt Git" \
    'git rev-parse --is-inside-work-tree'

# ---- Étape 2 : Au moins 2 branches existent ----
verifier_etape 2 "Au moins 2 branches existent" \
    '[ "$(git branch -a 2>/dev/null | wc -l)" -ge 2 ]'

# ---- Étape 3 : Le reflog montre une activité de stash ----
verifier_etape 3 "Le reflog montre une activité de stash" \
    'git reflog show stash 2>/dev/null | grep -q . || git log -g refs/stash --oneline 2>/dev/null | grep -q . || git reflog 2>/dev/null | grep -qi stash'

# ---- Étape 4 : Au moins 3 commits existent ----
verifier_etape 4 "Il y a au moins 3 commits dans l'historique" \
    '[ "$(git log --all --oneline 2>/dev/null | wc -l)" -ge 3 ]'

afficher_score
