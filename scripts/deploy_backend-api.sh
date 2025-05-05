#!/bin/bash

# Define variables
WORKING_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
K8S_DIR="$WORKING_DIR/backend-api"

#THIS WILL DEPLOY AND START THE POD
printf "Deploying Nginx to AKS:  kubectl apply -f ${K8S_DIR}/k8s/backend-api-deployment.yaml \n"
kubectl apply -f ${K8S_DIR}/k8s/backend-api-deployment.yaml

printf "Continue? \n"
read ANSWER

#THIS WILL DEPLOY THE SERVICE
printf "Deploying the service: kubectl apply -f ${K8S_DIR}/k8s/backend-api-service.yaml \n"
kubectl apply -f ${K8S_DIR}/k8s/backend-api-service.yaml

#COMMAND TO DO BOTH AT SAME TIME:
#kubectl apply -f "$K8S_DIR/k8s/backend-api-deployment.yaml" -f "$K8S_DIR/k8s/backend-api-service.yaml"

echo "Back-end deployment applied!"

