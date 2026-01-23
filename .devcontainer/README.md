# Dev Container Configuration

This dev container is configured to automatically set up a complete Flutter development environment for the Islamic app project.

## What Gets Installed

### System Dependencies
- **Build Tools**: clang, cmake, ninja-build
- **GTK Libraries**: libgtk-3-dev (for Linux desktop UI)
- **Compression**: liblzma-dev, xz-utils, zip, unzip
- **Graphics**: mesa-utils, libglu1-mesa (for OpenGL support)
- **C++ Development**: libstdc++-12-dev
- **GLib**: libglib2.0-dev

### Flutter SDK
- Latest stable Flutter SDK (installed to `/opt/flutter`)
- Linux desktop support enabled
- Pre-cached Linux artifacts

### VS Code Extensions
- **Dart Code**: Dart language support
- **Flutter**: Flutter framework support
- **Flutter Snippets**: Code snippets for Flutter development
- **Error Lens**: Inline error highlighting
- **Prettier**: Code formatting
- **Docker**: Container management

### Project Dependencies
All dependencies from `pubspec.yaml` including:
- State management (flutter_bloc, equatable)
- Networking (dio, retrofit)
- Database (floor, sqflite)
- UI components (flutter_svg, google_fonts)
- Localization (easy_localization)
- Location services (location, geocoding)
- Media (youtube_player_flutter)

## Usage

### First Time Setup
When you open this project in a GitHub Codespace or VS Code with Dev Containers:
1. The container will build automatically
2. All dependencies will be installed via `setup.sh`
3. Flutter will be configured and ready to use

### Running the App
```bash
flutter run -d linux
```

### Common Commands
```bash
# Check Flutter installation
flutter doctor

# Update dependencies
flutter pub get

# Clean build artifacts
flutter clean

# Run tests
flutter test

# Build for release
flutter build linux --release
```

### Rebuilding the Container
If you need to rebuild the container:
1. In VS Code: `Ctrl+Shift+P` → "Dev Containers: Rebuild Container"
2. Or manually: Delete container and reopen project

## Troubleshooting

### Permission Issues
If you encounter permission errors:
```bash
sudo chown -R $(whoami):$(whoami) /workspaces/majmuah
chmod -R u+w /workspaces/majmuah
```

### Flutter Not Found
Reload your terminal or run:
```bash
export PATH="$PATH:/opt/flutter/bin"
```

### Dependencies Issues
```bash
flutter clean
flutter pub get
```

## Notes

- Flutter SDK is installed system-wide at `/opt/flutter`
- Project dependencies are cached in `.pub-cache` for faster rebuilds
- The container uses Ubuntu 24.04 LTS
- Generated code files (*.g.dart) are preserved in the repository
