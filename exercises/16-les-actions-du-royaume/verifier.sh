#!/usr/bin/env bash
# =============================================================================
# Quête 16 - Les Actions du Royaume - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quête 16 - Les Actions du Royaume"
afficher_banniere "$QUETE_TITRE"

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
verifier_etape 1 "Tu es dans un dépôt Git" \
    'git rev-parse --is-inside-work-tree'

# ---- Étape 2 : Le dossier .github/workflows existe ----
verifier_etape 2 "Le dossier .github/workflows existe" \
    '[ -d ".github/workflows" ]'

# ---- Étape 3 : Au moins un fichier .yml existe dans .github/workflows ----
verifier_etape 3 "Au moins un fichier .yml existe dans .github/workflows" \
    'ls .github/workflows/*.yml 1>/dev/null 2>&1 || ls .github/workflows/*.yaml 1>/dev/null 2>&1'

# ---- Étape 4 : Le fichier YAML contient le mot-clé "name:" ----
verifier_etape 4 "Le workflow contient le mot-clé 'name:'" \
    'grep -rq "^name:" .github/workflows/*.yml 2>/dev/null || grep -rq "^name:" .github/workflows/*.yaml 2>/dev/null'

# ---- Étape 5 : Le fichier YAML contient le mot-clé "on:" ----
verifier_etape 5 "Le workflow contient le mot-clé 'on:'" \
    'grep -rq "^on:" .github/workflows/*.yml 2>/dev/null || grep -rq "^on:" .github/workflows/*.yaml 2>/dev/null'

# ---- Étape 6 : Le fichier YAML contient le mot-clé "jobs:" ----
verifier_etape 6 "Le workflow contient le mot-clé 'jobs:'" \
    'grep -rq "^jobs:" .github/workflows/*.yml 2>/dev/null || grep -rq "^jobs:" .github/workflows/*.yaml 2>/dev/null'

afficher_score
