# Drawer, Bitmap Icons, and Segmented Quran Download Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the unused YouTube drawer with useful app utilities, introduce polished custom bitmap icon assets, and change Quran download from one forced bulk action into three user-selected Juz packages.

**Architecture:** Keep the current Flutter app structure and existing manifest/chunk download model. The drawer becomes a compact utility/navigation panel for core app actions only. KBIHU Nur Multazam remains available from the dashboard, not the drawer, because it is outside the original cooperation scope and should not be over-promoted. Quran downloads stay manifest-driven, but each `QuranChunk` gains display metadata so the UI can download `Juz 1-10`, `Juz 11-20`, and `Juz 21-30` independently.

**Tech Stack:** Flutter, Bloc/Cubit, Dio, archive ZIP extraction, SharedPreferences, GitHub-hosted manifest/assets, bitmap PNG/WebP assets.

---

## File Structure

- Modify `lib/presentation/components/mydrawer.dart`
  - Replace YouTube-only drawer with utility rows: Kelola Unduhan, Lanjutkan Bacaan, Tentang Aplikasi, and optional Versi Aplikasi text. Do not add KBIHU to the drawer; keep KBIHU dashboard-only.
- Modify `lib/app/resources/routes_manager.dart`
  - Remove drawer dependency on `BrowseYoutubeScreen` from active navigation path. Keep route only if another screen still references it; otherwise remove import and route in a cleanup task.
- Modify `lib/domain/models/download/download_manifest.dart`
  - Add chunk label metadata: `title`, `subtitle`, `startJuz`, `endJuz`, while keeping `startPage` and `endPage`.
- Modify `lib/data/data_source/remote/asset_download_service.dart`
  - Make mock manifest parser-complete and aligned with 3 Juz package chunks.
  - Keep ZIP extraction path for page PNGs unless the GitHub files are confirmed not to be ZIPs.
- Modify `lib/presentation/download/cubit/download_cubit.dart`
  - Add `downloadQuranChunk(QuranChunk chunk)` for one-package download.
  - Keep `startQuranDownload()` as a compatibility helper, but make UI prefer per-package download.
- Modify `lib/presentation/download/cubit/download_state.dart`
  - Add active chunk metadata to progress/success if needed for labels.
- Modify `lib/presentation/settings/download_manager_screen.dart`
  - Replace single "Data Al-Quran" bulk card with three package rows.
  - Each row has status, size, progress, and one button: Unduh / Mengunduh / Hapus Paket.
- Modify `lib/presentation/home/screens/quran/view/quran_screen.dart`
  - When user taps a surah whose page package is missing, show a dialog for the exact package needed.
- Modify `lib/data/data_source/local/download_storage_manager.dart`
  - Add helper to verify a page range exists on disk.
  - Add helper to delete one chunk/page-range when the user removes a package.
- Create `assets/images/icons/*.png`
  - Custom bitmap icon set for dashboard/menu surfaces.
- Modify `pubspec.yaml`
  - Add `assets/images/icons/` to asset bundle.
- Modify `lib/presentation/home/helpers/category_visuals.dart`
  - Add optional bitmap asset mapping alongside existing IconData fallback.
- Modify relevant dashboard/menu widgets using `CategoryVisuals`
  - Prefer custom bitmap icon when available, fall back to current symbol.

---

## Task 1: Drawer Utility Redesign

**Files:**
- Modify: `lib/presentation/components/mydrawer.dart`
- Modify: `lib/app/resources/routes_manager.dart`

- [ ] **Step 1: Replace YouTube row with utility rows**

Implement drawer rows with these exact actions:

```dart
_drawerItem(
  context: context,
  icon: Icons.download_for_offline_outlined,
  title: 'Kelola Unduhan',
  subtitle: 'Mushaf dan data offline',
  onTap: () {
    Navigator.pop(context);
    Navigator.pushNamed(context, Routes.downloadManagerRoute);
  },
);
```

Add rows:

```dart
[
  ('Kelola Unduhan', 'Mushaf dan data offline', Icons.download_for_offline_outlined),
  ('Lanjutkan Bacaan', 'Buka bacaan terakhir', Icons.menu_book_outlined),
  ('Tentang Aplikasi', 'Annibros dan versi aplikasi', Icons.info_outline),
]
```

For `Lanjutkan Bacaan`, route to existing material last-read if present later; first implementation may show a snackbar:

```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Fitur lanjutkan bacaan sedang disiapkan.')),
);
```

KBIHU Nur Multazam is intentionally omitted from the drawer. It remains reachable from the dashboard tile only.

- [ ] **Step 2: Remove active YouTube drawer navigation**

Delete this active drawer action:

```dart
Navigator.of(context).pushNamed(Routes.browsenetRoute);
```

Do not delete the whole YouTube screen in the same task unless no compile path imports it after route cleanup.

