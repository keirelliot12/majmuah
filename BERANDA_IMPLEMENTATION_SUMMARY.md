# Beranda (Home Dashboard) - Major UI Refactor Summary

## Overview
Successfully implemented a **MAJOR UI REFACTOR** for the Home screen with modern Islamic app design featuring:
- **Gradient Header** (30% screen height) with prayer times
- **Overlapping Search Bar** for better UX
- **7 Islamic Menu Items** with smart grid layout
- **5-Item Bottom Navigation** (removed Hadith from bottom nav)

---

## 🎨 NEW DESIGN STRUCTURE

### A. Top Section (Header Container)
- **Height**: ~30% of screen
- **Background**: Linear Gradient (Yellow → Yellow-Green → Sage Green)
- **Content**: 
  - Hijri & Gregorian dates at top
  - Prayer times cards for Fajr & Dhuhr with icons
  - Clean, modern typography with dark text for contrast

### B. Search Bar Section
- **Position**: Overlapping between Header and Grid (Transform.translate with -30 offset)
- **Style**: 
  - White container
  - BorderRadius 30 (pill shape)
  - Soft shadow for depth
  - Search & mic icons
- **Function**: Opens Quran search delegate

### C. Menu Grid (Main Content)
**7 Islamic Menu Items**:
1. **Aurad Shalat** (Auto Stories Icon) - Green
2. **Doa & Tawasul** (Hands Icon) - Brown
3. **Ratib** (Book Icon) - Sage Green
4. **Khutbah** (Voice Icon) - Orange
5. **Maulid** (Celebration Icon) - Beige
6. **Tahlil & Ziarah** (Mosque Icon) - Teal
7. **Notes** (Note Icon) - Tan - **FULL WIDTH CARD**

**Grid Logic**:
- Items 1-6: 2-column grid layout
- Item 7 (Notes): Full-width card at bottom with arrow indicator
- All cards: White background, circular icon containers, elevation shadow

---

## 📱 BOTTOM NAVIGATION (5 ITEMS)

**New Structure**:
1. 🏠 **Beranda** (Home)
2. 📖 **Quran**
3. 🕌 **Prayer Times**
4. 📿 **Adzkar**
5. ⚙️ **Settings**

