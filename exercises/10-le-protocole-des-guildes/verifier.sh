#!/usr/bin/env bash
# =============================================================================
# Quête 10 - Le Protocole des Guildes - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quête 10 - Le Protocole des Guildes"
afficher_banniere "$QUETE_TITRE"

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
verifier_etape 1 "Tu es dans un dépôt Git" \
    'git rev-parse --is-inside-work-tree'

# ---- Étape 2 : La branche main/master existe ----
verifier_etape 2 "La branche principale (main ou master) existe" \
    'git branch --list main master | grep -qE "main|master"'

# ---- Étape 3 : Au moins 3 commits au total ----
verifier_etape 3 "Il y a au moins 3 commits dans l'historique" \
    '[ "$(git log --oneline 2>/dev/null | wc -l)" -ge 3 ]'

# ---- Étape 4 : Un commit de merge existe (preuve du --no-ff) ----
verifier_etape 4 "Un commit de merge existe (Protocole respecté)" \
    'git log --merges --oneline 2>/dev/null | grep -q .'

# ---- Étape 5 : Pas de branche de proposition restante (nettoyée) ----
verifier_etape 5 "La branche de proposition a été nettoyée" \
    '[ "$(git branch | grep -v "main\|master\|\*" | wc -l)" -eq 0 ]'

afficher_score
