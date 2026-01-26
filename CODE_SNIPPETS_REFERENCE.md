# Code Snippets Reference - Home Dashboard Refactor

## Key Code Patterns

### 1. Overlapping Search Bar Pattern
```dart
// Use Transform.translate with negative offset
SliverToBoxAdapter(
  child: Transform.translate(
    offset: Offset(0, -30),  // Overlap by 30 pixels
    child: _SearchBarWidget(),
  ),
),
```

### 2. Dual Layout Menu Card Pattern
```dart
class _MenuCard extends StatelessWidget {
  final bool isFullWidth;
  
  Widget build(BuildContext context) {
    return Container(
      height: isFullWidth ? AppSize.s100.h : null,
      child: isFullWidth
          ? _buildFullWidthContent(context)  // Horizontal layout with arrow
          : _buildGridContent(context),       // Vertical centered layout
    );
  }
}
```

### 3. Smart Grid with Extra Item Pattern
```dart
SliverList(
  delegate: SliverChildBuilderDelegate(
    (context, index) {
      if (index == 0) {
        // First 6 items in 2-column grid
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
          ),
          itemCount: 6,
          itemBuilder: (context, gridIndex) => _MenuCard(...),
        );
      } else if (index == 1) {
        // 7th item full-width
        return _MenuCard(isFullWidth: true, ...);
      }
      return null;
    },
    childCount: 2,  // Grid + Full-width
  ),
)
```

### 4. Navigation Index Mapping Pattern
```dart
// Internal app: 6 screens (0,1,2,3,4,5)
// Bottom nav: 5 items (0,1,2,3,4) - skip Hadith

int _mapIndexTo5Items(int internalIndex) {
  // Convert 6-item index to 5-item display
  if (internalIndex <= 1) return internalIndex;  // 0,1 → 0,1
  if (internalIndex == 2) return 0;              // Hadith → Home
  return internalIndex - 1;                      // 3,4,5 → 2,3,4
}

int _mapIndexFrom5Items(int navIndex) {
  // Convert 5-item nav to 6-item internal
  if (navIndex <= 1) return navIndex;   // 0,1 → 0,1
  return navIndex + 1;                  // 2,3,4 → 3,4,5
}

// Usage in BottomNavigationBar:
BottomNavigationBar(
  currentIndex: _mapIndexTo5Items(currentIndex),
  onTap: (index) => cubit.changeBotNavIndex(_mapIndexFrom5Items(index)),
)
```

### 5. Responsive Header Height Pattern
```dart
Widget build(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  
  return Container(
    height: screenHeight * 0.30,  // 30% of screen
    decoration: BoxDecoration(
      gradient: LinearGradient(...),
    ),
    child: SafeArea(...),  // Respect status bar
  );
}
```

### 6. Gradient Color Pattern
```dart
// Islamic App Gradient: Yellow → Green
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    const Color(0xFFE8D76E),  // Warm yellow
    const Color(0xFFC8CF7E),  // Yellow-green transition
    const Color(0xFF90A88E),  // Sage green
  ],
)
```

### 7. Pill-Shaped Search Bar Pattern
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),  // Pill shape
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(38),
        blurRadius: 12,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Row(
    children: [
      Icon(Icons.search),
      Expanded(child: Text(...)),
      Icon(Icons.mic),
    ],
  ),
)
```

### 8. Circular Icon Container Pattern
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: iconColor.withAlpha(51),  // 20% opacity
    shape: BoxShape.circle,
  ),
  child: Icon(
    iconData,
    size: 40,
    color: iconColor,
  ),
)
```

### 9. CustomScrollView Pattern
```dart
CustomScrollView(
  slivers: [
    SliverToBoxAdapter(child: Header()),
    SliverToBoxAdapter(child: SearchBar()),
    SliverPadding(
      padding: EdgeInsets.all(16),
      sliver: GridContent(),
    ),
  ],
)
```

### 10. Conditional Icon Color in BottomNav
```dart
BottomNavigationBarItem(
  icon: SvgPicture.asset(
    ImageAsset.quranIcon,
    colorFilter: ColorFilter.mode(
      _mapIndexTo5Items(currentIndex) == 1
          ? const Color(0xFF90A88E)  // Active
          : Colors.grey,              // Inactive
      BlendMode.srcIn,
    ),
  ),
)
```

