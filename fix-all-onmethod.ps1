# Search for all files with onMethod_ and fix them
$files = Get-ChildItem -Path "C:\Users\hp\Development\runelite\runelite-client\src\main\java" -Recurse -Include "*.java" | 
    Where-Object { (Get-Content $_.FullName -Raw) -match "onMethod_" }

Write-Host "Found files with onMethod_:"
$files | ForEach-Object { Write-Host $_.FullName }

foreach ($file in $files) {
    Write-Host "Fixing $($file.FullName)"
    $content = Get-Content $file.FullName -Raw
    
    # Replace all variations of onMethod_
    $content = $content -replace '@Getter\(onMethod_ = \{@[^}]+\}\)', '@Getter'
    $content = $content -replace '@Getter\(onMethod_ = @[^,)]+,\s*([^)]+)\)', '@Getter($1)'
    $content = $content -replace '@Getter\(onMethod_ = @[^,)]+\)', '@Getter'
    $content = $content -replace ',\s*onMethod_ = \{@[^}]+\}', ''
    $content = $content -replace ',\s*onMethod_ = @[^,)]+', ''
    $content = $content -replace 'onMethod_ = \{@[^}]+\},\s*', ''
    $content = $content -replace 'onMethod_ = @[^,)]+,\s*', ''
    
    Set-Content $file.FullName -Value $content -NoNewline
    Write-Host "Fixed $($file.FullName)"
}

Write-Host "Completed fixing all onMethod_ issues"
