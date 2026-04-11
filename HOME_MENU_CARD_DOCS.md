# HomeMenuCard Component Documentation

## Overview
`HomeMenuCard` is a reusable Flutter widget that creates a clean, modern menu card for the An-Nibros home dashboard. It features a white card with a centered icon and title text, designed to match the Material 3 design system.

## Features
✅ **Material 3 Compliant**: Uses modern Material Design principles  
✅ **Tap Animation**: Includes scale animation on tap for better UX  
✅ **Flexible Styling**: Customizable colors, sizes, and shadows  
✅ **Responsive**: Works across different screen sizes using `flutter_screenutil`  
✅ **Variants**: Pre-configured color schemes for quick implementation  
✅ **Accessibility**: Proper contrast and readable text

## Location
```
lib/presentation/components/home_menu_card.dart
```

## Basic Usage

### Simple Card
```dart
HomeMenuCard(
  title: 'Aurad Shalat',
  icon: Icons.mosque,
  iconColor: AppColors.tealGreen,
  onTap: () {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => AuradShalatScreen(),
    ));
  },
)
```

### Using Color Variants
```dart
// Teal variant
HomeMenuCardVariant.primary(
  title: 'Quran',
  icon: Icons.menu_book,
  onTap: () => navigateToQuran(),
)

// Yellow-green variant
HomeMenuCardVariant.secondary(
  title: 'Doa & Tawasul',
  icon: Icons.hand_has_water,
  onTap: () => navigateToDoaList(),
)

// Dark teal accent
HomeMenuCardVariant.accent(
  title: 'Notes',
  icon: Icons.note,
  onTap: () => navigateToNotes(),
)
```

## Constructor Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `title` | String | ✅ | - | Menu item title (max 2 lines) |
| `icon` | IconData | ✅ | - | Material icon for the card |
| `iconColor` | Color | ✅ | - | Color of the icon |
| `onTap` | VoidCallback | ✅ | - | Callback when card is tapped |
| `iconSize` | double? | ❌ | `50.w` | Custom icon size |
| `backgroundColor` | Color? | ❌ | `AppColors.white` | Card background color |
| `elevation` | double | ❌ | `2` | Shadow elevation |
| `borderRadius` | double | ❌ | `16` | Corner radius |

## Styling Properties

### Default Style
- **Background**: Pure white (`AppColors.white`)
- **Icon Container**: 50x50 dp with light tinted background (10% opacity)
- **Border Radius**: 16 dp on card and icon container
- **Elevation**: 2 dp shadow
- **Text**: 12sp, Semi-bold, Dark Teal color
- **Spacing**: 12 dp gap between icon and text

### Color Palette Integration
All cards use colors from `AppColors`:
```dart
class AppColors {
  static const Color tealGreen = Color(0xFF00897B);      // Primary
  static const Color lemonGreen = Color(0xFFB8CF70);     // Secondary
  static const Color darkTeal = Color(0xFF00695C);       // Accent
  static const Color darkerTeal = Color(0xFF004D40);     // Text
  static const Color white = Color(0xFFFFFFFF);          // Background
}
```

## Animation
The component includes a **tap-down scale animation**:
- Scale: 1.0 → 0.95 (5% reduction)
- Duration: 150ms
- Curve: EaseInOut
- Provides haptic feedback on interaction

## GridView Integration Example

### For 4-Column Grid (as in design)
```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 4,
    crossAxisSpacing: AppSize.s12.w,
    mainAxisSpacing: AppSize.s12.h,
    childAspectRatio: 1.0,
  ),
  itemCount: menuItems.length,
  itemBuilder: (context, index) {
    final item = menuItems[index];
    return HomeMenuCard(
      title: item.title,
      icon: item.icon,
      iconColor: item.color,
      onTap: () => handleMenuTap(item),
    );
  },
)
```

### For 2-Column Grid
```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: AppSize.s16.w,
    mainAxisSpacing: AppSize.s16.h,
    childAspectRatio: 1.0,
  ),
  itemCount: menuItems.length,
  itemBuilder: (context, index) {
    final item = menuItems[index];
    return HomeMenuCard(
      title: item.title,
      icon: item.icon,
      iconColor: item.color,
      onTap: () => handleMenuTap(item),
    );
  },
)
```

