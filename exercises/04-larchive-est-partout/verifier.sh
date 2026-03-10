#!/usr/bin/env bash
# =============================================================================
# Quete 04 - L'Archive est Partout - Script de verification
# Projet  : Les Chroniques du Versionneur
#
# Usage   : bash verifier.sh [chemin_du_dossier_parent]
#           Si aucun chemin n'est fourni, utilise le répertoire courant.
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quete 04 - L'Archive est Partout"
afficher_banniere "$QUETE_TITRE"

# Dossier de travail : parametre ou répertoire courant
WORKDIR="${1:-.}"
WORKDIR="$(cd "$WORKDIR" 2>/dev/null && pwd)" || {
    printf "%sErreur : le dossier '%s' n'existe pas.%s\n" \
        "${CLR_ROUGE}" "$1" "${CLR_RESET}" >&2
    exit 1
}

printf "  %sDossier analyse : %s%s\n\n" "${CLR_CYAN}" "$WORKDIR" "${CLR_RESET}"

# ---- Étape 1 : ma-copie/ existe et c'est un repo git ----
verifier_etape 1 "ma-copie/ existe et c'est un repo Git" \
    '[ -d "$WORKDIR/ma-copie/.git" ]'

# ---- Étape 2 : ma-copie a une remote origin pointant vers un chemin local ----
verifier_etape 2 "ma-copie/ a une remote origin vers un chemin local" \
    'grep -q "url = " "$WORKDIR/ma-copie/.git/config" 2>/dev/null && \
     ! grep "url = http" "$WORKDIR/ma-copie/.git/config" >/dev/null 2>&1 && \
     ! grep "url = git@" "$WORKDIR/ma-copie/.git/config" >/dev/null 2>&1'

# ---- Étape 3 : archive-centrale.git/ est un bare repo ----
verifier_etape 3 "archive-centrale.git/ existe et c'est un bare repo" \
    '[ -f "$WORKDIR/archive-centrale.git/HEAD" ] && \
     [ -d "$WORKDIR/archive-centrale.git/objects" ] && \
     [ -d "$WORKDIR/archive-centrale.git/refs" ] && \
     ! [ -d "$WORKDIR/archive-centrale.git/.git" ]'

# ---- Étape 4 : clone-depuis-bare/ existe et c'est un repo git ----
verifier_etape 4 "clone-depuis-bare/ existe et c'est un repo Git" \
    '[ -d "$WORKDIR/clone-depuis-bare/.git" ]'

afficher_score
