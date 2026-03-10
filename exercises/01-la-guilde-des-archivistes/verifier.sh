# SPDX-License-Identifier: MIT
#!/usr/bin/env bash
# =============================================================================
# Quête 01 - La Guilde des Archivistes - Verification script
# Project : Git Chronicles (Les Chroniques du Versionneur)
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"
_parse_lang_flag "$@"
_load_theme_messages

QUEST_TITLE="Quête 01 - La Guilde des Archivistes"
show_banner "$QUEST_TITLE"

check_step 1 "Git est installé" 'command -v git >/dev/null 2>&1'
check_step 2 "Ton nom est configuré" '[ -n "$(git config --global user.name)" ]'
check_step 3 "Ton email est configuré" '[ -n "$(git config --global user.email)" ]'

show_score
