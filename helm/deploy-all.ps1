# Helm Deployment Script for RENW Microservices (PowerShell)
# Deploys all 24 microservices to AKS

param(
    [string]$Environment = "prod",
    [string]$Namespace = "",
    [switch]$DryRun = $false
)

# Configuration
if ([string]::IsNullOrEmpty($Namespace)) {
    $Namespace = "renw-$Environment"
}

$HelmDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ValuesFile = "$HelmDir\values-$Environment.yaml"
$Registry = "acrreewnprod.azurecr.io"
$AcrSecret = "acr-secret"

# Color functions
function Write-Success { Write-Host $args -ForegroundColor Green }
function Write-Error { Write-Host $args -ForegroundColor Red }
function Write-Warning { Write-Host $args -ForegroundColor Yellow }

Write-Warning "========================================"
Write-Warning "RENW Microservices Helm Deployment"
Write-Warning "Environment: $Environment"
Write-Warning "Namespace: $Namespace"
Write-Warning "========================================"
Write-Host ""

# Create namespace if it doesn't exist
Write-Warning "Creating namespace $Namespace..."
kubectl create namespace $Namespace --dry-run=client -o yaml | kubectl apply -f -

# List of microservices
$Microservices = @(
    "account-api",
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

$DeployCount = 0
$FailedServices = @()

foreach ($Service in $Microservices) {
    $ChartPath = "$HelmDir\$Service"
    
    if (-not (Test-Path $ChartPath)) {
        Write-Warning "[SKIP] $Service - Chart directory not found"
        continue
    }
    
    Write-Host ""
    Write-Warning "Deploying $Service..."
    
    # Build helm command
    $HelmArgs = @(
        "upgrade",
        "--install",
        $Service,
        $ChartPath,
        "--namespace=$Namespace",
        "--values=$ValuesFile",
        "--wait",
        "--timeout=5m",
        "--atomic"
    )
    
    if ($DryRun) {
        $HelmArgs += "--dry-run"
        Write-Warning "DRY RUN MODE"
    }
    
    # Execute helm
    if (& helm @HelmArgs) {
        Write-Success "✓ $Service deployed successfully"
        $DeployCount++
    } else {
        Write-Error "✗ $Service deployment failed"
        $FailedServices += $Service
    }
}

Write-Host ""
Write-Warning "========================================"
Write-Success "Deployment Summary"
Write-Warning "========================================"
Write-Success "Successfully deployed: $DeployCount services"

if ($FailedServices.Count -gt 0) {
    Write-Error "Failed services: $($FailedServices.Count)"
    foreach ($Service in $FailedServices) {
        Write-Error "  ✗ $Service"
    }
    exit 1
} else {
    Write-Success "All services deployed successfully!"
}

# Verify deployments
Write-Host ""
Write-Warning "Verifying deployments..."
kubectl rollout status deployment -n $Namespace --all --timeout=5m

# Get service endpoints
Write-Host ""
Write-Warning "Service Endpoints:"
kubectl get svc -n $Namespace

Write-Host ""
Write-Success "Deployment complete!"
