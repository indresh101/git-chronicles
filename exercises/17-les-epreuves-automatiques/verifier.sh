#!/usr/bin/env bash
# =============================================================================
# Quête 17 - Les Épreuves Automatiques - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quête 17 - Les Épreuves Automatiques"
afficher_banniere "$QUETE_TITRE"

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
verifier_etape 1 "Tu es dans un dépôt Git" \
    'git rev-parse --is-inside-work-tree'

# ---- Étape 2 : Le dossier .github/workflows existe ----
verifier_etape 2 "Le dossier .github/workflows existe" \
    '[ -d ".github/workflows" ]'

# ---- Étape 3 : Un workflow YAML contient une stratégie de matrice ----
verifier_etape 3 "Un workflow contient une stratégie de matrice (matrix)" \
    'grep -rl "matrix:" .github/workflows/*.yml .github/workflows/*.yaml 2>/dev/null | grep -q .'

# ---- Étape 4 : Le workflow contient plusieurs étapes (steps) ----
verifier_etape 4 "Le workflow contient plusieurs étapes (steps)" \
    'fichier=$(ls .github/workflows/*.yml .github/workflows/*.yaml 2>/dev/null | head -1) && [ -n "$fichier" ] && [ "$(grep -c "name:" "$fichier")" -ge 2 ]'

# ---- Étape 5 : Au moins un script de test existe ----
verifier_etape 5 "Au moins un script de test existe" \
    'ls test-*.sh test-*.bash tests/*.sh tests/*.bash 2>/dev/null | grep -q .'

afficher_score
