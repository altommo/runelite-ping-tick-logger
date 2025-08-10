Write-Host "Fixing ALL config annotation issues..." -ForegroundColor Green

# List of config files that need fixing based on the error output
$configFiles = @(
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\externals\customswapper\CustomSwapperConfig.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\kalphitequeen\KQConfig.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\coxhelper\CoxConfig.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\theatre\TheatreConfig.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\fightcavespawnrotation\FightCavesSpawnRotationConfig.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\pvptools\PvpToolsConfig.java",
    "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins\effecttimers\EffectTimersConfig.java"
)

$totalFixed = 0

foreach ($filePath in $configFiles) {
    if (Test-Path $filePath) {
        Write-Host "Processing: $([System.IO.Path]::GetFileName($filePath))"
        
        $content = Get-Content $filePath -Raw
        $originalLength = $content.Length
        
        # Remove keyName parameters
        $content = $content -replace ',\s*keyName\s*=\s*"[^"]*"', ''
        $content = $content -replace 'keyName\s*=\s*"[^"]*",\s*', ''
        $content = $content -replace '\s*keyName\s*=\s*"[^"]*",', ','
        
        # Remove unhide parameters  
        $content = $content -replace ',\s*unhide\s*=\s*(true|false)', ''
        $content = $content -replace 'unhide\s*=\s*(true|false),\s*', ''
        $content = $content -replace '\s*unhide\s*=\s*(true|false),', ','
        
        # Remove disabledBy parameters
        $content = $content -replace ',\s*disabledBy\s*=\s*"[^"]*"', ''
        $content = $content -replace 'disabledBy\s*=\s*"[^"]*",\s*', ''
        $content = $content -replace '\s*disabledBy\s*=\s*"[^"]*",', ','
        
        # Remove enumClass parameters
        $content = $content -replace ',\s*enumClass\s*=\s*[^,)]+', ''
        $content = $content -replace 'enumClass\s*=\s*[^,)]+,\s*', ''
        
        # Replace Units.POINTS with Units.SECONDS
        $content = $content -replace 'Units\.POINTS', 'Units.SECONDS'
        
        # Clean up spacing and commas
        $content = $content -replace ',\s*,', ','
        $content = $content -replace '\(\s*,', '('
        $content = $content -replace ',\s*\)', ')'
        
        if ($content.Length -ne $originalLength) {
            Set-Content $filePath $content -NoNewline -Encoding UTF8
            Write-Host "  ✅ Fixed!" -ForegroundColor Green
            $totalFixed++
        } else {
            Write-Host "  ➡️ No changes needed" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  ❌ File not found: $filePath" -ForegroundColor Red
    }
}

Write-Host "`n🎉 Config annotation fix complete!" -ForegroundColor Green
Write-Host "📊 Files fixed: $totalFixed" -ForegroundColor Yellow
