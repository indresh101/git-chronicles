#!/usr/bin/env bash
# =============================================================================
# Quête 09 - Les Portails Distants - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quête 09 - Les Portails Distants"
afficher_banniere "$QUETE_TITRE"

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
verifier_etape 1 "Tu es dans un dépôt Git" \
    'git rev-parse --is-inside-work-tree'

# ---- Étape 2 : Au moins un remote est configuré ----
verifier_etape 2 "Au moins un remote est configuré" \
    '[ "$(git remote | wc -l)" -ge 1 ]'

# ---- Étape 3 : Un push a été effectué (vérifie les refs de suivi distant) ----
verifier_etape 3 "Tu as poussé au moins une fois vers un remote" \
    'git for-each-ref refs/remotes --format="%(refname)" 2>/dev/null | grep -q . || \
     git reflog show --all 2>/dev/null | grep -q "push"'

# ---- Étape 4 : Un fetch ou pull a été effectué ----
verifier_etape 4 "Tu as récupéré des changements depuis un remote" \
    '[ "$(git reflog show --all 2>/dev/null | grep -c "fetch\|pull")" -ge 1 ] || \
     [ "$(git log --all --oneline 2>/dev/null | wc -l)" -gt "$(git log --oneline 2>/dev/null | wc -l)" ]'

afficher_score
