.PHONY: help

.DEFAULT_GOAL	:= help
SHELL			:= /bin/bash

ENV ?= DEV

DOCKER_COMPOSE_DEV=docker-compose-debug.yml
DOCKER_COMPOSE_PROD=docker-compose.yml

$(info Running with env value $(ENV) )

ifeq ($(ENV), DEV)
	DOCKER_COMPOSE_FLAGS := -f $(DOCKER_COMPOSE_DEV)
else ifeq ($(ENV), PROD)
	DOCKER_COMPOSE_FLAGS := -f $(DOCKER_COMPOSE_PROD)
else
    $(error Invalid ENV value. Use DEV or PROD.)
endif

help: # http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


# ===================================================
#  DEV ENVIRONMENT COMMANDS
# ===================================================
build: ## Build containers.
	docker compose $(DOCKER_COMPOSE_FLAGS) build

start:  ## Create and start containers.
	docker compose $(DOCKER_COMPOSE_FLAGS) up -d --force-recreate

undetached:  ## Create and start containers.
	docker compose $(DOCKER_COMPOSE_FLAGS) up --force-recreate

restart:  ## Restart service containers.
	docker compose $(DOCKER_COMPOSE_FLAGS) restart

stop:  ## Stop all containers.
	docker compose $(DOCKER_COMPOSE_FLAGS) stop

down:  ## Stop all containers.
	docker compose $(DOCKER_COMPOSE_FLAGS) down

ps:  ## List containers.
	docker compose $(DOCKER_COMPOSE_FLAGS) ps

logs:  ## Show all containers logs.
	docker compose $(DOCKER_COMPOSE_FLAGS) logs -f

clean_docker:  ## Remove all container and images.
	docker rm $$(docker ps -a -q)
	docker rmi $$(docker image ls -q)
