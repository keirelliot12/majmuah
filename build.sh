#!/bin/bash
# Build Flutter app for available platforms (Web & Linux)
# Skip Android/iOS as they require additional SDKs

set -e

echo "🔨 Flutter Build Script (Web & Linux)"
echo ""

export PATH="$PATH:/opt/flutter/bin"

case "${1:-help}" in
    "web")
        echo "📱 Building for Web..."
        flutter build web --release
        echo "✅ Web build complete!"
        echo "📦 Output: build/web/"
        ;;
    
    "linux")
        echo "🖥️  Building for Linux..."
        flutter build linux --release
        echo "✅ Linux build complete!"
        echo "📦 Output: build/linux/x64/release/"
        ;;
    
    "all")
        echo "🔨 Building for all available platforms..."
        echo ""
        
        echo "📱 Building Web..."
        flutter build web --release
        echo "✅ Web done!"
        echo ""
        
        echo "🖥️  Building Linux..."
        flutter build linux --release
        echo "✅ Linux done!"
        echo ""
        
        echo "✅ All builds complete!"
        echo ""
        echo "📦 Outputs:"
        echo "  - Web: build/web/"
        echo "  - Linux: build/linux/x64/release/"
        ;;
    
    "help")
        echo "Usage: ./build.sh [platform]"
        echo ""
        echo "Platforms:"
        echo "  web     - Build for web browser"
        echo "  linux   - Build for Linux desktop"
        echo "  all     - Build for all platforms"
        echo ""
        echo "Note: Android/iOS builds require additional SDKs (not in container)"
        echo ""
        echo "Examples:"
        echo "  ./build.sh web"
        echo "  ./build.sh linux"
        echo "  ./build.sh all"
        ;;
    
    *)
        echo "Unknown platform: $1"
        echo "Use './build.sh help' for available options"
        exit 1
        ;;
esac
