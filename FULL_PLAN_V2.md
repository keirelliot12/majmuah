# 📋 FULL PLAN V2: Aplikasi An-Nibros - Beranda Feature Integration

**Last Updated**: January 30, 2026  
**Version**: 2.0  
**Status**: ✅ PHASE 1-4 COMPLETE | 🔄 PHASE 5 IN PROGRESS

---

## 📊 EXECUTIVE SUMMARY

Redesain tampilan beranda aplikasi An-Nibros dengan **Full Glassmorphism**, integrasi tombol-tombol menu dengan data dari `category.json` dan `Annibros.json`, pembuatan halaman Notes dengan penyimpanan lokal, dan halaman "Lainnya" yang menampilkan semua kategori.

---

## ✅ COMPLETION STATUS

### Sprint 1: Data Layer ✅ COMPLETE
| Task | Description | Status |
|------|-------------|--------|
| 1.1 | CategoryModel | ✅ Done |
| 1.2 | MaterialModel | ✅ Done |
| 1.3 | NoteModel | ✅ Done |
| 1.4 | CategoryDataSource | ✅ Done |
| 1.5 | MaterialDataSource | ✅ Done |
| 1.6 | NotesLocalDataSource | ✅ Done |
| 1.7 | CategoryRepository | ✅ Done |
| 1.8 | MaterialContentRepository | ✅ Done |
| 1.9 | NotesRepository | ✅ Done |
| 1.10 | DI Module Setup | ✅ Done |

### Sprint 2: Presentation Layer ✅ COMPLETE
| Task | Description | Status |
|------|-------------|--------|
| 2.1 | HomeHeader Widget | ✅ Done |
| 2.2 | PrayerCountdownCard Widget | ✅ Done |
| 2.3 | SearchBarWidget (Glassmorphism) | ✅ Done |
| 2.4 | LastReadCard Widget (Glassmorphism) | ✅ Done |
| 2.5 | MenuGridWidget (Glassmorphism) | ✅ Done |
| 2.6 | WisdomQuoteCard Widget | ✅ Done |
| 2.7 | CustomBottomNavBar | ✅ Done |
| 2.8 | AllCategoriesScreen | ✅ Done |
| 2.9 | MaterialListScreen | ✅ Done |
| 2.10 | MaterialDetailScreen | ✅ Done |
| 2.11 | NotesListScreen | ✅ Done |
| 2.12 | NoteDetailScreen | ✅ Done |
| 2.13 | SearchResultScreen | ✅ Done |

### Sprint 3: Navigation & Routes ✅ COMPLETE
| Task | Description | Status |
|------|-------------|--------|
| 3.1 | Routes Manager Update | ✅ Done |
| 3.2 | Menu Grid Navigation | ✅ Done |
| 3.3 | Category-based Filtering | ✅ Done |
| 3.4 | Search Integration | ✅ Done |

### Sprint 4: State Management ✅ COMPLETE
| Task | Description | Status |
|------|-------------|--------|
| 4.1 | BerandaCategoryCubit | ✅ Done |
| 4.2 | BerandaMaterialCubit | ✅ Done |
| 4.3 | BerandaNotesCubit | ✅ Done |
| 4.4 | Cubit Integration with Screens | ✅ Done |
| 4.5 | Last Read Feature | ✅ Done |

### Sprint 5: Polish & Testing 🔄 IN PROGRESS
| Task | Description | Status |
|------|-------------|--------|
| 5.1 | Glassmorphism Refinements | ✅ Done |
| 5.2 | Responsive Fixes | ✅ Done |
| 5.3 | Error Handling | ✅ Done |
| 5.4 | Build Verification | 🔄 Pending (OOM issue) |
| 5.5 | Final Testing | 🔄 Pending |

---

## 🏗️ ARCHITECTURE OVERVIEW

### File Structure
```
lib/
├── app/
│   ├── resources/
│   │   ├── colors_manager.dart      # AppColors with gradient colors
│   │   ├── glassmorphism_manager.dart # Glassmorphism utilities
│   │   └── routes_manager.dart       # Updated routes
│   └── utils/
│       └── material_search_delegate.dart # Search functionality
│
├── data/
│   ├── data_source/
│   │   ├── local/
│   │   │   └── notes_local_data_source.dart
│   │   └── remote/
│   │       ├── category_data_source.dart
│   │       └── material_data_source.dart
│   └── repository/
│       ├── category_repository.dart
│       ├── material_content_repository.dart
│       └── notes_repository.dart
│
├── domain/models/
│   ├── category/category_model.dart
│   ├── material/material_model.dart
│   └── note/note_model.dart
│
├── presentation/
│   ├── home/
│   │   ├── cubit/
│   │   │   ├── beranda_category_cubit.dart
│   │   │   ├── beranda_material_cubit.dart
│   │   │   └── beranda_notes_cubit.dart
│   │   ├── screens/
│   │   │   └── all_categories/all_categories_screen.dart
│   │   ├── view/home_view.dart
│   │   └── widgets/
│   │       ├── home_header.dart
│   │       ├── prayer_countdown_card.dart
│   │       ├── search_bar_widget.dart
│   │       ├── last_read_card.dart
│   │       ├── menu_grid_widget.dart
│   │       ├── wisdom_quote_card.dart
│   │       └── custom_bottom_nav_bar.dart
│   ├── material/
│   │   ├── material_list_screen.dart
│   │   └── material_detail_screen.dart
│   ├── notes/
│   │   ├── notes_list_screen.dart
│   │   └── note_detail_screen.dart
│   └── search/
│       └── search_result_screen.dart
│
└── di/di.dart  # Dependency Injection
```

