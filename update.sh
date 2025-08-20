#!/bin/bash

# This script pulls the latest changes, builds, and deploys the application

set -e  # Exit on any error

# Configuration
APP_DIR="/home/yassine/myapp"
REPO_URL="https://github.com/Ret2Hell/next-self-host.git"
BRANCH="main"
LOG_FILE="/var/log/app-update.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to log messages
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
    exit 1
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

# Update application code
update_code() {
  log "Updating application code..."
  cd "$APP_DIR"
  sudo -u yassine git fetch origin
  sudo -u yassine git reset --hard "origin/$BRANCH"
  sudo -u yassine git clean -fd
  sudo chown -R yassine:yassine "$APP_DIR"
  success "Code updated successfully"
}

# Stop existing containers
stop_containers() {
    log "Stopping existing containers..."
    cd "$APP_DIR"
    
    if sudo docker compose ps | grep -q "Up"; then
        sudo docker compose down
        success "Containers stopped"
    else
        log "No running containers found"
    fi
}

# Build and start containers
start_containers() {
    log "Building and starting containers..."
    cd "$APP_DIR"
    
    # Build new images
    sudo docker compose build --no-cache
    
    # Start containers
    sudo docker compose up -d
    
    # Wait for containers to be ready
    log "Waiting for containers to start..."
    sleep 10
    
    # Check if containers are running
    if sudo docker compose ps | grep -q "Up"; then
        success "Containers started successfully"
    else
        error "Failed to start containers"
    fi
}

# Health check
health_check() {
    log "Performing health check..."
    
    # Check if application is responding
    for i in {1..30}; do
        if curl -sf http://localhost:3000 > /dev/null 2>&1; then
            success "Application is healthy and responding"
            return 0
        fi
        log "Waiting for application to respond... (attempt $i/30)"
        sleep 2
    done
    
    error "Application health check failed"
}

# Cleanup old Docker images
cleanup() {
    log "Cleaning up old Docker images..."
    sudo docker system prune -f
    success "Cleanup completed"
}

# Main execution
main() {
    log "Starting application update process..."
    
    update_code
    stop_containers
    start_containers
    health_check
    cleanup
    
    success "Application update completed successfully!"
    log "Application is running at: http://localhost:3000"
}

# Handle script interruption
trap 'error "Update process interrupted"' INT TERM

# Run main function
main "$@"