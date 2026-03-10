#!/usr/bin/env bash
# =============================================================================
# Quête 01 - La Guilde des Archivistes - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quête 01 - La Guilde des Archivistes"
afficher_banniere "$QUETE_TITRE"

verifier_etape 1 "Git est installé" 'command -v git >/dev/null 2>&1'
verifier_etape 2 "Ton nom est configuré" '[ -n "$(git config --global user.name)" ]'
verifier_etape 3 "Ton email est configuré" '[ -n "$(git config --global user.email)" ]'

afficher_score
