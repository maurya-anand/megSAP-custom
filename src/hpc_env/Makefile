.PHONY: help

help:
	@echo "Invalid target"
	@echo ""
	@echo "Please refer to the installation instructions in the README.md"

.DEFAULT_GOAL := help

ENV_NAME := megsap

ENV_FILE := environment.yml

CONTAINER_URL=oras://ghcr.io/maurya-anand/megsap-custom

CONTAINER_VER=1.0.0

SRC_DIR := $(abspath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/../..)


create_env:
	@if command -v mamba >/dev/null 2>&1; then \
		mamba env create -f $(ENV_FILE) --name $(ENV_NAME); \
		mamba run -n $(ENV_NAME) apptainer pull $(SRC_DIR)/megsap-custom_$(CONTAINER_VER).sif $(CONTAINER_URL):$(CONTAINER_VER); \
	elif command -v conda >/dev/null 2>&1; then \
		conda env create -f $(ENV_FILE) --name $(ENV_NAME); \
		conda run -n $(ENV_NAME) apptainer pull $(SRC_DIR)/megsap-custom_$(CONTAINER_VER).sif $(CONTAINER_URL):$(CONTAINER_VER); \
	else \
		echo "Neither mamba nor conda is installed. Please refer to the requirements section in the README.md."; \
		exit 1; \
	fi; 

update_env:
	@if command -v mamba >/dev/null 2>&1; then \
		mamba env update -f $(ENV_FILE) --name $(ENV_NAME); \
		rm -f $(SRC_DIR)/megsap-custom_$(CONTAINER_VER).sif; \
		mamba run -n $(ENV_NAME) apptainer pull $(SRC_DIR)/megsap-custom_$(CONTAINER_VER).sif $(CONTAINER_URL):$(CONTAINER_VER); \
	elif command -v conda >/dev/null 2>&1; then \
		conda env update -f $(ENV_FILE) --name $(ENV_NAME); \
		rm -f $(SRC_DIR)/megsap-custom_$(CONTAINER_VER).sif; \
		conda run -n $(ENV_NAME) apptainer pull $(SRC_DIR)/megsap-custom_$(CONTAINER_VER).sif $(CONTAINER_URL):$(CONTAINER_VER); \
	else \
		echo "Neither mamba nor conda is installed. Please refer to the requirements section in the README.md."; \
		exit 1; \
	fi;

uninstall_env:
	@if command -v mamba >/dev/null 2>&1; then \
		mamba env remove -n $(ENV_NAME); \
	else \
		conda env remove -n $(ENV_NAME); \
	fi
