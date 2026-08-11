# PowerShell script to generate Helm charts for all microservices

param(
    [switch]$Force = $false
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TemplateDir = Join-Path $ScriptDir "account-api"

$Services = @(
    "admin-ui",
    "assistant-ui",
    "auth-api",
    "geo-api",
    "email-api",
    "phone-api",
    "sms-api",
    "mail-manager-api",
    "images",
    "rewn-chat",
    "rewn-dialer",
    "rewn-fastapi",
    "openrei",
    "myiflip",
    "motivated-api",
    "motivated-ui",
    "private-lender-marketplace",
    "website-generator-vue",
    "rest",
    "ressentials"
)

Write-Host "Generating Helm charts for RENW microservices..."
Write-Host ""

function Replace-Placeholders {
    param(
        [string]$FilePath,
        [string]$ServiceName
    )
    
    $content = Get-Content $FilePath -Raw
    $content = $content -replace "account-api", $ServiceName
    $content = $content -replace "account_api", ($ServiceName -replace '-', '_')
    Set-Content $FilePath -Value $content -Encoding UTF8
}

foreach ($Service in $Services) {
    $ServiceDir = Join-Path $ScriptDir $Service
    
    # Skip if already exists
    if ((Test-Path $ServiceDir) -and -not $Force) {
        Write-Host "✓ $Service already exists, skipping..." -ForegroundColor Yellow
        continue
    }
    
    Write-Host "Generating $Service..." -ForegroundColor Cyan
    
    # Copy template directory
    Copy-Item -Path $TemplateDir -Destination $ServiceDir -Recurse -Force
    
    # Replace placeholders in all files
    $Files = Get-ChildItem -Path "$ServiceDir" -Recurse -Include "*.yaml", "*.tpl", "*.yml"
    foreach ($File in $Files) {
        Replace-Placeholders -FilePath $File.FullName -ServiceName $Service
    }
    
    Write-Host "✓ $Service generated successfully" -ForegroundColor Green
}

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Chart Generation Complete!" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Generated charts for $($Services.Count) services" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Review each service's values.yaml"
Write-Host "2. Deploy with: .\deploy-all.ps1 -Environment prod"
Write-Host ""
