#!/usr/bin/env bash
# =============================================================================
# Quête 06 - L'Arbre des Possibles - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quête 06 - L'Arbre des Possibles"
afficher_banniere "$QUETE_TITRE"

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
verifier_etape 1 "Tu es dans un dépôt Git" \
    'git rev-parse --is-inside-work-tree'

# ---- Étape 2 : La branche expedition-nord existe ----
verifier_etape 2 "La branche expedition-nord existe" \
    'git branch --list expedition-nord | grep -q expedition-nord'

# ---- Étape 3 : La branche expedition-sud existe ----
verifier_etape 3 "La branche expedition-sud existe" \
    'git branch --list expedition-sud | grep -q expedition-sud'

# ---- Étape 4 : expedition-nord a au moins un commit propre ----
verifier_etape 4 "La branche expedition-nord contient un commit propre" \
    '[ "$(git log main..expedition-nord --oneline 2>/dev/null | wc -l)" -ge 1 ]'

# ---- Étape 5 : expedition-sud a au moins un commit propre ----
verifier_etape 5 "La branche expedition-sud contient un commit propre" \
    '[ "$(git log main..expedition-sud --oneline 2>/dev/null | wc -l)" -ge 1 ]'

# ---- Étape 6 : Au moins 3 branches au total ----
verifier_etape 6 "Il y a au moins 3 branches" \
    '[ "$(git branch | wc -l)" -ge 3 ]'

afficher_score
