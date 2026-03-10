# SPDX-License-Identifier: MIT
# =============================================================================
# Quête 01 - La Guilde des Archivistes - Verification script
# Project : Git Chronicles (Les Chroniques du Versionneur)
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\common.ps1"
_Parse-LangFlag $args
_Load-ThemeMessages

$script:QuestTitle = "Quête 01 - La Guilde des Archivistes"
Show-Banner $script:QuestTitle

Check-Step 1 "Git est installé" { Get-Command git -ErrorAction SilentlyContinue }
Check-Step 2 "Ton nom est configuré" { (git config --global user.name) -ne $null -and (git config --global user.name) -ne "" }
Check-Step 3 "Ton email est configuré" { (git config --global user.email) -ne $null -and (git config --global user.email) -ne "" }

Show-Score
