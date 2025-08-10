param()

Write-Host "🚀 RuneLite Build with Console AND File Logging" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "C:\Users\hp\Development\runelite"

# Generate timestamp
$timestamp = Get-Date -Format "MMdd_HHmm"
$logFile = "build_$timestamp.log"

Write-Host "Starting build at $(Get-Date)" -ForegroundColor Green
Write-Host "Logging to: $logFile" -ForegroundColor Green
Write-Host ""

# Initialize log file
"===============================================" | Out-File -FilePath $logFile -Encoding UTF8
"RuneLite Build Log - $(Get-Date)" | Out-File -FilePath $logFile -Encoding UTF8 -Append
"===============================================" | Out-File -FilePath $logFile -Encoding UTF8 -Append
"" | Out-File -FilePath $logFile -Encoding UTF8 -Append

# Function to run command with dual logging
function Invoke-WithLogging {
    param(
        [string]$Command,
        [string]$Phase
    )
    
    Write-Host "[$Phase] $Command" -ForegroundColor Yellow
    "[$Phase] $Command" | Out-File -FilePath $logFile -Encoding UTF8 -Append
    Write-Host ""
    
    $process = Start-Process -FilePath "cmd" -ArgumentList "/c", $Command -PassThru -NoNewWindow -RedirectStandardOutput "temp_output.txt" -RedirectStandardError "temp_error.txt" -Wait
    
    # Read and display/log output
    if (Test-Path "temp_output.txt") {
        $output = Get-Content "temp_output.txt"
        foreach ($line in $output) {
            Write-Host $line
            $line | Out-File -FilePath $logFile -Encoding UTF8 -Append
        }
        Remove-Item "temp_output.txt" -ErrorAction SilentlyContinue
    }
    
    # Read and display/log errors
    if (Test-Path "temp_error.txt") {
        $errors = Get-Content "temp_error.txt"
        foreach ($line in $errors) {
            Write-Host $line -ForegroundColor Red
            $line | Out-File -FilePath $logFile -Encoding UTF8 -Append
        }
        Remove-Item "temp_error.txt" -ErrorAction SilentlyContinue
    }
    
    return $process.ExitCode
}

try {
    # Phase 1: Clean
    Write-Host "[PHASE 1] MAVEN CLEAN" -ForegroundColor Magenta
    Write-Host "===================" -ForegroundColor Magenta
    
    $exitCode = Invoke-WithLogging -Command "mvn clean" -Phase "CLEAN"
    
    if ($exitCode -ne 0) {
        Write-Host ""
        Write-Host "❌ CLEAN FAILED!" -ForegroundColor Red
        "❌ CLEAN FAILED!" | Out-File -FilePath $logFile -Encoding UTF8 -Append
        exit $exitCode
    }
    
    Write-Host ""
    Write-Host "✅ Clean completed successfully" -ForegroundColor Green
    "✅ Clean completed successfully" | Out-File -FilePath $logFile -Encoding UTF8 -Append
    Write-Host ""
    
    # Phase 2: Compile
    Write-Host "[PHASE 2] MAVEN COMPILE" -ForegroundColor Magenta
    Write-Host "======================" -ForegroundColor Magenta
    Write-Host "This may take several minutes..." -ForegroundColor Yellow
    Write-Host ""
    
    $exitCode = Invoke-WithLogging -Command "mvn compile -DskipTests -pl runelite-client -am" -Phase "COMPILE"
    
    if ($exitCode -ne 0) {
        Write-Host ""
        Write-Host "❌ COMPILATION FAILED!" -ForegroundColor Red
        "❌ COMPILATION FAILED!" | Out-File -FilePath $logFile -Encoding UTF8 -Append
        
        Write-Host ""
        Write-Host "🔍 Analyzing compilation errors..." -ForegroundColor Yellow
        Write-Host ""
        
        # Analyze errors
        Write-Host "=== ERROR ANALYSIS ===" -ForegroundColor Cyan
        
        Write-Host ""
        Write-Host "Cannot find symbol errors:" -ForegroundColor Yellow
        Select-String -Path $logFile -Pattern "cannot find symbol" | Select-Object -First 10 | ForEach-Object { Write-Host $_.Line -ForegroundColor Red }
        
        Write-Host ""
        Write-Host "Compilation errors:" -ForegroundColor Yellow
        Select-String -Path $logFile -Pattern "COMPILATION ERROR" | ForEach-Object { Write-Host $_.Line -ForegroundColor Red }
        
        Write-Host ""
        Write-Host "Build failure summary:" -ForegroundColor Yellow
        Select-String -Path $logFile -Pattern "BUILD FAILURE" | ForEach-Object { Write-Host $_.Line -ForegroundColor Red }
        
        Write-Host ""
        Write-Host "📄 Complete build log saved to: $logFile" -ForegroundColor Cyan
        Write-Host ""
        exit $exitCode
    }
    
    Write-Host ""
    Write-Host "✅ Compilation completed successfully!" -ForegroundColor Green
    "✅ Compilation completed successfully!" | Out-File -FilePath $logFile -Encoding UTF8 -Append
    Write-Host ""
    
    # Phase 3: Package
    Write-Host "[PHASE 3] MAVEN PACKAGE" -ForegroundColor Magenta
    Write-Host "======================" -ForegroundColor Magenta
    
    $exitCode = Invoke-WithLogging -Command "mvn package -DskipTests -pl runelite-client" -Phase "PACKAGE"
    
    if ($exitCode -ne 0) {
        Write-Host ""
        Write-Host "❌ PACKAGING FAILED!" -ForegroundColor Red
        "❌ PACKAGING FAILED!" | Out-File -FilePath $logFile -Encoding UTF8 -Append
        Write-Host ""
        Write-Host "📄 Complete build log saved to: $logFile" -ForegroundColor Cyan
        Write-Host ""
        exit $exitCode
    }
    
    Write-Host ""
    Write-Host "✅ BUILD COMPLETED SUCCESSFULLY! 🎉" -ForegroundColor Green
    "✅ BUILD COMPLETED SUCCESSFULLY! 🎉" | Out-File -FilePath $logFile -Encoding UTF8 -Append
    Write-Host ""
    
    Write-Host "📦 Generated JAR files:" -ForegroundColor Cyan
    if (Test-Path "runelite-client\target\*.jar") {
        Get-ChildItem "runelite-client\target\*.jar" | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Green }
    } else {
        Write-Host "  No JAR files found in runelite-client\target\" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "🎯 RuneLite client is ready for testing!" -ForegroundColor Green
    
}
catch {
    Write-Host ""
    Write-Host "❌ SCRIPT ERROR: $($_.Exception.Message)" -ForegroundColor Red
    "❌ SCRIPT ERROR: $($_.Exception.Message)" | Out-File -FilePath $logFile -Encoding UTF8 -Append
    Write-Host ""
    Write-Host "📄 Complete build log saved to: $logFile" -ForegroundColor Cyan
    Write-Host ""
}
finally {
    Write-Host ""
    Write-Host "📄 Complete build log saved to: $logFile" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "Press any key to continue..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
