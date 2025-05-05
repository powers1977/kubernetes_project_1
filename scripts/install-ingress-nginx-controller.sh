#!/bin/bash

# Script to install the NGINX Ingress Controller on an AKS cluster.
# This creates a LoadBalancer service and deploys the controller components.

echo "Starting NGINX Ingress Controller installation..."

# Apply the official NGINX Ingress manifest for cloud providers (includes AKS)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.0/deploy/static/provider/cloud/deploy.yaml

if [ $? -eq 0 ]; then
    echo "NGINX Ingress Controller installation initiated."
    echo "It may take a couple minutes for the LoadBalancer IP to be provisioned."
    echo "You can check the status with: kubectl get svc -n ingress-nginx"
else
    echo "Failed to apply the Ingress Controller manifest."
    exit 1
fi

