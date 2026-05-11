# Aplikasi An Nibros 🕌

> **Teman mendekatkan diri kepada Allah** — [annibros.app](https://annibros.app)

Aplikasi An Nibros adalah aplikasi mobile & web berbasis Flutter yang dirancang sebagai pendamping spiritual harian bagi umat Muslim. Tersedia di Android, iOS, Web, dan Desktop (Linux/macOS/Windows).

---

## Fitur Utama

| Fitur | Keterangan |
|---|---|
| 📖 **Al-Quran Lengkap** | Baca seluruh 114 surah dengan font Utsman & Hafs. Termasuk fitur pencarian kata/ayat. |
| 🕌 **Hadith Arba'in An-Nawawi** | 40 hadith pilihan lengkap dengan terjemahan. |
| 🕐 **Waktu Shalat** | Jadwal shalat otomatis berdasarkan lokasi perangkat (via API [aladhan.com](https://aladhan.com)). |
| 📿 **Dzikir & Doa** | Koleksi dzikir harian dan doa pilihan. Mendukung dzikir kustom yang bisa ditambah/edit/hapus. |
| 🏛️ **Rukun Islam** | Penjelasan dan informasi Lima Rukun Islam. |
| 🎬 **Video YouTube** | Daftar video Islami pilihan yang bisa diputar langsung di dalam aplikasi. |
| 📚 **Materi Islami** | Konten/materi keislaman yang dapat dijelajahi berdasarkan kategori. |
| 📝 **Catatan** | Buat dan simpan catatan pribadi. |
| 🌐 **Multi-bahasa** | Tersedia dalam Bahasa Arab dan Bahasa Inggris. |
| 📥 **Download Manager** | Unduh aset Al-Quran (gambar halaman) untuk dibaca secara offline. |

---

## Arsitektur & Teknologi

- **Framework**: Flutter (Dart) — multi-platform (Android, iOS, Web, Linux, macOS, Windows)
- **Arsitektur**: Clean Architecture (layer `data` / `domain` / `presentation`)
- **State Management**: Flutter BLoC — pola Cubit
- **Dependency Injection**: GetIt
- **Database Lokal**: Floor (SQLite ORM) + sqflite
- **HTTP Client**: Dio + Retrofit (dengan interceptor logging)
- **Lokalisasi**: Easy Localization (`assets/translations/ar.json`, `en.json`)
- **Code Generation**: `build_runner` + `json_serializable` + `retrofit_generator` + `floor_generator`

---

## Struktur Direktori

```
majmuah/
├── android/              # Konfigurasi platform Android
├── ios/                  # Konfigurasi platform iOS
├── linux/                # Konfigurasi platform Linux Desktop
├── macos/                # Konfigurasi platform macOS
├── windows/              # Konfigurasi platform Windows
├── web/                  # Konfigurasi platform Web
├── assets/
│   ├── fonts/            # Font kustom (ElMessiri, UthmanTN, Hafs, dll)
│   ├── images/           # Gambar & ikon
│   ├── json/             # Data lokal (quran.json, hadith, adhkar, dll)
│   └── translations/     # File lokalisasi (ar.json, en.json)
├── lib/
│   ├── app/              # Resources, utilities, konstanta, preferences
│   ├── core/             # Inisialisasi aplikasi & BLoC observer
│   ├── data/             # Implementasi data (API, database, mapper, repository)
│   ├── di/               # Dependency injection (GetIt)
│   ├── domain/           # Model, use case, interface repository
│   ├── presentation/     # UI — screens, cubits, widgets
│   └── main.dart         # Entry point aplikasi
├── test/                 # Unit & widget tests
├── pubspec.yaml          # Konfigurasi project Flutter
└── Makefile              # Shortcut perintah umum
```

---

## Instalasi & Menjalankan di Lokal

### Prasyarat

- [Flutter SDK](https://flutter.dev/docs/get-started/install) versi `>=3.10.3`
- Dart SDK (sudah termasuk dalam Flutter)
- Untuk **Linux Desktop**: paket sistem tambahan (lihat langkah 3)

### Langkah-langkah

**1. Clone repository**
```bash
git clone https://github.com/keirelliot12/majmuah.git
cd majmuah
```

**2. Install dependensi**
```bash
flutter pub get
```

**3. (Khusus Linux Desktop) Install dependensi sistem**
```bash
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev
flutter config --enable-linux-desktop
```

**4. Generate kode (jika belum ada file `.g.dart`)**
```bash
dart run build_runner build --delete-conflicting-outputs
```

**5. Jalankan aplikasi**
```bash
# Android (pastikan emulator/device terhubung)
flutter run

# Web
flutter run -d chrome

# Linux Desktop
flutter run -d linux
```

### Menggunakan Makefile

```bash
make setup     # Install dependensi
make run       # Jalankan di Linux
make test      # Jalankan tests
make generate  # Generate kode (build_runner)
make analyze   # Analisis kode
make clean     # Bersihkan build artifacts
make help      # Tampilkan semua perintah
```

### Menggunakan Dev Container (VS Code / GitHub Codespaces)

Project ini menyertakan konfigurasi dev container yang sudah siap pakai:

1. Buka folder di VS Code dengan ekstensi **Dev Containers**, atau klik **"Open in GitHub Codespaces"**
2. Semua dependensi (Flutter SDK, library sistem, ekstensi VS Code) akan terinstal otomatis
3. Langsung mulai coding!

---

## Environment Variables

Aplikasi An Nibros **tidak memerlukan konfigurasi environment variable** untuk menjalankan fitur utamanya.

API Waktu Shalat menggunakan endpoint publik [aladhan.com](https://aladhan.com) tanpa kunci API:
```
https://api.aladhan.com/v1/timingsByCity/{date}?city={city}&country={country}
```

---

## Build & Deploy

### Build Android (APK / AAB)
```bash
# APK debug
flutter build apk

# APK release
flutter build apk --release

# Android App Bundle (untuk Play Store)
flutter build appbundle --release
```

### Build iOS
```bash
flutter build ios --release
```

### Build Web
```bash
flutter build web --release
# Output: build/web/
```

### Build Linux Desktop
```bash
flutter build linux --release
# Output: build/linux/x64/release/bundle/
```

---

## Platform yang Didukung

| Platform | Status |
|---|---|
| Android | ✅ Didukung |
| iOS | ✅ Didukung |
| Web | ✅ Didukung |
| Linux Desktop | ✅ Didukung |
| macOS | ✅ Didukung |
| Windows | ✅ Didukung |

---

## Kontribusi

Kontribusi sangat disambut! Silakan ikuti langkah berikut:

1. Fork repository ini
2. Buat branch fitur baru: `git checkout -b fitur/nama-fitur`
3. Commit perubahan: `git commit -m 'feat: tambah fitur baru'`
4. Push ke branch: `git push origin fitur/nama-fitur`
5. Buat Pull Request

Harap baca juga [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) sebelum berkontribusi.

---

## Lisensi

Didistribusikan di bawah lisensi **MIT**. Lihat file [LICENSE](LICENSE) untuk detail lengkap.

---

## Kontak

Website: [annibros.app](https://annibros.app)  
Repository: [github.com/keirelliot12/majmuah](https://github.com/keirelliot12/majmuah)
