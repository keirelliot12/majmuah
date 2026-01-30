# 🧪 Testing Guide - Fitur Pencarian

## Quick Start

### Menjalankan Aplikasi
```bash
cd C:\Users\PC\StudioProjects\majmuah
flutter clean
flutter pub get
flutter run
```

## Test Scenarios

### 🔍 Test 1: Akses dari Home Dashboard

**Steps:**
1. Buka aplikasi
2. Navigate ke tab "Beranda" (Home)
3. Lihat search bar di bagian atas (yang overlap dengan header gradient)
4. **Tap pada search bar**

**Expected Result:**
- ✅ Navigate ke halaman "Pencarian Bacaan"
- ✅ Search bar sudah fokus dan siap diketik
- ✅ Menampilkan semua kategori dalam chip horizontal
- ✅ Menampilkan semua bacaan (tanpa filter)

---

### 🔍 Test 2: Pencarian Judul (English)

**Steps:**
1. Buka search screen
2. Ketik: **"doa"**
3. Tunggu hasil muncul (real-time)

**Expected Result:**
- ✅ Menampilkan material dengan "doa" di judul
- ✅ Contoh: "Doa Fajr", "Doa Setelah Sholat"
- ✅ Badge kategori muncul di setiap card
- ✅ Snippet content ditampilkan
- ✅ Counter: "Ditemukan X bacaan"

**Screenshot Location**: `islamic_screenshots/search_doa.jpg` (capture hasil ini)

---

### 🔍 Test 3: Pencarian Judul Arabic

**Steps:**
1. Clear search (tap X)
2. Ketik: **"صلاة"** atau **"الله"**

**Expected Result:**
- ✅ Menampilkan material dengan kata Arabic di:
  - Arabic title
  - Content
- ✅ Text Arabic ditampilkan RTL dengan benar
- ✅ Snippet menunjukkan context sekeliling kata

---

### 🔍 Test 4: Filter Kategori

**Steps:**
1. Clear search
2. Tap chip **"Doa"** di bagian filter horizontal
3. Observasi hasil

**Expected Result:**
- ✅ Chip "Doa" menjadi putih (selected)
- ✅ Chip lain abu-abu transparan
- ✅ Hanya menampilkan material kategori "Doa"
- ✅ Counter update: "Ditemukan X bacaan"

**Next:**
4. Ketik: **"fajr"**

**Expected Result:**
- ✅ Filter kombinasi: kategori Doa + contains "fajr"
- ✅ Hasil: "Doa Fajr" (filtered by both)

---

### 🔍 Test 5: Clear Filter

**Steps:**
1. Dengan filter aktif (e.g., kategori "Doa" + query "fajr")
2. Tap chip **"Semua"**

**Expected Result:**
- ✅ Category filter cleared
- ✅ Masih menampilkan hasil search "fajr" dari semua kategori

**Next:**
3. Tap icon **X** di search bar

**Expected Result:**
- ✅ Search query cleared
- ✅ Menampilkan semua material lagi

---

### 🔍 Test 6: Pencarian di Content

**Steps:**
1. Ketik: **"Rasulullah"**

**Expected Result:**
- ✅ Menampilkan semua material yang menyebut "Rasulullah"
- ✅ Tidak hanya di title, tapi juga di content
- ✅ Snippet menampilkan bagian yang mengandung "Rasulullah"
- ✅ "..." muncul jika ada text sebelum/sesudah

---

### 🔍 Test 7: No Results (Empty State)

**Steps:**
1. Ketik: **"xyzabc123"** (random gibberish)

**Expected Result:**
- ✅ Menampilkan empty state
- ✅ Icon search_off
- ✅ Text: "Tidak ditemukan"
- ✅ Subtitle: "Coba kata kunci lain"
- ✅ Counter: "Ditemukan 0 bacaan"

---

### 🔍 Test 8: Navigation ke Detail

**Steps:**
1. Search: **"doa fajr"**
2. Tap pada card "Doa Fajr"

**Expected Result:**
- ✅ Navigate ke MaterialDetailScreen
- ✅ Menampilkan full content
- ✅ Warna header sesuai kategori (orange untuk Doa)
- ✅ Copy/Share buttons available

**Next:**
3. Tap back button

**Expected Result:**
- ✅ Kembali ke search screen
- ✅ Search query "doa fajr" masih ada
- ✅ Results preserved (tidak reload)

---

### 🔍 Test 9: Akses dari Material List

**Steps:**
1. Dari home, tap kategori **"Ratib"**
2. Di MaterialListScreen, tap icon **search** (AppBar kanan atas)

**Expected Result:**
- ✅ Navigate ke MaterialSearchScreen
- ✅ Bisa search dari sini
- ✅ Filter kategori "Ratib" bisa dipilih

---

### 🔍 Test 10: Multiple Categories

**Steps:**
1. Clear all filters
2. Ketik: **"al"**
3. Scroll through results

**Expected Result:**
- ✅ Menampilkan dari berbagai kategori:
  - Ratib: "Ratib Al-Haddad", "Ratib Al-Attas"
  - Qasidah: "Ya Nabi Salam Alaika"
  - Al-Quran: materials
- ✅ Badge kategori berbeda warna
- ✅ Semua hasil ter-sort (by relevance atau order)

---

### 🔍 Test 11: Case Insensitive

**Steps:**
1. Ketik: **"DOA"** (uppercase)

**Expected Result:**
- ✅ Same results as typing "doa" (lowercase)
- ✅ Case doesn't matter

**Next:**
2. Ketik: **"DoA"** (mixed case)

