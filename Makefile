# Include .env file if it exists
ifneq (,$(wildcard .env))
    include .env
    export $(shell sed 's/=.*//' .env)
endif

# Read from Cargo.toml if values are not set in .env
APP_NAME ?= $(shell toml get Cargo.toml package.name)
APP_VERSION ?= $(shell toml get Cargo.toml package.version)
GH_USER ?= codeitlikemiley


# Default target
.PHONY: all
all: info build registry deploy

# Print app info
.PHONY: info
info:
	@echo "App Name: $(APP_NAME)"
	@echo "App Version: $(APP_VERSION)"

# Build the project
.PHONY: build
build:
	spin build
	@echo "Build complete for $(APP_NAME) version $(APP_VERSION)"

.PHONY: up
up:
	spin up
	@echo "Running $(APP_NAME) version $(APP_VERSION) locally at port 3000"

# Push Build Image to Registry
.PHONY: registry
registry:
	spin registry push ghcr.io/$(GH_USER)/$(APP_NAME):$(APP_VERSION)

# Deploy the to AKS
.PHONY: deploy
deploy:
	spin kube deploy --from ghcr.io/$(GH_USER)/$(APP_NAME):$(APP_VERSION)

# Port forward the service
.PHONY: open
open:
	kubectl port-forward svc/$(APP_NAME) 8080:80

# Close port
.PHONY: close
close:
	lsof -ti:8080 | xargs kill

# Get Pods
.PHONY: pods
pods:
	kubectl get pods

# Run the project
.PHONY: run
run:
	spin watch
	@echo "Running $(APP_NAME) version $(APP_VERSION)"

# Stop all pods
.PHONY: stop
stop:
	kubectl delete -f spinapp.yaml

# Clean the project
.PHONY: clean
clean:
	cargo clean
	@echo "Clean complete for $(APP_NAME)"

# Stop All Pods and Clean the Project
.PHONY: reset
reset: stop clean
	@echo "Reset complete for $(APP_NAME)"
