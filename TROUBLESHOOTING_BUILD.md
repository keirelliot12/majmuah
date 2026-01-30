# 🔧 TROUBLESHOOTING GUIDE: Build Issues

**Date**: January 30, 2026

---

## Issue 1: Dart SDK Locked

### Symptoms
```
Error: Unable to update Dart SDK after 3 retries.
The process cannot access the file because it is being used by another process.
```

### Cause
Proses Dart dari IDE atau build sebelumnya masih berjalan dan mengunci file SDK.

### Solution

1. **Tutup semua proses Dart/Flutter**:
   ```powershell
   # Di PowerShell sebagai Administrator
   Get-Process -Name "dart*" | Stop-Process -Force
   Get-Process -Name "flutter*" | Stop-Process -Force
   ```

2. **Tutup IDE** (IntelliJ IDEA, Android Studio, VS Code)

3. **Jalankan ulang**:
   ```powershell
   cd C:\Users\PC\StudioProjects\majmuah
   J:\flutter\bin\flutter.bat clean
   J:\flutter\bin\flutter.bat pub get
   ```

---

## Issue 2: Out of Memory (OOM) During Build

### Symptoms
```
runtime/vm/zone.cc: 96: error: Out of memory.
=== Crash occurred when compiling dart:core_RegExp...
```

### Cause
Dart compiler kehabisan memori saat mengompilasi kode yang kompleks.

### Solutions

1. **Tutup aplikasi lain** untuk membebaskan RAM

2. **Gunakan release build** (lebih ringan):
   ```powershell
   flutter build apk --release
   ```

3. **Batasi parallel jobs**:
   ```powershell
   flutter build apk --debug -j 1
   ```

4. **Tambah swap memory** (Windows):
   - Settings → System → About → Advanced system settings
   - Performance → Settings → Advanced → Virtual memory
   - Set custom size: Initial 8192, Maximum 16384

5. **Clear Dart cache**:
   ```powershell
   Remove-Item -Recurse -Force J:\flutter\bin\cache\dart-sdk
   flutter doctor
   ```

---

## Issue 3: Gradle Version Warnings

### Symptoms
```
Warning: Flutter support for your project's Gradle version (8.5.0) will soon be dropped.
```

### Solution

Update `android/gradle/wrapper/gradle-wrapper.properties`:
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.7-all.zip
```

Update `android/settings.gradle`:
```groovy
plugins {
    id "com.android.application" version "8.6.0" apply false
    id "org.jetbrains.kotlin.android" version "2.1.0" apply false
}
```

---

## Quick Recovery Steps

```powershell
# 1. Kill all Flutter/Dart processes
taskkill /F /IM dart.exe 2>$null
taskkill /F /IM flutter.exe 2>$null

# 2. Close IDE

# 3. Clean and rebuild
cd C:\Users\PC\StudioProjects\majmuah
Remove-Item -Recurse -Force build 2>$null
Remove-Item -Recurse -Force .dart_tool 2>$null
J:\flutter\bin\flutter.bat clean
J:\flutter\bin\flutter.bat pub get
J:\flutter\bin\flutter.bat pub run build_runner build --delete-conflicting-outputs
J:\flutter\bin\flutter.bat build apk --release
```

---

## Verification Commands

```powershell
# Check Flutter status
flutter doctor -v

# Check for errors
flutter analyze

# Test build
flutter build apk --release
```

---

**Note**: Jika masalah tetap berlanjut, restart komputer dan coba lagi.

