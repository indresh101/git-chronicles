#!/usr/bin/env bash
# =============================================================================
# Quête 18 - Le Déploiement Sacré - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quête 18 - Le Déploiement Sacré"
afficher_banniere "$QUETE_TITRE"

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
verifier_etape 1 "Tu es dans un dépôt Git" \
    'git rev-parse --is-inside-work-tree'

# ---- Étape 2 : Le dossier .github/workflows existe avec au moins un fichier YAML ----
verifier_etape 2 "Un dossier .github/workflows existe avec un workflow" \
    'ls .github/workflows/*.yml .github/workflows/*.yaml 2>/dev/null | grep -q .'

# ---- Étape 3 : Le workflow mentionne le déploiement (production ou deploy) ----
verifier_etape 3 "Le workflow mentionne le déploiement (production ou deploy)" \
    'grep -rqlE "production|deploy" .github/workflows/ 2>/dev/null'

# ---- Étape 4 : Au moins un tag existe ----
verifier_etape 4 "Au moins un tag de version existe" \
    '[ "$(git tag | wc -l)" -ge 1 ]'

afficher_score
