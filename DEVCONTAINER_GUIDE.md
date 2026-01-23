# 🚀 Dev Container Setup - Quick Start

## Apa yang Sudah Dibuat?

### 1. Dev Container Configuration
**File**: `.devcontainer/devcontainer.json`
- Konfigurasi container dengan Ubuntu 24.04
- Auto-install Flutter SDK dan dependensi
- Extensions VS Code otomatis terinstall
- Settings optimal untuk Flutter development

### 2. Setup Script
**File**: `.devcontainer/setup.sh`
- Script otomatis untuk install semua dependensi
- Install Flutter SDK stable version
- Install system dependencies (GTK, build tools, dll)
- Enable Linux desktop support
- Install project dependencies dari pubspec.yaml

### 3. VS Code Configuration
**Files dalam `.vscode/`**:
- `settings.json` - Pengaturan editor optimal untuk Flutter
- `launch.json` - Debug configurations
- `tasks.json` - Quick tasks (run, build, test, dll)
- `extensions.json` - Recommended extensions

### 4. Quick Command Tools
- `flutter-commands.sh` - Script untuk command Flutter yang sering dipakai
- `Makefile` - Make commands untuk development

## 🎯 Cara Menggunakan

### Pertama Kali (GitHub Codespaces / VS Code Dev Containers)

1. **Buka di Codespace**:
   - Klik "Code" → "Create codespace on [branch]"
   - Atau buka di VS Code dengan Dev Containers extension

2. **Tunggu Setup Otomatis**:
   - Container akan build otomatis
   - Script setup akan jalan
   - Flutter SDK dan semua dependensi akan terinstall
   - Proses memakan waktu 5-10 menit

3. **Mulai Coding**:
   - Setelah selesai, terminal akan menampilkan "✅ Setup complete!"
   - Semua siap digunakan!

### Restart Container

Setiap kali Anda restart atau rebuild container:
- Semua dependensi akan otomatis terinstall ulang
- Flutter SDK sudah tersedia di `/opt/flutter`
- Project dependencies sudah ter-install
- Tidak perlu manual setup lagi!

## 📝 Quick Commands

### Menggunakan Script
```bash
# Run app
./flutter-commands.sh run

# Build release
./flutter-commands.sh build

# Run tests
./flutter-commands.sh test

# Clean project
./flutter-commands.sh clean

# Lihat semua commands
./flutter-commands.sh help
```

### Menggunakan Make
```bash
make run      # Run app
make build    # Build release
make test     # Run tests
make clean    # Clean project
make doctor   # Flutter doctor
```

### Menggunakan VS Code Tasks
- `Ctrl+Shift+P` → "Tasks: Run Task"
- Pilih task yang diinginkan:
  - Flutter: Run on Linux
  - Flutter: Build Release
  - Flutter: Run Tests
  - dll

### Debug di VS Code
- Tekan `F5` untuk start debugging
- Atau pilih configuration di Debug panel:
  - Flutter: Debug
  - Flutter: Profile
  - Flutter: Release

## 🔄 Rebuild Container

Jika perlu rebuild container dari awal:

**VS Code**:
1. `Ctrl+Shift+P`
2. Ketik "Dev Containers: Rebuild Container"
3. Enter

**Codespaces**:
1. Tutup Codespace
2. Delete Codespace dari GitHub
3. Buat Codespace baru

## 📦 Yang Terinstall Otomatis

### System Packages
- clang, cmake, ninja-build
- GTK 3 development libraries
- Mesa utils (graphics)
- Build essential tools

### Flutter SDK
- Flutter stable channel
- Linux desktop support enabled
- Dart SDK included

### VS Code Extensions
- Dart & Flutter extensions
- Flutter snippets
- Error Lens
- Git extensions

### Project Dependencies
Semua dari `pubspec.yaml`:
- flutter_bloc, equatable
- dio, retrofit
- floor, sqflite
- flutter_svg, google_fonts
- easy_localization
- location, geocoding
- youtube_player_flutter
- Dan semua lainnya...

## 🛠️ Troubleshooting

### Container tidak build
- Cek koneksi internet
- Coba rebuild container
- Periksa log error di terminal

### Flutter command not found
Terminal mungkin belum reload. Jalankan:
```bash
export PATH="$PATH:/opt/flutter/bin"
# Atau
source ~/.bashrc
```

### Permission errors
```bash
sudo chown -R $(whoami):$(whoami) /workspaces/majmuah
chmod -R u+w /workspaces/majmuah
```

### Dependencies tidak ter-install
```bash
cd /workspaces/majmuah
flutter clean
flutter pub get
```

## 📚 Dokumentasi Lengkap

Lihat file-file berikut untuk info lebih detail:
- `.devcontainer/README.md` - Dokumentasi lengkap dev container
- `README.md` - Dokumentasi project utama

## ✨ Fitur

- ✅ **Zero Config**: Buka dan langsung pakai
- ✅ **Auto Setup**: Semua otomatis terinstall
- ✅ **Consistent**: Sama di semua machine
- ✅ **Fast Restart**: Rebuild cepat dengan cache
- ✅ **VS Code Integrated**: Tasks, debug, extensions
- ✅ **Flutter Ready**: SDK dan tools siap pakai

---

**Selamat coding! 🎉**

Jika ada masalah, check troubleshooting section atau lihat logs di terminal.
