# Import and set environment variables
include .env
COMPOSE = docker compose
IMAGE_NAME = ${TEAM_MEMBER_NAME}_image
CONTAINER_NAME = ${TEAM_MEMBER_NAME}_container

.Phony: help docker-build docker-run docker-stop docker-clean logs shell summary

# Make 'help' the default target
.DEFAULT_GOAL := help

# ------------------------------------------------------------------------------
# Docker commands
# ------------------------------------------------------------------------------

## Build the docker image
docker-build: 
	$(COMPOSE) build

## Run the docker container
docker-run: 
	$(COMPOSE) up -d

## Stop the docker container
docker-stop: 
	$(COMPOSE) down

# Stop all containers and remove all images
docker-clean: stop 
	docker rmi $(IMAGE_NAME)

# Show container logs
logs: 
	$(COMPOSE) logs -f

# Start a shell in the container
shell: 
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
	@echo "            Welcome to out team, ${TEAM_MEMBER_NAME}!             "
	@echo "══════════════════════════════════════════════════════════════════"
	@echo ""
	@echo "Here are the available commands to interact with ${TEAM_MEMBER_NAME}:"
	@echo "Make [Targets]:"
	@echo "  docker-build     Build the docker image"
	@echo "  docker-run       Run the docker container"
	@echo "  docker-stop      Stop the docker container"
	@echo "  docker-clean     Stop all containers and remove all images"
	@echo "  logs             Show container logs"
	@echo "  shell            Start a shell in the container"
	@echo "  summary          Generate project summary"
	@echo "  help             Show this help message"
	@echo ""
	
