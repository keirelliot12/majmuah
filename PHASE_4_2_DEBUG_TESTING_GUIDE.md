# Phase 4.2 Sync Badge - Debug & Testing Guide

**Status**: Testing Phase  
**Date**: January 31, 2026  
**Objective**: Verify Sync Badge displays correctly

---

## 🔍 HOW SYNC BADGE WORKS (Technical Flow)

```
1. App Launch
   ↓
2. MyApp MultiBlocProvider initializes DownloadCubit
   ↓
3. DownloadCubit.checkManifest() called automatically
   ↓
4. fetchManifest() → GET https://github.com/.../manifest.json
   ↓
5. Compare: remote manifest.version vs local currentVersion
   ↓
6. If different → isUpdateAvailable = true
   ↓
7. SyncBadgeWidget BlocBuilder sees state change
   ↓
8. Badge renders (or hides if no update)
```

---

## 📋 CHECKLIST: WHAT NEEDS TO BE TRUE FOR BADGE TO SHOW

### Prerequisites (must all be true):

- [ ] ✅ DownloadCubit registered in DI
- [ ] ✅ DownloadCubit added to MultiBlocProvider in MyApp
- [ ] ✅ DownloadCubit.checkManifest() called at app startup
- [ ] ✅ AssetDownloadService can fetch manifest.json from GitHub
- [ ] ✅ DownloadStorageManager can save/retrieve version
- [ ] ✅ SyncBadgeWidget listens to DownloadCubit state
- [ ] ✅ isUpdateAvailable property returns true when versions differ

### Current Status:

```
✅ 1. DownloadCubit registered in DI (line 115-116 in di.dart)
✅ 2. DownloadCubit in MultiBlocProvider (JUST ADDED to app.dart)
✅ 3. checkManifest() called at startup (JUST ADDED to app.dart)
✅ 4. AssetDownloadService can fetch (with logging)
✅ 5. DownloadStorageManager working (saveManifestVersion & getCurrentManifestVersion)
✅ 6. SyncBadgeWidget listening (BlocBuilder<DownloadCubit>)
✅ 7. isUpdateAvailable fixed (now works even if currentVersion is null)
```

---

## 🧪 HOW TO TEST IN CHROME/WEB

### Test 1: Basic Flow Test
1. Run: `flutter run -d chrome`
2. Open DevTools Console (F12)
3. Look for these logs:
   ```
   🔍 Checking manifest...
   📥 Fetching manifest from: https://...
   ✅ Manifest fetched successfully. Version: X.X.X
   📊 Manifest Check Results:
     • Remote version: X.X.X
     • Local version: null (or different)
     • Downloaded chunks: 0
     • Update available: true
   ✅ Manifest check complete
   ```
4. Navigate to Settings → "Kelola Unduhan"
5. Look for logs:
   ```
   🎨 SyncBadgeWidget building with state: DownloadManifestLoaded
     → isUpdateAvailable: true
     → ✅ Showing badge (mode: expanded)
   ```

### Test 2: Visual Verification
After step 4 above:
- [ ] Red notification card appears at top of "Kelola Unduhan" screen
- [ ] Card shows: "Pembaruan Tersedia" + "Konten baru menunggu untuk disinkronkan"
- [ ] Icon: Update symbol
- [ ] Glassmorphism effect visible
- [ ] Can tap the card

### Test 3: After Download
1. Click "Unduh" button to download Quran
2. Wait for download complete
3. App saves manifest.version locally
4. Navigate away and back to "Kelola Unduhan"
5. Check: Badge should disappear (versions now match)
6. Look for log: `→ No update available, hiding badge`

---

## 🐛 TROUBLESHOOTING: BADGE NOT SHOWING

### Issue: Badge not visible even after navigating to Kelola Unduhan

**Step 1: Check Logs**
- Open DevTools Console (F12)
- Search for "🎨 SyncBadgeWidget"
- If not found → SyncBadgeWidget not rendering at all

**Step 2: Verify DownloadCubit Initialization**
- Search for "🔍 Checking manifest"
- If not found → DownloadCubit.checkManifest() not called
- Solution: Verify it's added to MultiBlocProvider in app.dart

**Step 3: Verify Manifest Fetch**
- Search for "📥 Fetching manifest"
- If not found → fetchManifest not called
- If "❌ Error" → Check network, GitHub URL

**Step 4: Check isUpdateAvailable**
- Search for "Remote version:" in logs
- Compare remote vs local version
- Should show: `Update available: true`

**Step 5: Check SyncBadgeWidget State**
- Search for "isUpdateAvailable: true"
- If you see "isUpdateAvailable: false" → Versions match (expected after download)
- If you see "→ No update available, hiding badge" → Badge intentionally hidden

---

## 📊 DETAILED LOG FLOW

Here's what you should see in console when everything works:

```
[AppStartup]
🔍 Checking manifest...
  → State is not DownloadManifestLoaded (initial state)
📥 Fetching manifest from: https://github.com/keirelliot12/annibros-assets/releases/download/1.0/manifest.json
✅ Manifest fetched successfully. Version: 1.0.0

📊 Manifest Check Results:
  • Remote version: 1.0.0
  • Local version: null (first time user)
  • Downloaded chunks: 0
  • Update available: true (null != 1.0.0)
✅ Manifest check complete

[NavigateToSettingsScreen]
🎨 SyncBadgeWidget building with state: DownloadManifestLoaded
  → isUpdateAvailable: true
  → ✅ Showing badge (mode: expanded)

[UserClicksDownload]
[Download process...]
🔍 Checking manifest... (after download complete)
📊 Manifest Check Results:
  • Remote version: 1.0.0
  • Local version: 1.0.0 (saved after download)
  • Downloaded chunks: 3
  • Update available: false (1.0.0 == 1.0.0)
✅ Manifest check complete

[SyncBadgeWidget re-renders]
🎨 SyncBadgeWidget building with state: DownloadManifestLoaded
  → isUpdateAvailable: false
  → No update available, hiding badge
```

---

## 🔧 HOW TO ENABLE LOGGING CONSOLE ON CHROME

1. **Open DevTools**:
   - Press `F12` or right-click → "Inspect"

2. **Go to Console Tab**:
   - Click "Console" at top

3. **Look for Dart/Flutter Logs**:
   - Logs prefixed with 🎨, 🔍, 📥, ✅, ❌ are from our code
   - Scroll through to find them

4. **Filter Logs** (optional):
   - Type in search: `🎨` (for SyncBadge logs)
   - Type in search: `📊` (for manifest comparison)

---

## 📝 KEY FILES MODIFIED

1. **lib/core/app.dart**
   - Added: DownloadCubit to MultiBlocProvider
   - Effect: checkManifest() runs at app startup

2. **lib/presentation/download/cubit/download_state.dart**
   - Changed: isUpdateAvailable logic
   - Before: `currentVersion != null && manifest.version != currentVersion`
   - After: `manifest.version != currentVersion`
   - Effect: Badge shows on first install (when currentVersion is null)

3. **lib/presentation/download/cubit/download_cubit.dart**
   - Added: Debug logging in checkManifest()
   - Effect: Can see detailed version comparison in logs

4. **lib/data/data_source/remote/asset_download_service.dart**
   - Added: Debug logging in fetchManifest()
   - Effect: Can see manifest fetch success/error in logs

5. **lib/presentation/settings/widgets/sync_badge_widget.dart**
   - Added: Debug logging in build()
   - Effect: Can see why badge shows or hides in logs

---

## ✅ VERIFICATION STEPS

### Step 1: Compile Check
```bash
flutter analyze
# Should show: 0 errors
```

### Step 2: Run on Chrome
```bash
flutter run -d chrome
```

### Step 3: Open Console
- Press F12
- Go to Console tab

### Step 4: Check Initial Logs
- App should start
- Look for: `🔍 Checking manifest...`
- Look for: `✅ Manifest fetched successfully`

### Step 5: Navigate to Settings
- Tap: Settings icon
- Tap: "Kelola Unduhan"

### Step 6: Verify Badge
- Look for: `🎨 SyncBadgeWidget building`
- Look for: `→ ✅ Showing badge (mode: expanded)`
- Look for: Red card with "Pembaruan Tersedia"

---

## 🎯 EXPECTED TEST RESULTS

| Test Case | Expected Result | Status |
|-----------|-----------------|--------|
| App Launch | `🔍 Checking manifest` logs | ✅ Should show |
| Manifest Fetch | `✅ Manifest fetched successfully` | ✅ Should show |
| Version Compare | `Update available: true` | ✅ Should show (first time) |
| Badge Rendering | Red card visible | ⏳ Testing now |
| Badge Hidden Post-Download | Badge disappears | ⏳ Testing after |

---

## 📞 IF BADGE STILL NOT SHOWING

**Possible Causes**:

1. **Network Error**
   - GitHub might be unreachable
   - Check: Look for `❌ Error fetching manifest`
   - Solution: Check internet, GitHub status

2. **Manifest URL Wrong**
   - Solution: Verify URL in AssetDownloadService line 14
   - Should be: `https://github.com/keirelliot12/annibros-assets/releases/download/1.0/manifest.json`

3. **BlocProvider Not Working**
   - Solution: Verify DownloadCubit added to app.dart line ~68
   - Check: Context has access to DownloadCubit

4. **Manifest Already Downloaded Locally**
   - If versions already match, badge won't show
   - Solution: Clear app data or SharedPreferences

5. **Browser Cache**
   - Solution: Hard refresh (Ctrl+Shift+R)

---

## 🚀 NEXT STEPS AFTER TESTING

1. ✅ Verify badge shows on first run
2. ✅ Verify badge hides after download
3. ✅ Verify all logs output correctly
4. ✅ Verify no errors in console
5. → Then proceed to Phase 5

---

*Debug Guide - Phase 4.2 Sync Badge*  
*Created: January 31, 2026*  
*Status: Active Testing*
