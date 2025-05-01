#!/bin/bash

# Define variables
IMAGE_NAME="my-nginx"       # Image name
ACR_NAME="acrgrownpossum"      # Azure Container Registry name
VERSION_TAG="v1.0"          # Version tag for your image
LATEST_TAG="latest"         # Tag for latest

# Tag the image with both version and latest tags
echo "Tagging image with version and latest tags..."
docker tag $IMAGE_NAME:latest $ACR_NAME.azurecr.io/$IMAGE_NAME:$VERSION_TAG
docker tag $IMAGE_NAME:latest $ACR_NAME.azurecr.io/$IMAGE_NAME:$LATEST_TAG

# Log in to Azure ACR
echo "Logging into Azure ACR..."
az acr login --name $ACR_NAME

# Push the image to Azure ACR
echo "Pushing image to Azure ACR..."
docker push $ACR_NAME.azurecr.io/$IMAGE_NAME:$VERSION_TAG
docker push $ACR_NAME.azurecr.io/$IMAGE_NAME:$LATEST_TAG

echo "Done!"
