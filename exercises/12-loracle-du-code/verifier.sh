#!/usr/bin/env bash
# =============================================================================
# Quête 12 - L'Oracle du Code - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quête 12 - L'Oracle du Code"
afficher_banniere "$QUETE_TITRE"

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
verifier_etape 1 "Tu es dans un dépôt Git" \
    'git rev-parse --is-inside-work-tree'

# ---- Étape 2 : git bisect a été utilisé ----
# bisect laisse des traces : soit dans le reflog (checkouts multiples entre
# hashes détachés), soit via le fichier BISECT_LOG, soit au moins 3 checkouts
# vers des commits détachés (typique d'une recherche binaire).
verifier_etape 2 "git bisect a été utilisé (trace dans le reflog)" \
    '[ "$(git reflog | grep -c "checkout: moving from [0-9a-f]\{7,\} to [0-9a-f]\{7,\}")" -ge 2 ]'

# ---- Étape 3 : git cherry-pick a été utilisé (trace dans le reflog) ----
verifier_etape 3 "git cherry-pick a été utilisé (trace dans le reflog)" \
    'git reflog | grep -q "cherry-pick"'

# ---- Étape 4 : Le grimoire ne contient plus le mot CORROMPU ----
verifier_etape 4 "Le grimoire ne contient plus le mot CORROMPU" \
    '! grep -q "CORROMPU" grimoire.txt 2>/dev/null'

afficher_score
