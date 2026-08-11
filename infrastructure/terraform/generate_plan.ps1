#!/usr/bin/env pwsh

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Terraform Production Plan Generation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$startTime = Get-Date
Write-Host "Start Time: $startTime" -ForegroundColor Yellow

# Run terraform plan with all var-files
Write-Host "`nRunning terraform plan..." -ForegroundColor Green

$planOutput = @(
    "terraform plan",
    "-lock=false",
    "-var-file='environments/prod/_globals.tfvars'",
    "-var-file='environments/prod/backup.tfvars'",
    "-var-file='environments/prod/compute.tfvars'",
    "-var-file='environments/prod/databases.tfvars'",
    "-var-file='environments/prod/monitoring.tfvars'",
    "-var-file='environments/prod/networking.tfvars'",
    "-var-file='environments/prod/resource_groups.tfvars'",
    "-var-file='environments/prod/security.tfvars'",
    "-var-file='environments/prod/storage.tfvars'",
    "-var-file='environments/prod/application_gateway.tfvars'",
    "-var-file='environments/prod/front_door.tfvars'",
    "-var-file='environments/prod/functions.tfvars'",
    "-var-file='environments/prod/migration.tfvars'"
)

$cmd = $planOutput -join " "
Write-Host "`nCommand: $cmd`n" -ForegroundColor Gray

Invoke-Expression $cmd 2>&1 | Tee-Object -FilePath "./terraform_prod_plan_output.txt" | ForEach-Object {
    if ($_ -match "Plan:|Error|Warning") {
        Write-Host $_ -ForegroundColor Yellow
    } else {
        Write-Host $_
    }
}

$endTime = Get-Date
$duration = ($endTime - $startTime).TotalSeconds

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Plan Generation Complete" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "End Time: $endTime" -ForegroundColor Yellow
Write-Host "Duration: $([math]::Round($duration, 2)) seconds" -ForegroundColor Yellow

if (Test-Path "./terraform_prod_plan_output.txt") {
    $fileSize = (Get-Item "./terraform_prod_plan_output.txt").Length
    $fileSizeKB = [math]::Round($fileSize / 1KB, 2)
    Write-Host "Output File: ./terraform_prod_plan_output.txt" -ForegroundColor Green
    Write-Host "File Size: $fileSizeKB KB" -ForegroundColor Green
}

Write-Host ""
