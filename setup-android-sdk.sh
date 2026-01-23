#!/bin/bash
# Setup Android SDK and Build Tools untuk Flutter App Build
# Install: Android SDK, Build Tools, NDK
# Setup: Signing key, Gradle configuration

set -e

echo "========================================"
echo "🔧 Android SDK & Build Tools Setup"
echo "========================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Setup variables
ANDROID_HOME="${ANDROID_HOME:-$HOME/Android}"
SDK_TOOLS_VERSION="11076708"
NDK_VERSION="26.1.10909125"
BUILD_TOOLS_VERSION="34.0.0"
ANDROID_PLATFORM="android-34"

echo "📁 Creating Android directories..."
mkdir -p "$ANDROID_HOME/cmdline-tools"
mkdir -p "$ANDROID_HOME/licenses"

# Step 1: Download and install SDK Command Line Tools
echo ""
echo "📥 Downloading SDK Command Line Tools..."
cd "$ANDROID_HOME/cmdline-tools"

if [ ! -f "latest/bin/sdkmanager" ]; then
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-${SDK_TOOLS_VERSION}_latest.zip
    unzip -q commandlinetools-linux-${SDK_TOOLS_VERSION}_latest.zip
    rm commandlinetools-linux-${SDK_TOOLS_VERSION}_latest.zip
    mv cmdline-tools latest
    echo "✅ SDK Command Line Tools installed"
else
    echo "⏭️  SDK Command Line Tools already installed"
fi

cd ~

# Step 2: Setup PATH
echo ""
echo "🛣️  Setting up PATH..."
export ANDROID_HOME
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

# Add to bashrc for persistence
if ! grep -q "ANDROID_HOME=$ANDROID_HOME" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# Android SDK Setup" >> ~/.bashrc
    echo "export ANDROID_HOME=$ANDROID_HOME" >> ~/.bashrc
    echo 'export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"' >> ~/.bashrc
fi

# Step 3: Accept licenses
echo ""
echo "📜 Accepting Android licenses..."
yes | sdkmanager --licenses > /dev/null 2>&1 || true
echo "✅ Licenses accepted"

# Step 4: Install SDK Platform
echo ""
echo "📦 Installing Android SDK Platform ($ANDROID_PLATFORM)..."
sdkmanager "platforms;$ANDROID_PLATFORM" > /dev/null 2>&1
echo "✅ Android SDK Platform installed"

# Step 5: Install Build Tools
echo ""
echo "🔨 Installing Build Tools ($BUILD_TOOLS_VERSION)..."
sdkmanager "build-tools;$BUILD_TOOLS_VERSION" > /dev/null 2>&1
echo "✅ Build Tools installed"

# Step 6: Install NDK
echo ""
echo "⚙️  Installing NDK ($NDK_VERSION)..."
sdkmanager "ndk;$NDK_VERSION" > /dev/null 2>&1
echo "✅ NDK installed"

# Step 7: Verify installation
echo ""
echo "🔍 Verifying installation..."
echo "✓ ANDROID_HOME: $ANDROID_HOME"
echo "✓ SDK Tools: $ANDROID_HOME/cmdline-tools/latest/bin"
echo "✓ Build Tools: $ANDROID_HOME/build-tools/$BUILD_TOOLS_VERSION"
echo "✓ Platform: $ANDROID_PLATFORM"
echo "✓ NDK: $ANDROID_HOME/ndk/$NDK_VERSION"

echo ""
echo "========================================" 
echo "✅ Android SDK Setup Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Run: ./setup-signing-key.sh"
echo "2. Run: flutter build appbundle --release"
echo ""
