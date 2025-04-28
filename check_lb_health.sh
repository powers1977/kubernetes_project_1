#!/bin/bash

# Check if the resource group argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <resource-group-name>"
  exit 1
fi

# Set the resource group variable
typeset RG=$1

# Get the Load Balancer name by listing available Load Balancers in the given resource group
LB_NAME=$(az network lb list --resource-group "$RG" --query "[0].name" -o tsv)

# Check if a Load Balancer was found
if [ -z "$LB_NAME" ]; then
  echo "No Load Balancer found in resource group: $RG"
  exit 1
fi

# Display the Load Balancer details
echo "Found Load Balancer: $LB_NAME"
echo "Fetching Load Balancer details..."

# Get the Load Balancer details
az network lb show --resource-group "$RG" --name "$LB_NAME"

# List the health probes associated with the Load Balancer
echo "Listing health probes for Load Balancer: $LB_NAME"
az network lb probe list --resource-group "$RG" --lb-name "$LB_NAME"

# List the backend pool health status
echo "Checking backend pool health for Load Balancer: $LB_NAME"
az network lb address-pool list --resource-group "$RG" --lb-name "$LB_NAME" --query "[].{Name:name, Health:health}" -o table

exit 0

