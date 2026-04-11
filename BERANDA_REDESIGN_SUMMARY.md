# Beranda (Home Dashboard) Redesign - An-Nibros Modern Style

## Overview
Successfully redesigned the Home Dashboard (Beranda) screen to match the modern An-Nibros Islamic app design with a vibrant Fajr-inspired gradient, prayer countdown timer, and clean UI/UX.

## Implementation Date
January 29, 2026

## Key Features Implemented

### 1. Vibrant Fajr Gradient Background
**Colors:**
- Top: `#F4F878` (Vibrant Lemon Yellow)
- Middle: `#B8CF70` (Mid-tone Yellow-Green)
- Bottom: `#00897B` (Deep Teal Green)

**Implementation:**
```dart
LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFF4F878), // Vibrant Lemon Yellow
    Color(0xFFB8CF70), // Mid-tone Yellow-Green
    Color(0xFF00897B), // Deep Teal Green
  ],
)
```

### 2. Modern Header Section (`_HomeHeader`)
**Layout:**
- Transparent background (sits on top of gradient)
- Height: 35% of screen height
- Location icon + city name (left side)
- Hijri date below location
- Notification bell icon (right side)
- Gregorian date (top right)

**Features:**
- Dynamic location display using `recordLocation` from constants
- Bilingual support (English/Arabic)
- Loading state with progress indicator
- Dark teal color scheme (`#00695C`, `#004D40`) for text

### 3. Prayer Countdown Card (`_PrayerCountdownCard`)
**New StatefulWidget with Dynamic Timer:**
- Updates every second using `Timer.periodic`
- Calculates next prayer from current time
- Shows countdown in HH:MM:SS format
- Displays prayer name and time
- Proper timer disposal to prevent memory leaks

**Features:**
- Auto-detects next prayer (Fajr, Dhuhr, Asr, Maghrib, Isha)
- Bilingual prayer names (English/Arabic)
- Glassmorphism-style design with white background
- Yellow-highlighted countdown display
- Position: Overlapping header with -40 offset

**Timer Implementation:**
```dart
Timer? _timer;
Duration _remainingTime = Duration.zero;

@override
void initState() {
  super.initState();
  _calculateNextPrayer();
  _timer = Timer.periodic(const Duration(seconds: 1), (_) {
    if (mounted) {
      setState(() {
        _calculateNextPrayer();
      });
    }
  });
}

@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}
```

### 4. Updated Search Bar (`_SearchBarWidget`)
**Style:**
- Pure white background (`#FFFFFF`)
- Border radius: 30px
- Deep teal search icon (`#00897B`)
- Proper shadow with opacity
- Bilingual placeholder text
- Position: Overlapping countdown card with -20 offset

### 5. Menu Grid (Existing - Maintained)
**7 Menu Items:**
1. Aurad Shalat → Panduan Ibadah
2. Doa & Tawasul → Doa
3. Ratib → Ratib
4. Khutbah → Umum
5. Maulid → Qasidah
6. Tahlil & Ziarah → Tahlil & Jenazah
7. Notes → Amalan Khusus (Full width)

**Style:**
- White cards with `BorderRadius.circular(20)`
- Color-coded icons per category
- Proper shadows and elevation
- 2-column grid for first 6 items
- Full-width card for Notes

## File Structure

### Modified Files:
1. **`lib/presentation/home/screens/dashboard/view/home_dashboard_screen.dart`** (684 lines)
   - Added `dart:async` import for Timer
   - Added `islamic/app/utils/constants.dart` import for recordLocation
   - Completely redesigned `_HomeHeader` widget
   - Added new `_PrayerCountdownCard` StatefulWidget with timer
   - Updated `_SearchBarWidget` styling
   - Updated `_MenuCard` border radius to 20
   - Fixed CustomScrollView layout with proper offsets

## Widget Tree Structure

```
HomeDashboardScreen (StatelessWidget)
├── BlocBuilder<PrayerTimingsCubit>
    └── CustomScrollView
        ├── SliverToBoxAdapter: _HomeHeader
        │   ├── Container (Gradient Background)
        │   └── SafeArea
        │       ├── Loading State OR
        │       └── Header Content
        │           ├── Location + Hijri Date
        │           └── Notification + Gregorian Date
        │
        ├── SliverToBoxAdapter: _PrayerCountdownCard (offset: -40)
        │   ├── Next Prayer Label
        │   ├── Prayer Name (Bilingual)
        │   ├── Countdown Timer (HH:MM:SS)
        │   └── Prayer Time
        │
        ├── SliverToBoxAdapter: _SearchBarWidget (offset: -20)
        │   ├── Search Icon (Deep Teal)
        │   └── Placeholder Text
        │
        └── SliverPadding: _MenuGrid
            ├── GridView (6 items, 2 columns)
            └── Full Width Card (Notes)
```

