# Complete Terraform Plan Command - All 128 Production Resources
# Generated: 2026-08-06

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "TERRAFORM PRODUCTION PLAN - ALL 128 RESOURCES" -ForegroundColor Cyan
Write-Host "================================================`n" -ForegroundColor Cyan

$planCmd = @"
terraform plan `
  -var-file="environments/prod/_globals.tfvars" `
  -var-file="environments/prod/resource_groups.tfvars" `
  -var-file="environments/prod/networking.tfvars" `
  -var-file="environments/prod/compute.tfvars" `
  -var-file="environments/prod/storage.tfvars" `
  -var-file="environments/prod/databases.tfvars" `
  -var-file="environments/prod/security.tfvars" `
  -var-file="environments/prod/monitoring.tfvars" `
  -var-file="environments/prod/backup.tfvars" `
  -var-file="environments/prod/functions.tfvars" `
  -var-file="environments/prod/application_gateway.tfvars" `
  -var-file="environments/prod/front_door.tfvars" `
  -var-file="environments/prod/migration.tfvars"
"@

Write-Host "PLAN COMMAND:" -ForegroundColor Yellow
Write-Host $planCmd `n

Write-Host "Executing plan..." -ForegroundColor Green
Write-Host "This will show all 128 resources to be created`n" -ForegroundColor Gray

# Execute plan and save to file
Invoke-Expression $planCmd | Tee-Object -FilePath "plan_output_complete.txt" | Out-String

Write-Host "`n================================================" -ForegroundColor Cyan
Write-Host "Plan complete! Output saved to: plan_output_complete.txt" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
