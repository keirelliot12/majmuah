# Flutter Web - Troubleshooting Guide

## If Errors Still Appear After Fix

### Step 1: Hard Refresh Browser
Sometimes the browser caches old JavaScript files.

**How to do it**:
- **Windows/Linux**: `Ctrl + Shift + R`
- **Mac**: `Cmd + Shift + R`
- **Alternative**: Open DevTools (F12) → Right-click refresh button → "Empty Cache and Hard Reload"

---

### Step 2: Stop and Restart Dev Server
The Flutter dev server might be serving cached files.

```powershell
# In your terminal where app is running:
# Press Q to quit
q

# Then restart:
flutter run -d chrome
```

---

### Step 3: Clear Build Cache
If hard refresh doesn't work, clear Flutter's build cache.

```powershell
# Stop the app first (press Q)

# Clean build files
flutter clean

# Rebuild
flutter pub get
flutter run -d chrome
```

---

### Step 4: Verify File Changes Were Saved
Make sure all edited files were actually saved.

**Files to check**:
- `lib/presentation/home/cubit/home_cubit.dart`
- `lib/presentation/home/screens/prayer_times/cubit/prayer_timings_cubit.dart`
- `lib/data/network/network_info.dart`
- `web/index.html`

**Look for**:
- Try-catch blocks around `location.hasPermission()`
- `if (kIsWeb)` in network_info.dart
- `mobile-web-app-capable` meta tag in index.html

---

### Step 5: Check Browser Console Carefully

**Open DevTools**: Press `F12`

**Look for**:
- New errors (different from before)
- Stack traces showing line numbers
- Network tab for failed requests

---

## Common Issues After Fix

### Issue: "kIsWeb not found"
**Error**: `Undefined name 'kIsWeb'`

**Fix**: Make sure import is at top of file
```dart
import 'package:flutter/foundation.dart' show kIsWeb;
```

---

### Issue: Location Still Not Working
**This is normal on web!**

Web browsers have strict location permissions:
- User must explicitly allow location
- HTTPS required in production (not localhost)
- Some browsers block location API

**Expected behavior**:
- ✅ No error in console
- ✅ Browser prompts for permission
- ⚠️ May show "Getting your location..." if denied

---

### Issue: Different Errors Appearing
**New errors might be unrelated to the fixes.**

**Check**:
1. What's the error message?
2. Which file is causing it?
3. Is it related to location/CORS/network?

**If different errors**:
- Prayer times API might be down
- Network issues with api.aladhan.com
- Different web platform limitation

---

## How to Verify Fix Worked

### ✅ Success Indicators

**Console should show**:
```
[🌎 Easy Localization] [INFO] Start locale loaded ar
onCreate -- HomeCubit
onCreate -- QuranCubit
onCreate -- PrayerTimingsCubit
onChange -- PrayerTimingsCubit...
```

**Console should NOT show**:
```
❌ location_web.dart:61 Uncaught TypeError
❌ Access to fetch blocked by CORS policy
❌ ERR_CONNECTION_TIMED_OUT
❌ apple-mobile-web-app-capable is deprecated
```

---

## Platform-Specific Behavior

### Location Permission on Web

**What happens now**:
1. App tries to get location
2. If permission check fails → catches error → continues
3. Browser shows native permission prompt
4. User allows/denies
5. App handles result gracefully

**Console output (normal)**:
```
Permission check not supported on this platform, trying to get location anyway
```

This is EXPECTED and not an error!

---

### Network Check on Web

**What happens now**:
1. App checks if on web platform
2. If web → returns `true` (assumes connected)
3. If mobile → checks actual connection

**Why this works**:
- Browsers handle offline state
- Avoids CORS issues
- Faster response
- No external API calls

---

## Advanced Troubleshooting

### Check Actual Code Changes

**home_cubit.dart** should have around line 85-125:
```dart
try {
  serviceEnabled = await location.serviceEnabled();
  // ...
  try {
    permissionGranted = await location.hasPermission();
    // ...
  } catch (permissionError) {
    print('Permission check not supported on this platform');
  }
  locationData = await location.getLocation();
} catch (e) {
  print('Error getting location: $e');
  // ...
}
```

**network_info.dart** should have:
```dart
import 'package:flutter/foundation.dart' show kIsWeb;

// ...

@override
Future<bool> get isConnected async {
  if (kIsWeb) {
    return true;
  }
  try {
    return await _internetConnectionChecker.hasConnection;
  } catch (e) {
    return true;
  }
}
```

---

## Testing Checklist

### After Hot Restart

- [ ] Open browser DevTools (F12)
- [ ] Go to Console tab
- [ ] Clear console (trash icon)
- [ ] Refresh page
- [ ] Watch for errors

### Expected Results

**Good signs** ✅:
- No red errors
- Blue info logs only
- "Permission check not supported" message (normal)
- App loads successfully

**Bad signs** ❌:
- Red error messages
- Same location_web.dart errors
- CORS policy errors
- Connection timeout errors

---

## Still Having Issues?

### Get More Information

**Enable verbose logging**:
```powershell
flutter run -d chrome --verbose
```

**Check Flutter doctor**:
```powershell
flutter doctor -v
```

**Check dependencies**:
```powershell
flutter pub outdated
```

---

### Report Issue with Details

If errors persist, provide:

1. **Exact error message** from console
2. **Stack trace** (full error details)
3. **File and line number** where error occurs
4. **Steps to reproduce**
5. **Browser and version** (Chrome, Firefox, etc.)
6. **Flutter version**: `flutter --version`

---

## Quick Fixes Reference

| Error Type | File to Check | Line to Look For |
|------------|---------------|------------------|
| Location permission | home_cubit.dart | Line ~97 with try-catch |
| Location permission | prayer_timings_cubit.dart | Line ~62 with try-catch |
| CORS/Timeout | network_info.dart | Line ~14 with `if (kIsWeb)` |
| Deprecated warning | web/index.html | Line ~24 with mobile-web-app-capable |

---

## Emergency Rollback

If something breaks and you need to revert:

### Revert Single File
```powershell
git checkout HEAD -- lib/data/network/network_info.dart
```

### Revert All Changes
```powershell
git checkout HEAD -- lib/presentation/home/cubit/home_cubit.dart
git checkout HEAD -- lib/presentation/home/screens/prayer_times/cubit/prayer_timings_cubit.dart
git checkout HEAD -- lib/data/network/network_info.dart
git checkout HEAD -- web/index.html
```

---

## Success Criteria

**Your fix is working if**:

✅ App runs without console errors  
✅ Location may or may not work (browser dependent) but no errors  
✅ No CORS policy violations  
✅ No connection timeouts  
✅ Clean developer console  
✅ App is usable on web browser  

---

## Additional Help

**Documentation**:
- See `WEB_ERRORS_FIXED.md` for detailed technical explanation
- See `quick_fix_summary.md` for quick reference

**Flutter Resources**:
- [Flutter Web Docs](https://docs.flutter.dev/platform-integration/web)
- [Flutter Web FAQ](https://docs.flutter.dev/platform-integration/web/faq)

---

*Troubleshooting Guide*  
*Last Updated: January 26, 2026*  
*For: Flutter Web Platform* 🌐
