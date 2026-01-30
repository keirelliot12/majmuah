# Quick Reference: Material System

## File Structure
```
lib/
├── domain/models/material/
│   ├── material_category.dart    # Category model
│   └── material_item.dart        # Material model
├── data/repository/
│   └── material_repository.dart  # Data loading & caching
└── presentation/material/
    ├── material_list_screen.dart   # List of materials by category
    └── material_detail_screen.dart # Full material content

assets/json/
├── category.json    # Categories definition
└── Annibros.json    # Material content
```

## Key Classes

### MaterialCategory
```dart
MaterialCategory(
  id: 1,
  title: "Al-Quran",
  iconAsset: "assets/icons/al_quran.png",
  route: "/category",
  filterKey: "Al-Quran"
)
```

### MaterialItem
```dart
MaterialItem(
  id: "muqaddimah",
  title: "Muqaddimah",
  arabicTitle: "مقدمة",
  content: ["Paragraph 1", "Paragraph 2"],
  category: "Umum",
  tags: []
)
```

## Category Mappings (Home Dashboard → JSON)

| Menu Item        | Filter Key           | Category in JSON      |
|------------------|----------------------|-----------------------|
| Aurad Shalat     | Panduan Ibadah       | Panduan Ibadah        |
| Doa & Tawasul    | Doa                  | Doa                   |
| Ratib            | Ratib                | Ratib                 |
| Khutbah          | Umum                 | Umum                  |
| Maulid           | Qasidah              | Qasidah               |
| Tahlil & Ziarah  | Tahlil & Jenazah     | Tahlil & Jenazah      |
| Notes            | Amalan Khusus        | Amalan Khusus         |

## Usage Example

### Navigate to Material List
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => MaterialListScreen(
      categoryName: 'Doa & Tawasul',
      categoryFilterKey: 'Doa',
      categoryColor: Color(0xFFD4945F),
    ),
  ),
);
```

### Navigate to Material Detail
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => MaterialDetailScreen(
      material: materialItem,
      categoryColor: Color(0xFFD4945F),
    ),
  ),
);
```

### Load Materials Programmatically
```dart
final repository = MaterialRepository();

// Get all categories
final categories = await repository.getCategories();

// Get all materials
final materials = await repository.getMaterials();

// Filter by category
final doaMaterials = await repository.getMaterialsByCategoryFilterKey('Doa');

// Get specific material
final material = await repository.getMaterialById('muqaddimah');
```

## Color Scheme

Each category has a distinct color:
- **Aurad Shalat**: `Color(0xFF5A8C6B)` - Dark Green
- **Doa & Tawasul**: `Color(0xFFD4945F)` - Orange
- **Ratib**: `Color(0xFF90A88E)` - Sage Green
- **Khutbah**: `Color(0xFFE8A05D)` - Light Orange
- **Maulid**: `Color(0xFF8B7355)` - Brown
- **Tahlil & Ziarah**: `Color(0xFF6B8E7D)` - Teal
- **Notes**: `Color(0xFFB8906D)` - Tan

## Common Tasks

### Add a New Category to Home Dashboard
1. Add new menu item in `home_dashboard_screen.dart`:
```dart
{
  'name': 'New Category',
  'filterKey': 'CategoryName', // Must match category in JSON
  'color': const Color(0xFFXXXXXX),
}
```

2. Ensure materials exist in `Annibros.json` with matching category

### Add New Material
1. Add to `assets/json/Annibros.json`:
```json
{
  "id": "unique_id",
  "title": "Material Title",
  "arabic_title": "العنوان بالعربية",
  "category": "CategoryName",
  "tags": ["tag1", "tag2"],
  "content": [
    "Paragraph 1",
    "Paragraph 2"
  ]
}
```

2. Material will automatically appear in correct category

### Modify Material Display
Edit `material_list_screen.dart` → `_MaterialCard` widget
Edit `material_detail_screen.dart` → `build()` method

## API Reference

### MaterialRepository

| Method | Description | Returns |
|--------|-------------|---------|
| `getCategories()` | Load all categories | `Future<List<MaterialCategory>>` |
| `getMaterials()` | Load all materials | `Future<List<MaterialItem>>` |
| `getMaterialsByCategoryFilterKey(String)` | Filter by category | `Future<List<MaterialItem>>` |
| `getMaterialById(String)` | Get specific material | `Future<MaterialItem?>` |
| `getCategoryByFilterKey(String)` | Get category by key | `MaterialCategory?` |

### MaterialItem Properties

| Property | Type | Description |
|----------|------|-------------|
| `id` | `String` | Unique identifier |
| `title` | `String` | English title |
| `arabicTitle` | `String?` | Arabic title (optional) |
| `content` | `List<String>` | Content paragraphs |
| `category` | `String` | Category name |
| `tags` | `List<String>` | Tags for filtering |
| `contentText` | `String` (getter) | Joined content as single string |

## Troubleshooting

**Issue**: Materials not loading
- Check JSON file paths in repository
- Verify JSON syntax is valid
- Check pubspec.yaml includes assets/json/

**Issue**: Empty material list
- Verify category name matches exactly (case-insensitive)
- Check that materials exist in Annibros.json with that category

**Issue**: Arabic text not displaying
- Ensure proper font support
- TextDirection.rtl is already set for Arabic content

**Issue**: App crashes on material tap
- Check MaterialItem model matches JSON structure
- Verify all required fields are present in JSON

## Performance Tips

1. Repository caches data after first load
2. Use singleton pattern - don't create multiple instances
3. JSON files loaded once, kept in memory
4. Consider pagination for very large material lists (future)

## Future Enhancements

Planned features:
- [ ] Search within materials
- [ ] Bookmark/Favorites with local storage
- [ ] Material reading history
- [ ] Share via share_plus package
- [ ] Text size adjustment
- [ ] Night mode optimizations
- [ ] Audio recitation (for Arabic content)
- [ ] Material tags/filtering
- [ ] Related materials suggestions
