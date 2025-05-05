#!/bin/bash

# Define variables
WORKING_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
K8S_DIR="$WORKING_DIR/ingress"
INGRESS_FILE="${K8S_DIR}/ingress.yaml"

# Deploy the Ingress resource
echo "Deploying Ingress to AKS: kubectl apply -f ${INGRESS_FILE}"

if kubectl apply -f "${INGRESS_FILE}"; then
  echo "Ingress deployment applied successfully!"
else
  echo "Failed to apply ingress deployment." >&2
  exit 1
fi

