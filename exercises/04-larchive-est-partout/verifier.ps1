# =============================================================================
# Quete 04 - L'Archive est Partout - Script de verification
# Projet  : Les Chroniques du Versionneur
#
# Usage   : .\verifier.ps1 [-Chemin <dossier_parent>]
#           Si aucun chemin n'est fourni, utilise le répertoire courant.
# =============================================================================

param(
    [string]$Chemin = "."
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\verifier-common.ps1"

$script:QueteTitre = "Quete 04 - L'Archive est Partout"
Afficher-Banniere $script:QueteTitre

# Resoudre le chemin absolu
$WorkDir = Resolve-Path -Path $Chemin -ErrorAction SilentlyContinue
if (-not $WorkDir) {
    Write-Host "Erreur : le dossier '$Chemin' n'existe pas." -ForegroundColor Red
    exit 1
}
$WorkDir = $WorkDir.Path

Write-Host "  Dossier analyse : $WorkDir" -ForegroundColor Cyan
Write-Host ""

# ---- Étape 1 : ma-copie/ existe et c'est un repo git ----
Verifier-Etape 1 "ma-copie/ existe et c'est un repo Git" {
    Test-Path (Join-Path $WorkDir "ma-copie\.git") -PathType Container
}

# ---- Étape 2 : ma-copie a une remote origin vers un chemin local ----
Verifier-Etape 2 "ma-copie/ a une remote origin vers un chemin local" {
    $configPath = Join-Path $WorkDir "ma-copie\.git\config"
    if (-not (Test-Path $configPath)) { return $false }
    $content = Get-Content $configPath -Raw
    if ($content -match "url\s*=\s*") {
        # Verifier que ce n'est PAS une URL distante
        if ($content -match "url\s*=\s*http" -or $content -match "url\s*=\s*git@") {
            return $false
        }
        return $true
    }
    return $false
}

# ---- Étape 3 : archive-centrale.git/ est un bare repo ----
Verifier-Etape 3 "archive-centrale.git/ existe et c'est un bare repo" {
    $barePath = Join-Path $WorkDir "archive-centrale.git"
    $hasHead    = Test-Path (Join-Path $barePath "HEAD") -PathType Leaf
    $hasObjects = Test-Path (Join-Path $barePath "objects") -PathType Container
    $hasRefs    = Test-Path (Join-Path $barePath "refs") -PathType Container
    $noGitDir   = -not (Test-Path (Join-Path $barePath ".git") -PathType Container)
    $hasHead -and $hasObjects -and $hasRefs -and $noGitDir
}

# ---- Étape 4 : clone-depuis-bare/ existe et c'est un repo git ----
Verifier-Etape 4 "clone-depuis-bare/ existe et c'est un repo Git" {
    Test-Path (Join-Path $WorkDir "clone-depuis-bare\.git") -PathType Container
}

Afficher-Score
