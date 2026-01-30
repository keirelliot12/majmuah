# Prayer Time Widget - Documentation

## Overview
`PrayerTimeWidget` is a full-featured Flutter widget that displays prayer time information with a live countdown timer. It shows location, Hijri date, next prayer name/time, and a real-time countdown to the next prayer.

## Location
```
lib/presentation/components/prayer_time_widget.dart
```

## Features
✅ **Live Countdown Timer** - Updates every second with remaining time  
✅ **Automatic Prayer Detection** - Determines next prayer based on current time  
✅ **Primary Gradient Background** - Lemon Yellow to Teal Green (An-Nibros design)  
✅ **White Text** - High contrast on gradient background  
✅ **Bilingual Support** - English/Arabic labels  
✅ **Hijri Date Display** - Shows Islamic calendar date  
✅ **Responsive Design** - Works across all screen sizes  
✅ **Memory Safe** - Proper timer disposal to prevent leaks  

## Constructor Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `prayerTimingsModel` | PrayerTimingsModel | ✅ | - | Prayer timings data from API |
| `location` | String | ✅ | - | Location string (e.g., "Kudus, Indonesia") |
| `isEnglish` | bool | ✅ | - | Language toggle (true = English, false = Arabic) |
| `height` | double? | ❌ | 180.h | Custom widget height |
| `onUpdate` | VoidCallback? | ❌ | null | Callback when countdown updates |

## Design Specifications

