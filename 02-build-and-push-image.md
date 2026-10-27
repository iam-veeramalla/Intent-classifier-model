# Build and Push Intent Classifier Model Container

This document provides the commands to build the Docker image for the Intent Classifier model and push it to Docker Hub.

### Login to Docker Hub

`docker login`

### Build the Docker Image

Replace <dockerhub-username> with your Docker Hub username.

`docker build -t <dockerhub-username>/intent-classifier:latest .`

> ⚠️ **Apple Silicon Mac Users (M1/M2/M3/M4/M5)**
> 
> The default `docker build` on Apple Silicon creates an ARM64 image.
> This causes the following error when applying deployment.yaml on 
> Linux/EKS clusters:
> ```
> ErrImagePull: no match for platform in manifest
> ```
> Use `docker buildx` instead — this single command builds, tags
> and pushes in one step (skip the tag and push steps below):
> ```bash
> docker buildx build \
>   --platform linux/amd64 \
>   -t <dockerhub-username>/intent-classifier:v1 \
>   --push .
> ```

### Tag the Image (Optional Version Tag)

`docker tag <dockerhub-username>/intent-classifier:latest <dockerhub-username>/intent-classifier:v1`

### Push the Image to Docker Hub

Push the latest tag:

`docker push <dockerhub-username>/intent-classifier:latest`

Push the versioned tag:

`docker push <dockerhub-username>/intent-classifier:v1`

5. Verify the Image
docker pull <dockerhub-username>/intent-classifier:latest
