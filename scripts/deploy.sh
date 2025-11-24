#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables
AWS_REGION="${AWS_REGION:-us-east-2}"
ECS_CLUSTER_NAME="${ECS_CLUSTER_NAME:-simple-webapp-cluster}"
ECS_SERVICE_NAME="${ECS_SERVICE_NAME:-simple-webapp-service}"
ECS_TASK_DEFINITION="${ECS_TASK_DEFINITION:-simple-webapp-task}"
IMAGE_REPO_NAME="${IMAGE_REPO_NAME:-simple-webapp}"
AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID:-}
IMAGE_TAG=${IMAGE_TAG:-latest}

# Build the Docker image
echo "Building the Docker image..."
docker build -t $IMAGE_REPO_NAME .

# Authenticate Docker to the Amazon ECR registry
echo "Authenticating to Amazon ECR..."
if [ -z "$AWS_ACCOUNT_ID" ]; then
	echo "AWS_ACCOUNT_ID is not set. Please export AWS_ACCOUNT_ID or set the env var in CI."
	exit 1
fi

aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.$AWS_REGION.amazonaws.com

# Tag the Docker image
echo "Tagging the Docker image..."
docker tag $IMAGE_REPO_NAME:${IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_REPO_NAME:${IMAGE_TAG}

# Push the Docker image to Amazon ECR
echo "Pushing the Docker image to Amazon ECR..."
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_REPO_NAME:${IMAGE_TAG}

# Update the ECS service with the new task definition
echo "Updating the ECS service..."
aws ecs update-service --cluster $ECS_CLUSTER_NAME --service $ECS_SERVICE_NAME --force-new-deployment

echo "Deployment completed successfully!"