### Colors
- **Background Gradient:** Lemon Yellow (#F4F878) → Teal Green (#00897B)
- **Text Color:** White (with various opacity levels)
- **Icon Background:** Teal Green (#00897B)
- **Container Background:** White with 40% opacity (glassmorphism)

### Layout Structure
```
┌─────────────────────────────────────────────┐
│  📍 Location          [🔔 Notifications]    │  ← Header Row
│  Date (Hijri)                               │
├─────────────────────────────────────────────┤
│  [Icon] Next Prayer: Ashar        2:45 PM   │  ← Prayer Info
│         ─────────────────────────────────   │
│                   Time Left: 02:45:30       │
└─────────────────────────────────────────────┘
```

### Dimensions
- **Default Height:** 180.h (responsive)
- **Border Radius:** 24 dp
- **Padding:** 16 dp all sides
- **Inner Container Radius:** 20 dp

## Basic Usage

### Simple Implementation
```dart
PrayerTimeWidget(
  prayerTimingsModel: cubit.prayerTimingsModel,
  location: 'Kudus, Indonesia',
  isEnglish: true,
)
```

### With Callback
```dart
PrayerTimeWidget(
  prayerTimingsModel: prayerTimingsModel,
  location: location,
  isEnglish: isEnglish,
  onUpdate: () {
    debugPrint('Prayer time updated');
  },
)
```

### With Custom Height
```dart
PrayerTimeWidget(
  prayerTimingsModel: prayerTimingsModel,
  location: location,
  isEnglish: isEnglish,
  height: 200.h,
)
```

## Using Builder Functions

### Basic Builder
```dart
PrayerTimeWidgetBuilder.create(
  prayerTimingsModel: prayerTimingsModel,
  location: 'Kudus, Indonesia',
  isEnglish: true,
)
```

### With Custom Height
```dart
PrayerTimeWidgetBuilder.withHeight(
  prayerTimingsModel: prayerTimingsModel,
  location: 'Gresik, Indonesia',
  isEnglish: false,
  height: 220.h,
)
```

## Integration in Home Dashboard

### In CustomScrollView
```dart
CustomScrollView(
  slivers: [
    SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p16.w,
          vertical: AppPadding.p12.h,
        ),
        child: PrayerTimeWidget(
          prayerTimingsModel: prayerTimingsModel,
          location: recordLocation.toString(),
          isEnglish: isEnglish,
          onUpdate: () => setState(() {}),
        ),
      ),
    ),
    // ... other slivers
  ],
)
```

## How the Countdown Works

### Initialization
1. Parse prayer timings from API response
2. Get current time
3. Find first prayer time that hasn't passed
4. Calculate duration until that prayer

### Update Loop
- Timer runs every 1 second
- Updates remaining time
- When countdown reaches 0, calculates next prayer
- Auto-scrolls to Fajr if past Isha

### Prayer Detection Logic
```
if Fajr > now → Next prayer is Fajr
else if Dhuhr > now → Next prayer is Dhuhr
else if Asr > now → Next prayer is Asr
else if Maghrib > now → Next prayer is Maghrib
else if Isha > now → Next prayer is Isha
else → Next prayer is tomorrow's Fajr
```

## Displayed Information

### Header Section (Row 1)
- **Location Icon + Text:** Current location
- **Hijri Date:** Islamic calendar date
- **Notification Bell:** Interactive icon (tappable)

### Prayer Info Section (Row 2)
- **Prayer Icon:** Teal green icon in rounded container
- **Next Prayer Name:** Bilingual label
- **Prayer Time:** Time when prayer starts
- **Countdown Timer:** HH:MM:SS format
- **Time Left Label:** Bilingual label

## Bilingual Support

### English Labels
```dart
'Next Prayer' → 'Next Prayer'
'Time Left' → 'Time Left'
Prayer names: 'Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'
```

### Arabic Labels
```dart
'الصلاة القادمة' → 'Next Prayer'
'الوقت المتبقي' → 'Time Left'
Prayer names: 'الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'
```

## Styling Details

### Text Hierarchy
1. **Location/Label:** White 80% opacity, 12sp Semi-bold
2. **Date:** White 60% opacity, 11sp Regular
3. **Prayer Name/Time:** White 100%, 16sp/14sp Bold
4. **Timer Label:** White 70% opacity, 10sp Bold
5. **Timer Value:** White 100%, 14sp Bold (monospace)

### Containers
- **Outer Container:** Gradient background, 24dp radius
- **Header:** Flexible layout with notification button
- **Prayer Info:** White 40% opacity background, glassmorphism effect
- **Icon Container:** Teal green, 12dp radius

## Error Handling

### Invalid Data Handling
If `prayerTimingsModel.code != 200`:
- Display `'N/A'` for prayer name
- Display `'00:00'` for prayer time
- Show `0:00:00` countdown

### Time Parsing
- Expects `"HH:MM"` format from API
- Safely handles parsing errors
- Falls back gracefully if format invalid

## Performance Considerations

### Timer Management
- Single `Timer.periodic` running once per second
- Properly disposed in `dispose()` method
- No memory leaks with `mounted` check
- Efficient state updates only when needed

### Responsive Sizing
- Uses `flutter_screenutil` for all dimensions
- Scales smoothly across different devices
- Default height: 180.h (responsive)
- All padding/spacing responsive

## Customization Examples

### Change Height
```dart
PrayerTimeWidget(
  prayerTimingsModel: model,
  location: 'Jakarta',
  isEnglish: true,
  height: 200.h,  // Custom height
)
```

### With Debug Logging
```dart
PrayerTimeWidget(
  prayerTimingsModel: model,
  location: 'Bandung',
  isEnglish: false,
  onUpdate: () {
    debugPrint('Prayer widget updated at ${DateTime.now()}');
  },
)
```

## Integration with Home Dashboard

### Complete Example
```dart
class HomeDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimingsCubit, PrayerTimingsState>(
      builder: (context, state) {
        final cubit = PrayerTimingsCubit.get(context);
        final model = cubit.prayerTimingsModel;
        
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 60.h,
              // ... app bar config
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppPadding.p16.w),
                child: PrayerTimeWidget(
                  prayerTimingsModel: model,
                  location: 'Kudus, Indonesia',
                  isEnglish: context.locale.languageCode == 'en',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SearchBar(),  // Next widget
            ),
          ],
        );
      },
    );
  }
}
```

## Accessibility Features

✅ **High Contrast** - White text on gradient  
✅ **Clear Typography** - Readable font sizes  
✅ **Semantic Structure** - Proper widget hierarchy  
✅ **RTL Support** - Works with Arabic (RTL) layouts  
✅ **Bilingual** - Full English/Arabic support  

## Known Limitations

1. Countdown displays local device time (not server time)
2. Prayer times depend on API data availability
3. If device time is incorrect, countdown may be inaccurate
4. Requires `intl` package for date formatting

## Related Components

- `HomeMenuCard` - Menu grid cards
- `SearchBarWidget` - Search functionality
- `PrayerTimingsCubit` - State management for prayer times
- `PrayerTimingsModel` - Data model

## Testing Recommendations

### Unit Tests
```dart
test('PrayerTimeWidget parses prayer times correctly', () {
  // Test prayer time parsing
});

test('Countdown timer calculates remaining time accurately', () {
  // Test countdown calculation
});
```

### Widget Tests
```dart
testWidgets('PrayerTimeWidget displays correct prayer name', 
  (WidgetTester tester) async {
    // Test widget display
  });

testWidgets('Countdown updates every second', 
  (WidgetTester tester) async {
    // Test timer update
  });
```

## Version Information

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | Jan 29, 2026 | Initial release with countdown timer |

---

**Status**: ✅ Production Ready  
**File**: `lib/presentation/components/prayer_time_widget.dart`  
**Lines**: ~430  
**Errors**: 0 ✅
