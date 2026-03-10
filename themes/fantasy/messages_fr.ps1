# SPDX-License-Identifier: MIT
# =============================================================================
# messages_fr.ps1 - Themed messages: Heroic Fantasy (French)
# Project : Git Chronicles (Les Chroniques du Versionneur)
# Theme   : Heroic Fantasy - Gamified Git course
# Version : 2.0.0
#
# This file is sourced automatically by common.ps1 via dot-sourcing.
# It defines theme variables that override the default messages.
#
# Compatibility : PowerShell 5.1+ (Windows native) and PowerShell 7+ (cross-platform)
# Encoding      : UTF-8
# =============================================================================

# Active theme name (useful for debugging)
$script:ThemeName = "fantasy"

# -----------------------------------------------------------------------------
# Success messages
# Each successful check picks a random message from this array
# to vary the learning experience and maintain immersion.
# -----------------------------------------------------------------------------
$script:MessagesSuccess = @(
    "Le parchemin est scellé !"
    "L'archiviste approuve !"
    "Le scribe valide ton travail !"
    "La rune s'illumine !"
    "Le Gardien du Code s'incline devant toi."
    "L'Oracle confirme : la voie est juste."
    "Ton sort a pris effet, apprenti !"
    "La Guilde des Versionneurs salue ton geste."
    "L'encre magique a bien pris sur le parchemin."
    "Bien forgé, brave apprenti !"
)

# -----------------------------------------------------------------------------
# Failure messages
# Each failed check picks a random message from this array.
# Messages remain encouraging even on error.
# -----------------------------------------------------------------------------
$script:MessagesFailure = @(
    "Le scribe refuse ce parchemin."
    "L'archive rejette cette entrée."
    "Le gardien bloque le passage."
    "La rune reste éteinte... quelque chose cloche."
    "L'Oracle secoue la tête : ce n'est pas la bonne voie."
    "La Guilde ne reconnaît pas ce geste."
    "Le parchemin se consume avant d'être scellé."
    "L'encre magique refuse de prendre."
    "Les anciens textes indiquent une erreur de rituel."
    "Le cristal de vérification reste terne."
)

# -----------------------------------------------------------------------------
# End-of-quest global messages
# -----------------------------------------------------------------------------

# Displayed when all steps are successful
$script:MsgCongratulations = "Félicitations ! Tu as complété cette quête !"

# Displayed when at least one step has failed
$script:MsgEncouragement = "Courage, apprenti ! Relis les consignes et réessaie."
