# Import and set environment variables
include .env
COMPOSE = docker compose

# Convert TEAM_MEMBER_NAME and PROJECT_NAME to lowercase for Docker image naming
TEAM_MEMBER_NAME_LOWER := $(shell echo $(TEAM_MEMBER_NAME) | tr '[:upper:]' '[:lower:]')
PROJECT_NAME_LOWER := $(shell echo $(PROJECT_NAME) | tr '[:upper:]' '[:lower:]')

# Generate Docker image and container names
DOCKER_IMAGE_NAME := $(TEAM_MEMBER_NAME_LOWER)-image-$(PROJECT_NAME_LOWER)
DOCKER_CONTAINER_NAME := $(TEAM_MEMBER_NAME_LOWER)-container-$(PROJECT_NAME_LOWER)

# Export all variables
export

# Set the image and container names
IMAGE_NAME = $(TEAM_MEMBER_NAME_LOWER)-image-$(PROJECT_NAME_LOWER)
CONTAINER_NAME = $(TEAM_MEMBER_NAME_LOWER)-container-$(PROJECT_NAME_LOWER)

# Define phony targets
.Phony: help docker-build docker-run docker-stop docker-clean docker-logs docker-shell summary

# Make 'help' the default target
.DEFAULT_GOAL := help

# ------------------------------------------------------------------------------
# Docker commands
# ------------------------------------------------------------------------------

## Build the docker image
docker-build: 
	$(COMPOSE) build

## Run the docker container
docker-up: 
	$(COMPOSE) up -d

## Stop the docker container
docker-stop: 
	$(COMPOSE) down

# Stop all containers and remove all images
docker-clean: docker-stop 
	docker rmi $(IMAGE_NAME)
	@echo "To remove all related images, use: docker image prune -a"

# Show container logs
docker-logs: 
	$(COMPOSE) logs -f

# Start a shell in the container
docker-shell: 
	docker exec -it $(CONTAINER_NAME) /bin/bash

# ------------------------------------------------------------------------------
# Generate project summary
# ------------------------------------------------------------------------------
summary:
	python ../generate_project_summary.py

# ------------------------------------------------------------------------------
# help
# ------------------------------------------------------------------------------
help:
	@echo "══════════════════════════════════════════════════════════════════"
	@echo "     Welcome to $(PROJECT_NAME) team, ${TEAM_MEMBER_NAME}!        "
	@echo "══════════════════════════════════════════════════════════════════"
	@echo ""
	@echo "Here are the available commands to interact with ${TEAM_MEMBER_NAME}:"
	@echo "Make [Targets]:"
	@echo "  docker-build     Build the docker image"
	@echo "  docker-up        Run the docker container"
	@echo "  docker-stop      Stop the docker container"
	@echo "  docker-clean     Stop all containers and remove all images"
	@echo "  docker-logs      Show container logs"
	@echo "  docker-shell     Start a shell in the container"
	@echo "  summary          Generate project summary"
	@echo "  help             Show this help message"
	@echo ""
	
