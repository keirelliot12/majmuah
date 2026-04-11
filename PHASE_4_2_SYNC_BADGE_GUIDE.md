# Phase 4.2: Sync Badge Implementation Guide

**Status**: ✅ COMPLETE  
**Date**: January 31, 2026  
**Components**: 2 widgets + 1 enhanced screen

---

## 🎯 OVERVIEW

Sync Badge adalah sistem notifikasi visual yang memberitahu user bahwa ada pembaruan konten tersedia di server. Sistem ini terintegrasi dengan `DownloadCubit` dan `DownloadManifestLoaded.isUpdateAvailable` property.

---

## 📦 COMPONENTS IMPLEMENTED

### 1. **SyncBadgeWidget**
**File**: `lib/presentation/settings/widgets/sync_badge_widget.dart`

**Fungsi**: Display badge notification dengan 2 mode
- **Compact Mode**: Hanya red dot (untuk menu items)
- **Expanded Mode**: Full notification card dengan detail

**Props**:
```dart
SyncBadgeWidget({
  VoidCallback? onTap,        // Action saat badge diklik
  bool compact = false,        // Mode (compact/expanded)
})
```

**Features**:
- ✅ Automatic hidden jika tidak ada update (`isUpdateAvailable` = false)
- ✅ Glassmorphic styling dengan gradient
- ✅ Smooth animation dan shadow effects
- ✅ Responsive design

**Usage**:
```dart
// Compact badge (dot only)
SyncBadgeWidget(compact: true)

// Expanded badge (full notification)
SyncBadgeWidget(
  onTap: () => _navigateToSync(),
)
```

---

### 2. **SettingsMenuItemWithBadge**
**File**: `lib/presentation/settings/widgets/settings_menu_item_with_badge.dart`

**Fungsi**: Reusable menu item dengan optional sync badge indicator

**Props**:
```dart
SettingsMenuItemWithBadge({
  required String title,           // Menu title
  required String subtitle,        // Menu subtitle
  required IconData icon,          // Menu icon
  Color? iconColor,                // Icon color override
  required VoidCallback onTap,     // Tap action
  bool showSyncBadge = false,      // Enable sync badge
})
```

**Features**:
- ✅ Shows "✦ Pembaruan tersedia" jika ada update
- ✅ Red dot badge di icon corner
- ✅ "Baru" label badge di kanan
- ✅ Dynamic subtitle berdasarkan state

**Usage**:
```dart
SettingsMenuItemWithBadge(
  title: "Kelola Unduhan",
  subtitle: "Download & sinkronisasi konten",
  icon: Icons.download,
  showSyncBadge: true,  // Enable badge
  onTap: () => _openDownloadManager(),
)
```

---

### 3. **Enhanced DownloadManagerScreen**
**File**: `lib/presentation/settings/download_manager_screen.dart`

**Changes**:
1. Imported `SyncBadgeWidget`
2. Added SyncBadgeWidget di awal ListView
3. Enhanced `_buildSyncContentCard()` dengan:
   - Red dot indicator di icon
   - "Baru" label badge
   - Dynamic subtitle
   - Visual feedback untuk update

**Integration**:
```dart
BlocBuilder<DownloadCubit, DownloadState>(
  builder: (context, state) {
    return ListView(
      children: [
        // Sync Badge - automatic visibility
        SyncBadgeWidget(
          onTap: () { /* sync action */ },
        ),
        // ... rest of UI
      ],
    );
  },
)
```

---

## 🔄 FLOW DIAGRAM

```
┌─────────────────────────────────────────────────┐
│         APP LAUNCH / MANIFEST CHECK             │
├─────────────────────────────────────────────────┤
│  1. DownloadCubit.checkManifest() called        │
│  2. Fetch manifest.json dari server             │
│  3. Get local manifest version from preferences │
│  4. Compare versions                            │
└────────────────┬────────────────────────────────┘
                 │
        ┌────────┴────────┐
        ▼                 ▼
    ✅ SAME             ❌ DIFFERENT
    (Update = false)    (Update = true)
        │                 │
        ▼                 ▼
   SyncBadgeWidget   SyncBadgeWidget
   HIDDEN            VISIBLE
   (SizedBox.shrink)  (Red badge + card)
        │                 │
        ▼                 ▼
  DownloadManager    User sees:
  screen normal      • Red dot at icon
                     • "Pembaruan Tersedia" card
                     • "Baru" label
                     • Can tap to sync
```

---

## 🎨 VISUAL DESIGN

### Compact Mode
```
║ ┌─────────────────────────────┐
║ │ [⬤ UPDATE ICON] Unduhan   │
║ │ Kelola file terunduh      │
║ │ (Red dot badge at icon)   │
║ └─────────────────────────────┘
```