**Expected Result:**
- ✅ Same results

---

### 🔍 Test 12: Tags Search

**Steps:**
1. Ketik tag yang ada di data (jika ada)
2. Contoh: jika material punya tag "pagi"

**Expected Result:**
- ✅ Material dengan tag tersebut muncul
- ✅ Tags ditampilkan di card result
- ✅ Max 3 tags shown per card

---

### 🔍 Test 13: Performance Test

**Steps:**
1. Ketik karakter satu per satu: **"d"**, **"o"**, **"a"**
2. Observe response time

**Expected Result:**
- ✅ Results update immediately (< 50ms)
- ✅ No lag or stutter
- ✅ Smooth typing experience
- ✅ No UI freeze

---

### 🔍 Test 14: Long Content Snippet

**Steps:**
1. Search material dengan content panjang
2. Observe snippet di result card

**Expected Result:**
- ✅ Snippet max ~3 lines
- ✅ "..." ellipsis di akhir
- ✅ Relevant part shown (with search keyword)

---

### 🔍 Test 15: Screen Rotation (Mobile)

**Steps:**
1. Search: **"doa"**
2. Rotate device (portrait → landscape)

**Expected Result:**
- ✅ Layout adapts (responsive)
- ✅ Search query preserved
- ✅ Results still visible
- ✅ No data loss

---

## Test Matrix

| Test Case | Input | Expected Output | Status |
|-----------|-------|----------------|--------|
| Search Title EN | "doa" | Shows Doa materials | ⬜ |
| Search Title AR | "صلاة" | Shows Arabic matches | ⬜ |
| Filter Category | Chip: "Ratib" | Only Ratib materials | ⬜ |
| Combined Filter | Cat: Doa + "fajr" | Doa Fajr only | ⬜ |
| Clear Search | Tap X | All materials shown | ⬜ |
| Search Content | "Rasulullah" | Content matches | ⬜ |
| Empty State | "xyz123" | No results message | ⬜ |
| Navigate Detail | Tap card | Opens detail screen | ⬜ |
| Back Navigation | Back button | Returns preserved | ⬜ |
| Multiple Results | "al" | Mixed categories | ⬜ |
| Case Insensitive | "DOA" | Same as "doa" | ⬜ |
| Real-time Update | Type slow | Immediate results | ⬜ |
| Performance | Fast typing | No lag | ⬜ |

## Bug Report Template

If you find a bug, report dengan format:

```markdown
**Bug Title**: [Short description]

**Steps to Reproduce**:
1. 
2. 
3. 

**Expected Result**:
- 

**Actual Result**:
- 

**Screenshots**:
[Attach screenshot]

**Device Info**:
- Device: 
- OS: 
- App Version: 

**Priority**: High/Medium/Low
```

## Performance Benchmarks

Expected performance:

| Metric | Target | Acceptable |
|--------|--------|------------|
| Initial Load | < 500ms | < 1s |
| Search Response | < 50ms | < 100ms |
| Scroll Performance | 60 FPS | 45 FPS |
| Memory Usage | < 50MB | < 100MB |
| Battery Impact | Minimal | Low |

## Accessibility Testing

### Test dengan Screen Reader
1. Enable TalkBack (Android) atau VoiceOver (iOS)
2. Navigate search screen
3. Verify announcements make sense

### Test dengan High Contrast
1. Enable high contrast mode
2. Verify text readable
3. Check color combinations

### Test dengan Large Text
1. Increase system font size to max
2. Verify layout doesn't break
3. Check text overflow handling

## Integration Testing

### Test dengan Data Kosong
1. Rename Annibros.json temporarily
2. Run app
3. Expected: Graceful error handling

### Test dengan Data Corrupted
1. Add invalid JSON to Annibros.json
2. Run app
3. Expected: Error caught, empty state shown

### Test dengan Banyak Data
1. Add more materials to Annibros.json (>1000)
2. Test search performance
3. Expected: Still fast (< 100ms)

## Automated Testing (Future)

Example widget test:

```dart
testWidgets('Search finds materials by title', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  
  // Navigate to search
  await tester.tap(find.byType(TextField));
  await tester.pumpAndSettle();
  
  // Type query
  await tester.enterText(find.byType(TextField), 'doa');
  await tester.pump();
  
  // Verify results
  expect(find.text('Doa Fajr'), findsOneWidget);
});
```

## Sign Off Checklist

Before marking feature as complete:

- [ ] All 15 test scenarios passed
- [ ] No critical bugs found
- [ ] Performance meets benchmarks
- [ ] UI/UX approved
- [ ] Accessibility verified
- [ ] Documentation complete
- [ ] Screenshots captured
- [ ] Demo video recorded (optional)

## Demo Script

For presenting the feature:

1. **Intro** (30s)
   - "Fitur pencarian memungkinkan user mencari bacaan dengan mudah"
   
2. **Basic Search** (1 min)
   - Show typing "doa"
   - Point out real-time results
   - Highlight snippet feature

3. **Category Filter** (1 min)
   - Demonstrate chip selection
   - Show combined filtering
   - Explain color coding

4. **Arabic Search** (30s)
   - Type Arabic text
   - Show RTL support
   - Highlight Arabic title matching

5. **Navigation** (30s)
   - Tap result → detail
   - Back button → preserved state

6. **Edge Cases** (30s)
   - Empty state
   - Clear filters
   - No results

**Total Demo Time**: ~4 minutes

## Conclusion

Fitur pencarian sudah siap untuk testing. Ikuti test scenarios di atas dan laporkan hasil testing atau bug yang ditemukan.

**Happy Testing! 🚀**
