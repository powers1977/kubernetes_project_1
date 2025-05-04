#!/bin/bash

# Define resource files
DEPLOYMENT_FILE="../backend-api/app-deployment.yaml"
SERVICE_FILE="../backend-api/backend-api-service.yaml"

echo "Deleting service..."
kubectl delete -f $SERVICE_FILE

echo "Deleting deployment..."
kubectl delete -f $DEPLOYMENT_FILE

echo "Cleanup complete!"

