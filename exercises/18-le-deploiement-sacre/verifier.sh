# SPDX-License-Identifier: MIT
#!/usr/bin/env bash
# =============================================================================
# Quête 18 - Le Déploiement Sacré - Verification script
# Project : Git Chronicles (Les Chroniques du Versionneur)
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"
_parse_lang_flag "$@"
_load_theme_messages

QUEST_TITLE="Quête 18 - Le Déploiement Sacré"
show_banner "$QUEST_TITLE"

# ---- Step 1 : Est-on dans un dépôt Git ? ----
check_step 1 "Tu es dans un dépôt Git" \
    'git rev-parse --is-inside-work-tree'

# ---- Step 2 : Le dossier .github/workflows existe avec au moins un fichier YAML ----
check_step 2 "Un dossier .github/workflows existe avec un workflow" \
    'ls .github/workflows/*.yml .github/workflows/*.yaml 2>/dev/null | grep -q .'

# ---- Step 3 : Le workflow mentionne le déploiement (production ou deploy) ----
check_step 3 "Le workflow mentionne le déploiement (production ou deploy)" \
    'grep -rqlE "production|deploy" .github/workflows/ 2>/dev/null'

# ---- Step 4 : Au moins un tag existe ----
check_step 4 "Au moins un tag de version existe" \
    '[ "$(git tag | wc -l)" -ge 1 ]'

show_score