---

## Color Palette Reference

```dart
// Header Gradient
const Color(0xFFE8D76E)  // Yellow
const Color(0xFFC8CF7E)  // Yellow-Green
const Color(0xFF90A88E)  // Sage Green

// Menu Item Colors
const Color(0xFF5A8C6B)  // Aurad Shalat - Dark Green
const Color(0xFFD4945F)  // Doa & Tawasul - Brown
const Color(0xFF90A88E)  // Ratib - Sage Green
const Color(0xFFE8A05D)  // Khutbah - Orange
const Color(0xFF8B7355)  // Maulid - Beige
const Color(0xFF6B8E7D)  // Tahlil - Teal
const Color(0xFFB8906D)  // Notes - Tan
```

---

## Size Constants Used

```dart
AppSize.s4   // 4.0  - Small gaps
AppSize.s8   // 8.0  - Icon/text spacing
AppSize.s12  // 12.0 - Card padding, spacing
AppSize.s16  // 16.0 - Standard padding
AppSize.s20  // 20.0 - Icon sizes
AppSize.s24  // 24.0 - Large icons
AppSize.s35  // 35.0 - Full-width card icon
AppSize.s40  // 40.0 - Grid card icon
AppSize.s100 // 100.0 - Full-width card height

AppPadding.p12  // Padding small
AppPadding.p16  // Padding medium
AppPadding.p20  // Padding large

FontSize.s12  // Label text
FontSize.s14  // Body text
FontSize.s18  // Title text
```

---

## Widget Tree Reference

```
HomeDashboardScreen
│
├─ BlocBuilder<PrayerTimingsCubit>
│  │
│  └─ CustomScrollView
│     │
│     ├─ SliverToBoxAdapter
│     │  └─ _HomeHeader (30% screen)
│     │     ├─ Container (Gradient)
│     │     │  └─ SafeArea
│     │     │     └─ Padding
│     │     │        ├─ Row (Dates)
│     │     │        ├─ Spacer
│     │     │        └─ Row (Prayer Cards)
│     │     │           ├─ _PrayerTimeCard (Fajr)
│     │     │           └─ _PrayerTimeCard (Dhuhr)
│     │
│     ├─ SliverToBoxAdapter
│     │  └─ Transform.translate (offset -30)
│     │     └─ _SearchBarWidget
│     │        └─ Padding
│     │           └─ GestureDetector
│     │              └─ Container (pill-shaped)
│     │                 └─ Row
│     │                    ├─ Icon (search)
│     │                    ├─ Expanded (text)
│     │                    └─ Icon (mic)
│     │
│     └─ SliverPadding
│        └─ _MenuGrid
│           └─ SliverList
│              ├─ GridView (6 items)
│              │  └─ _MenuCard × 6
│              └─ _MenuCard (full-width)
```

---

## Testing Checklist

- [ ] Header gradient displays correctly
- [ ] Prayer times show Fajr & Dhuhr
- [ ] Dates display in correct language (EN/AR)
- [ ] Search bar overlaps header
- [ ] Search opens Quran search on tap
- [ ] Grid shows 6 items in 2 columns
- [ ] Notes card is full-width with arrow
- [ ] All menu items show SnackBar on tap
- [ ] Bottom nav has 5 items only
- [ ] Hadith not in bottom nav
- [ ] Navigation highlights correct item
- [ ] Tap nav items changes screen
- [ ] Responsive on different screen sizes

---

## Future Enhancements

1. **Add Navigation**: Connect menu items to actual screens
2. **Add Icons**: Use custom SVG icons for menu items
3. **Add Animations**: Fade-in effects for cards
4. **Add Shimmer**: Loading state for prayer times
5. **Add More Prayers**: Show all 5 prayer times in expanded view
6. **Add Weather**: Location-based weather in header
7. **Add Quick Actions**: Shortcuts in menu items
8. **Add Settings**: Customize which items to show

---

Generated on: January 26, 2026
Flutter Version: Compatible with latest stable