- [ ] **Step 3: Verify drawer compile**

Run:

```powershell
$env:DART_SUPPRESS_ANALYTICS='true'
flutter analyze lib\presentation\components\mydrawer.dart lib\app\resources\routes_manager.dart
```

Expected: no errors.

---

## Task 2: Bitmap Icon Asset Pass

**Files:**
- Create: `assets/images/icons/aurad_doa.png`
- Create: `assets/images/icons/hizib_ratib.png`
- Create: `assets/images/icons/puji_bilal.png`
- Create: `assets/images/icons/amalan_hijriyah.png`
- Create: `assets/images/icons/maulid.png`
- Create: `assets/images/icons/tahlil_ziarah.png`
- Create: `assets/images/icons/kbihu.png`
- Create: `assets/images/icons/lainnya.png`
- Modify: `pubspec.yaml`
- Modify: `lib/presentation/home/helpers/category_visuals.dart`
- Modify: dashboard/menu widgets that render category icons.

- [ ] **Step 1: Generate cohesive icon assets**

Use Image Gen to create an 8-icon set with this brief:

```text
Create a cohesive set of 8 polished mobile app bitmap icons for an Indonesian Islamic reading app named Annibros. Style: elegant modern Islamic editorial, soft rounded square icon canvas, no text inside icons, no generic AI shine, no stock clipart, subtle paper/enamel texture, colors from deep emerald, teal, lime gold, warm cream, indigo, amber, rose, and blue. Icons: Aurad & Doa, Hizib & Ratib, Puji & Bilal, Amalan Hijriyah, Maulid, Tahlil & Ziarah, KBIHU, Lainnya. Each icon should be clear at 48px, centered, consistent lighting, transparent or clean light background.
```

Export final assets as `1024x1024` PNG, then downscale if needed.

- [ ] **Step 2: Register icon directory**

Add to `pubspec.yaml`:

```yaml
    - assets/images/icons/
```

- [ ] **Step 3: Extend CategoryVisual**

Change:

```dart
class CategoryVisual {
  final IconData icon;
  final Color color;

  const CategoryVisual({required this.icon, required this.color});
}
```

to:

```dart
class CategoryVisual {
  final IconData icon;
  final Color color;
  final String? assetPath;

  const CategoryVisual({
    required this.icon,
    required this.color,
    this.assetPath,
  });
}
```

Set mappings:

```dart
assetPath: 'assets/images/icons/aurad_doa.png'
```

for each matching category.

- [ ] **Step 4: Render bitmap first, icon fallback second**

In menu tile widgets, replace direct `Icon(visual.icon...)` with:

```dart
visual.assetPath == null
    ? Icon(visual.icon, color: visual.color, size: 28.r)
    : Image.asset(
        visual.assetPath!,
        width: 34.r,
        height: 34.r,
        fit: BoxFit.contain,
      )
```

- [ ] **Step 5: Verify assets load**

Run:

```powershell
flutter build web --no-wasm-dry-run
```

Expected: build succeeds and no missing asset error appears.

---

## Task 3: Quran Download as Three Juz Packages

**Files:**
- Modify: `lib/domain/models/download/download_manifest.dart`
- Modify: `lib/data/data_source/remote/asset_download_service.dart`
- Modify: `lib/data/data_source/local/download_storage_manager.dart`
- Modify: `lib/presentation/download/cubit/download_cubit.dart`
- Modify: `lib/presentation/download/cubit/download_state.dart`
- Modify: `lib/presentation/settings/download_manager_screen.dart`
- Modify: `lib/presentation/home/screens/quran/view/quran_screen.dart`

- [ ] **Step 1: Extend chunk model with Juz metadata**

Add fields to `QuranChunk`:

```dart
final String title;
final String subtitle;
final int startJuz;
final int endJuz;
```

Update constructor:

```dart
QuranChunk({
  required this.id,
  required this.url,
  required this.startPage,
  required this.endPage,
  required this.sizeBytes,
  required this.checksum,
  required this.title,
  required this.subtitle,
  required this.startJuz,
  required this.endJuz,
});
```

Update `fromJson`:

```dart
title: json['title'] ?? 'Juz ${json['startJuz']}-${json['endJuz']}',
subtitle: json['subtitle'] ?? 'Halaman ${json['startPage']}-${json['endPage']}',
startJuz: json['startJuz'] ?? 1,
endJuz: json['endJuz'] ?? 10,
```

- [ ] **Step 2: Make mock manifest parser-complete**

Use this mock shape in `AssetDownloadService._getMockManifest()`:

