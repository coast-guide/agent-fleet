#!/bin/bash

# Script: docker_cleanup.sh
# Purpose: Comprehensive Docker resource cleanup (containers, images, volumes, networks, build cache)
# Date: June 2025
# Warning: This script deletes ALL unused Docker resources. Use with caution and ensure backups.

# Exit on error
set -e

# Default flags
start=false

# Usage function
usage() {
    echo "Usage: $0 [--start] [--help]"
    echo
    echo "Options:"
    echo "  --start         Start the cleanup process (required to proceed)."
    echo "  --help          Display this help message and exit."
    echo
    echo "Description:"
    echo "  This script performs a comprehensive cleanup of Docker resources, including containers, images,"
    echo "  volumes, networks, and build cache."
    echo
    echo "Warning:"
    echo "  - This script is destructive. Ensure critical data is backed up before running."
    echo "  - Requires Docker to be installed and running."
    echo
    echo "Examples:"
    echo "  $0                  # Show this help message (default)"
    echo "  $0 --start          # Clean only Docker resources"
    echo "  $0 --help           # Show this help message"
    exit 0
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --start)
            start=true
            shift
            ;;
        --help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Show usage by default if --start is not provided
if [ "$start" = false ]; then
    usage
fi

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
    log "ERROR: Docker is not installed. Exiting."
    exit 1
fi

if ! docker info &> /dev/null; then
    log "ERROR: Docker daemon is not running. Exiting."
    exit 1
fi

# Prepare warning message
warning="WARNING: This script will remove ALL stopped containers, unused images, volumes, networks, and build cache."

# Prompt for confirmation
log "$warning"
read -p "Are you sure you want to continue? (y/N): " confirm
if [[ ! "$confirm" =~ ^[yY]$ ]]; then
    log "Cleanup aborted by user."
    exit 0
fi

# Step 1: Stop all running containers
log "Stopping all running containers..."
if docker ps -q | grep -q .; then
    # shellcheck disable=SC2046
    docker stop $(docker ps -q) || {
        log "Warning: Some containers could not be stopped."
    }
else
    log "No running containers found."
fi

# Step 2: Remove all containers (stopped and exited)
log "Removing all containers..."
if docker ps -a -q | grep -q .; then
    # shellcheck disable=SC2046
    docker rm -f $(docker ps -a -q) || {
        log "Warning: Some containers could not be removed."
    }
else
    log "No containers to remove."
fi

# Step 3: Remove all images
log "Removing all images..."
if docker images -q | sort -u | grep -q .; then
    # shellcheck disable=SC2046
    docker rmi -f $(docker images -q | sort -u) || {
        log "Warning: Some images could not be removed (possibly in use or protected)."
    }
else
    log "No images to remove."
fi

# Step 4: Remove all volumes
log "Removing all volumes..."
if docker volume ls -q | grep -q .; then
    # shellcheck disable=SC2046
    docker volume rm -f $(docker volume ls -q) || {
        log "Warning: Some volumes could not be removed."
    }
else
    log "No volumes to remove."
fi

# Step 5: Remove all networks
log "Removing unused networks..."
docker network prune -f || {
    log "Warning: Some networks could not be removed."
}

# Step 6: Remove build cache
log "Removing build cache..."
docker builder prune -f || {
    log "Warning: Build cache could not be fully removed."
}

# Step 7: Comprehensive system prune
log "Running docker system prune to clean up remaining unused resources..."
docker system prune -a --volumes -f || {
    log "Warning: System prune encountered an issue."
}

# Step 8: Check disk space reclaimed
log "Checking disk space usage after cleanup..."
docker system df

# Final message
log "Docker cleanup completed. Verify no critical resources were removed."
