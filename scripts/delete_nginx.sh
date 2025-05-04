#!/bin/bash

# Define resource files
DEPLOYMENT_FILE="../nginx/app-deployment.yaml"
SERVICE_FILE="../nginx/nginx-service.yaml"

echo "Deleting service..."
kubectl delete -f $SERVICE_FILE

echo "Deleting deployment..."
kubectl delete -f $DEPLOYMENT_FILE

echo "Cleanup complete!"