```dart
return {
  'version': '1.0.0',
  'lastUpdated': '2026-05-09',
  'quran': {
    'version': '1.0.0',
    'totalPages': 604,
    'chunks': [
      {
        'id': 'quran-juz-01-10',
        'title': 'Juz 1-10',
        'subtitle': 'Paket awal mushaf',
        'url': 'https://example.com/quran-juz-01-10.zip',
        'startJuz': 1,
        'endJuz': 10,
        'startPage': 1,
        'endPage': 201,
        'sizeBytes': 40000000,
        'checksum': '',
      },
      {
        'id': 'quran-juz-11-20',
        'title': 'Juz 11-20',
        'subtitle': 'Paket tengah mushaf',
        'url': 'https://example.com/quran-juz-11-20.zip',
        'startJuz': 11,
        'endJuz': 20,
        'startPage': 202,
        'endPage': 401,
        'sizeBytes': 40000000,
        'checksum': '',
      },
      {
        'id': 'quran-juz-21-30',
        'title': 'Juz 21-30',
        'subtitle': 'Paket akhir mushaf',
        'url': 'https://example.com/quran-juz-21-30.zip',
        'startJuz': 21,
        'endJuz': 30,
        'startPage': 402,
        'endPage': 604,
        'sizeBytes': 40000000,
        'checksum': '',
      },
    ],
  },
};
```

Replace `example.com` in the real GitHub manifest, not in app code. App code remains manifest-driven.

- [ ] **Step 3: Add page-range verification**

In `DownloadStorageManager`, add:

```dart
Future<bool> isPageRangeAvailable(int startPage, int endPage) async {
  final quranDir = await quranDirectory;
  for (var page = startPage; page <= endPage; page++) {
    final fileName = 'page${page.toString().padLeft(3, '0')}.png';
    if (!await File('${quranDir.path}/$fileName').exists()) {
      return false;
    }
  }
  return true;
}
```

Use this before treating a chunk as truly available.

- [ ] **Step 4: Add single chunk download Cubit method**

Add method:

```dart
Future<void> downloadQuranChunk(QuranChunk chunk) async {
  try {
    emit(DownloadProgressState(
      progress: DownloadProgress(
        chunkId: chunk.id,
        bytesReceived: 0,
        totalBytes: chunk.sizeBytes,
        percentage: 0,
        state: DownloadState.downloading,
      ),
      currentChunk: 1,
      totalChunks: 1,
    ));

    await _downloadService.downloadQuranChunk(
      chunk: chunk,
      onProgress: (progress) {
        emit(DownloadProgressState(
          progress: progress,
          currentChunk: 1,
          totalChunks: 1,
        ));
      },
    );

    emit(DownloadSuccess('${chunk.title} berhasil diunduh.'));
    await checkManifest();
  } catch (e) {
    emit(DownloadFailure('Gagal mengunduh ${chunk.title}: $e'));
  }
}
```

- [ ] **Step 5: Redesign download manager package list**

Render one row per `manifest.quran.chunks`:

```dart
for (final chunk in state.manifest.quran.chunks)
  _QuranPackageTile(
    chunk: chunk,
    isDownloaded: state.downloadedChunks.contains(chunk.id),
    onDownload: () => context.read<DownloadCubit>().downloadQuranChunk(chunk),
  )
```

Visible labels:

```text
Juz 1-10
Paket awal mushaf · Halaman 1-201
Unduh
```

- [ ] **Step 6: Update Quran tap behavior**

When a surah is tapped and not all Quran pages are available, find the package containing `pageNo`:

```dart
final requiredChunk = manifest.quran.chunks.firstWhere(
  (chunk) => pageNo >= chunk.startPage && pageNo <= chunk.endPage,
);
```

Dialog copy:

```text
Paket mushaf belum diunduh
Untuk membuka halaman ini, unduh Juz 1-10 terlebih dahulu.
```

Buttons:

```text
Download Sekarang
Nanti
```

`Download Sekarang` calls `downloadQuranChunk(requiredChunk)`.

- [ ] **Step 7: Verify segmented flow**

Run:

```powershell
flutter analyze lib\domain\models\download\download_manifest.dart lib\data\data_source\remote\asset_download_service.dart lib\data\data_source\local\download_storage_manager.dart lib\presentation\download\cubit\download_cubit.dart lib\presentation\settings\download_manager_screen.dart lib\presentation\home\screens\quran\view\quran_screen.dart
flutter build web --no-wasm-dry-run
```

Expected:
- No compile errors.
- Download manager shows 3 package rows.
- Quran list still opens without blocking.
- Tapping a surah requests only the needed Juz package.

---

## Self-Review

Spec coverage:
- Drawer no longer depends on YouTube and has useful utility actions.
- KBIHU Nur Multazam remains dashboard-only, not drawer-promoted.
- Bitmap custom icon pass is represented as a separate asset task.
- Quran download becomes one-by-one package download for three Juz ranges.

Known dependency:
- The exact GitHub URLs must live in `manifest.json`. The app can implement the manifest-driven UI now, but the real download will only work when the manifest points to real ZIP chunks containing `page001.png` to `page604.png` across the three packages.
