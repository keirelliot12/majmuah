# Prayer Time Widget - Quick Reference

## 📍 Import
```dart
import 'package:islamic/presentation/components/prayer_time_widget.dart';
```

## 🚀 One-Liner

### Basic
```dart
PrayerTimeWidget(prayerTimingsModel: model, location: 'Kudus, Indonesia', isEnglish: true)
```

### Builder
```dart
PrayerTimeWidgetBuilder.create(prayerTimingsModel: model, location: 'Jakarta', isEnglish: true)
```

---

## 📋 Constructor

```dart
PrayerTimeWidget(
  // Required
  prayerTimingsModel: PrayerTimingsModel,    // From API
  location: 'Kudus, Indonesia',              // City name
  isEnglish: true,                           // Language flag

  // Optional
  height: 180.h,                             // Custom height
  onUpdate: () => print('Updated'),          // Callback
)
```

---

## 🎨 Visual Layout

```
┌─────────────────────────────────────────────────┐
│ 📍 Kudus, Indonesia      [🔔 Notifications]    │
│    Kamis, 13 Rajab 1445 H                       │
├─────────────────────────────────────────────────┤
│ [🌙] Berikutnya: Dzuhur    12:05                │
│      ────────────────────────────────────────   │
│             Sisa Waktu: 02:45:30                │
└─────────────────────────────────────────────────┘
```

---

## 🎯 Common Use Cases

### 1. In BlocBuilder (Recommended)
```dart
BlocBuilder<PrayerTimingsCubit, PrayerTimingsState>(
  builder: (context, state) {
    return PrayerTimeWidget(
      prayerTimingsModel: PrayerTimingsCubit.get(context).prayerTimingsModel,
      location: 'Kudus, Indonesia',
      isEnglish: context.locale.languageCode == 'en',
    );
  },
)
```

### 2. In CustomScrollView
```dart
CustomScrollView(
  slivers: [
    SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: PrayerTimeWidget(
          prayerTimingsModel: model,
          location: 'Jakarta',
          isEnglish: true,
        ),
      ),
    ),
    // ... other slivers
  ],
)
```

### 3. Standalone Screen
```dart
Scaffold(
  body: PrayerTimeWidget(
    prayerTimingsModel: model,
    location: 'Bandung',
    isEnglish: true,
  ),
)
```

### 4. With Callback
```dart
PrayerTimeWidget(
  prayerTimingsModel: model,
  location: 'Surabaya',
  isEnglish: true,
  onUpdate: () {
    // Do something when timer updates
  },
)
```

---

## 🌈 Color Scheme

| Element | Color | Hex |
|---------|-------|-----|
| Background Top | Lemon Yellow | #F4F878 |
| Background Bottom | Teal Green | #00897B |
| Text | White | #FFFFFF |
| Icon Background | Teal Green | #00897B |

---

## 📊 Displayed Information

| Section | Shows | Format |
|---------|-------|--------|
| Location | City/Country | "Kudus, Indonesia" |
| Date | Hijri Date | "13 Rajab 1445 H" |
| Prayer Name | Next Prayer | "Dzuhur" / "الظهر" |
| Prayer Time | When Prayer Starts | "12:05" |
| Countdown | Time Until Prayer | "02:45:30" |

---

## 🔄 Auto-Update Behavior

- **Frequency:** Every 1 second
- **Countdown Updates:** HH:MM:SS decrements
- **Prayer Switch:** Automatic when prayer time passes
- **Next Day:** Auto-switches to tomorrow's Fajr after Isha

---

## 🌐 Bilingual Support

### English
- "Next Prayer" / "Time Left"
- Prayer names: Fajr, Dhuhr, Asr, Maghrib, Isha

### Arabic
- "الصلاة القادمة" / "الوقت المتبقي"
- Prayer names: الفجر, الظهر, العصر, المغرب, العشاء

---

## 🎯 Parameters Summary

| Param | Type | Required | Default | Notes |
|-------|------|----------|---------|-------|
| `prayerTimingsModel` | Model | ✅ | - | From API response |
| `location` | String | ✅ | - | e.g., "Kudus, Indonesia" |
| `isEnglish` | bool | ✅ | - | true = EN, false = AR |
| `height` | double? | ❌ | 180.h | Responsive by default |
| `onUpdate` | Callback? | ❌ | null | Called every second |

---

## ⚡ Performance Tips

1. **Single Timer** - Only one timer per widget instance
2. **Proper Disposal** - Timer automatically cleaned up
3. **Efficient Updates** - Only re-builds countdown section
4. **No Memory Leaks** - Uses `mounted` check before setState

---

## 🔧 Integration in Home Dashboard

```dart
// In home_dashboard_screen.dart or similar

BlocBuilder<PrayerTimingsCubit, PrayerTimingsState>(
  builder: (context, state) {
    final cubit = PrayerTimingsCubit.get(context);
    final isEnglish = context.locale.languageCode == 'en';

    return CustomScrollView(
      slivers: [
        // Prayer Time Widget ✨
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.p16.w,
              vertical: AppPadding.p12.h,
            ),
            child: PrayerTimeWidget(
              prayerTimingsModel: cubit.prayerTimingsModel,
              location: recordLocation.toString(),
              isEnglish: isEnglish,
            ),
          ),
        ),

        // Search Bar
        SliverToBoxAdapter(child: SearchBar()),

        // Menu Grid
        SliverPadding(child: MenuGrid()),
      ],
    );
  },
)
```

---

## 🎓 Design System

**Component Type:** Large Card Widget  
**Background:** Primary Gradient (Yellow → Teal)  
**Text Color:** White (100%, 80%, 70%, 60% opacity)  
**Border Radius:** 24dp (outer), 20dp (inner)  
**Height:** 180.h (responsive, customizable)  
**Animation:** Live countdown every second  

---

## 🧪 Data Requirements

Needs `PrayerTimingsModel` with:
- ✅ `code` (200 = success)
- ✅ `data.timings.fajr`
- ✅ `data.timings.dhuhr`
- ✅ `data.timings.asr`
- ✅ `data.timings.maghrib`
- ✅ `data.timings.isha`
- ✅ `data.date.hijri` (optional but recommended)

---

## 📱 Responsive Behavior

| Screen Size | Default Height | Recommended |
|-------------|----------------|----|
| Small (<400w) | 180.h | Use default |
| Medium (400-600w) | 180.h | Use default |
| Large (>600w) | 180.h | Can increase to 200.h |

---

## ⚠️ Important Notes

1. **Device Time:** Countdown based on device's system time
2. **API Data:** Requires valid prayer timings from API
3. **Location:** Display only, doesn't affect prayer calculation
4. **Timer:** Runs even when app in background (stops on dispose)

---

## 🔗 Related Components

- `HomeMenuCard` - Menu grid cards below
- `SearchBarWidget` - Search box
- `PrayerTimingsCubit` - State management
- `PrayerTimingsModel` - Data model

---

## ✅ Verification

- [x] Component created
- [x] Countdown working
- [x] Gradient background correct
- [x] Bilingual support
- [x] Zero compilation errors
- [x] Production ready

---

**File:** `lib/presentation/components/prayer_time_widget.dart`  
**Status:** ✅ Production Ready  
**Version:** 1.0.0
