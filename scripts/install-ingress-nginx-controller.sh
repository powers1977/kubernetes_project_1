#!/bin/bash

# Script to install the NGINX Ingress Controller on an AKS cluster.
# This creates a LoadBalancer service and deploys the controller components.

printf "Starting NGINX Ingress Controller installation... \n"

# Apply the official NGINX Ingress manifest for cloud providers (includes AKS)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.0/deploy/static/provider/cloud/deploy.yaml

if [ $? -eq 0 ]; then
    printf "\nNGINX Ingress Controller installation initiated. \n"
    printf "It may take a couple minutes for the LoadBalancer IP to be provisioned.\n"
    printf "You can check the status with: \n"
    printf "kubectl get svc -n ingress-nginx \n"
else
    printf "\nFailed to apply the Ingress Controller manifest! Please check! \n"
    exit 1
fi

