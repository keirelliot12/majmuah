.PHONY: help run build test clean doctor upgrade analyze format generate setup

# Flutter path
FLUTTER := /opt/flutter/bin/flutter
DART := /opt/flutter/bin/dart

# Ensure DISPLAY is set
export DISPLAY ?= :99

# Check and start Xvfb if needed
XVFB_CHECK := $(shell pgrep -x Xvfb > /dev/null || (Xvfb :99 -screen 0 1280x1024x24 > /dev/null 2>&1 & sleep 2))

help:
	@echo "Flutter Islamic App - Makefile Commands"
	@echo ""
	@echo "Available commands:"
	@echo "  make run        - Run the app on Linux"
	@echo "  make build      - Build release version"
	@echo "  make test       - Run tests"
	@echo "  make clean      - Clean build artifacts"
	@echo "  make doctor     - Check Flutter installation"
	@echo "  make upgrade    - Upgrade dependencies"
	@echo "  make analyze    - Analyze code"
	@echo "  make format     - Format code"
	@echo "  make generate   - Generate code files"
	@echo "  make setup      - Initial project setup"

run:
	@echo "🚀 Running app on Linux..."
	@$(FLUTTER) run -d linux

build:
	@echo "🔨 Building for Linux release..."
	@$(FLUTTER) build linux --release

test:
	@echo "🧪 Running tests..."
	@$(FLUTTER) test

clean:
	@echo "🧹 Cleaning build artifacts..."
	@$(FLUTTER) clean
	@$(FLUTTER) pub get

doctor:
	@echo "🏥 Running Flutter doctor..."
	@$(FLUTTER) doctor -v

upgrade:
	@echo "⬆️  Upgrading dependencies..."
	@$(FLUTTER) pub upgrade

analyze:
	@echo "🔍 Analyzing code..."
	@$(FLUTTER) analyze

format:
	@echo "✨ Formatting code..."
	@$(DART) format lib/ test/

generate:
	@echo "🔨 Generating code..."
	@$(DART) run build_runner build --delete-conflicting-outputs

setup:
	@echo "⚙️  Setting up project..."
	@$(FLUTTER) pub get
	@echo "✅ Setup complete!"
