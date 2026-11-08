# install.ps1

$ErrorActionPreference = "Stop"

# Allow script execution for current session
try {
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force -ErrorAction SilentlyContinue
} catch {}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Installing @litol-ai/cli for Windows   " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. Check if npm or node is installed
$npmInstalled = (Get-Command npm -ErrorAction SilentlyContinue) -or (Get-Command node -ErrorAction SilentlyContinue)

if (-not $npmInstalled) {
    Write-Host "`n[!] Node.js & npm not found." -ForegroundColor Yellow
    Write-Host "Installing Node.js LTS via winget..." -ForegroundColor Yellow
    
    # Check if winget is available
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "`n[ERROR] 'winget' is not available on this machine." -ForegroundColor Red
        Write-Host "Please install Node.js manually from: https://nodejs.org" -ForegroundColor White
        Exit 1
    }

    # Install Node.js LTS silently
    winget install OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements

    # Reload PATH for the current session so npm is immediately accessible
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# 2. Run npm install via cmd.exe to bypass PowerShell's npm.ps1 execution policy block
Write-Host "`n[+] Installing @litol-ai/cli globally..." -ForegroundColor Green
cmd.exe /c "npm install -g @litol-ai/cli"

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host " Installation Complete!" -ForegroundColor Green
    Write-Host " You can now run: litol" -ForegroundColor White
    Write-Host "========================================" -ForegroundColor Green
} else {
    Write-Host "`n[NOTICE] Please restart your PowerShell window, then run:" -ForegroundColor Yellow
    Write-Host "    npm install -g @litol-ai/cli" -ForegroundColor Cyan
}
