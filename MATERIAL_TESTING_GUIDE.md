# Material Integration Testing Guide

## Quick Test Steps

### 1. Test Home Dashboard Navigation
1. Open the app and navigate to the "Beranda" (Home) tab
2. You should see 7 menu items:
   - Aurad Shalat
   - Doa & Tawasul
   - Ratib
   - Khutbah
   - Maulid
   - Tahlil & Ziarah
   - Notes

### 2. Test Material List Screen
For each menu item, test the following:

#### Test "Doa & Tawasul" (Has materials)
1. Tap on "Doa & Tawasul" card
2. Should navigate to Material List screen
3. Should show materials with category "Doa"
4. Expected materials to see:
   - "Doa Fajr" (دعاء الفجر)
   - "Doa Setelah Sholat" (دعاء بعد الصلاة)
   - Any other materials with category "Doa"

#### Test "Ratib" (Has materials)
1. Tap on "Ratib" card
2. Should show materials with category "Ratib"
3. Should see various Ratib materials

#### Test "Maulid" (Uses Qasidah category)
1. Tap on "Maulid" card
2. Should show materials with category "Qasidah"
3. Expected materials:
   - "Qasidah Burdah" (قصيدة البردة)
   - "Ya Nabi Salam Alaika" (يا نبي سلام عليك)
   - Other Qasidah materials

#### Test "Khutbah" (Uses Umum category)
1. Tap on "Khutbah" card
2. Should show materials with category "Umum"
3. Expected materials:
   - "Muqaddimah" (مقدمة)
   - "Daftar Isi" (فهرس الكتاب)
   - Other general materials

### 3. Test Material Detail Screen
1. From any Material List screen, tap on a material card
2. Verify the following elements are displayed:
   - ✅ Material title in English
   - ✅ Material title in Arabic (if available)
   - ✅ Full content text (properly formatted)
   - ✅ Gradient header with category color
   - ✅ Share button in AppBar
   - ✅ Copy button in AppBar
   - ✅ Floating Action Button at bottom right

3. Test functionality:
   - **Copy button**: Tap and verify clipboard notification appears
   - **Share button**: Tap and verify clipboard notification appears
   - **FAB**: Tap to open bottom sheet with options:
     - Bagikan (Share)
     - Salin Konten (Copy Content)
     - Simpan ke Favorit (Save to Favorites - placeholder)

4. Test content:
   - Verify Arabic text displays correctly (RTL)
   - Verify content is selectable (long press to select)
   - Scroll through long content to ensure it displays properly

### 4. Test Empty States
1. Test "Notes" or "Aurad Shalat" if they have no materials
2. Should show empty state with:
   - Icon
   - "Belum ada materi" message
   - Description text

### 5. Test Navigation
1. **Back Navigation**:
   - From Material Detail → Material List (using back button)
   - From Material List → Home Dashboard (using back button)
2. **AppBar Back Button**:
   - Test back button in Material List screen
   - Test back button in Material Detail screen

## Expected Material Counts by Category

Based on Annibros.json:
- **Umum**: Multiple materials (Muqaddimah, Daftar Isi, etc.)
- **Puji-pujian & Bilal**: At least 2 materials
- **Doa**: At least 2 materials (Doa Fajr, Doa Setelah Sholat)
- **Al-Quran**: 4 materials (various Surahs)
- **Qasidah**: Multiple materials
- **Manaqib & Istighosah**: At least 1 material
- **Sholawat**: At least 1 material

## Common Issues & Solutions

### Issue: "No materials found" for all categories
**Solution**: Check that:
1. `assets/json/Annibros.json` exists
2. `assets/json/category.json` exists
3. Both files are properly formatted JSON
4. `pubspec.yaml` includes: `- assets/json/`

### Issue: Import error for material_detail_screen.dart
**Solution**: 
- This is typically a transient IDE analysis issue
- Run: `flutter clean`
- Run: `flutter pub get`
- Restart your IDE
- The error should disappear on next hot reload

### Issue: Materials not filtering correctly
**Solution**: 
- Check that category names in Annibros.json match filter_key in category.json
- Case-sensitive comparison, but repository does case-insensitive matching

### Issue: Arabic text displays incorrectly
**Solution**:
- Ensure device/browser supports Arabic fonts
- TextDirection is set to RTL for Arabic content
- Already implemented in MaterialDetailScreen

## Performance Notes

1. **First Load**: May take 1-2 seconds to load JSON files
2. **Subsequent Loads**: Should be instant (data is cached)
3. **Memory Usage**: All materials loaded in memory (~224KB for Annibros.json)

## Code Verification Checklist

Run these commands to verify everything is correct:

```bash
# Check for syntax errors
flutter analyze

# Run tests (if you have tests)
flutter test

# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## Debug Commands

If you need to debug:

```dart
// Add to MaterialRepository methods to debug loading
print('Loaded ${materials.length} materials');
print('Categories available: ${categories.map((c) => c.filterKey).toList()}');

// Add to MaterialListScreen to debug filtering
print('Filtering by: ${widget.categoryFilterKey}');
print('Found ${materials.length} materials');
```

## Sample Test Flow

1. **Start App** → Home Tab
2. **Tap "Doa & Tawasul"** → Material List with Doa materials
3. **Tap "Doa Fajr"** → Detail screen with full content
4. **Tap Copy Button** → See "Konten telah disalin" notification
5. **Tap Back** → Return to Material List
6. **Tap Back** → Return to Home Dashboard
7. **Tap "Maulid"** → Material List with Qasidah materials
8. **Verify** different category color
9. **Tap any material** → Detail screen
10. **Tap FAB** → Bottom sheet appears
11. **Tap "Bagikan"** → Content copied to clipboard

## Success Criteria

✅ All 7 menu items navigate correctly
✅ Materials load for each category
✅ Material details display correctly
✅ Arabic text displays properly
✅ Copy/Share functions work
✅ Back navigation works smoothly
✅ Empty states display when no materials
✅ No crashes or errors
✅ Smooth scrolling in long content
✅ Proper color coding by category

## Next Steps After Testing

If all tests pass:
1. Test on actual Android device
2. Test on iOS device (if applicable)
3. Consider adding:
   - Search functionality within materials
   - Bookmark/Favorite feature
   - Share with share_plus package
   - Material history tracking
   - Offline capability improvements
