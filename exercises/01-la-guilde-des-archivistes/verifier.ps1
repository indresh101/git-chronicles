# =============================================================================
# Quête 01 - La Guilde des Archivistes - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\verifier-common.ps1"

$script:QueteTitre = "Quête 01 - La Guilde des Archivistes"
Afficher-Banniere $script:QueteTitre

Verifier-Etape 1 "Git est installé" { Get-Command git -ErrorAction SilentlyContinue }
Verifier-Etape 2 "Ton nom est configuré" { (git config --global user.name) -ne $null -and (git config --global user.name) -ne "" }
Verifier-Etape 3 "Ton email est configuré" { (git config --global user.email) -ne $null -and (git config --global user.email) -ne "" }

Afficher-Score
