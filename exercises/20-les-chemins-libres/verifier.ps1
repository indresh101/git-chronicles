# SPDX-License-Identifier: MIT
# =============================================================================
# Quête 20 - Les Chemins Libres - Verification script
# Project : Git Chronicles (Les Chroniques du Versionneur)
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\common.ps1"
_Parse-LangFlag $args
_Load-ThemeMessages

$script:QuestTitle = "Quête 20 - Les Chemins Libres"
Show-Banner $script:QuestTitle

# ---- Step 1 : Est-on dans un dépôt Git ? ----
Check-Step 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Step 2 : Le fichier mon-parcours.txt existe ----
Check-Step 2 "Le fichier mon-parcours.txt existe" {
    Test-Path "mon-parcours.txt"
}

# ---- Step 3 : Le fichier est suivi par Git ----
Check-Step 3 "Le fichier mon-parcours.txt est suivi par Git" {
    $result = & git ls-files --error-unmatch "mon-parcours.txt" 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Step 4 : Au moins un commit a été créé ----
Check-Step 4 "Au moins un commit a été créé" {
    $result = & git log --oneline -1 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Step 5 : Au moins un tag existe ----
Check-Step 5 "Au moins un tag existe" {
    $tags = & git tag -l 2>&1
    $LASTEXITCODE -eq 0 -and $null -ne $tags -and ($tags | Measure-Object).Count -ge 1
}

Show-Score

# Message spécial si toutes les étapes sont validées
if ($script:Score -eq $script:Total -and $script:Total -gt 0) {
    Write-Host ""
    Write-Host "    ╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
    Write-Host "    ║                                                              ║" -ForegroundColor Yellow
    Write-Host "    ║        ⚔️  MAÎTRE VERSIONNEUR  ⚔️                            ║" -ForegroundColor Yellow
    Write-Host "    ║                                                              ║" -ForegroundColor Yellow
    Write-Host "    ║           /\                                                 ║" -ForegroundColor Yellow
    Write-Host "    ║          /  \       Tu as complété les 20 quêtes             ║" -ForegroundColor Yellow
    Write-Host "    ║         / ⭐ \      des Chroniques du Versionneur.           ║" -ForegroundColor Yellow
    Write-Host "    ║        /______\                                              ║" -ForegroundColor Yellow
    Write-Host "    ║       /\      /\    Tu maîtrises :                           ║" -ForegroundColor Yellow
    Write-Host "    ║      /  \    /  \     - Les fondations de Git                ║" -ForegroundColor Yellow
    Write-Host "    ║     / ⭐ \  / ⭐ \    - La collaboration                     ║" -ForegroundColor Yellow
    Write-Host "    ║    /______\/______\   - Les arts avancés                     ║" -ForegroundColor Yellow
    Write-Host "    ║   /\      /\      /\  - Les forges automatiques              ║" -ForegroundColor Yellow
    Write-Host "    ║  /  \    /  \    /  \  - Les chemins libres                  ║" -ForegroundColor Yellow
    Write-Host "    ║ / ⭐ \  / ⭐ \  / ⭐ \                                       ║" -ForegroundColor Yellow
    Write-Host "    ║/______\/______\/______\                                      ║" -ForegroundColor Yellow
    Write-Host "    ║                                                              ║" -ForegroundColor Yellow
    Write-Host "    ║  « Gardien des chroniques du royaume, maître des branches    ║" -ForegroundColor Yellow
    Write-Host "    ║    et des fusions, tisseur du temps, forgeron des pipelines  ║" -ForegroundColor Yellow
    Write-Host "    ║    éternels, et marcheur des chemins libres. »               ║" -ForegroundColor Yellow
    Write-Host "    ║                                                              ║" -ForegroundColor Yellow
    Write-Host "    ║            Que tes commits soient clairs,                    ║" -ForegroundColor Yellow
    Write-Host "    ║            tes branches propres,                             ║" -ForegroundColor Yellow
    Write-Host "    ║            et tes merges sans conflits.                      ║" -ForegroundColor Yellow
    Write-Host "    ║                                                              ║" -ForegroundColor Yellow
    Write-Host "    ║                   FIN DES CHRONIQUES                         ║" -ForegroundColor Yellow
    Write-Host "    ╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
    Write-Host ""
}
