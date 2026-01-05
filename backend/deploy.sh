#!/bin/bash

# Artepix Backend Deployment Script

echo "🚀 Starting Artepix Backend Deployment..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "📦 Docker not found. Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    echo "✅ Docker installed successfully."
else
    echo "✅ Docker is already installed."
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "📦 Docker Compose not found. Installing..."
    sudo apt-get update
    sudo apt-get install -y docker-compose-plugin
    echo "✅ Docker Compose installed."
fi

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker compose down

# Build and start containers
echo "🏗️ Building and starting containers..."
docker compose -p artepix_smart_packaging up -d --build

# Check status
echo "📊 Checking container status..."
docker compose -p artepix_smart_packaging ps

echo "🎉 Deployment Complete! API should be running on port 8000."
