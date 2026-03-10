#!/usr/bin/env bash
# =============================================================================
# verifier.sh - Quête 02 : Les Trois Salles du Savoir
# Projet  : Les Chroniques du Versionneur
# Vérifie que l'apprenti a bien compris le flux Working Dir → Staging Area
# =============================================================================

# Chargement des fonctions communes
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source "${SCRIPT_DIR}/../../lib/verifier-common.sh"

# Titre de la quête
QUETE_TITRE="Quête 02 - Les Trois Salles du Savoir"
afficher_banniere "${QUETE_TITRE}"

# ── Étape 1 : On est dans un dépôt git ──────────────────────────────────────
verifier_etape 1 \
    "Tu te trouves dans un dépôt git (git init a été fait)" \
    "git rev-parse --is-inside-work-tree" \
    || true

# ── Étape 2 : Le fichier parchemin.txt existe ───────────────────────────────
verifier_etape 2 \
    "Le fichier parchemin.txt existe dans la Salle de Travail" \
    "test -f parchemin.txt" \
    || true

# ── Étape 3 : parchemin.txt est dans le staging area ────────────────────────
verifier_etape 3 \
    "parchemin.txt est dans la Salle de Préparation (staging area)" \
    "git diff --cached --name-only | grep -q parchemin.txt" \
    || true

# ── Étape 4 : Pas encore de commit (pas de HEAD valide) ─────────────────────
verifier_etape 4 \
    "Aucun parchemin n'a encore été scellé (pas de commit)" \
    "! git rev-parse HEAD > /dev/null 2>&1" \
    || true

# ── Score final ──────────────────────────────────────────────────────────────
afficher_score