### Expanded Mode
```
╔��════════════════════════════════════════════════════════╗
║ [🔄] Pembaruan Tersedia                      [→]       ║
║                                                       ║
║ Konten baru menunggu untuk disinkronkan               ║
╚═════════════════════════════════════════════════════════╝
```

### Colors & Styling
- **Background**: Gradient red.shade400 → red.shade600
- **Text**: White (#FFFFFF)
- **Border**: Rounded, semi-transparent shadow
- **Badge Dot**: Red with white border & glow effect
- **Icon**: Material Symbols (update, sync)

---

## 🔧 STATE MANAGEMENT

### DownloadCubit State
```dart
// dari download_state.dart
class DownloadManifestLoaded extends DownloadState {
  bool get isUpdateAvailable =>
    currentVersion != null && manifest.version != currentVersion;
}
```

### Automatic Trigger
```dart
BlocBuilder<DownloadCubit, DownloadState>(
  builder: (context, state) {
    if (state is! DownloadManifestLoaded || !state.isUpdateAvailable) {
      return SizedBox.shrink();  // Badge hidden
    }
    return _buildExpandedBadge();  // Badge shown
  },
)
```

---

## 📱 RESPONSIVE DESIGN

**Mobile (320px - 480px)**
- Compact badge (dot only)
- Reduced padding
- Single line subtitle

**Tablet (480px - 1024px)**
- Expanded badge dengan full text
- More padding
- Enhanced animation

**Desktop (1024px+)**
- Same as tablet
- Fixed width constraints

---

## 🚀 USAGE EXAMPLES

### Example 1: In DownloadManagerScreen
```dart
// Already implemented
SyncBadgeWidget(
  onTap: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fitur sinkronisasi sedang dikembangkan")),
    );
  },
),
```

### Example 2: In Custom Settings Menu
```dart
SettingsMenuItemWithBadge(
  title: "Pembaruan Konten",
  subtitle: "Khutbah, Maulid, Kata Mutiara...",
  icon: Symbols.sync,
  iconColor: Colors.blue,
  showSyncBadge: true,
  onTap: () {
    context.read<DownloadCubit>().checkManifest();
    // Navigate to sync screen
  },
)
```

### Example 3: In Floating Action Button
```dart
Stack(
  children: [
    FloatingActionButton(
      onPressed: () {},
      child: Icon(Symbols.download),
    ),
    // Badge overlay
    BlocBuilder<DownloadCubit, DownloadState>(
      builder: (context, state) {
        bool hasUpdate = state is DownloadManifestLoaded &&
                         state.isUpdateAvailable;
        
        if (!hasUpdate) return SizedBox.shrink();
        
        return Positioned(
          right: 0,
          top: 0,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    ),
  ],
)
```

---

## ✅ TESTING CHECKLIST

### Unit Tests
- [ ] `SyncBadgeWidget._buildCompactBadge()` render correctly
- [ ] `SyncBadgeWidget._buildExpandedBadge()` render correctly
- [ ] `SettingsMenuItemWithBadge` conditional rendering

### Widget Tests
- [ ] Badge visible saat `isUpdateAvailable = true`
- [ ] Badge hidden saat `isUpdateAvailable = false`
- [ ] Tap handler berfungsi
- [ ] Animations smooth

### Integration Tests
- [ ] Badge appears after manifest update check
- [ ] Badge disappears after sync complete
- [ ] DownloadManagerScreen renders correctly dengan badge

---

## 🐛 TROUBLESHOOTING

### Badge tidak muncul
**Solusi**:
1. Pastikan `DownloadCubit` di atas widget tree
2. Verify `BlocBuilder` correctly listening to DownloadState
3. Check `isUpdateAvailable` property return true

### Badge animation choppy
**Solusi**:
1. Reduce animation duration
2. Check device performance
3. Use `SingleChildScrollView` jika dalam list

### Badge tidak responsive
**Solusi**:
1. Verify using ScreenUtil for sizing
2. Check MediaQuery.of(context).size usage
3. Test di berbagai ukuran device

---

## 📚 RELATED FILES

- `lib/presentation/download/cubit/download_cubit.dart` - State management
- `lib/presentation/download/cubit/download_state.dart` - State definitions
- `lib/domain/models/download/download_manifest.dart` - Data models
- `lib/data/data_source/remote/asset_download_service.dart` - API calls
- `OFFLINE_FIRST_REMOTE_CONTENT_PLAN.md` - Architecture overview

---

## 🎓 LEARNING RESOURCES

- **BlocBuilder**: Listen to state changes
- **Equatable**: Compare state objects
- **ScreenUtil**: Responsive design
- **Material Design**: Badge patterns
- **Glassmorphism**: UI trends

---

**Implementation Complete** ✅  
**Next Phase**: 5.2 Asset Removal & Optimization
