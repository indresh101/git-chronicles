#!/usr/bin/env bash
# =============================================================================
# Quête 19 - Les Autres Forges - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quête 19 - Les Autres Forges"
afficher_banniere "$QUETE_TITRE"

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
verifier_etape 1 "Tu es dans un dépôt Git" \
    'git rev-parse --is-inside-work-tree'

# ---- Étape 2 : Le fichier GitHub Actions existe ----
verifier_etape 2 "Le fichier .github/workflows/ci.yml existe" \
    'ls .github/workflows/*.yml >/dev/null 2>&1'

# ---- Étape 3 : Le fichier GitLab CI existe ----
verifier_etape 3 "Le fichier .gitlab-ci.yml existe" \
    '[ -f ".gitlab-ci.yml" ]'

# ---- Étape 4 : Le fichier Bitbucket Pipelines existe ----
verifier_etape 4 "Le fichier bitbucket-pipelines.yml existe" \
    '[ -f "bitbucket-pipelines.yml" ]'

# ---- Étape 5 : Le script de test existe ----
verifier_etape 5 "Le script de test scripts/test.sh existe" \
    '[ -f "scripts/test.sh" ]'

# ---- Étape 6 : Au moins un commit a été créé ----
verifier_etape 6 "Au moins un commit a été créé" \
    'git log --oneline -1 >/dev/null 2>&1'

afficher_score
