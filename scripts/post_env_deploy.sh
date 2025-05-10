#!/bin/bash

set -e

# Possum Power config
RESOURCE_GROUP="grownpossum-rg"
DNS_ZONE="privatelink.monitor.azure.com"
PE_NAME="grownpossum-ampls-pe"

# Get the Private IP of the AMPLS Private Endpoint
PE_IP=$(az network private-endpoint show \
  --name $PE_NAME \
  --resource-group $RESOURCE_GROUP \
  --query 'customDnsConfigs[0].ipAddresses[0]' -o tsv)

if [[ -z "$PE_IP" ]]; then
  echo "Error: Couldn't fetch Private IP for $PE_NAME. Check if it's deployed."
  exit 1
fi

echo "Private IP for $PE_NAME is $PE_IP"

# List of DNS record set names (you can add more as needed)
DNS_NAMES=(
  "ampls"
  "ampls.eastus"
  "ampls.eastus2"
)

# Create DNS A records
for name in "${DNS_NAMES[@]}"; do
  echo "Creating A record: $name -> $PE_IP"
  az network private-dns record-set a add-record \
    --resource-group $RESOURCE_GROUP \
    --zone-name $DNS_ZONE \
    --record-set-name "$name" \
    --ipv4-address "$PE_IP"
done

echo "All DNS records created for AMPLS Private Endpoint!"

