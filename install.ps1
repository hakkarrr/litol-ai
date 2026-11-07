# install.ps1

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Installing @litol-ai/cli for Windows   " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. Check if npm is installed
$npmInstalled = Get-Command npm -ErrorAction SilentlyContinue

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

# 2. Check npm again after PATH refresh
if (Get-Command npm -ErrorAction SilentlyContinue) {
    Write-Host "`n[+] npm found. Installing @litol-ai/cli globally..." -ForegroundColor Green
    npm install -g @litol-ai/cli
    
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host " Installation Complete!" -ForegroundColor Green
    Write-Host " Run: litol --help (or your CLI command)" -ForegroundColor White
    Write-Host "========================================" -ForegroundColor Green
} else {
    Write-Host "`n[NOTICE] Node.js was installed successfully!" -ForegroundColor Yellow
    Write-Host "Please close and reopen your PowerShell window, then run:" -ForegroundColor Yellow
    Write-Host "    npm install -g @litol-ai/cli" -ForegroundColor Cyan
}

# hi
