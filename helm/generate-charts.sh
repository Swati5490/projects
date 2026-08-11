#!/bin/bash

# Script to generate Helm charts for all 24 microservices from templates

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/account-api"  # Use account-api as template

# Microservices list
SERVICES=(
    "admin-ui"
    "assistant-ui"
    "auth-api"
    "geo-api"
    "email-api"
    "phone-api"
    "sms-api"
    "mail-manager-api"
    "images"
    "rewn-chat"
    "rewn-dialer"
    "rewn-fastapi"
    "openrei"
    "myiflip"
    "motivated-api"
    "motivated-ui"
    "private-lender-marketplace"
    "website-generator-vue"
    "rest"
    "ressentials"
)

echo "Generating Helm charts for RENW microservices..."
echo ""

# Function to replace placeholders
replace_placeholders() {
    local file=$1
    local service_name=$2
    local service_name_upper=$(echo $service_name | tr '-' '_' | tr '[:lower:]' '[:upper:]')
    
    sed -i "s/account-api/$service_name/g" "$file"
    sed -i "s/Account API/$service_name/g" "$file"
    sed -i "s/account_api/$service_name/g" "$file"
    sed -i "s/ACCOUNT_API/$service_name_upper/g" "$file"
}

for SERVICE in "${SERVICES[@]}"
do
    SERVICE_DIR="$SCRIPT_DIR/$SERVICE"
    
    # Skip if already exists
    if [ -d "$SERVICE_DIR" ]; then
        echo "✓ $SERVICE already exists, skipping..."
        continue
    fi
    
    echo "Generating $SERVICE..."
    
    # Copy template directory
    cp -r "$TEMPLATE_DIR" "$SERVICE_DIR"
    
    # Replace placeholders in all files
    for file in "$SERVICE_DIR/Chart.yaml" "$SERVICE_DIR/values.yaml" "$SERVICE_DIR/templates"/*.{yaml,tpl}
    do
        if [ -f "$file" ]; then
            replace_placeholders "$file" "$SERVICE"
        fi
    done
    
    # Customize repository name in values.yaml
    sed -i "s/repository: account-api/repository: $SERVICE/g" "$SERVICE_DIR/values.yaml"
    
    echo "✓ $SERVICE generated successfully"
done

echo ""
echo "================================"
echo "Chart Generation Complete!"
echo "================================"
echo ""
echo "Generated charts for ${#SERVICES[@]} services"
echo ""
echo "Next steps:"
echo "1. Review each service's values.yaml for service-specific configuration"
echo "2. Update database/cache settings per service"
echo "3. Deploy with: ./deploy-all.sh prod"
echo ""
