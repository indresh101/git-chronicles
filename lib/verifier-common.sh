#!/usr/bin/env bash
# =============================================================================
# verifier-common.sh - Fonctions partagées pour les scripts de vérification
# Projet  : Les Chroniques du Versionneur
# Thème   : Heroic Fantasy - Cours Git gamifié
# Auteur  : Infrastructure pédagogique
# Version : 1.0.0
#
# Usage   : source "$(dirname "$0")/../lib/verifier-common.sh"
#
# Compatibilité : bash 3.2+ (macOS), bash 4+ (Linux)
# Encodage       : UTF-8
# =============================================================================

# Garde contre le double chargement
[[ -n "${_VERIFIER_COMMON_LOADED:-}" ]] && return 0
readonly _VERIFIER_COMMON_LOADED=1

# -----------------------------------------------------------------------------
# Variables globales de score
# -----------------------------------------------------------------------------
SCORE=0
TOTAL=0
QUETE_TITRE=""

# -----------------------------------------------------------------------------
# Détection des couleurs ANSI
# Le terminal doit être un TTY ET supporter les couleurs.
# -----------------------------------------------------------------------------
_init_couleurs() {
    if [[ -t 1 ]] && [[ "${TERM:-}" != "dumb" ]] && [[ "${NO_COLOR:-}" != "1" ]]; then
        CLR_RESET=$'\033[0m'
        CLR_GRAS=$'\033[1m'
        CLR_VERT=$'\033[32m'
        CLR_ROUGE=$'\033[31m'
        CLR_JAUNE=$'\033[33m'
        CLR_CYAN=$'\033[36m'
        CLR_MAGENTA=$'\033[35m'
        CLR_BLANC=$'\033[97m'
    else
        CLR_RESET=""
        CLR_GRAS=""
        CLR_VERT=""
        CLR_ROUGE=""
        CLR_JAUNE=""
        CLR_CYAN=""
        CLR_MAGENTA=""
        CLR_BLANC=""
    fi
}

_init_couleurs

# -----------------------------------------------------------------------------
# Chargement optionnel du thème fantasy
# Chemin relatif depuis git/lib/ → git/themes/fantasy/messages.sh
# -----------------------------------------------------------------------------
_THEME_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)/../../themes/fantasy"
_THEME_FILE="${_THEME_DIR}/messages.sh"

# Messages par défaut (écrasés si le thème est chargé)
THEME_NOM="defaut"
MESSAGES_SUCCES=("Correct !" "Bien joué !" "Validé !" "Réussi !" "Parfait !" "Bravo !")
MESSAGES_ECHEC=("Incorrect." "Raté." "À corriger." "Non valide." "Échec." "À revoir.")
MSG_FELICITATIONS="Félicitations ! Tu as complété cette quête !"
MSG_ENCOURAGEMENT="Courage ! Relis les consignes et réessaie."

if [[ -f "${_THEME_FILE}" ]]; then
    # shellcheck source=../themes/fantasy/messages.sh
    source "${_THEME_FILE}"
fi

# -----------------------------------------------------------------------------
# _message_aleatoire <tableau_name>
# Retourne un message aléatoire depuis un tableau bash.
# Compatible bash 3.2 (pas de nameref, utilise eval).
# -----------------------------------------------------------------------------
_message_aleatoire() {
    local tableau_name="$1"

    # bash 3.2 ne supporte pas les namerefs ; on utilise eval de façon sûre
    # (le nom de tableau est contrôlé en interne, jamais fourni par l'utilisateur)
    local taille
    eval "taille=\${#${tableau_name}[@]}"

    if [[ "${taille}" -eq 0 ]]; then
        printf "Message indisponible."
        return
    fi

    local index=$(( RANDOM % taille ))
    local msg
    eval "msg=\${${tableau_name}[${index}]}"
    printf "%s" "${msg}"
}

