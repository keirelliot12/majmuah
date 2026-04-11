# HomeMenuCard - Quick Reference

## Import
```dart
import 'package:islamic/presentation/components/home_menu_card.dart';
```

## 1-Liner Examples

### Basic Card
```dart
HomeMenuCard(title: 'Quran', icon: Icons.menu_book, iconColor: AppColors.tealGreen, onTap: () {})
```

### Using Variants
```dart
HomeMenuCardVariant.primary(title: 'Quran', icon: Icons.menu_book, onTap: () {})
HomeMenuCardVariant.secondary(title: 'Doa', icon: Icons.hand_has_water, onTap: () {})
HomeMenuCardVariant.accent(title: 'Notes', icon: Icons.note, onTap: () {})
```

## Common Use Cases

### In GridView (4-Column)
```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 4,
    childAspectRatio: 1.0,
    crossAxisSpacing: 12.w,
    mainAxisSpacing: 12.h,
  ),
  itemBuilder: (context, i) => HomeMenuCard(
    title: items[i].title,
    icon: items[i].icon,
    iconColor: items[i].color,
    onTap: () => handleTap(i),
  ),
)
```

### With Navigation
```dart
HomeMenuCard(
  title: 'Aurad Shalat',
  icon: Icons.mosque,
  iconColor: AppColors.tealGreen,
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => AuradScreen()),
  ),
)
```

### With Snackbar
```dart
HomeMenuCard(
  title: 'Settings',
  icon: Icons.settings,
  iconColor: AppColors.darkTeal,
  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Settings tapped')),
  ),
)
```

## Color Schemes

| Name | Color | Usage |
|------|-------|-------|
| `AppColors.tealGreen` | #00897B | Primary action |
| `AppColors.lemonGreen` | #B8CF70 | Secondary action |
| `AppColors.darkTeal` | #00695C | Accent/Featured |
| `AppColors.darkerTeal` | #004D40 | Text/Headers |

## Pre-Built Variants

```dart
// Teal Primary
HomeMenuCardVariant.primary(
  title: 'Home',
  icon: Icons.home,
  onTap: () {},
)

// Yellow-Green Secondary
HomeMenuCardVariant.secondary(
  title: 'Favorites',
  icon: Icons.favorite,
  onTap: () {},
)

// Dark Teal Accent
HomeMenuCardVariant.accent(
  title: 'Profile',
  icon: Icons.person,
  onTap: () {},
)

// Custom Color
HomeMenuCardVariant.withColorScheme(
  title: 'Custom',
  icon: Icons.star,
  color: Colors.purple,
  onTap: () {},
)
```

## All Properties

```dart
HomeMenuCard(
  // Required
  title: 'Menu Item',                 // String, max 2 lines
  icon: Icons.home,                   // IconData
  iconColor: AppColors.tealGreen,     // Color
  onTap: () {},                       // VoidCallback

  // Optional
  iconSize: 50.w,                     // double? (default: 50.w)
  backgroundColor: Colors.white,      // Color? (default: white)
  elevation: 2,                       // double (default: 2)
  borderRadius: 16,                   // double (default: 16)
)
```

## Design System Integration

**Component Size**: Responsive via `flutter_screenutil`
- Icon Container: 50x50 (default, customizable)
- Icon: 30sp (60% of container)
- Text: 12sp, Semi-bold
- Padding: 12 dp between icon & text
- Border Radius: 16 dp card + 12 dp icon bg
- Shadow: 2 dp elevation

**Animation**:
- Tap-down scale: 1.0 → 0.95
- Duration: 150ms
- Curve: EaseInOut

**Colors** (from AppColors):
```dart
tealGreen     = #00897B   (Primary)
lemonGreen    = #B8CF70   (Secondary)
darkTeal      = #00695C   (Accent)
darkerTeal    = #004D40   (Text)
white         = #FFFFFF   (Background)
```

## Tips & Tricks

1. **Text Too Long?** - Max 2 lines with ellipsis, keep titles short
2. **Need More Space?** - Use `maxLines: 1` by forking component
3. **Custom Animation?** - Fork component and modify `_scaleAnimation` values
4. **Dark Mode?** - Component inherits from Theme, no changes needed
5. **Accessibility?** - Already has high contrast, works with screen readers

## Common Icons

```dart
Icons.mosque              // Religious
Icons.menu_book          // Quran/Reading
Icons.front_hand         // Dua/Prayer
Icons.celebration        // Maulid/Events
Icons.note              // Notes
Icons.settings          // Settings
Icons.favorite          // Favorites
Icons.home              // Home
```

## Performance Tips

- Use `const` when possible
- Place GridView in separate widget for optimization
- Use `physics: NeverScrollableScrollPhysics()` if nested in scroll
- Limit number of cards in viewport (8-12 max for performance)

---

**File**: `lib/presentation/components/home_menu_card.dart`  
**Status**: ✅ Production Ready
