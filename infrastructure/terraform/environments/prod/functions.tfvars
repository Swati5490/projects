# Production Azure Functions Configuration
# Lambda Function equivalents migrated to Azure Functions
# Usage: terraform plan -var-file="environments/prod/_globals.tfvars" -var-file="environments/prod/functions.tfvars"

# ============================================================================
# FUNCTION APPS - Production (Count: 1 app)
# ============================================================================
function_apps = {
  corelogic = {
    name                 = "func-corelogic-prod"
    sku_name             = "Y1"
    runtime              = "Python"
    storage_account_name = "stfuncrewnprod001"
  }
  scheduler = {
    name                 = "func-scheduler-prod"
    sku_name             = "Y1"
    runtime              = "Python"
    storage_account_name = "stfuncrewnprod001"
  }
}

# ============================================================================
# FUNCTIONS - Production (Count: 7 functions)
# ============================================================================
functions = {
  corelogic-involuntary = {
    name              = "corelogic-involuntary-to-s3"
    function_app_name = "corelogic"
    runtime           = "Python"
    schedule          = "0 2 * * *"
    script_file       = "corelogic_involuntary.py"
    purpose           = "Import CoreLogic Involuntary Data to S3"
  }
  corelogic-foreclosure = {
    name              = "corelogic-foreclosure-to-s3"
    function_app_name = "corelogic"
    runtime           = "Python"
    schedule          = "0 3 * * *"
    script_file       = "corelogic_foreclosure.py"
    purpose           = "Import Foreclosure Data to S3"
  }
  corelogic-tax = {
    name              = "corelogic-tax-to-s3"
    function_app_name = "corelogic"
    runtime           = "Python"
    schedule          = "0 4 * * *"
    script_file       = "corelogic_tax.py"
    purpose           = "Import Tax Data to S3"
  }
  corelogic-hoamx = {
    name              = "corelogic-hoamx-to-s3"
    function_app_name = "corelogic"
    runtime           = "Python"
    schedule          = "0 5 * * *"
    script_file       = "corelogic_hoamx.py"
    purpose           = "Import HOA Data to S3"
  }
  corelogic-deed-legacy = {
    name              = "CoreLogicDeedToS3"
    function_app_name = "corelogic"
    runtime           = "Python"
    schedule          = "0 1 * * *"
    script_file       = "corelogic_deed_legacy.py"
    purpose           = "Legacy Deed Import to S3"
  }
  corelogic-deed = {
    name              = "corelogic-deed-to-s3"
    function_app_name = "corelogic"
    runtime           = "Python"
    schedule          = "0 6 * * *"
    script_file       = "corelogic_deed.py"
    purpose           = "Deed Data Import to S3"
  }
  dev-vm-scheduler = {
    name              = "EC2-dev-Scheduler"
    function_app_name = "scheduler"
    runtime           = "Python"
    schedule          = "0 22 * * *"
    script_file       = "dev_vm_scheduler.py"
    purpose           = "Development EC2/VM Start/Stop Scheduler"
  }
}
