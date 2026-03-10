# SPDX-License-Identifier: MIT
# =============================================================================
# Quête 13 - Les Sceaux Magiques - Verification script
# Project : Git Chronicles (Les Chroniques du Versionneur)
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptDir\..\..\lib\common.ps1"
_Parse-LangFlag $args
_Load-ThemeMessages

$script:QuestTitle = "Quête 13 - Les Sceaux Magiques"
Show-Banner $script:QuestTitle

# ---- Step 1 : Est-on dans un dépôt Git ? ----
Check-Step 1 "Tu es dans un dépôt Git" {
    $result = & git rev-parse --is-inside-work-tree 2>&1
    $LASTEXITCODE -eq 0
}

# ---- Step 2 : Au moins 2 tags existent ----
Check-Step 2 "Au moins 2 tags existent" {
    $tags = & git tag 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    ($tags | Measure-Object).Count -ge 2
}

# ---- Step 3 : Au moins un tag annoté existe ----
Check-Step 3 "Au moins un tag annoté existe" {
    $tags = & git tag 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    $found = $false
    foreach ($t in $tags) {
        $tagType = & git cat-file -t $t.Trim() 2>&1
        if ($LASTEXITCODE -eq 0 -and $tagType.Trim() -eq "tag") {
            $found = $true
            break
        }
    }
    $found
}

# ---- Step 4 : Les tags suivent le format de versionnage (v*) ----
Check-Step 4 "Les tags suivent le format de versionnage (v*)" {
    $tags = & git tag 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    $found = $false
    foreach ($t in $tags) {
        if ($t.Trim() -match "^v\d+\.\d+\.\d+$") {
            $found = $true
            break
        }
    }
    $found
}

Show-Score
