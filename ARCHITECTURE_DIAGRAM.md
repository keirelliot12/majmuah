# Material System Architecture

## Component Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────┐      ┌──────────────────┐                │
│  │ Home Dashboard   │─────▶│ Material List    │                │
│  │ Screen           │      │ Screen           │                │
│  │                  │      │                  │                │
│  │ • 7 Menu Items   │      │ • Filtered List  │                │
│  │ • Color Coded    │      │ • Loading State  │                │
│  │ • Navigation     │      │ • Empty State    │                │
│  └──────────────────┘      └────────┬─────────┘                │
│                                     │                           │
│                                     │ Tap Material              │
│                                     ▼                           │
│                            ┌──────────────────┐                 │
│                            │ Material Detail  │                 │
│                            │ Screen           │                 │
│                            │                  │                 │
│                            │ • Full Content   │                 │
│                            │ • Arabic Text    │                 │
│                            │ • Copy/Share     │                 │
│                            └──────────────────┘                 │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                               │
                               │ Uses
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                          DATA LAYER                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │         MaterialRepository (Singleton)                   │   │
│  │                                                          │   │
│  │  Methods:                                                │   │
│  │  • getCategories()                                       │   │
│  │  • getMaterials()                                        │   │
│  │  • getMaterialsByCategoryFilterKey(String)              │   │
│  │  • getMaterialById(String)                               │   │
│  │  • getCategoryByFilterKey(String)                        │   │
│  │                                                          │   │
│  │  Cache:                                                  │   │
│  │  • _categories: List<MaterialCategory>                  │   │
│  │  • _materials: List<MaterialItem>                       │   │
│  └─────────────────────────────────────────────────────────┘   │
│                               │                                  │
│                               │ Loads from                       │
│                               ▼                                  │
└─────────────────────────────────────────────────────────────────┘
                               │
                               │
┌─────────────────────────────────────────────────────────────────┐
│                         DOMAIN LAYER                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────────┐         ┌──────────────────────┐     │
│  │ MaterialCategory     │         │ MaterialItem         │     │
│  │                      │         │                      │     │
│  │ • id: int            │         │ • id: String         │     │
│  │ • title: String      │         │ • title: String      │     │
│  │ • iconAsset: String  │         │ • arabicTitle: String│     │
│  │ • route: String      │         │ • content: List<str> │     │
│  │ • filterKey: String  │         │ • category: String   │     │
│  │                      │         │ • tags: List<String> │     │
│  └──────────────────────┘         └──────────────────────┘     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                               │
                               │ Parsed from
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                         ASSETS (JSON)                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────────┐         ┌──────────────────────┐     │
│  │ category.json        │         │ Annibros.json        │     │
│  │                      │         │                      │     │
│  │ • 13 categories      │         │ • 1937 lines         │     │
│  │ • Filter keys        │         │ • Multiple materials │     │
│  │ • Icons              │         │ • Various categories │     │
│  │ • Routes             │         │ • Arabic content     │     │
│  └──────────────────────┘         └──────────────────────┘     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Data Flow Sequence

```
User Action                  System Response
────────────                 ───────────────

1. Opens App
   └─▶ Navigate to Home     ─▶ Shows 7 menu items

2. Taps "Doa & Tawasul"
   └─▶ Navigate with params ─▶ MaterialListScreen(
                                  categoryName: "Doa & Tawasul",
                                  categoryFilterKey: "Doa",
                                  categoryColor: orange
                                )

3. Screen Loads
   └─▶ Call Repository      ─▶ MaterialRepository.getMaterialsByCategoryFilterKey("Doa")
       │
       ├─▶ First time?       ─▶ Load Annibros.json → Parse → Cache
       │                        Return filtered materials
       │
       └─▶ Already cached?   ─▶ Return filtered materials (instant)

4. Materials Displayed
   └─▶ Show list            ─▶ Cards with title, Arabic title, icon

5. Taps Material Card
   └─▶ Navigate             ─▶ MaterialDetailScreen(
                                  material: selectedItem,
                                  categoryColor: orange
                                )

6. Detail Screen Loads
   └─▶ Display content      ─▶ Show title, Arabic title, full content
       │                        with gradient header and actions
       │
       ├─▶ Tap Copy         ─▶ Copy to clipboard → Show notification
       │
       ├─▶ Tap Share        ─▶ Copy to clipboard → Show notification
       │
       └─▶ Tap FAB          ─▶ Show bottom sheet with actions

7. Back Navigation
   └─▶ Back button         ─▶ Return to Material List
       └─▶ Back again      ─▶ Return to Home Dashboard
```

## Category Color Mapping

