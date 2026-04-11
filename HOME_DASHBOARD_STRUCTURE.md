# Home Dashboard Screen - Final Structure

## File: home_dashboard_screen.dart

### Complete Widget Hierarchy

```
home_dashboard_screen.dart
│
├─ HomeDashboardScreen (Main Widget)
│  └─ BlocBuilder<PrayerTimingsCubit>
│     └─ CustomScrollView
│        ├─ SliverToBoxAdapter(_HomeHeader)
│        ├─ SliverToBoxAdapter(Transform.translate(_SearchBarWidget))
│        └─ SliverPadding(_MenuGrid)
│
├─ _HomeHeader (Header Component)
│  └─ Container (Gradient)
│     └─ SafeArea
│        └─ Padding
│           ├─ _buildLoadingContent() OR
│           └─ _buildPrayerContent()
│              ├─ Row (Dates)
│              ├─ Spacer
│              ├─ Row (Prayer Cards)
│              │  ├─ _PrayerTimeCard (Fajr)
│              │  └─ _PrayerTimeCard (Dhuhr)
│              └─ SizedBox
│
├─ _PrayerTimeCard (Prayer Card Component)
│  └─ Container
│     └─ Column
│        ├─ Icon
│        ├─ Text (Name)
│        └─ Text (Time)
│
├─ _SearchBarWidget (Search Component)
│  └─ Padding
│     └─ GestureDetector
│        └─ Container (Pill-shaped)
│           └─ Row
│              ├─ Icon (Search)
│              ├─ Expanded (Text)
│              └─ Icon (Mic)
│
├─ _MenuGrid (Grid Component)
│  └─ SliverList
│     └─ SliverChildBuilderDelegate
│        ├─ [0] GridView (6 items)
│        │  └─ _MenuCard × 6
│        └─ [1] _MenuCard (Full-width)
│
└─ _MenuCard (Card Component)
   └─ GestureDetector
      └─ Container
         ├─ _buildGridContent() OR
         └─ _buildFullWidthContent()
```

---

## Class Definitions

### 1. HomeDashboardScreen
```dart
class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimingsCubit, PrayerTimingsState>(...);
  }
}
```
**Purpose**: Main entry point, contains CustomScrollView with sliver widgets

---

### 2. _HomeHeader
```dart
class _HomeHeader extends StatelessWidget {
  final PrayerTimingsModel prayerTimingsModel;
  final bool isEnglish;

  const _HomeHeader({
    required this.prayerTimingsModel,
    required this.isEnglish,
  });
  
  @override
  Widget build(BuildContext context) {...}
  
  Widget _buildLoadingContent(BuildContext context) {...}
  Widget _buildPrayerContent(BuildContext context) {...}
}
```
**Purpose**: Header with gradient background, dates, and prayer times

**Features**:
- Responsive height (30% screen)
- Gradient background
- Conditional loading state
- Prayer time display

---

### 3. _PrayerTimeCard
```dart
class _PrayerTimeCard extends StatelessWidget {
  final String name;
  final String time;
  final IconData icon;

  const _PrayerTimeCard({
    required this.name,
    required this.time,
    required this.icon,
  });
  
  @override
  Widget build(BuildContext context) {...}
}
```
**Purpose**: Individual prayer time card with icon, name, and time

**Features**:
- Circular icon
- Prayer name
- Formatted time
- White background with opacity

---

### 4. _SearchBarWidget
```dart
class _SearchBarWidget extends StatelessWidget {
  const _SearchBarWidget();
  
  @override
  Widget build(BuildContext context) {...}
}
```
**Purpose**: Search bar that opens Quran search

**Features**:
- Pill-shaped design
- Overlapping with header (-30px)
- Search and mic icons
- GestureDetector for tap

---

### 5. _MenuGrid
```dart
class _MenuGrid extends StatelessWidget {
  const _MenuGrid();
  
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [...];
    return SliverList(...);
  }
  
  void _handleMenuTap(BuildContext context, int index) {...}
}
```
**Purpose**: Grid layout for 7 menu items

**Features**:
- Smart layout (6 grid + 1 full-width)
- Menu data definition
- Tap handling

**Menu Items**:
1. Aurad Shalat (Green)
2. Doa & Tawasul (Brown)
3. Ratib (Sage Green)
4. Khutbah (Orange)
5. Maulid (Beige)
6. Tahlil & Ziarah (Teal)
7. Notes (Tan) - Full width

---

### 6. _MenuCard
```dart
class _MenuCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final bool isFullWidth;
  final VoidCallback onTap;

  const _MenuCard({
    required this.name,
    required this.icon,
    required this.color,
    this.isFullWidth = false,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {...}
  
  Widget _buildGridContent(BuildContext context) {...}
  Widget _buildFullWidthContent(BuildContext context) {...}
}
```
**Purpose**: Individual menu card with dual layout

**Features**:
- Two layouts: Grid and Full-width
- Circular icon container
- Custom colors per item
- Tap handling

---

## Data Flow

### Prayer Times Data Flow
```
PrayerTimingsCubit
    ↓
HomeDashboardScreen (BlocBuilder)
    ↓
_HomeHeader (receives prayerTimingsModel)
    ↓
_buildPrayerContent()
    ↓
_PrayerTimeCard × 2 (Fajr, Dhuhr)
```

