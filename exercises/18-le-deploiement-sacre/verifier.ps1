# SPDX-License-Identifier: MIT
# =============================================================================
# Quête 18 - Le Déploiement Sacré - Verification script
# Project : Git Chronicles (Les Chroniques du Versionneur)
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\common.ps1"
_Parse-LangFlag $args
_Load-ThemeMessages

$script:QuestTitle = "Quête 18 - Le Déploiement Sacré"
Show-Banner $script:QuestTitle

# ---- Step 1 : Est-on dans un dépôt Git ? ----
Check-Step 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Step 2 : Le dossier .github/workflows existe avec au moins un fichier YAML ----
Check-Step 2 "Un dossier .github/workflows existe avec un workflow" {
    $workflowDir = Join-Path "." ".github/workflows"
    if (-not (Test-Path $workflowDir)) { return $false }
    $files = Get-ChildItem -Path $workflowDir -Filter "*.yml" -ErrorAction SilentlyContinue
    $filesYaml = Get-ChildItem -Path $workflowDir -Filter "*.yaml" -ErrorAction SilentlyContinue
    ($files | Measure-Object).Count + ($filesYaml | Measure-Object).Count -ge 1
}

# ---- Step 3 : Le workflow mentionne le déploiement (production ou deploy) ----
Check-Step 3 "Le workflow mentionne le déploiement (production ou deploy)" {
    $workflowDir = Join-Path "." ".github/workflows"
    if (-not (Test-Path $workflowDir)) { return $false }
    $found = $false
    $files = Get-ChildItem -Path $workflowDir -Include "*.yml","*.yaml" -Recurse -ErrorAction SilentlyContinue
    foreach ($f in $files) {
        $content = Get-Content $f.FullName -Raw
        if ($content -match "production|deploy") {
            $found = $true
            break
        }
    }
    $found
}

# ---- Step 4 : Au moins un tag existe ----
Check-Step 4 "Au moins un tag de version existe" {
    $tags = & git tag 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($tags | Measure-Object).Count -ge 1
}

Show-Score
