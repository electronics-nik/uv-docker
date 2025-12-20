.PHONY: help version clean commit lint test coverage
.DEFAULT_GOAL := help

SHELL := /bin/bash
VENV_PREFIX ?= uv run

VERSION := $(shell $(VENV_PREFIX) cz version -p)

# Macro to print help
# Don't leave space after ## (Eg. ##***CI/CD-only***) to prevent help from picking up
define PRINT_HELP_PYSCRIPT
import re, sys

print("\nPossible commands:")
for line in sys.stdin:
	match = re.match(r'^([a-zA-Z0-9_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("  %-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

help:  ## Print this help message
	@echo src version $(VERSION)
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

version:  ## Print version
	@echo $(VERSION)

install-uv:  ## Install uv
	@if ! command -v uv >/dev/null 2>&1; then \
			echo "uv not found, installing..."; \
			brew install uv; \
	else \
			echo "uv is already installed."; \
	fi

init-venv:  ## Install python libraries defined in pyproject.toml
	uv sync

setup-pre-commit:  ## Install pre-commit hooks
	$(VENV_PREFIX) pre-commit install
	$(VENV_PREFIX) pre-commit autoupdate

init-dev: install-uv init-venv setup-pre-commit

init-cicd: install-uv init-venv

commit:
	$(VENV_PREFIX) cz commit
