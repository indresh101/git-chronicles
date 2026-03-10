#!/usr/bin/env bash
# =============================================================================
# Quête 13 - Les Sceaux Magiques - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quête 13 - Les Sceaux Magiques"
afficher_banniere "$QUETE_TITRE"

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
verifier_etape 1 "Tu es dans un dépôt Git" \
    'git rev-parse --is-inside-work-tree'

# ---- Étape 2 : Au moins 2 tags existent ----
verifier_etape 2 "Au moins 2 tags existent" \
    '[ "$(git tag | wc -l)" -ge 2 ]'

# ---- Étape 3 : Au moins un tag annoté existe ----
verifier_etape 3 "Au moins un tag annoté existe" \
    'found=false; for t in $(git tag); do if [ "$(git cat-file -t "$t" 2>/dev/null)" = "tag" ]; then found=true; break; fi; done; $found'

# ---- Étape 4 : Les tags suivent le format de versionnage (v*) ----
verifier_etape 4 "Les tags suivent le format de versionnage (v*)" \
    'git tag | grep -qE "^v[0-9]+\.[0-9]+\.[0-9]+$"'

afficher_score
