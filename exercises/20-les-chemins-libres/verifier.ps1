# =============================================================================
# Quête 20 - Les Chemins Libres - Script de vérification
# Projet  : Les Chroniques du Versionneur
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\verifier-common.ps1"

$script:QueteTitre = "Quête 20 - Les Chemins Libres"
Afficher-Banniere $script:QueteTitre

# ---- Étape 1 : Est-on dans un dépôt Git ? ----
Verifier-Etape 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Étape 2 : Le fichier mon-parcours.txt existe ----
Verifier-Etape 2 "Le fichier mon-parcours.txt existe" {
    Test-Path "mon-parcours.txt"
}

# ---- Étape 3 : Le fichier est suivi par Git ----
Verifier-Etape 3 "Le fichier mon-parcours.txt est suivi par Git" {
    $result = & git ls-files --error-unmatch "mon-parcours.txt" 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Étape 4 : Au moins un commit a été créé ----
Verifier-Etape 4 "Au moins un commit a été créé" {
    $result = & git log --oneline -1 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Étape 5 : Au moins un tag existe ----
Verifier-Etape 5 "Au moins un tag existe" {
    $tags = & git tag -l 2>&1
    $LASTEXITCODE -eq 0 -and $null -ne $tags -and ($tags | Measure-Object).Count -ge 1
}

Afficher-Score

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
