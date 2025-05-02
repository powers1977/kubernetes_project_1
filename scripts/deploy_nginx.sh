#!/bin/bash

# Define variables
WORKING_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
K8S_DIR="$WORKING_DIR/nginx"

#THIS WILL DEPLOY AND START THE POD
printf "Deploying Nginx to AKS:  kubectl apply -f ${K8S_DIR}/app-deployment.yaml \n"
kubectl apply -f ${K8S_DIR}/app-deployment.yaml

printf "Continue? \n"
read ANSWER

#THIS WILL DEPLOY THE SERVICE
printf "Deploying the service: kubectl apply -f ${K8S_DIR}/nginx-service.yaml \n"
kubectl apply -f ${K8S_DIR}/nginx-service.yaml

#COMMAND TO DO BOTH AT SAME TIME:
#kubectl apply -f "$K8S_DIR/app-deployment.yaml" -f "$K8S_DIR/nginx-service.yaml"

echo "Nginx deployment applied!"

