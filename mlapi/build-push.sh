#!/bin/bash

# Navigate to your project directory if necessary
cd /Users/savinaychandrupatla/Documents/GitHub/project-pytorch-fastapi-Savinay09

# Get the short commit hash
git_commit_hash=$(git rev-parse --short HEAD)

# Set your image name and ACR name
image_name="project"
acr_name="w255mids"
namespace="savinay"

# Build the Docker image for linux/amd64 architecture
docker build --platform linux/amd64 -t $acr_name.azurecr.io/$namespace/$image_name:$git_commit_hash .

# Push the image to Azure Container Registry
az acr login --name $acr_name
docker push $acr_name.azurecr.io/$namespace/$image_name:$git_commit_hash

echo "Image $acr_name.azurecr.io/$namespace/$image_name:$git_commit_hash pushed successfully"
