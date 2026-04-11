# 🔍 Quick Reference - Fitur Pencarian

## Akses Cepat

### Dari Home
```
Beranda → Tap Search Bar → MaterialSearchScreen
```

### Dari Material List  
```
Category → Search Icon (AppBar) → MaterialSearchScreen
```

## Fitur Utama

| Fitur | Deskripsi |
|-------|-----------|
| 🔍 Real-time Search | Hasil muncul saat ketik |
| 🏷️ Category Filter | Filter by kategori |
| 📝 Multi-field | Cari di title, arabic, content, tags |
| 📊 Result Counter | Tampilkan jumlah hasil |
| 📄 Smart Snippet | Context sekeliling keyword |
| 🎨 Color Coded | Badge kategori berwarna |

## Cara Pakai

```
1. Tap search bar
2. Ketik keyword (e.g., "doa")
3. [Optional] Pilih kategori filter
4. Tap hasil → Lihat detail
```

## Search di:

- ✅ Judul (English)
- ✅ Judul Arabic (عربي)
- ✅ Kategori
- ✅ Konten/Isi
- ✅ Tags

## Contoh Query

| Query | Hasil |
|-------|-------|
| `doa` | Semua material dengan "doa" |
| `الله` | Material dengan Arabic text |
| `fajr` | Material tentang Fajr |
| `Rasulullah` | Material menyebut Rasulullah |

## Kombinasi Filter

```
Category: Doa + Query: "fajr"
→ Result: Hanya "Doa Fajr"

Category: Ratib + Query: "al"
→ Result: Ratib Al-Haddad, Ratib Al-Attas, etc.
```

## Shortcut

| Action | How |
|--------|-----|
| Clear search | Tap X icon |
| Clear category | Tap "Semua" chip |
| Go to detail | Tap result card |
| Back | Back button (preserves state) |

## File Location

```
lib/presentation/search/material_search_screen.dart
```

## Documentation

- **Technical**: SEARCH_FEATURE_DOCUMENTATION.md
- **Testing**: SEARCH_TESTING_GUIDE.md
- **Summary**: SEARCH_FEATURE_COMPLETE.md

## Testing

```bash
flutter run
→ Tap search bar
→ Ketik "doa"
→ Should show results immediately
```

## Color Scheme

```dart
Header: Color(0xFF5A8C6B)        // Green
Selected: White with green text
Unselected: White transparent
Category badges: Category-specific colors
```

## Performance

- Load: < 500ms
- Search: < 50ms (real-time)
- Memory: < 50MB

## Status

✅ **READY TO USE**

---

**Quick Help**: See SEARCH_TESTING_GUIDE.md for detailed testing
