# 📱 Android App Bundle (AAB) Build Guide untuk Google Play Console

## ✅ Status Setup

Kami telah berhasil setup:
- ✅ Android SDK + Build Tools installed
- ✅ Signing key created dan configured
- ✅ key.properties file ready

## ⚠️ Current Issue

Ada compatibility issue antara:
- Gradle 7.5
- Flutter 3.38.7
- Java 17

## 🎯 Solusi Alternatif (3 Opsi)

### Opsi 1: Build di Local Machine (RECOMMENDED)

Jika Anda punya computer dengan Android Studio yang sudah di-setup:

```bash
# Di local machine
flutter pub get
flutter build appbundle --release
```

File akan ada di: `build/app/outputs/bundle/release/app-release.aab`

### Opsi 2: Build APK (Alternative ke AAB)

APK masih bisa upload ke Google Play Console, tapi AAB lebih optimal:

```bash
# Build APK
flutter build apk --release

# Output: build/app/outputs/apk/release/app-release.apk
```

### Opsi 3: Upgrade Flutter & Gradle (Experimental)

```bash
# Update Flutter
flutter upgrade

# Update Gradle
# Edit android/gradle/wrapper/gradle-wrapper.properties:
# distributionUrl=https\://services.gradle.org/distributions/gradle-8.1-all.zip

# Try build
flutter build appbundle --release
```

---

## 📋 Signing Key Info (Sudah Di-Setup)

```
Keystore: ~/.android/release.keystore
Alias: flutter-key
Key Properties: android/key.properties
Password: FlutterBuild@123
Validity: 30 years (10,950 days)
```

### Backup Key yang Important:

```bash
# Backup keystore Anda (JANGAN HILANG!)
cp ~/.android/release.keystore ~/my-app-release.keystore

# Simpan password di temp file (RAHASIA!)
echo "FlutterBuild@123" > ~/keystore-password.txt
chmod 600 ~/keystore-password.txt
```

---

## 🚀 Langkah Upload ke Google Play Console

### 1. Persiapan di Google Play Console

- Login ke [Google Play Console](https://play.google.com/console)
- Create new app atau buka existing app
- Navigasi ke "Release" → "Production"

### 2. Upload AAB

- Klik "Create new release"
- Upload file `.aab`

### 3. Add Release Notes

- Indonesia & English versi

### 4. Review & Publish

- Check app content rating form
- Confirm price & distribution
- Submit for review (1-2 hari approval)

---

## 📱 Files yang Sudah Disiapkan

```
✅ setup-android-sdk.sh       - Android SDK installation
✅ setup-signing-key.sh       - Signing key setup
✅ build-aab.sh              - AAB build script
✅ android/key.properties    - Signing configuration
✅ ~/.android/release.keystore - Signing key (backup it!)
```

---

## 🛠️ Manual Build Commands (kalau script tidak bekerja)

### Build APK (lebih sederhana):
```bash
export PATH="/usr/lib/jvm/java-17-openjdk-amd64/bin:$PATH:/opt/flutter/bin"
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export ANDROID_HOME=$HOME/Android

cd /workspaces/majmuah
flutter clean
flutter pub get
flutter build apk --release
```

Output: `build/app/outputs/apk/release/app-release.apk`

### Build AAB (setelah fixed):
```bash
# Same environment setup, tapi:
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

---

## 📊 APK vs AAB

| Aspek | APK | AAB |
|-------|-----|-----|
| Upload Google Play | ✅ Bisa | ✅ Direkomendasikan |
| Size lebih kecil | ❌ | ✅ |
| Dynamic features | ❌ | ✅ |
| Mudah di-setup | ✅ | ❌ |

**Rekomendasi**: Build APK untuk testing, AAB untuk production

---

## 🔧 Troubleshooting

### Build Failed - Gradle Issue
```bash
# Clear everything
flutter clean
rm -rf build/
rm -rf ~/.gradle

# Try again
flutter pub get
flutter build apk --release
```

### Missing android/key.properties
```bash
# Recreate
cat > android/key.properties << EOF
storeFile=/home/codespace/.android/release.keystore
storePassword=FlutterBuild@123
keyPassword=FlutterBuild@123
keyAlias=flutter-key
EOF
```

### Java Version Issue
```bash
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
java -version  # Verify Java 17
```

---

## 💾 Important Files Backup

Backup file-file ini sebelum dilanjutkan:

```bash
# Backup signing key
cp ~/.android/release.keystore ~/my-islamic-app.keystore

# Backup key.properties
cp android/key.properties ~/key.properties.backup

# Backup built app
cp build/app/outputs/apk/release/app-release.apk ~/app-release-backup.apk
```

---

## 📞 Next Steps

1. **Local Build**: Coba build di local machine dulu untuk confirm working
2. **Test Build**: Generate APK untuk testing
3. **Production**: Setelah tested, build AAB untuk Google Play Console
4. **Upload**: Upload ke Google Play Console production track
5. **Release**: Submit for review

---

## 🎯 Quick Links

- [Google Play Console](https://play.google.com/console)
- [Flutter Android Build Docs](https://docs.flutter.dev/deployment/android)
- [Google Play Console Help](https://support.google.com/googleplay/answer/7159011)

---

## ✨ Setelah Build Successful

```bash
# List build outputs
ls -lh build/app/outputs/

# Check APK size
du -h build/app/outputs/apk/release/app-release.apk

# Check signing (jika sudah punya)
jarsigner -verify -verbose -certs build/app/outputs/apk/release/app-release.apk
```

---

**TL;DR:**
1. Setup sudah done ✅
2. Build di local machine recommended 🖥️
3. Atau coba APK build di sini: `flutter build apk --release`
4. Upload ke Google Play Console 🚀

Butuh bantuan? Setup sudah siap, tinggal eksekusi!
