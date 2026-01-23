# GUI Display Fix for Dev Container

## Problem
When running Flutter desktop apps in headless environments (GitHub Codespaces, Docker containers), you get:
```
(islamic:20745): Gtk-WARNING **: cannot open display: 
Error waiting for a debug connection: The log reader stopped unexpectedly
```

## Solution
We've configured a virtual display using Xvfb (X Virtual Framebuffer) and optional VNC for viewing.

## What Was Added

### 1. System Packages
- `xvfb` - Virtual X11 display server
- `x11vnc` - VNC server for remote viewing
- `fluxbox` - Lightweight window manager
- `dbus-x11` - D-Bus X11 integration
- Additional X11 libraries

### 2. Virtual Display Setup
The display is automatically started:
- Display number: `:99`
- Resolution: 1280x1024x24
- Auto-starts on terminal open

### 3. Environment Configuration
- `DISPLAY=:99` - Set in all terminals
- `LIBGL_ALWAYS_INDIRECT=1` - For indirect rendering
- Auto-start script in `.bashrc`

## Usage

### Running Flutter Apps
The display is automatically configured. Just run:
```bash
flutter run -d linux
# or
make run
# or
./flutter-commands.sh run
```

### Viewing the GUI (Optional)
If you want to see the actual GUI:

1. **Start VNC Server**:
   ```bash
   bash .devcontainer/start-display.sh
   ```

2. **Forward Port 5900**:
   - In VS Code: Ports panel → Forward Port → 5900
   - Or in Codespaces: Forward port 5900

3. **Connect with VNC Client**:
   - Address: `localhost:5900`
   - Password: `codespace`
   
   VNC Clients:
   - **macOS**: Built-in Screen Sharing (Finder → Go → Connect to Server → `vnc://localhost:5900`)
   - **Windows**: TigerVNC, TightVNC, RealVNC
   - **Linux**: Remmina, TigerVNC
   - **Browser**: noVNC (web-based)

### Manual Display Control

**Check if Xvfb is running**:
```bash
pgrep Xvfb
```

**Start Xvfb manually**:
```bash
Xvfb :99 -screen 0 1280x1024x24 > /dev/null 2>&1 &
```

**Stop Xvfb**:
```bash
pkill Xvfb
```

**Check DISPLAY variable**:
```bash
echo $DISPLAY
```

## Files Modified

1. **`.devcontainer/setup.sh`**
   - Added Xvfb and VNC installation
   - Auto-start virtual display
   - Configure bashrc

2. **`.devcontainer/devcontainer.json`**
   - Added `DISPLAY` and `LIBGL_ALWAYS_INDIRECT` environment variables

3. **`.devcontainer/start-display.sh`** (new)
   - Script to start Xvfb, Fluxbox, and VNC server

4. **`flutter-commands.sh`**
   - Auto-check and start Xvfb if not running
   - Set DISPLAY variable

5. **`Makefile`**
   - Export DISPLAY variable
   - Auto-start Xvfb check

6. **`~/.bashrc`**
   - Auto-export DISPLAY=:99
   - Auto-start Xvfb on terminal open

## Testing

Test if display is working:
```bash
# Check DISPLAY
echo $DISPLAY

# Test X11 (should not error)
xdpyinfo -display :99

# Run a simple X app
xeyes &
```

## Troubleshooting

### "cannot open display" error
```bash
# Ensure DISPLAY is set
export DISPLAY=:99

# Restart Xvfb
pkill Xvfb
Xvfb :99 -screen 0 1280x1024x24 > /dev/null 2>&1 &
sleep 2
```

### Flutter still can't open display
```bash
# Check if Xvfb is running
ps aux | grep Xvfb

# Source bashrc
source ~/.bashrc

# Try running with explicit DISPLAY
DISPLAY=:99 flutter run -d linux
```

### VNC connection refused
```bash
# Restart VNC server
pkill x11vnc
x11vnc -display :99 -forever -shared -rfbport 5900 -passwd codespace &
```

### Black screen in VNC
```bash
# Restart window manager
pkill fluxbox
fluxbox &
```

## Performance Notes

- Xvfb uses minimal resources (headless)
- VNC only needed if you want to view the GUI
- App runs fine without viewing it
- Good for automated testing and CI/CD

## Container Rebuild

When you rebuild the container:
- Virtual display auto-configured
- DISPLAY variable auto-set
- Xvfb auto-starts
- No manual intervention needed

## References

- [Xvfb Manual](https://www.x.org/releases/X11R7.6/doc/man/man1/Xvfb.1.xhtml)
- [x11vnc Documentation](https://github.com/LibVNC/x11vnc)
- [Flutter Linux Desktop](https://docs.flutter.dev/platform-integration/linux/install-linux)
