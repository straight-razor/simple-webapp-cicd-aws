#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Build the application
echo "Building the application..."
npm install

# Run unit tests
echo "Running unit tests..."
npm test

# Perform SAST using Snyk
echo "Running SAST with Snyk..."
snyk test --all-projects

echo "Build process completed successfully."