#!/bin/bash
set -e

echo "🚀 Starting Flutter Development Environment Setup..."

# Update system packages
echo "📦 Updating system packages..."
sudo apt-get update

# Install required system dependencies for Flutter Linux development
echo "🔧 Installing system dependencies..."
sudo apt-get install -y \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    liblzma-dev \
    libstdc++-12-dev \
    libglib2.0-dev \
    mesa-utils \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    xvfb \
    x11vnc \
    fluxbox \
    dbus-x11 \
    libxrandr2 \
    libxcursor1 \
    libxi6 \
    libxinerama1 \
    libsqlite3-dev \
    sqlite3

# Create symlink for SQLite if needed
echo "🔗 Configuring SQLite..."
if [ ! -f "/usr/lib/x86_64-linux-gnu/libsqlite3.so" ]; then
    sudo ln -s /usr/lib/x86_64-linux-gnu/libsqlite3.so.0 /usr/lib/x86_64-linux-gnu/libsqlite3.so
fi

# Install Flutter SDK
echo "📱 Installing Flutter SDK..."
if [ ! -d "/opt/flutter" ]; then
    sudo git clone https://github.com/flutter/flutter.git -b stable --depth 1 /opt/flutter
    sudo chown -R $(whoami):$(whoami) /opt/flutter
fi

# Add Flutter to PATH
export PATH="$PATH:/opt/flutter/bin"
echo 'export PATH="$PATH:/opt/flutter/bin"' >> ~/.bashrc
echo 'export PATH="$PATH:/opt/flutter/bin"' >> ~/.zshrc 2>/dev/null || true

# Pre-download Flutter dependencies
echo "⬇️  Pre-downloading Flutter dependencies..."
flutter precache --linux

# Enable Linux desktop support
echo "🖥️  Enabling Linux desktop support..."
flutter config --enable-linux-desktop
flutter config --no-analytics

# Fix workspace permissions
echo "🔐 Setting up workspace permissions..."
sudo chown -R $(whoami):$(whoami) /workspaces/majmuah
chmod -R u+w /workspaces/majmuah

# Install Flutter project dependencies
echo "📚 Installing Flutter project dependencies..."
cd /workspaces/majmuah
flutter pub get

# Generate code (if needed)
echo "🔨 Checking for code generation..."
if [ -f "pubspec.yaml" ] && grep -q "build_runner" pubspec.yaml; then
    echo "Skipping build_runner due to version compatibility (generated files already exist)"
    # dart run build_runner build --delete-conflicting-outputs || echo "⚠️  Code generation skipped due to compatibility issues"
fi

# Run Flutter doctor to check setup
echo "🏥 Running Flutter doctor..."
flutter doctor -v

echo ""
echo "✅ Setup complete! You can now run your Flutter app with:"
echo "   flutter run -d linux"
echo ""
echo "💡 Useful commands:"
echo "   flutter doctor          - Check environment setup"
echo "   flutter pub get         - Update dependencies"
echo "   flutter clean           - Clean build artifacts"
echo "   flutter run -d linux    - Run on Linux desktop"
echo ""

# Setup display for GUI applications
echo "🖥️  Setting up virtual display..."
mkdir -p ~/.vnc
echo "#!/bin/bash
export DISPLAY=:99
Xvfb :99 -screen 0 1280x1024x24 > /dev/null 2>&1 &
fluxbox > /dev/null 2>&1 &
" > ~/.display-setup.sh
chmod +x ~/.display-setup.sh

# Add display setup to bashrc
if ! grep -q "DISPLAY=:99" ~/.bashrc; then
    echo 'export DISPLAY=:99' >> ~/.bashrc
    echo '# Start virtual display if not running' >> ~/.bashrc
    echo 'if ! pgrep -x "Xvfb" > /dev/null; then' >> ~/.bashrc
    echo '    Xvfb :99 -screen 0 1280x1024x24 > /dev/null 2>&1 &' >> ~/.bashrc
    echo 'fi' >> ~/.bashrc
fi

# Start virtual display now
export DISPLAY=:99
if ! pgrep -x "Xvfb" > /dev/null; then
    Xvfb :99 -screen 0 1280x1024x24 > /dev/null 2>&1 &
    sleep 2
    echo "✅ Virtual display started on :99"
fi

echo ""
echo "🎉 All setup complete!"
echo ""
