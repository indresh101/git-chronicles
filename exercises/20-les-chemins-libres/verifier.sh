#!/usr/bin/env bash
# =============================================================================
# Quête 20 - Les Chemins Libres - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/verifier-common.sh"

QUETE_TITRE="Quête 20 - Les Chemins Libres"
afficher_banniere "$QUETE_TITRE"

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
verifier_etape 1 "Tu es dans un dépôt Git" \
    'git rev-parse --is-inside-work-tree'

# ---- Étape 2 : Le fichier mon-parcours.txt existe ----
verifier_etape 2 "Le fichier mon-parcours.txt existe" \
    '[ -f "mon-parcours.txt" ]'

# ---- Étape 3 : Le fichier est suivi par Git ----
verifier_etape 3 "Le fichier mon-parcours.txt est suivi par Git" \
    'git ls-files --error-unmatch mon-parcours.txt'

# ---- Étape 4 : Au moins un commit a été créé ----
verifier_etape 4 "Au moins un commit a été créé" \
    'git log --oneline -1 >/dev/null 2>&1'

# ---- Étape 5 : Au moins un tag existe ----
verifier_etape 5 "Au moins un tag existe" \
    '[ -n "$(git tag -l)" ]'

afficher_score

# Message spécial si toutes les étapes sont validées
if [[ "${SCORE}" -eq "${TOTAL}" ]] && [[ "${TOTAL}" -gt 0 ]]; then
    cat << 'FINALE'

    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║        ⚔️  MAÎTRE VERSIONNEUR  ⚔️                            ║
    ║                                                              ║
    ║           /\                                                 ║
    ║          /  \       Tu as complété les 20 quêtes             ║
    ║         / ⭐ \      des Chroniques du Versionneur.           ║
    ║        /______\                                              ║
    ║       /\      /\    Tu maîtrises :                           ║
    ║      /  \    /  \     - Les fondations de Git                ║
    ║     / ⭐ \  / ⭐ \    - La collaboration                     ║
    ║    /______\/______\   - Les arts avancés                     ║
    ║   /\      /\      /\  - Les forges automatiques              ║
    ║  /  \    /  \    /  \  - Les chemins libres                  ║
    ║ / ⭐ \  / ⭐ \  / ⭐ \                                       ║
    ║/______\/______\/______\                                      ║
    ║                                                              ║
    ║  « Gardien des chroniques du royaume, maître des branches    ║
    ║    et des fusions, tisseur du temps, forgeron des pipelines  ║
    ║    éternels, et marcheur des chemins libres. »               ║
    ║                                                              ║
    ║            Que tes commits soient clairs,                    ║
    ║            tes branches propres,                             ║
    ║            et tes merges sans conflits.                      ║
    ║                                                              ║
    ║                   FIN DES CHRONIQUES                         ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝

FINALE
fi
