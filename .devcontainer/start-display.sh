#!/bin/bash
# Start Virtual Display and VNC Server for GUI Applications

set -e

echo "🖥️  Setting up virtual display and VNC server..."

# Kill existing processes
pkill Xvfb 2>/dev/null || true
pkill x11vnc 2>/dev/null || true
pkill fluxbox 2>/dev/null || true

# Start Xvfb (Virtual Display)
export DISPLAY=:99
Xvfb :99 -screen 0 1280x1024x24 -ac > /dev/null 2>&1 &
sleep 2
echo "✅ Virtual display started on :99"

# Start window manager
fluxbox > /dev/null 2>&1 &
sleep 1
echo "✅ Window manager started"

# Start VNC server (optional, for remote viewing)
x11vnc -display :99 -forever -shared -rfbport 5900 -passwd codespace > /dev/null 2>&1 &
sleep 1
echo "✅ VNC server started on port 5900 (password: codespace)"

echo ""
echo "🎉 Display environment ready!"
echo ""
echo "To view the GUI:"
echo "  1. Forward port 5900 in VS Code"
echo "  2. Connect with VNC client to localhost:5900"
echo "  3. Password: codespace"
echo ""
