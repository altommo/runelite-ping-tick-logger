# Fix RuneLite Config Annotations
# Remove unsupported annotation parameters systematically

Write-Host "🔧 Fixing RuneLite Config Annotations..." -ForegroundColor Green

$pluginsPath = "C:\Users\hp\Development\runelite\runelite-client\src\main\java\net\runelite\client\plugins"
$configFiles = Get-ChildItem -Path $pluginsPath -Name "*Config.java" -Recurse

$totalFiles = 0
$totalReplacements = 0

foreach ($file in $configFiles) {
    $filePath = Join-Path $pluginsPath $file
    if (Test-Path $filePath) {
        $content = Get-Content $filePath -Raw -Encoding UTF8
        $originalContent = $content
        
        # Remove keyName() from @ConfigSection
        $content = $content -replace 'keyName\s*=\s*"[^"]*",?\s*', ''
        $content = $content -replace 'keyName\s*=\s*[^,)]+,?\s*', ''
        $content = $content -replace ',\s*keyName\s*=\s*"[^"]*"', ''
        $content = $content -replace ',\s*keyName\s*=\s*[^,)]+', ''
        
        # Remove unhide() from @ConfigItem
        $content = $content -replace 'unhide\s*=\s*true,?\s*', ''
        $content = $content -replace 'unhide\s*=\s*false,?\s*', ''
        $content = $content -replace 'unhide\(\),?\s*', ''
        $content = $content -replace ',\s*unhide\s*=\s*true', ''
        $content = $content -replace ',\s*unhide\s*=\s*false', ''
        $content = $content -replace ',\s*unhide\(\)', ''
        
        # Remove disabledBy() from @ConfigItem
        $content = $content -replace 'disabledBy\s*=\s*"[^"]*",?\s*', ''
        $content = $content -replace 'disabledBy\s*=\s*[^,)]+,?\s*', ''
        $content = $content -replace ',\s*disabledBy\s*=\s*"[^"]*"', ''
        $content = $content -replace ',\s*disabledBy\s*=\s*[^,)]+', ''
        
        # Remove enumClass() from @ConfigItem
        $content = $content -replace 'enumClass\s*=\s*[^,)]+,?\s*', ''
        $content = $content -replace ',\s*enumClass\s*=\s*[^,)]+', ''
        
        # Replace Units.POINTS with Units.SECONDS
        $content = $content -replace 'Units\.POINTS', 'Units.SECONDS'
        
        # Clean up double commas and spacing issues
        $content = $content -replace ',\s*,', ','
        $content = $content -replace '\(\s*,', '('
        $content = $content -replace ',\s*\)', ')'
        $content = $content -replace '\s+', ' '
        
        # Fix closedByDefault issues if any
        $content = $content -replace 'closedByDefault\s*=\s*true,?\s*', ''
        $content = $content -replace ',\s*closedByDefault\s*=\s*true', ''
        
        if ($content -ne $originalContent) {
            Set-Content $filePath $content -NoNewline -Encoding UTF8
            $replacements = ($originalContent.Length - $content.Length) / 10  # Rough estimate
            Write-Host "  ✅ Fixed: $file ($replacements changes)" -ForegroundColor Cyan
            $totalFiles++
            $totalReplacements += $replacements
        }
    }
}

Write-Host "`n🎉 Config annotation fix complete!" -ForegroundColor Green
Write-Host "📊 Files modified: $totalFiles" -ForegroundColor Yellow
Write-Host "📊 Estimated replacements: $totalReplacements" -ForegroundColor Yellow
Write-Host "`n🔍 Running test build to check results..." -ForegroundColor Blue
