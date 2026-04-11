#!/bin/bash
# Quick Flutter Commands for Islamic App

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}Flutter Islamic App - Quick Commands${NC}"
echo ""

# Function to print section
print_section() {
    echo -e "${GREEN}$1${NC}"
}

# Add Flutter to PATH if not already
export PATH="$PATH:/opt/flutter/bin"

# Ensure DISPLAY is set for GUI applications
export DISPLAY=${DISPLAY:-:99}

# Check if Xvfb is running, start if not
if ! pgrep -x "Xvfb" > /dev/null; then
    echo -e "${YELLOW}Starting virtual display...${NC}"
    Xvfb :99 -screen 0 1280x1024x24 > /dev/null 2>&1 &
    sleep 2
fi

case "${1:-help}" in
    "run")
        print_section "🚀 Running app on Linux..."
        flutter run -d linux
        ;;
    
    "build")
        print_section "🔨 Building for Linux release..."
        flutter build linux --release
        ;;
    
    "test")
        print_section "🧪 Running tests..."
        flutter test
        ;;
    
    "clean")
        print_section "🧹 Cleaning build artifacts..."
        flutter clean
        flutter pub get
        ;;
    
    "doctor")
        print_section "🏥 Running Flutter doctor..."
        flutter doctor -v
        ;;
    
    "upgrade")
        print_section "⬆️  Upgrading dependencies..."
        flutter pub upgrade
        ;;
    
    "analyze")
        print_section "🔍 Analyzing code..."
        flutter analyze
        ;;
    
    "format")
        print_section "✨ Formatting code..."
        dart format lib/ test/
        ;;
    
    "generate")
        print_section "🔨 Generating code..."
        dart run build_runner build --delete-conflicting-outputs
        ;;
    
    "devices")
        print_section "📱 Available devices..."
        flutter devices
        ;;
    
    "help")
        echo "Available commands:"
        echo ""
        echo -e "  ${YELLOW}run${NC}       - Run the app on Linux"
        echo -e "  ${YELLOW}build${NC}     - Build release version"
        echo -e "  ${YELLOW}test${NC}      - Run tests"
        echo -e "  ${YELLOW}clean${NC}     - Clean and get dependencies"
        echo -e "  ${YELLOW}doctor${NC}    - Check Flutter installation"
        echo -e "  ${YELLOW}upgrade${NC}   - Upgrade dependencies"
        echo -e "  ${YELLOW}analyze${NC}   - Analyze code for issues"
        echo -e "  ${YELLOW}format${NC}    - Format Dart code"
        echo -e "  ${YELLOW}generate${NC}  - Generate code (build_runner)"
        echo -e "  ${YELLOW}devices${NC}   - List available devices"
        echo ""
        echo "Usage: ./flutter-commands.sh [command]"
        ;;
    
    *)
        echo "Unknown command: $1"
        echo "Run './flutter-commands.sh help' for available commands"
        exit 1
        ;;
esac
