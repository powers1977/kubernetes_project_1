#!/bin/bash

# Define resource files
DEPLOYMENT_FILE="../backend-api/k8s/backend-api-deployment.yaml"
SERVICE_FILE="../backend-api/k8s/backend-api-service.yaml"

echo "Deleting service..."
kubectl delete -f $SERVICE_FILE

echo "Deleting deployment..."
kubectl delete -f $DEPLOYMENT_FILE

echo "Cleanup complete!"