```
Home Dashboard Menu Items
─────────────────────────

┌─────────────────┐
│ Aurad Shalat    │ ─▶ Dark Green   (0xFF5A8C6B)
└─────────────────┘    │
                       ├─▶ filterKey: "Panduan Ibadah"
                       └─▶ category: "Panduan Ibadah"

┌─────────────────┐
│ Doa & Tawasul   │ ─▶ Orange       (0xFFD4945F)
└─────────────────┘    │
                       ├─▶ filterKey: "Doa"
                       └─▶ category: "Doa"

┌─────────────────┐
│ Ratib           │ ─▶ Sage Green   (0xFF90A88E)
└─────────────────┘    │
                       ├─▶ filterKey: "Ratib"
                       └─▶ category: "Ratib"

┌─────────────────┐
│ Khutbah         │ ─▶ Light Orange (0xFFE8A05D)
└─────────────────┘    │
                       ├─▶ filterKey: "Umum"
                       └─▶ category: "Umum"

┌─────────────────┐
│ Maulid          │ ─▶ Brown        (0xFF8B7355)
└─────────────────┘    │
                       ├─▶ filterKey: "Qasidah"
                       └─▶ category: "Qasidah"

┌─────────────────┐
│ Tahlil & Ziarah │ ─▶ Teal         (0xFF6B8E7D)
└─────────────────┘    │
                       ├─▶ filterKey: "Tahlil & Jenazah"
                       └─▶ category: "Tahlil & Jenazah"

┌─────────────────┐
│ Notes           │ ─▶ Tan          (0xFFB8906D)
└─────────────────┘    │
                       ├─▶ filterKey: "Amalan Khusus"
                       └─▶ category: "Amalan Khusus"
```

## File Dependencies

```
home_dashboard_screen.dart
  │
  ├─▶ material_list_screen.dart
  │     │
  │     ├─▶ material_detail_screen.dart
  │     │     │
  │     │     └─▶ material_item.dart (domain model)
  │     │
  │     └─▶ material_repository.dart
  │           │
  │           ├─▶ material_category.dart (domain model)
  │           ├─▶ material_item.dart (domain model)
  │           │
  │           ├─▶ category.json (assets)
  │           └─▶ Annibros.json (assets)
  │
  └─▶ resources.dart (colors, sizes, fonts)
```

## State Management

```
MaterialListScreen
  │
  ├─▶ State: _MaterialListScreenState
  │     │
  │     ├─▶ _materials: List<MaterialItem>
  │     ├─▶ _isLoading: bool
  │     │
  │     └─▶ initState()
  │           │
  │           └─▶ _loadMaterials()
  │                 │
  │                 ├─▶ setState(() { _isLoading = true })
  │                 │
  │                 ├─▶ await repository.getMaterialsByCategoryFilterKey()
  │                 │
  │                 └─▶ setState(() {
  │                       _materials = results
  │                       _isLoading = false
  │                     })
  │
  └─▶ build()
        │
        ├─▶ if _isLoading
        │     └─▶ CircularProgressIndicator
        │
        ├─▶ if _materials.isEmpty
        │     └─▶ _buildEmptyState()
        │
        └─▶ else
              └─▶ _buildMaterialsList()
```

## Error Handling

```
MaterialRepository
  │
  └─▶ getMaterials()
        │
        └─▶ try {
              final jsonString = await rootBundle.loadString('assets/json/Annibros.json')
              final jsonData = json.decode(jsonString)
              return materials
            }
            catch (e) {
              print('Error: $e')    ─▶ Log to console
              return []             ─▶ Return empty list
            }
                │
                └─▶ MaterialListScreen checks if empty
                      └─▶ Shows empty state UI
```

## Memory Management

```
MaterialRepository (Singleton)
  │
  ├─▶ _categories: List<MaterialCategory>? = null
  │     │
  │     └─▶ First call: Load from JSON → Cache in memory
  │     └─▶ Next calls: Return cached data (instant)
  │
  └─▶ _materials: List<MaterialItem>? = null
        │
        └─▶ First call: Load from JSON → Cache in memory (~224KB)
        └─▶ Next calls: Return cached data (instant)

Benefits:
  • Fast subsequent loads
  • No repeated JSON parsing
  • Single source of truth
  • Memory efficient (load once)
```

## Screen Lifecycle

```
Home Dashboard Screen (Always mounted)
  │
  └─▶ User taps menu item
        │
        └─▶ Navigator.push(MaterialListScreen) ─┐
              │                                   │
              │ ┌─────────────────────────────────┘
              │ │
              ▼ ▼
         MaterialListScreen (New route)
              │
              ├─▶ initState() → Load materials
              │
              ├─▶ build() → Display list
              │
              └─▶ User taps material
                    │
                    └─▶ Navigator.push(MaterialDetailScreen) ─┐
                          │                                     │
                          │ ┌───────────────────────────────────┘
                          │ │
                          ▼ ▼
                     MaterialDetailScreen (New route)
                          │
                          ├─▶ build() → Display content
                          │
                          └─▶ User taps back
                                │
                                └─▶ Navigator.pop() ─▶ Back to MaterialListScreen
                                      │
                                      └─▶ User taps back
                                            │
                                            └─▶ Navigator.pop() ─▶ Back to Home Dashboard
```

This architecture ensures:
- ✅ Clean separation of concerns
- ✅ Efficient data caching
- ✅ Smooth navigation
- ✅ Proper memory management
- ✅ Easy maintenance and extension