# -----------------------------------------------------------------------------
# afficher_banniere <titre>
# Affiche un encadré ASCII thématisé avec le titre centré.
# -----------------------------------------------------------------------------
afficher_banniere() {
    local titre="${1:-Les Chroniques du Versionneur}"
    local largeur=60

    # Calcule le padding pour centrer le titre
    local titre_len=${#titre}
    local espace_total=$(( largeur - titre_len - 2 ))   # -2 pour les ║ de chaque côté
    local pad_gauche=$(( espace_total / 2 ))
    local pad_droite=$(( espace_total - pad_gauche ))

    # Construction des lignes
    local ligne_h
    ligne_h="$(printf '%0.s═' $(seq 1 "${largeur}"))"

    printf "\n"
    printf "%s╔%s╗%s\n" "${CLR_MAGENTA}${CLR_GRAS}" "${ligne_h}" "${CLR_RESET}"
    printf "%s║%*s%s%*s║%s\n" \
        "${CLR_MAGENTA}${CLR_GRAS}" \
        "${pad_gauche}" "" \
        "${CLR_CYAN}${CLR_GRAS}${titre}${CLR_MAGENTA}${CLR_GRAS}" \
        "${pad_droite}" "" \
        "${CLR_RESET}"
    printf "%s╚%s╝%s\n" "${CLR_MAGENTA}${CLR_GRAS}" "${ligne_h}" "${CLR_RESET}"
    printf "\n"
}

# -----------------------------------------------------------------------------
# verifier_etape <numero> <description> <commande_test>
# Exécute <commande_test> via eval.
# Affiche ✅ + message succès ou ❌ + message échec selon le code de retour.
# Incrémente TOTAL à chaque appel ; incrémente SCORE en cas de succès.
# -----------------------------------------------------------------------------
verifier_etape() {
    local numero="${1:?verifier_etape: argument 'numero' requis}"
    local description="${2:?verifier_etape: argument 'description' requis}"
    local commande_test="${3:?verifier_etape: argument 'commande_test' requis}"

    TOTAL=$(( TOTAL + 1 ))

    # Exécution silencieuse de la commande de test
    local resultat=0
    eval "${commande_test}" > /dev/null 2>&1 || resultat=$?

    if [[ "${resultat}" -eq 0 ]]; then
        SCORE=$(( SCORE + 1 ))
        local msg_theme
        msg_theme="$(_message_aleatoire MESSAGES_SUCCES)"
        printf "  %s✅  Étape %s - %s%s\n" \
            "${CLR_VERT}${CLR_GRAS}" \
            "${numero}" \
            "${description}" \
            "${CLR_RESET}"
        printf "      %s%s%s\n\n" \
            "${CLR_VERT}" \
            "${msg_theme}" \
            "${CLR_RESET}"
    else
        local msg_theme
        msg_theme="$(_message_aleatoire MESSAGES_ECHEC)"
        printf "  %s❌  Étape %s - %s%s\n" \
            "${CLR_ROUGE}${CLR_GRAS}" \
            "${numero}" \
            "${description}" \
            "${CLR_RESET}"
        printf "      %s%s%s\n\n" \
            "${CLR_ROUGE}" \
            "${msg_theme}" \
            "${CLR_RESET}"
    fi

    return "${resultat}"
}

# -----------------------------------------------------------------------------
# afficher_score
# Affiche le score final et un message d'encouragement ou de félicitations.
# -----------------------------------------------------------------------------
afficher_score() {
    local separateur
    separateur="$(printf '%0.s─' $(seq 1 60))"

    printf "%s%s%s\n" "${CLR_CYAN}" "${separateur}" "${CLR_RESET}"
    printf "%s  Score : %s%d / %d%s\n" \
        "${CLR_GRAS}" \
        "${CLR_JAUNE}${CLR_GRAS}" \
        "${SCORE}" \
        "${TOTAL}" \
        "${CLR_RESET}"

    if [[ "${SCORE}" -eq "${TOTAL}" ]] && [[ "${TOTAL}" -gt 0 ]]; then
        printf "\n  %s%s%s\n" \
            "${CLR_VERT}${CLR_GRAS}" \
            "${MSG_FELICITATIONS}" \
            "${CLR_RESET}"
    else
        printf "\n  %s%s%s\n" \
            "${CLR_JAUNE}" \
            "${MSG_ENCOURAGEMENT}" \
            "${CLR_RESET}"
    fi

    printf "%s%s%s\n\n" "${CLR_CYAN}" "${separateur}" "${CLR_RESET}"
}

# -----------------------------------------------------------------------------
# verifier_git_installe
# Vérifie que la commande git est disponible dans le PATH.
# Retourne 0 si git est trouvé, 1 sinon.
# -----------------------------------------------------------------------------
verifier_git_installe() {
    if command -v git > /dev/null 2>&1; then
        printf "%sgit est installé (%s).%s\n" \
            "${CLR_VERT}" \
            "$(git --version)" \
            "${CLR_RESET}"
        return 0
    else
        printf "%sErreur : git n'est pas installé ou absent du PATH.%s\n" \
            "${CLR_ROUGE}" \
            "${CLR_RESET}" >&2
        return 1
    fi
}

# -----------------------------------------------------------------------------
# verifier_dans_repo
# Vérifie que le répertoire courant est à l'intérieur d'un dépôt git.
# Retourne 0 si on est dans un repo, 1 sinon.
# -----------------------------------------------------------------------------
verifier_dans_repo() {
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        local racine
        racine="$(git rev-parse --show-toplevel 2>/dev/null)"
        printf "%sRépositoire détecté : %s%s\n" \
            "${CLR_VERT}" \
            "${racine}" \
            "${CLR_RESET}"
        return 0
    else
        printf "%sErreur : ce répertoire n'est pas dans un dépôt git.%s\n" \
            "${CLR_ROUGE}" \
            "${CLR_RESET}" >&2
        return 1
    fi
}
