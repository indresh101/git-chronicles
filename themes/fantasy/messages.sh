#!/usr/bin/env bash
# =============================================================================
# messages.sh - Messages thématisés : Heroic Fantasy
# Projet  : Les Chroniques du Versionneur
# Thème   : Heroic Fantasy - Cours Git gamifié
# Auteur  : Infrastructure pédagogique
# Version : 1.0.0
#
# Ce fichier est sourcé automatiquement par verifier-common.sh.
# Il définit les variables de thème qui surclassent les messages par défaut.
#
# Compatibilité : bash 3.2+ (macOS), bash 4+ (Linux)
# Encodage       : UTF-8
# =============================================================================

# Nom du thème actif (utile pour le débogage)
THEME_NOM="fantasy"

# -----------------------------------------------------------------------------
# Messages de succès
# Chaque vérification réussie pioche un message aléatoire dans ce tableau
# pour varier l'expérience d'apprentissage et maintenir l'immersion.
# -----------------------------------------------------------------------------
MESSAGES_SUCCES=(
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
# Messages d'échec
# Chaque vérification échouée pioche un message aléatoire dans ce tableau.
# Les messages restent encourageants même en cas d'erreur.
# -----------------------------------------------------------------------------
MESSAGES_ECHEC=(
    "Le scribe refuse ce parchemin."
    "L'archive rejette cette entrée."
    "Le gardien bloque le passage."
    "La rune reste éteinte… quelque chose cloche."
    "L'Oracle secoue la tête : ce n'est pas la bonne voie."
    "La Guilde ne reconnaît pas ce geste."
    "Le parchemin se consume avant d'être scellé."
    "L'encre magique refuse de prendre."
    "Les anciens textes indiquent une erreur de rituel."
    "Le cristal de vérification reste terne."
)

# -----------------------------------------------------------------------------
# Messages globaux de fin de quête
# -----------------------------------------------------------------------------

# Affiché quand toutes les étapes sont réussies
MSG_FELICITATIONS="🎉 FÉLICITATIONS ! Tu as complété cette quête !"

# Affiché quand au moins une étape a échoué
MSG_ENCOURAGEMENT="Courage, apprenti ! Relis les consignes et réessaie."
