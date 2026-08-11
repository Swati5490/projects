#!/bin/bash

# Helm Deployment Script for RENW Microservices
# Deploys all 24 microservices to AKS

set -e

# Configuration
ENVIRONMENT=${1:-prod}
RELEASE_NAMESPACE="renw-${ENVIRONMENT}"
HELM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VALUES_FILE="${HELM_DIR}/values-${ENVIRONMENT}.yaml"
REGISTRY="acrreewnprod.azurecr.io"
ACR_SECRET="acr-secret"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}RENW Microservices Helm Deployment${NC}"
echo -e "${YELLOW}Environment: ${ENVIRONMENT}${NC}"
echo -e "${YELLOW}Namespace: ${RELEASE_NAMESPACE}${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""

# Create namespace if it doesn't exist
echo -e "${YELLOW}Creating namespace ${RELEASE_NAMESPACE}...${NC}"
kubectl create namespace ${RELEASE_NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

# Add ACR secret
echo -e "${YELLOW}Configuring ACR secret...${NC}"
kubectl create secret docker-registry ${ACR_SECRET} \
  --docker-server=${REGISTRY} \
  --docker-username=<ACR_USERNAME> \
  --docker-password=<ACR_PASSWORD> \
  --docker-email=devops@ifitechsolutions.com \
  --namespace=${RELEASE_NAMESPACE} \
  --dry-run=client -o yaml | kubectl apply -f -

# List of microservices
MICROSERVICES=(
  "account-api"
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

# Deploy each microservice
DEPLOY_COUNT=0
FAILED_SERVICES=()

for SERVICE in "${MICROSERVICES[@]}"
do
  CHART_PATH="${HELM_DIR}/${SERVICE}"
  
  if [ ! -d "${CHART_PATH}" ]; then
    echo -e "${RED}[SKIP] ${SERVICE} - Chart directory not found${NC}"
    continue
  fi
  
  echo ""
  echo -e "${YELLOW}Deploying ${SERVICE}...${NC}"
  
  # Helm upgrade/install
  if helm upgrade --install ${SERVICE} ${CHART_PATH} \
    --namespace=${RELEASE_NAMESPACE} \
    --values=${VALUES_FILE} \
    --wait \
    --timeout=5m \
    --atomic; then
    echo -e "${GREEN}✓ ${SERVICE} deployed successfully${NC}"
    ((DEPLOY_COUNT++))
  else
    echo -e "${RED}✗ ${SERVICE} deployment failed${NC}"
    FAILED_SERVICES+=("${SERVICE}")
  fi
done

echo ""
echo -e "${YELLOW}========================================${NC}"
echo -e "${GREEN}Deployment Summary${NC}"
echo -e "${YELLOW}========================================${NC}"
echo -e "Successfully deployed: ${DEPLOY_COUNT} services"

if [ ${#FAILED_SERVICES[@]} -gt 0 ]; then
  echo -e "${RED}Failed services: ${#FAILED_SERVICES[@]}${NC}"
  for SERVICE in "${FAILED_SERVICES[@]}"
  do
    echo -e "  ${RED}✗ ${SERVICE}${NC}"
  done
  exit 1
else
  echo -e "${GREEN}All services deployed successfully!${NC}"
fi

# Verify deployments
echo ""
echo -e "${YELLOW}Verifying deployments...${NC}"
kubectl rollout status deployment -n ${RELEASE_NAMESPACE} --all --timeout=5m

# Get service endpoints
echo ""
echo -e "${YELLOW}Service Endpoints:${NC}"
kubectl get svc -n ${RELEASE_NAMESPACE}

echo ""
echo -e "${GREEN}Deployment complete!${NC}"