---

## 🎨 UI/UX SPECIFICATIONS

### Glassmorphism Design System
- **Background**: Gradient from `lemonYellow` to `islamicTeal`
- **Cards**: `BackdropFilter` with `blur(10, 10)` + `white.withAlpha(102)`
- **Border**: `white.withAlpha(51)` with width 1
- **Border Radius**: 16-24r depending on component
- **Shadows**: Minimal, using subtle black alpha

### Color Palette
| Color | Hex | Usage |
|-------|-----|-------|
| lemonYellow | #E8F5A3 | Gradient top |
| islamicTeal | #26A69A | Gradient bottom |
| emerald500 | #10B981 | Aurad Sholat |
| amber500 | #F59E0B | Doa & Tawassul |
| indigo500 | #6366F1 | Ratib |
| rose500 | #F43F5E | Khutbah |
| orange500 | #F97316 | Maulid |
| teal600 | #0D9488 | Tahlil & Ziarah |
| cyan600 | #0891B2 | Notes |
| gray500 | #6B7280 | Lainnya |

### Component Specifications
1. **HomeHeader**: Location + Hijri date + Notification bell
2. **PrayerCountdownCard**: Next prayer time + countdown timer
3. **SearchBar**: Pill-shaped, 50r radius, glassmorphism
4. **LastReadCard**: Book icon + last read title + chevron
5. **MenuGrid**: 4x2 grid, glassmorphism cards, Material Symbols icons
6. **WisdomQuoteCard**: Quote icon + "MUTIARA HIKMAH" + italic text
7. **CustomBottomNavBar**: 5 items, sage green accent

---

## 🔗 NAVIGATION ROUTES

| Route | Screen | Arguments |
|-------|--------|-----------|
| `/home` | HomeView | - |
| `/beranda/categories` | AllCategoriesScreen | - |
| `/beranda/materialList` | MaterialListScreen | categoryName, categoryFilterKey, categoryColor |
| `/beranda/materialDetail` | MaterialDetailScreen | material, categoryColor |
| `/beranda/notes` | NotesListScreen | - |
| `/beranda/noteDetail` | NoteDetailScreen | note (optional) |
| `/beranda/search` | SearchResultScreen | query |

---

## 📝 MENU MAPPING

| Menu | Category ID | Filter Key | Icon |
|------|-------------|------------|------|
| Aurad Sholat | 2 | "Aurad Sholat" | mosque |
| Doa & Tawassul | 3 | "Doa & Tawassul" | front_hand |
| Ratib | 5 | "Ratib" | auto_stories |
| Khutbah | - | "Khutbah" | record_voice_over |
| Maulid | 7 | "Maulid" | auto_awesome |
| Tahlil & Ziarah | 9 | "Tahlil & Ziarah" | history_edu |
| Notes | 13 | Local Storage | edit_note |
| Lainnya | - | All Categories | grid_view |

---

## ✅ ACCEPTANCE CRITERIA

- [x] Semua 8 menu grid item berfungsi
- [x] Navigasi ke MaterialListView berdasarkan kategori
- [x] MaterialDetailView menampilkan konten Arab dengan benar
- [x] Notes dapat ditambah, diedit, dan dihapus
- [x] Notes tersimpan di local storage
- [x] Lainnya menampilkan semua kategori
- [x] Last Read Card menampilkan item terakhir dibaca
- [x] Search berfungsi untuk mencari konten
- [x] Full Glassmorphism pada semua card
- [ ] Build APK berhasil tanpa error
- [ ] Semua test pass

---

## 🐛 KNOWN ISSUES

1. **Build OOM**: Dart compiler crash dengan "Out of memory" saat build APK debug. Solusi: Restart Flutter/Dart process atau upgrade RAM.
2. **Deprecation Warnings**: `withOpacity`, `MaterialState`, `WillPopScope` - minor, tidak memblokir.
3. **Gradle Version**: Warning untuk upgrade Gradle (8.5.0 → 8.7.0), Kotlin (1.9.22 → 2.1.0).

---

## 📅 TIMELINE

| Phase | Duration | Status |
|-------|----------|--------|
| Sprint 1: Data Layer | 30 min | ✅ Complete |
| Sprint 2: Presentation | 2 hours | ✅ Complete |
| Sprint 3: Navigation | 30 min | ✅ Complete |
| Sprint 4: State Management | 1.5 hours | ✅ Complete |
| Sprint 5: Polish & Testing | 1 hour | 🔄 In Progress |
| **Total** | **~6 hours** | **90% Complete** |

---

## 🚀 NEXT STEPS

1. **Resolve OOM Issue**: Restart system atau clear Flutter cache
2. **Run Build**: `flutter build apk --debug`
3. **Run Tests**: `flutter test`
4. **Final Verification**: Manual UI testing on device
5. **Create Release Build**: `flutter build apk --release`

---

## 📚 REFERENCES

- `QUICK_REFERENCE.md` - Development rules and patterns
- `AI_AGENT_RULES_AND_SKILLS.md` - AI agent guidelines
- `SYSTEM_PROMPT_FOR_AI_AGENT.md` - System configuration
- `assets/json/category.json` - Category definitions
- `assets/json/Annibros.json` - Content data

