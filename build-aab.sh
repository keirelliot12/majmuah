#!/bin/bash
# Complete build script for Android App Bundle (AAB)
# Builds optimized app bundle for Google Play Console

set -e

echo "========================================" 
echo "📦 Building Android App Bundle (AAB)"
echo "========================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Setup Flutter path
export PATH="$PATH:/opt/flutter/bin"

# Check Flutter installation
echo -e "${BLUE}🔍 Checking Flutter setup...${NC}"
flutter doctor -v | grep -E "Flutter|Android toolchain|build-tools" | head -5
echo ""

# Check if key.properties exists
if [ ! -f "android/key.properties" ]; then
    echo -e "${YELLOW}⚠️  key.properties not found!${NC}"
    echo "Please run: ./setup-signing-key.sh"
    exit 1
fi

# Get version from pubspec.yaml
echo -e "${BLUE}📋 Reading version from pubspec.yaml...${NC}"
VERSION=$(grep "^version:" pubspec.yaml | cut -d' ' -f2)
echo "App version: $VERSION"
echo ""

# Step 1: Clean build
echo -e "${BLUE}🧹 Cleaning previous builds...${NC}"
flutter clean
flutter pub get
echo ""

# Step 2: Build AAB
echo -e "${BLUE}🔨 Building Android App Bundle...${NC}"
flutter build appbundle --release

# Step 3: Get output path
OUTPUT_PATH="build/app/outputs/bundle/release/app-release.aab"

if [ -f "$OUTPUT_PATH" ]; then
    echo ""
    echo -e "${GREEN}✅ AAB Build Successful!${NC}"
    echo ""
    echo -e "${BLUE}📦 Output Information:${NC}"
    SIZE=$(du -h "$OUTPUT_PATH" | cut -f1)
    echo "  File: $OUTPUT_PATH"
    echo "  Size: $SIZE"
    echo "  SHA256: $(sha256sum $OUTPUT_PATH | cut -d' ' -f1)"
    echo ""
    echo -e "${BLUE}📍 Next Steps:${NC}"
    echo "1. Login to Google Play Console"
    echo "2. Create new release"
    echo "3. Upload AAB file: $OUTPUT_PATH"
    echo "4. Add release notes"
    echo "5. Review and publish"
    echo ""
    echo -e "${BLUE}📚 Useful Commands:${NC}"
    echo "  Verify AAB: bundletool-linux validate --bundle-path=$OUTPUT_PATH"
    echo "  View APKs: bundletool-linux dump manifest --bundle=$OUTPUT_PATH"
    echo ""
else
    echo -e "${RED}❌ Build failed!${NC}"
    exit 1
fi

echo "========================================"
echo -e "${GREEN}✅ Ready for Google Play Console!${NC}"
echo "========================================"
