.PHONY: help bootstrap up down logs networks rebuild shell lock-update health clean

help:
	@echo "Available commands:"
	@echo "  make help          - Show this help message"
	@echo "  make bootstrap     - Initialize development environment"
	@echo "  make up STACK=name - Start the specified Docker stack"
	@echo "  make down STACK=name - Stop the specified Docker stack"
	@echo "  make logs STACK=name - View logs for the specified stack"
	@echo "  make rebuild STACK=name [SERVICE=name] - Rebuild services in stack"
	@echo "  make shell STACK=name SERVICE=name - Open shell in service"
	@echo "  make networks      - List and inspect Docker networks"
	@echo "  make lock-update STACK=name [SERVICE=name] - Update service lock file"
	@echo "  make health STACK=name - Check service health status"
	@echo "  make clean         - Clean up Docker resources"
	@echo ""
	@echo "Example usage:"
	@echo "  make bootstrap"
	@echo "  make up STACK=stack_discord-llm-bot"
	@echo "  make logs STACK=stack_discord-llm-bot"
	@echo "  make rebuild STACK=stack_discord-llm-bot SERVICE=api"
	@echo "  make shell STACK=stack_discord-llm-bot SERVICE=api"
	@echo "  make networks"
	@echo "  make lock-update STACK=stack_discord-llm-bot"
	@echo "  make health STACK=stack_discord-llm-bot"
	@echo "  make down STACK=stack_discord-llm-bot"

bootstrap:
	@echo "Initializing development environment..."
	@./scripts/bootstrap.sh

up:
	@if [ -z "$(STACK)" ]; then \
		echo "Error: STACK parameter is required"; \
		echo "Usage: make up STACK=stack-name"; \
		echo "Available stacks:"; \
		ls -1 stacks/ 2>/dev/null || echo "  No stacks found"; \
		exit 1; \
	fi
	@if [ ! -d "stacks/$(STACK)" ]; then \
		echo "Error: Stack 'stacks/$(STACK)' does not exist"; \
		echo "Available stacks:"; \
		ls -1 stacks/ 2>/dev/null || echo "  No stacks found"; \
		exit 1; \
	fi
	@if [ ! -f "stacks/$(STACK)/compose.yaml" ]; then \
		echo "Error: compose.yaml not found in stacks/$(STACK)/"; \
		exit 1; \
	fi
	@echo "Starting stack $(STACK)..."
	@cd stacks/$(STACK) && docker compose --project-name docker-stacks_$(STACK) up -d --build
	@echo "Updating service lock file..."
	@./scripts/update-lock.sh $(STACK)
	@echo "✓ Stack $(STACK) started successfully"

down:
	@if [ -z "$(STACK)" ]; then \
		echo "Error: STACK parameter is required"; \
		echo "Usage: make down STACK=stack-name"; \
		exit 1; \
	fi
	@if [ ! -d "stacks/$(STACK)" ]; then \
		echo "Error: Stack 'stacks/$(STACK)' does not exist"; \
		exit 1; \
	fi
	@if [ ! -f "stacks/$(STACK)/compose.yaml" ]; then \
		echo "Error: compose.yaml not found in stacks/$(STACK)/"; \
		exit 1; \
	fi
	@echo "Stopping stack $(STACK)..."
	@cd stacks/$(STACK) && docker compose --project-name docker-stacks_$(STACK) down --remove-orphans
	@echo "✓ Stack $(STACK) stopped successfully"

logs:
	@if [ -z "$(STACK)" ]; then \
		echo "Error: STACK parameter is required"; \
		echo "Usage: make logs STACK=stack-name"; \
		exit 1; \
	fi
	@if [ ! -d "stacks/$(STACK)" ]; then \
		echo "Error: Stack 'stacks/$(STACK)' does not exist"; \
		exit 1; \
	fi
	@if [ ! -f "stacks/$(STACK)/compose.yaml" ]; then \
		echo "Error: compose.yaml not found in stacks/$(STACK)/"; \
		exit 1; \
	fi
	@echo "Viewing logs for stack $(STACK)... (Press Ctrl+C to exit)"
	@cd stacks/$(STACK) && docker compose --project-name docker-stacks_$(STACK) logs -f

