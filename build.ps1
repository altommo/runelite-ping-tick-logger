$timestamp = Get-Date -Format "MMdd_HHmm"
$logFile = "build_$timestamp.log"

Set-Location "C:\Users\hp\Development\runelite"

Write-Host "Starting build - logging to $logFile"

"Build started at $(Get-Date)" | Out-File -FilePath $logFile

Write-Host "Phase 1: Clean"
$cleanOutput = mvn clean 2>&1
$cleanOutput | Out-File -FilePath $logFile -Append
$cleanOutput

if ($LASTEXITCODE -ne 0) {
    Write-Host "Clean failed"
    exit 1
}

Write-Host "Phase 2: Compile"
$compileOutput = mvn compile -DskipTests -pl runelite-client -am 2>&1
$compileOutput | Out-File -FilePath $logFile -Append
$compileOutput

if ($LASTEXITCODE -ne 0) {
    Write-Host "Compilation failed - check errors above"
    Write-Host "Log saved to $logFile"
    exit 1
}

Write-Host "Phase 3: Package"
$packageOutput = mvn package -DskipTests -pl runelite-client 2>&1
$packageOutput | Out-File -FilePath $logFile -Append
$packageOutput

if ($LASTEXITCODE -ne 0) {
    Write-Host "Package failed"
    Write-Host "Log saved to $logFile"
    exit 1
}

Write-Host "Build completed successfully"
Write-Host "Log saved to $logFile"
