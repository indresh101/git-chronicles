# SPDX-License-Identifier: MIT
# =============================================================================
# Quête 07 - Le Conflit des Royaumes - Verification script
# Project : Git Chronicles (Les Chroniques du Versionneur)
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\common.ps1"
_Parse-LangFlag $args
_Load-ThemeMessages

$script:QuestTitle = "Quête 07 - Le Conflit des Royaumes"
Show-Banner $script:QuestTitle

# ---- Step 1 : Est-on dans un dépôt Git ? ----
Check-Step 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Step 2 : Un commit de merge existe dans l'historique ----
Check-Step 2 "Un merge a été effectué (commit de merge présent)" {
    $count = & git rev-list --merges --count HEAD 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    [int]$count -ge 1
}

# ---- Step 3 : Pas de marqueurs de conflit dans les fichiers trackés ----
Check-Step 3 "Aucun marqueur de conflit ne reste dans les fichiers" {
    $trackedFiles = & git ls-files 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    foreach ($file in $trackedFiles) {
        if ($file -match '\.(sh|ps1|md)$') { continue }
        if (-not (Test-Path $file)) { continue }
        $contenu = Get-Content $file -Raw -ErrorAction SilentlyContinue
        if ($contenu -match '<<<<<<< |=======|>>>>>>> ') {
            return $false
        }
    }
    $true
}

# ---- Step 4 : Pas de merge en cours (pas de MERGE_HEAD) ----
Check-Step 4 "Aucun merge n'est en cours (pas de conflit non résolu)" {
    $gitDir = & git rev-parse --git-dir 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    -not (Test-Path (Join-Path $gitDir "MERGE_HEAD"))
}

# ---- Step 5 : Le commit de merge a un message descriptif ----
Check-Step 5 "Le dernier commit de merge a un message descriptif (>= 10 caractères)" {
    $msg = & git log --merges -1 --format="%s" 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    $msg.Length -ge 10
}

Show-Score