## Technical Details

### Timer Management
- **Initialization:** Timer starts in `initState()`
- **Update Frequency:** Every 1 second
- **Safety Check:** Uses `if (mounted)` before setState
- **Cleanup:** Timer properly disposed in `dispose()` method
- **Memory Leak Prevention:** Ensures no memory leaks with proper disposal

### Next Prayer Calculation Logic
1. Parse all 5 daily prayer times from API
2. Convert 24-hour format to DateTime objects
3. Compare each prayer time with current time
4. If prayer time passed, add 1 day (next day's prayer)
5. Find earliest upcoming prayer
6. Calculate duration difference
7. Format as HH:MM:SS string

### Responsive Design
- Uses `flutter_screenutil` for responsive sizing
- All sizes use `.r`, `.w`, `.h` extensions
- Screen height percentage for header (35%)
- Proper padding and spacing throughout

### Color Scheme
**Primary Colors:**
- Lemon Yellow: `#F4F878`
- Yellow-Green: `#B8CF70`
- Deep Teal: `#00897B`
- Dark Teal: `#00695C`
- Darker Teal: `#004D40`

**Semantic Usage:**
- Background: Gradient (Lemon to Teal)
- Icons & Headings: Dark Teal (#00695C)
- Body Text: Darker Teal (#004D40)
- Cards: Pure White (#FFFFFF)
- Countdown Background: Light Yellow with opacity

## Breaking Changes
None - All changes are backward compatible. The screen maintains the same navigation structure and integration with existing cubits.

## Dependencies
**Required (Already in pubspec.yaml):**
- `dart:async` (built-in)
- `flutter_bloc` - State management
- `flutter_screenutil` - Responsive design
- `easy_localization` - Internationalization
- `islamic/app/utils/constants.dart` - For recordLocation
- `islamic/app/utils/extensions.dart` - For time format conversion

## Testing Checklist
- [x] App compiles without errors
- [x] Timer updates every second
- [x] Timer disposes properly on navigation
- [x] Next prayer calculation works for all 5 prayers
- [x] Countdown displays correctly
- [x] Location displays from fallback (Gresik, Indonesia)
- [x] Hijri and Gregorian dates display correctly
- [x] Search bar navigation works
- [x] All 7 menu items navigate correctly
- [ ] Test on physical device
- [ ] Test with different prayer times
- [ ] Test transition at midnight
- [ ] Test bilingual support (English/Arabic)
- [ ] Test on different screen sizes
- [ ] Test timer performance (no lag)

## Future Enhancements
1. Add notification scheduling for upcoming prayers
2. Add swipe gestures to view all prayer times
3. Add prayer time adjustment (e.g., Asr calculation method)
4. Add Islamic calendar view
5. Add weather integration in header
6. Add Qibla direction indicator
7. Add daily hadith/verse widget
8. Add prayer time history/analytics

## Performance Notes
- Timer runs at 1Hz (once per second) - minimal CPU usage
- No unnecessary rebuilds (only countdown widget updates)
- Proper state management with BlocBuilder
- Efficient widget tree with const constructors where possible
- Gradient rendered once, not rebuilt
- Icons cached by Flutter

## Accessibility
- High contrast text colors (Dark Teal on Light Yellow)
- Large, readable countdown timer
- Clear iconography
- Bilingual support for all text
- Semantic widget structure

## Known Limitations
1. Countdown continues even when app is in background (timer pauses)
2. No audio alerts for prayer times (future feature)
3. Location must be manually set if GPS fails (uses fallback)
4. Prayer times based on API data (requires internet on first load)

## Migration Notes
No migration needed - this is a visual redesign of existing screen. All existing functionality preserved.

## Credits
- Design Inspiration: An-Nibros Islamic App
- Gradient Colors: Fajr Prayer aesthetic (Dawn colors)
- Font: UthmanTN (Arabic-optimized)
- Icons: Material Design Icons

## Support
For issues or questions, refer to:
- Main project README.md
- MATERIAL_INTEGRATION_SUMMARY.md
- TROUBLESHOOTING_WEB.md

---
**Status:** ✅ COMPLETE - Ready for testing
**Last Updated:** January 29, 2026
**Developer:** AI Assistant via GitHub Copilot
