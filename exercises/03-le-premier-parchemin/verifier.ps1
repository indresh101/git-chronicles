# SPDX-License-Identifier: MIT
# =============================================================================
# Quête 03 - Le Premier Parchemin - Verification script (PowerShell)
# Project : Git Chronicles (Les Chroniques du Versionneur)
#
# Usage   : Lancer DEPUIS le dossier mon-archive/
#           ..\verifier.ps1
# =============================================================================

. "$PSScriptRoot\..\..\lib\common.ps1"
_Parse-LangFlag $args
_Load-ThemeMessages

$script:QuestTitle = "Quête 03 - Le Premier Parchemin"
Show-Banner -Title $script:QuestTitle

# --- Step 1 : On est dans un dépôt git ---
Check-Step -Number 1 -Description "Tu es dans un dépôt Git" -TestCommand {
    Check-InRepo
}

# --- Step 2 : Au moins 2 commits ---
Check-Step -Number 2 -Description "Tu as au moins 2 commits" -TestCommand {
    $count = & git rev-list --count HEAD 2>$null
    if ($LASTEXITCODE -ne 0) { return $false }
    return ([int]$count -ge 2)
}

# --- Step 3 : mission.txt est tracké ---
Check-Step -Number 3 -Description "Le fichier mission.txt est suivi par Git" -TestCommand {
    & git ls-files --error-unmatch mission.txt 2>$null | Out-Null
    return ($LASTEXITCODE -eq 0)
}

# --- Step 4 : Le premier message de commit n'est pas générique ---
Check-Step -Number 4 -Description "Ton premier commit a un message personnalisé" -TestCommand {
    $premierMsg = (& git log --reverse --format="%s" 2>$null) | Select-Object -First 1
    if ([string]::IsNullOrWhiteSpace($premierMsg)) { return $false }
    $generiques = @("Initial commit", "initial commit", "first commit", "init")
    if ($generiques -contains $premierMsg.Trim()) { return $false }
    return $true
}

Show-Score
