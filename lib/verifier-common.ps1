# =============================================================================
# verifier-common.ps1 - Fonctions partagées pour les scripts de vérification
# Projet  : Les Chroniques du Versionneur
# Thème   : Heroic Fantasy - Cours Git gamifié
# Auteur  : Infrastructure pédagogique
# Version : 1.0.0
#
# Usage   : . "$PSScriptRoot/../lib/verifier-common.ps1"
#
# Compatibilité : PowerShell 5.1+ (Windows natif) et PowerShell 7+ (cross-platform)
# Encodage       : UTF-8
# =============================================================================

# Garde contre le double chargement
if ($script:_VerifierCommonLoaded) { return }
$script:_VerifierCommonLoaded = $true

# -----------------------------------------------------------------------------
# Variables de script partagées (score, total, titre de la quête)
# -----------------------------------------------------------------------------
$script:Score       = 0
$script:Total       = 0
$script:QueteTitre  = ""

# -----------------------------------------------------------------------------
# Chargement optionnel du thème fantasy
# Chemin relatif depuis git/lib/ → git/themes/fantasy/messages.ps1
# -----------------------------------------------------------------------------
$_ThemeFile = Join-Path $PSScriptRoot "..\..\themes\fantasy\messages.ps1"

# Messages par défaut (écrasés si le thème est chargé)
$script:ThemeNom         = "defaut"
$script:MessageSucces    = @("Correct !", "Bien joué !", "Validé !", "Réussi !", "Parfait !", "Bravo !")
$script:MessageEchec     = @("Incorrect.", "Raté.", "À corriger.", "Non valide.", "Échec.", "À revoir.")
$script:MsgFelicitations = "Félicitations ! Tu as complété cette quête !"
$script:MsgEncouragement = "Courage ! Relis les consignes et réessaie."

if (Test-Path $_ThemeFile) {
    . $_ThemeFile
}

# -----------------------------------------------------------------------------
# Get-MessageAleatoire <tableau>
# Retourne un message aléatoire depuis un tableau PowerShell.
# Fonction interne, préfixée par convention privée.
# -----------------------------------------------------------------------------
function _Get-MessageAleatoire {
    param(
        [string[]]$Tableau
    )
    if ($Tableau.Count -eq 0) { return "Message indisponible." }
    $index = Get-Random -Minimum 0 -Maximum $Tableau.Count
    return $Tableau[$index]
}

# -----------------------------------------------------------------------------
# Afficher-Banniere [-Titre <string>]
# Affiche un encadré ASCII thématisé avec le titre centré.
# -----------------------------------------------------------------------------
function Afficher-Banniere {
    param(
        [string]$Titre = "Les Chroniques du Versionneur"
    )

    $largeur     = 60
    $ligneH      = "═" * $largeur
    $titreLen    = $Titre.Length
    $espaceTotal = $largeur - $titreLen - 2  # -2 pour les ║ de chaque côté
    $padGauche   = [Math]::Floor($espaceTotal / 2)
    $padDroite   = $espaceTotal - $padGauche

    Write-Host ""
    Write-Host ("╔" + $ligneH + "╗") -ForegroundColor Magenta
    Write-Host ("║" + (" " * $padGauche)) -NoNewline -ForegroundColor Magenta
    Write-Host $Titre -NoNewline -ForegroundColor Cyan
    Write-Host ((" " * $padDroite) + "║") -ForegroundColor Magenta
    Write-Host ("╚" + $ligneH + "╝") -ForegroundColor Magenta
    Write-Host ""
}

# -----------------------------------------------------------------------------
# Verifier-Etape -Numero <int> -Description <string> -CommandeTest <scriptblock>
# Exécute le bloc de script de test.
# Affiche ✅ ou ❌ selon le résultat, avec un message thématisé aléatoire.
# Incrémente $script:Total ; incrémente $script:Score en cas de succès.
# -----------------------------------------------------------------------------
function Verifier-Etape {
    param(
        [Parameter(Mandatory)]
        [int]$Numero,

        [Parameter(Mandatory)]
        [string]$Description,

        [Parameter(Mandatory)]
        [scriptblock]$CommandeTest
    )

    $script:Total++

    # Exécution silencieuse du test
    $succes = $false
    try {
        $resultat = & $CommandeTest 2>&1
        # Le test est considéré réussi si aucune exception n'est levée
        # et si le bloc retourne $true ou une valeur truthy
        if ($LASTEXITCODE -ne $null -and $LASTEXITCODE -ne 0) {
            $succes = $false
        } elseif ($resultat -is [bool]) {
            $succes = $resultat
        } elseif ($resultat -ne $null -and $resultat -ne $false -and $resultat -ne 0) {
            $succes = $true
        } else {
            $succes = $true
        }
    }
    catch {
        $succes = $false
    }

    if ($succes) {
        $script:Score++
        $msgTheme = _Get-MessageAleatoire -Tableau $script:MessageSucces
        Write-Host ("  ✅  Étape $Numero - $Description") -ForegroundColor Green
        Write-Host ("      $msgTheme") -ForegroundColor Green
        Write-Host ""
    }
    else {
        $msgTheme = _Get-MessageAleatoire -Tableau $script:MessageEchec
        Write-Host ("  ❌  Étape $Numero - $Description") -ForegroundColor Red
        Write-Host ("      $msgTheme") -ForegroundColor Red
        Write-Host ""
    }

    return $succes
}

# -----------------------------------------------------------------------------
# Afficher-Score
# Affiche le score final et un message d'encouragement ou de félicitations.
# -----------------------------------------------------------------------------
function Afficher-Score {
    $separateur = "─" * 60

    Write-Host $separateur -ForegroundColor Cyan
    Write-Host ("  Score : $($script:Score) / $($script:Total)") -ForegroundColor Yellow

    if ($script:Score -eq $script:Total -and $script:Total -gt 0) {
        Write-Host ""
        Write-Host ("  $($script:MsgFelicitations)") -ForegroundColor Green
    }
    else {
        Write-Host ""
        Write-Host ("  $($script:MsgEncouragement)") -ForegroundColor Yellow
    }

    Write-Host $separateur -ForegroundColor Cyan
    Write-Host ""
}

# -----------------------------------------------------------------------------
# Verifier-GitInstalle
# Vérifie que la commande git est disponible dans le PATH.
# Retourne $true si git est trouvé, $false sinon.
# -----------------------------------------------------------------------------
function Verifier-GitInstalle {
    $gitCmd = Get-Command git -ErrorAction SilentlyContinue
    if ($gitCmd) {
        $version = & git --version 2>&1
        Write-Host "git est installé ($version)." -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "Erreur : git n'est pas installé ou absent du PATH." -ForegroundColor Red
        return $false
    }
}

# -----------------------------------------------------------------------------
# Verifier-DansRepo
# Vérifie que le répertoire courant est à l'intérieur d'un dépôt git.
# Retourne $true si on est dans un repo, $false sinon.
# -----------------------------------------------------------------------------
function Verifier-DansRepo {
    $resultat = & git rev-parse --is-inside-work-tree 2>&1
    if ($LASTEXITCODE -eq 0) {
        $racine = & git rev-parse --show-toplevel 2>&1
        Write-Host "Répositoire détecté : $racine" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "Erreur : ce répertoire n'est pas dans un dépôt git." -ForegroundColor Red
        return $false
    }
}
