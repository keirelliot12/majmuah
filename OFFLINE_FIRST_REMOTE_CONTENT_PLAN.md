# Plan: Offline-First Remote Content Architecture

**Date**: January 31, 2026  
**Status**: 📋 BLUEPRINT APPROVED  
**Goal**: Reduce APK size from 185MB to ~65MB by moving large assets (Al-Quran mushaf) to cloud storage with an offline-first, user-consented download approach.

---

## 📊 ARCHITECTURE OVERVIEW

```
┌─────────────────────────────────────────────────────────────────────┐
│                        AN-NIBROS APP                                │
├─────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────┐  │
│  │  CORE FEATURES  │  │ DOWNLOADABLE    │  │  SYNC-ABLE CONTENT  │  │
│  │  (Bundled)      │  │ FEATURES        │  │  (Manual Sync)      │  │
│  ├─────────────────┤  ├─────────────────┤  ├─────────────────────┤  │
│  │ • Beranda       │  │ • Al-Quran      │  │ • Khutbah (update)  │  │
│  │ • Aurad Sholat  │  │   (ZIP chunks)  │  │ • Maulid (update)   │  │
│  │ • Doa & Tawassul│  │                 │  │ • Kata Mutiara      │  │
│  │ • Ratib         │  │                 │  │ • Pengumuman        │  │
│  │ • Tahlil        │  │                 │  │                     │  │
│  │ • Notes (local) │  │                 │  │                     │  │
│  └────────┬────────┘  └────────┬────────┘  └──────────┬──────────┘  │
│           │                    │                      │             │
│           ▼                    ▼                      ▼             │
│  ┌─────────────────────────────────────────────────────────────────┐│
│  │              LOCAL STORAGE (SharedPrefs + Files)                ││
│  │  • JSON data (Annibros.json, category.json) - BUNDLED           ││
│  │  • Notes SQLite - LOCAL                                         ││
│  │  • Quran WebP - DOWNLOADED (optional)                           ││
│  │  • Sync cache - DOWNLOADED (optional)                           ││
│  └─────────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────────┘
                                 │
                    ┌────────────┴────────────┐
                    │   MANUAL SYNC TRIGGER   │
                    │   (User Consent Only)   │
                    └────────────┬────────────┘
                                 ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      REMOTE SERVER / CDN                            │
├─────────────────────────────────────────────────────────────────────┤
│  GitHub Releases (Fase 1) → Cloudflare R2 (Fase 2)                  │
│                                                                     │
│  /releases/                                                         │
│  ├── quran-v1.0/                                                    │
│  │   ├── quran-part1.zip (page001-200, ~35MB)                       │
│  │   ├── quran-part2.zip (page201-400, ~35MB)                       │
│  │   └── quran-part3.zip (page401-604, ~30MB)                       │
│  │                                                                  │
│  └── content-v1.0/                                                  │
│      └── sync-data.json (khutbah, maulid, quotes updates)           │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🛠️ PHASE 1: ASSET PREPARATION & CLOUD SETUP

### 1.1 PNG Optimization (Skipped)
- Decided to stay with PNG as current files are already optimal size.

### 1.2 ZIP Chunking (Max 50MB per file) - ✅ COMPLETE
- **Part 1**: `page001-200.png` (~38MB)
- **Part 2**: `page201-400.png` (~39.7MB)
- **Part 3**: `page401-604.png` (~41.7MB)
- All chunks created in `quran_chunks/` folder.

### 1.3 Cloud Hosting (GitHub Releases) - ✅ COMPLETE
- GitHub Repository: [keirelliot12/annibros-assets](https://github.com/keirelliot12/annibros-assets)
- ZIP Chunks: Uploaded to Release 1.0
- `manifest.json`: ✅ Uploaded and linked in `AssetDownloadService`

---

## 🏗️ PHASE 2: FLUTTER IMPLEMENTATION - CORE SERVICES

### 2.1 Dependencies - ✅ COMPLETE
- archive, crypto, path_provider added to `pubspec.yaml`.

### 2.2 DownloadStorageManager - ✅ COMPLETE
- Implemented in `lib/data/data_source/local/download_storage_manager.dart`.

### 2.3 AssetDownloadService - ✅ COMPLETE
- Implemented in `lib/data/data_source/remote/asset_download_service.dart`.
- Supports ZIP download, SHA-256 verification, and extraction.

### 2.4 Download Manifest & Status Models - ✅ COMPLETE
- Implemented in `lib/domain/models/download/`.

---

## 🎨 PHASE 3: UI/UX IMPLEMENTATION

### 3.1 Download UX Principles & Components - ✅ COMPLETE
1. **Persetujuan Pengguna**: Implementasi logic di `DownloadCubit`.
2. **Prompt yang Jelas**: `DownloadPromptDialog` diimplementasikan dengan Glassmorphism.
3. **Progress Visibility**: `DownloadProgressSheet` diimplementasikan dengan real-time percentage dan bytes tracking.
4. **Resilience**: Handled via Cubit states.

### 3.2 Quran Screen & Surah Builder Integration - ✅ COMPLETE
- **QuranScreen**: Added `DownloadCubit` listener, download fallback view, and confirm dialog.
- **SurahBuilder**: Switched to `Image.file` using `DownloadStorageManager`.
- **Logic**: Prevents Al-Quran usage until mushaf images are downloaded and extracted.

---

## ⚙️ PHASE 4: SETTINGS & SYNC UI

### 4.1 Download Manager Screen - ✅ COMPLETE
- Created `lib/presentation/settings/download_manager_screen.dart`.
- Integrated into `SettingsScreen`.
- Shows download status, progress, and management options.

### 4.2 Sync Badge
Notifikasi visual di menu pengaturan jika `manifest.json` mendeteksi versi konten baru di server.

---

## 🚀 PHASE 5: REFINEMENT & CLEANUP

### 5.1 Asset Removal
Setelah sistem download terverifikasi, hapus `assets/images/quran/` dari folder project dan hapus referensinya di `pubspec.yaml`.

### 5.2 Build Optimization
- Aktifkan `shrinkResources` dan `minifyEnabled` di Gradle.
- Gunakan App Bundle (`.aab`) untuk distribusi.

---

## 📅 TIMELINE SUMMARY

| Sprint | Task | Duration | Status |
|--------|------|----------|--------|
| 1 | Asset Prep & Cloud Setup | 4 hours | ✅ Complete |
| 2 | Download & Storage Services | 6 hours | ✅ Complete |
| 3 | UI Implementation & Screen Updates | 6 hours | ✅ Complete |
| 4 | Settings & Sync UI | 4 hours | ✅ Complete |
| **Total** | | **~20 hours** |

---

## ✅ EXPECTED RESULTS

- **APK Size**: 185 MB ➔ **~60-65 MB**
- **User Experience**: Offline-first, lower initial install size, clear control over data usage.
- **Scalability**: New content can be pushed via `sync-data.json` without app updates.