## Complete Home Menu Example

```dart
class HomeMenuGrid extends StatelessWidget {
  const HomeMenuGrid({Key? key}) : super(key: key);

  final List<MenuItemData> menuItems = const [
    MenuItemData(
      title: 'Aurad Shalat',
      icon: Icons.mosque,
      color: Color(0xFF2F9E84),
    ),
    MenuItemData(
      title: 'Doa & Tawasul',
      icon: Icons.front_hand,
      color: Color(0xFFD4945F),
    ),
    MenuItemData(
      title: 'Ratib',
      icon: Icons.menu_book,
      color: Color(0xFF90A88E),
    ),
    MenuItemData(
      title: 'Khutbah',
      icon: Icons.record_voice_over,
      color: Color(0xFFE8A05D),
    ),
    MenuItemData(
      title: 'Maulid',
      icon: Icons.celebration,
      color: Color(0xFF8B7355),
    ),
    MenuItemData(
      title: 'Tahlil',
      icon: Icons.mosque,
      color: Color(0xFF6B8E7D),
    ),
    MenuItemData(
      title: 'Notes',
      icon: Icons.note,
      color: Color(0xFFB8906D),
    ),
    MenuItemData(
      title: 'Lainnya',
      icon: Icons.more,
      color: Color(0xFF9E9E9E),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: AppSize.s12.w,
        mainAxisSpacing: AppSize.s12.h,
        childAspectRatio: 0.9,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return HomeMenuCard(
          title: item.title,
          icon: item.icon,
          iconColor: item.color,
          onTap: () => _handleMenuTap(context, index),
        );
      },
    );
  }

  void _handleMenuTap(BuildContext context, int index) {
    // Handle navigation or actions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tapped: ${menuItems[index].title}')),
    );
  }
}

class MenuItemData {
  final String title;
  final IconData icon;
  final Color color;

  const MenuItemData({
    required this.title,
    required this.icon,
    required this.color,
  });
}
```

## Customization Examples

### Larger Icon
```dart
HomeMenuCard(
  title: 'Custom Size',
  icon: Icons.star,
  iconColor: AppColors.tealGreen,
  iconSize: 80.w,
  onTap: () {},
)
```

### Custom Colors
```dart
HomeMenuCard(
  title: 'Custom Theme',
  icon: Icons.palette,
  iconColor: Colors.purple,
  backgroundColor: Colors.purple.withAlpha(26),
  onTap: () {},
)
```

### Different Border Radius
```dart
HomeMenuCard(
  title: 'Rounded',
  icon: Icons.rounded_corner,
  iconColor: AppColors.darkTeal,
  borderRadius: 24,
  onTap: () {},
)
```

### No Shadow
```dart
HomeMenuCard(
  title: 'Flat',
  icon: Icons.layers,
  iconColor: AppColors.lemonGreen,
  elevation: 0,
  onTap: () {},
)
```

## Accessibility Features
- ✅ High contrast text (Dark Teal on White)
- ✅ Readable icon sizes (30sp)
- ✅ Clear tap target (50x50 minimum)
- ✅ Semantic Material widget hierarchy
- ✅ Proper text truncation with ellipsis

## Performance Considerations
- Uses `StatefulWidget` for animation efficiency
- Single `AnimationController` for smooth tap feedback
- Properly disposes resources in `dispose()`
- Minimal rebuilds with `ScaleTransition`

## Integration Checklist
- [x] Component created and tested
- [x] No compilation errors
- [x] AppColors properly imported
- [x] Animation working smoothly
- [x] Responsive sizing with flutter_screenutil
- [x] All color variants available
- [x] Documentation complete

## Version History
| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | Jan 29, 2026 | Initial release with tap animation and color variants |

## Files Required
```
lib/
├── app/resources/
│   ├── resources.dart (AppColors, AppSize, AppPadding)
│   └── font_manager.dart (FontWeightsManager, FontSize)
└── presentation/components/
    └── home_menu_card.dart ← This component
```

## Related Components
- `AppColors` - Color palette (theme.dart)
- `FontSize` & `FontWeightsManager` - Typography
- `HomeMenuCardVariant` - Pre-styled variants
- `GridView` - Layout for multiple cards

---

**Status**: ✅ Production Ready  
**Last Updated**: January 29, 2026