### Menu Tap Flow
```
User taps menu card
    ↓
_MenuCard.onTap()
    ↓
_MenuGrid._handleMenuTap()
    ↓
ScaffoldMessenger (Shows SnackBar)
```

---

## Styling Constants

### Colors
```dart
// Header Gradient
Color(0xFFE8D76E)  // Yellow
Color(0xFFC8CF7E)  // Yellow-Green
Color(0xFF90A88E)  // Sage Green

// Menu Colors
Color(0xFF5A8C6B)  // Aurad - Dark Green
Color(0xFFD4945F)  // Doa - Brown
Color(0xFF90A88E)  // Ratib - Sage
Color(0xFFE8A05D)  // Khutbah - Orange
Color(0xFF8B7355)  // Maulid - Beige
Color(0xFF6B8E7D)  // Tahlil - Teal
Color(0xFFB8906D)  // Notes - Tan
```

### Dimensions
```dart
// Header
screenHeight * 0.30  // Height

// Search Bar
BorderRadius.circular(30)  // Pill shape
Offset(0, -30)             // Overlap

// Menu Grid
crossAxisCount: 2
childAspectRatio: 1.0
crossAxisSpacing: 16
mainAxisSpacing: 16

// Menu Card
BorderRadius.circular(16)
height: 100 (full-width only)
```

---

## Key Features

### 1. CustomScrollView
Menggunakan Sliver widgets untuk smooth scrolling:
- `SliverToBoxAdapter` untuk header dan search
- `SliverPadding` untuk grid
- `SliverList` untuk menu items

### 2. Transform.translate
Search bar menggunakan negative offset untuk overlapping effect:
```dart
Transform.translate(
  offset: const Offset(0, -30),
  child: const _SearchBarWidget(),
)
```

### 3. Conditional Rendering
Header shows loading atau content based on data:
```dart
prayerTimingsModel.code != 200
    ? _buildLoadingContent(context)
    : _buildPrayerContent(context)
```

### 4. Smart Grid Layout
6 items dalam grid, 1 item full-width:
```dart
SliverChildBuilderDelegate(
  (context, index) {
    if (index == 0) return GridView(...);  // 6 items
    if (index == 1) return FullWidthCard(); // 1 item
  },
  childCount: 2,
)
```

### 5. Type Safety
Explicit casting untuk menu data:
```dart
name: menuItems[index]['name'] as String,
icon: menuItems[index]['icon'] as IconData,
color: menuItems[index]['color'] as Color,
```

---

## Performance Optimizations

### 1. Const Constructors
```dart
const _SearchBarWidget();
const _MenuGrid();
const _PrayerTimeCard({...});
```

### 2. withAlpha() vs withOpacity()
```dart
// Better performance
Colors.white.withAlpha(204)
Colors.black.withAlpha(38)

// Instead of
Colors.white.withOpacity(0.8)
Colors.black.withOpacity(0.15)
```

### 3. Const Widgets
```dart
const Offset(0, -30)
const Offset(0, 4)
const Duration(seconds: 1)
const NeverScrollableScrollPhysics()
```

### 4. Widget Separation
Setiap component adalah class terpisah untuk:
- Efficient rebuilds
- Better code organization
- Reusability

---

## Testing Guide

### Unit Tests
```dart
// Test prayer card rendering
testWidgets('Prayer card shows name and time', (tester) async {
  await tester.pumpWidget(_PrayerTimeCard(
    name: 'FAJR',
    time: '05:30 AM',
    icon: Icons.nightlight_round,
  ));
  expect(find.text('FAJR'), findsOneWidget);
  expect(find.text('05:30 AM'), findsOneWidget);
});
```

### Widget Tests
```dart
// Test menu grid layout
testWidgets('Menu grid shows 7 items', (tester) async {
  await tester.pumpWidget(_MenuGrid());
  expect(find.byType(_MenuCard), findsNWidgets(7));
});
```

### Integration Tests
```dart
// Test search functionality
testWidgets('Search bar opens search delegate', (tester) async {
  await tester.pumpWidget(HomeDashboardScreen());
  await tester.tap(find.byType(_SearchBarWidget));
  await tester.pumpAndSettle();
  expect(find.byType(CustomSearch), findsOneWidget);
});
```

---

## Future Enhancements

### Potential Improvements
1. **Add Navigation**: Connect menu items to screens
2. **Add Icons**: Use custom SVG icons
3. **Add Animations**: Fade-in for cards
4. **Add State**: Remember last tapped item
5. **Add Favorites**: Star favorite menu items
6. **Add Search**: Search within menu items
7. **Add Settings**: Customize menu order
8. **Add Analytics**: Track menu usage

---

## Troubleshooting

### Common Issues

**Issue**: Gradient not showing  
**Fix**: Check Container height is `screenHeight * 0.30`

**Issue**: Search bar not overlapping  
**Fix**: Verify `Transform.translate` offset is `Offset(0, -30)`

**Issue**: Menu items not showing  
**Fix**: Check `childCount: 2` in SliverChildBuilderDelegate

**Issue**: Cards not tappable  
**Fix**: Ensure GestureDetector wraps the card

---

Generated: January 26, 2026  
Version: 2.0 (Complete Refactor)