**Styling**:
- Type: `BottomNavigationBarType.fixed`
- Active Color: Sage Green (#90A88E)
- Inactive Color: Grey
- Larger active icon size (24dp vs 20dp)

**Technical Implementation**:
- Internal app has 6 screens (including Hadith)
- Bottom nav shows only 5 items
- Helper functions map between 6 internal indices ↔ 5 nav items
- Hadith screen accessible via drawer menu

## Changes Made

### 1. Translation Files Updated
- **en.json**: Added translations for:
  - `home`: "HOME"
  - `beranda`: "Beranda"
  - `namaz`: "Namaz"
  - `duas`: "Duas"
  - `zakat`: "Zakat"
  - `qibla`: "Qibla"
  - `tasbih`: "Tasbih"
  - `search_word_or_ayat`: "Search word or ayat in Quran"

- **ar.json**: Added Arabic translations for the same keys

### 2. String Manager Updated
- **lib/app/resources/strings_manager.dart**:
  - Added new string constants for all new features
  - Added: `home`, `beranda`, `namaz`, `duas`, `zakat`, `qibla`, `tasbih`, `searchWordOrAyat`

### 3. Constants Updated
- **lib/app/utils/constants.dart**:
  - Added `homeIndex = 0` as the new first tab
  - Updated all other indices:
    - `quranIndex = 1` (was 0)
    - `hadithIndex = 2` (was 1)
    - `prayerTimingsIndex = 3` (was 2)
    - `adhkarIndex = 4` (was 3)
    - `settingsIndex = 5` (was 4)

### 4. New Screen Created
- **lib/presentation/home/screens/dashboard/view/home_dashboard_screen.dart**:
  - Created a new home dashboard screen with:
    - Yellow-to-green gradient background matching the design
    - Prayer times card showing Fajr and Dhuhr with icons
    - Hijri and Gregorian date display
    - Search bar for Quran with microphone icon
    - 2x3 grid of feature cards:
      - Namaz (Prayer)
      - Duas (Supplications)
      - Quran
      - Zakat (Charity)
      - Qibla (Direction)
      - Tasbih (Counter)

### 5. Home View Model Updated
- **lib/presentation/home/viewmodel/home_viewmodel.dart**:
  - Added `HomeDashboardScreen` as the first screen
  - Updated the screens list to include 6 items (was 5)
  - Updated the titles list to include "HOME" as first title

### 6. Home View Updated
- **lib/presentation/home/view/home_view.dart**:
  - Added conditional AppBar rendering:
    - Transparent AppBar with white text for home screen
    - Standard AppBar for other screens
  - Added "Beranda" as the first bottom navigation item with home icons
  - Updated search functionality to work on both home and Quran screens
  - Removed horizontal padding for home screen to allow full-width gradient
  - Updated all index references to work with new navigation structure

## Design Features

### Widget Architecture (Separation of Concerns)
```
HomeDashboardScreen (StatelessWidget)
├── CustomScrollView
│   ├── SliverToBoxAdapter: _HomeHeader
│   │   ├── Gradient Container (30% screen)
│   │   ├── Date Display (Hijri/Gregorian)
│   │   └── Prayer Time Cards (Fajr & Dhuhr)
│   ├── SliverToBoxAdapter: _SearchBarWidget
│   │   └── Overlapping Container (-30 offset)
│   └── SliverPadding: _MenuGrid
│       ├── First 6 items (2-column grid)
│       └── 7th item (Full width)
```

### Color Scheme
- **Header Gradient**: #E8D76E → #C8CF7E → #90A88E
- **Prayer Cards**: White with 80% opacity, sage green icons
- **Search Bar**: Pure white (#FFFFFF) with shadow
- **Menu Cards**: Pure white with colored icon backgrounds
- **Active Nav**: Sage Green (#90A88E)
- **Inactive Nav**: Grey

### UI Components Details

1. **_HomeHeader Component**:
   - Responsive height (30% of screen)
   - SafeArea wrapper for status bar
   - Conditional rendering (loading vs. prayer data)
   - Prayer time cards with rounded corners
   - Icon + Name + Time layout

2. **_SearchBarWidget Component**:
   - Pill-shaped design (BorderRadius 30)
   - Elevated shadow (blur 12, offset 4)
   - Horizontal padding for touch target
   - Search and mic icons at ends

3. **_MenuGrid Component**:
   - SliverList with 2 children (grid + full-width)
   - GridView for first 6 items
   - Special Padding for Notes card
   - Tap feedback with SnackBar (ready for navigation)

4. **_MenuCard Component**:
   - Dual layout support (grid vs full-width)
   - Circular icon containers with colored backgrounds
   - Dynamic sizing based on isFullWidth flag
   - Arrow indicator for full-width cards

### Navigation Structure

**Internal Screen Indices (6 items)**:
```
0 = Home Dashboard (Beranda)
1 = Quran Screen
2 = Hadith Screen (hidden from bottom nav)
3 = Prayer Times Screen
4 = Adhkar Screen
5 = Settings Screen
```

**Bottom Navigation Indices (5 items)**:
```
0 = Beranda (Home)
1 = Quran
2 = Prayer Times
3 = Adzkar
4 = Settings
```

**Index Mapping Functions**:
- `_mapIndexTo5Items()`: Converts internal 6-item index → 5-item nav index
- `_mapIndexFrom5Items()`: Converts 5-item nav index → internal 6-item index
- Hadith screen (index 2) is skipped in bottom nav but accessible via drawer

**Navigation Flow**:
```
User taps nav item → _mapIndexFrom5Items() → Change internal index → Update screen
Internal index changes → _mapIndexTo5Items() → Update nav highlight
```

## Benefits
- Better user experience with immediate access to prayer times
- Modern, visually appealing design with gradient background
- Quick access to all major features from home screen
- Search functionality prominently displayed
- Consistent with modern Islamic app design patterns

## Next Steps (Future Enhancements)
- Implement navigation for feature cards (Namaz, Duas, Zakat, Qibla, Tasbih)
- Add animations for card interactions
- Implement actual notifications functionality
- Add more prayer times to the home card (optional)
- Customize feature cards based on user preferences

## Testing Recommendations
1. Test navigation between all bottom navigation tabs
2. Verify search functionality works from home screen
3. Check gradient rendering on different screen sizes
4. Ensure prayer times display correctly with location permission
5. Test both English and Arabic translations
6. Verify floating action buttons appear on correct screens
