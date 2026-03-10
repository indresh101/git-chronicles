# SPDX-License-Identifier: MIT
# =============================================================================
# verifier.ps1 - Quête 02 : Les Trois Salles du Savoir
# Project : Git Chronicles (Les Chroniques du Versionneur)
# Verifies that the apprentice understands le flux Working Dir → Staging Area
# =============================================================================

# Load shared functions
. "$PSScriptRoot\..\..\lib\common.ps1"
_Parse-LangFlag $args
_Load-ThemeMessages

# Quest title
$script:QuestTitle = "Quête 02 - Les Trois Salles du Savoir"
Show-Banner -Title $script:QuestTitle

# ── Step 1 : On est dans un dépôt git ──────────────────────────────────────
Check-Step -Number 1 `
    -Description "Tu te trouves dans un dépôt git (git init a été fait)" `
    -TestCommand {
        $result = & git rev-parse --is-inside-work-tree 2>&1
        return ($LASTEXITCODE -eq 0)
    }

# ── Step 2 : Le fichier parchemin.txt existe ───────────────────────────────
Check-Step -Number 2 `
    -Description "Le fichier parchemin.txt existe dans la Salle de Travail" `
    -TestCommand {
        return (Test-Path "parchemin.txt")
    }

# ── Step 3 : parchemin.txt est dans le staging area ────────────────────────
Check-Step -Number 3 `
    -Description "parchemin.txt est dans la Salle de Préparation (staging area)" `
    -TestCommand {
        $staged = & git diff --cached --name-only 2>&1
        return ($staged -match "parchemin\.txt")
    }

# ── Step 4 : Pas encore de commit (pas de HEAD valide) ─────────────────────
Check-Step -Number 4 `
    -Description "Aucun parchemin n'a encore été scellé (pas de commit)" `
    -TestCommand {
        & git rev-parse HEAD 2>&1 | Out-Null
        return ($LASTEXITCODE -ne 0)
    }

# ── Score final ──────────────────────────────────────────────────────────────
Show-Score
