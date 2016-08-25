SHELL := /bin/bash

# If you need to put your Makefile in a different directory to your compose 
# file, you will need to edit the variable below
DOCKER_FILE := docker-compose.yml
COMPOSE := docker-compose -f $(DOCKER_FILE)
SERVICE_COMMANDS := pull build down kill rm ps stop events unpause restart port pause create
COMPOSE_COMMANDS := config version $(SERVICE_COMMANDS)
SERVICES := $(shell $(COMPOSE) config --services)

.PHONY: $(SERVICES)

all: up

up:
	$(COMPOSE) up -d

logs:
	$(COMPOSE) logs -f

reboot:
	make down up

$(SERVICES):
	make $@/up

$(COMPOSE_COMMANDS):
	$(COMPOSE) "$@"

# Start a bash shell in the given container
$(foreach service,$(SERVICES),$(service)/ssh):
	$(COMPOSE) exec $(word 1, $(subst /, ,$@)) bash

# Stop, remove then up a container
$(foreach service,$(SERVICES),$(service)/reboot):
	$(eval TASK := $(subst /, ,$@))
	make $(word 1, $(TASK))/stop $(word 1, $(TASK))/rm $(word 1, $(TASK))/up

# Start a container in the background
$(foreach service,$(SERVICES),$(service)/up):
	$(COMPOSE) up -d $(word 1, $(subst /, ,$@))

# Attach to the container's log output
$(foreach service,$(SERVICES),$(service)/logs):
	$(COMPOSE) logs -f $(word 1, $(subst /, ,$@))

$(foreach service,$(SERVICES),$(foreach command,$(SERVICE_COMMANDS),$(service)/$(command))):
	$(eval TASK := $(subst /, ,$@))
	$(COMPOSE) $(word 2, $(TASK)) $(word 1, $(TASK))