networks:
	@echo "Docker Networks:"
	@docker network ls | grep docker-stacks || echo "No docker-stacks networks found"
	@echo ""
	@echo "To inspect a specific network: docker network inspect <network-name>"

rebuild:
	@if [ -z "$(STACK)" ]; then \
		echo "Error: STACK parameter is required"; \
		echo "Usage: make rebuild STACK=stack-name [SERVICE=service-name]"; \
		exit 1; \
	fi
	@if [ ! -d "stacks/$(STACK)" ]; then \
		echo "Error: Stack 'stacks/$(STACK)' does not exist"; \
		exit 1; \
	fi
	@if [ ! -f "stacks/$(STACK)/compose.yaml" ]; then \
		echo "Error: compose.yaml not found in stacks/$(STACK)/"; \
		exit 1; \
	fi
	@if [ -n "$(SERVICE)" ]; then \
		@echo "Rebuilding service $(SERVICE) in stack $(STACK)..."; \
		@cd stacks/$(STACK) && docker compose --project-name docker-stacks_$(STACK) build --no-cache $(SERVICE); \
		@echo "Restarting service $(SERVICE)..."; \
		@cd stacks/$(STACK) && docker compose --project-name docker-stacks_$(STACK) up -d $(SERVICE); \
	else \
		@echo "Rebuilding all services in stack $(STACK)..."; \
		@cd stacks/$(STACK) && docker compose --project-name docker-stacks_$(STACK) build --no-cache; \
		@echo "Restarting all services..."; \
		@cd stacks/$(STACK) && docker compose --project-name docker-stacks_$(STACK) up -d; \
	fi
	@echo "✓ Rebuild completed"

shell:
	@if [ -z "$(STACK)" ] || [ -z "$(SERVICE)" ]; then \
		echo "Error: Both STACK and SERVICE parameters are required"; \
		echo "Usage: make shell STACK=stack-name SERVICE=service-name"; \
		exit 1; \
	fi
	@if [ ! -d "stacks/$(STACK)" ]; then \
		echo "Error: Stack 'stacks/$(STACK)' does not exist"; \
		exit 1; \
	fi
	@if [ ! -f "stacks/$(STACK)/compose.yaml" ]; then \
		echo "Error: compose.yaml not found in stacks/$(STACK)/"; \
		exit 1; \
	fi
	@echo "Opening shell for service $(SERVICE) in stack $(STACK)... (Type 'exit' to quit)"
	@cd stacks/$(STACK) && docker compose --project-name docker-stacks_$(STACK) exec $(SERVICE) sh || \
		cd stacks/$(STACK) && docker compose --project-name docker-stacks_$(STACK) exec $(SERVICE) bash

lock-update:
	@if [ -z "$(STACK)" ]; then \
		echo "Error: STACK parameter is required"; \
		echo "Usage: make lock-update STACK=stack-name [SERVICE=service-name]"; \
		exit 1; \
	fi
	@if [ ! -d "stacks/$(STACK)" ]; then \
		echo "Error: Stack 'stacks/$(STACK)' does not exist"; \
		exit 1; \
	fi
	@echo "Updating lock file for stack $(STACK)..."
	@./scripts/update-lock.sh $(STACK) $(SERVICE)
	@echo "✓ Lock file updated"

health:
	@if [ -z "$(STACK)" ]; then \
		echo "Error: STACK parameter is required"; \
		echo "Usage: make health STACK=stack-name"; \
		exit 1; \
	fi
	@if [ ! -d "stacks/$(STACK)" ]; then \
		echo "Error: Stack 'stacks/$(STACK)' does not exist"; \
		exit 1; \
	fi
	@if [ ! -f "stacks/$(STACK)/compose.yaml" ]; then \
		echo "Error: compose.yaml not found in stacks/$(STACK)/"; \
		exit 1; \
	fi
	@echo "Checking health of services in stack $(STACK)..."
	@cd stacks/$(STACK) && docker compose --project-name docker-stacks_$(STACK) ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"

clean:
	@echo "Cleaning up Docker resources..."
	@echo "Stopping all running containers..."
	@docker compose down --remove-orphans 2>/dev/null || true
	@echo "Removing dangling images and unused networks..."
	@docker image prune -f
	@docker network prune -f
	@docker volume prune -f
	@echo "✓ Docker cleanup completed"