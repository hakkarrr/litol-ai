# install.ps1
$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Installing @litol-ai/cli for Windows   " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# 1. Permanently allow running npm-installed CLI scripts for this user
try {
    Write-Host "`n[+] Configuring PowerShell execution policy..." -ForegroundColor Cyan
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force -ErrorAction SilentlyContinue
} catch {
    Write-Host "[!] Could not set execution policy, continuing..." -ForegroundColor Yellow
}

# 2. Check if Node.js & npm are installed
$npmInstalled = (Get-Command npm -ErrorAction SilentlyContinue) -or (Get-Command node -ErrorAction SilentlyContinue)

if (-not $npmInstalled) {
    Write-Host "`n[!] Node.js & npm not found." -ForegroundColor Yellow
    Write-Host "Installing Node.js LTS via winget..." -ForegroundColor Yellow
    
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "`n[ERROR] 'winget' is not available on this machine." -ForegroundColor Red
        Write-Host "Please install Node.js manually from: https://nodejs.org" -ForegroundColor White
        Exit 1
    }

    # Install Node.js LTS silently
    winget install OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements

    # Reload PATH for the current session
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# 3. Install @litol-ai/cli globally
Write-Host "`n[+] Installing @litol-ai/cli globally..." -ForegroundColor Green
cmd.exe /c "npm install -g @litol-ai/cli"

# Reload user environment variables & npm bin path into current session
$userNpmPath = "$env:APPDATA\npm"
if ($env:Path -notlike "*$userNpmPath*") {
    $env:Path = "$userNpmPath;" + $env:Path
}

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host " Installation Complete!" -ForegroundColor Green
    Write-Host " You can now run: litol" -ForegroundColor White
    Write-Host "========================================" -ForegroundColor Green
} else {
    Write-Host "`n[NOTICE] Please restart your PowerShell window, then run:" -ForegroundColor Yellow
    Write-Host "    npm install -g @litol-ai/cli" -ForegroundColor Cyan
}
