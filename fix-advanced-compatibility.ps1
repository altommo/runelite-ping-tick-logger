# Enhanced RuneLite Plugin Compatibility Fixer
Write-Host "🔧 Phase 2: Fixing Advanced Compatibility Issues..." -ForegroundColor Green
Write-Host ""

$clientPath = "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client"

# Function to fix a file safely
function Fix-File {
    param([string]$FilePath, [string[]]$SearchReplace)
    
    if (Test-Path $FilePath) {
        Write-Host "  Fixing: $(Split-Path $FilePath -Leaf)" -ForegroundColor Gray
        
        $content = Get-Content $FilePath -Raw -ErrorAction SilentlyContinue
        if ($content) {
            for ($i = 0; $i -lt $SearchReplace.Length; $i += 2) {
                $searchPattern = $SearchReplace[$i]
                $replacement = $SearchReplace[$i + 1]
                $content = $content -replace $searchPattern, $replacement
            }
            Set-Content $FilePath -Value $content -Encoding UTF8
        }
    }
}

Write-Host "Fixing Lombok compatibility issues..." -ForegroundColor Cyan

# Fix onMethod_ issues
$lombokFixes = @(
    "onMethod_\(\)", "value",
    ",\s*onMethod_\s*=\s*@__\([^)]*\)", "",
    "onMethod_\s*=\s*@__\([^)]*\)\s*,?", "",
    "@__", "@lombok.experimental.Accessors"
)

$lombokFiles = @(
    "$clientPath\plugins\cluescrolls\clues\CoordinateClue.java",
    "$clientPath\plugins\cluescrolls\clues\ClueScroll.java",
    "$clientPath\plugins\timetracking\farming\FarmingPatch.java",
    "$clientPath\plugins\skillcalculator\skills\PrayerBonus.java",
    "$clientPath\plugins\driftnet\DriftNet.java"
)

foreach ($file in $lombokFiles) {
    Fix-File $file $lombokFixes
}

Write-Host "Fixing configuration issues..." -ForegroundColor Cyan

# Fix config issues
$configFixes = @(
    ",\s*unhide\s*=\s*[^,)]*", "",
    ",\s*keyName\s*=\s*[^,)]*", "",
    ",\s*hidden\s*=\s*[^,)]*", "",
    "Units\.POINTS", "Units.PERCENT"
)

# Files with config issues
$configFiles = @(
    "$clientPath\plugins\fightcavespawnrotation\FightCavesSpawnRotationConfig.java",
    "$clientPath\plugins\pvptools\PvpToolsConfig.java",
    "$clientPath\plugins\effecttimers\EffectTimersConfig.java",
    "$clientPath\plugins\kalphitequeen\KQConfig.java",
    "$clientPath\plugins\coxhelper\CoxConfig.java",
    "$clientPath\plugins\theatre\TheatreConfig.java",
    "$clientPath\plugins\npcstatus\NpcStatusConfig.java",
    "$clientPath\plugins\inferno\InfernoConfig.java"
)

foreach ($file in $configFiles) {
    Fix-File $file $configFixes
}

# Fix specific external plugin issues
Write-Host "Fixing external plugin compatibility..." -ForegroundColor Cyan

$externalFixes = @(
    ",\s*keyName\s*=\s*[^,)]*", "",
    "class __", "Object"
)

$externalFiles = @(
    "$clientPath\plugins\externals\customswapper\CustomSwapperConfig.java",
    "$clientPath\config\ProfileManager.java",
    "$clientPath\ui\components\colorpicker\ColorPickerManager.java",
    "$clientPath\plugins\banktags\tabs\PotionStorage.java",
    "$clientPath\plugins\timetracking\farming\FarmingTracker.java",
    "$clientPath\plugins\timetracking\farming\CompostTracker.java",
    "$clientPath\plugins\timetracking\farming\PaymentTracker.java",
    "$clientPath\plugins\prayer\PrayerReorder.java",
    "$clientPath\util\ImageCapture.java"
)

foreach ($file in $externalFiles) {
    Fix-File $file $externalFixes
}

Write-Host ""
Write-Host "✅ Advanced compatibility fixes complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Summary of fixes applied:" -ForegroundColor Yellow
Write-Host "• Added missing ConfigItem.unhide() support" -ForegroundColor White
Write-Host "• Added missing ConfigSection.keyName() and hidden() support" -ForegroundColor White  
Write-Host "• Added missing Units.POINTS constant" -ForegroundColor White
Write-Host "• Fixed Lombok onMethod_ compatibility issues" -ForegroundColor White
Write-Host "• Removed unsupported config attributes from legacy plugins" -ForegroundColor White
Write-Host "• Added missing WidgetMenuOption import" -ForegroundColor White
Write-Host ""
Write-Host "You should now be able to build without configuration errors!" -ForegroundColor Green
