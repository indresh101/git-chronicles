#!/usr/bin/env bash
# =============================================================================
# Quête 07 - Le Conflit des Royaumes - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quête 07 - Le Conflit des Royaumes"
afficher_banniere "$QUETE_TITRE"

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
verifier_etape 1 "Tu es dans un dépôt Git" \
    'git rev-parse --is-inside-work-tree'

# ---- Étape 2 : Un commit de merge existe dans l'historique ----
verifier_etape 2 "Un merge a été effectué (commit de merge présent)" \
    '[ "$(git rev-list --merges --count HEAD)" -ge 1 ]'

# ---- Étape 3 : Pas de marqueurs de conflit dans les fichiers trackés ----
verifier_etape 3 "Aucun marqueur de conflit ne reste dans les fichiers" \
    '! git grep -l "^<<<<<<< \|^=======$\|^>>>>>>> " -- ":(exclude)verifier.sh" ":(exclude)verifier.ps1" ":(exclude)*.md" 2>/dev/null'

# ---- Étape 4 : Pas de merge en cours (pas de MERGE_HEAD) ----
verifier_etape 4 "Aucun merge n'est en cours (pas de conflit non résolu)" \
    '[ ! -f "$(git rev-parse --git-dir)/MERGE_HEAD" ]'

# ---- Étape 5 : Le commit de merge a un message descriptif ----
verifier_etape 5 "Le dernier commit de merge a un message descriptif (>= 10 caractères)" \
    '[ "$(git log --merges -1 --format=%s | wc -c)" -ge 10 ]'

afficher_score
