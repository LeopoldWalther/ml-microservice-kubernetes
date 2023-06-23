#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`

# Create dockerpath
dockerpath=leopoldwalther/housing-price-prediction

# Authenticate & tag
echo "Docker ID and Image: $dockerpath"
docker login -u leopoldwalther
docker tag housing-price-prediction $dockerpath:latest

# Push image to a docker repository
docker push $dockerpath:latest