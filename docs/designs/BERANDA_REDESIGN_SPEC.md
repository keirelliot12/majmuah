# Beranda Redesign - Design Specification

**Status:** ✅ APPROVED FOR IMPLEMENTATION
**Date:** January 29, 2026
**Methodology:** Superpowers (TDD-First)

---

## 1. VISUAL DESIGN

### Color Palette
- **Primary Gradient Top:** #F4F878 (Lemon Yellow)
- **Primary Gradient Bottom:** #00897B (Teal Green)
- **Cards:** #FFFFFF (White)
- **Card Border Radius:** 20 px
- **Card Shadow:** Elevation 4
- **Text Color:** #1F1F1F (Dark) for contrast
- **Accent Color:** #00897B (Teal for icons/interactive)

### Typography
- **Font Family:** Poppins (default sans-serif)
- **Headlines:** Bold, 18-20 px
- **Body Text:** Regular, 14-16 px
- **Small Text:** Regular, 12-13 px

---

## 2. LAYOUT STRUCTURE

### A. Top Section - Header (30% screen height)
```
┌─────────────────────────────────────┐
│ 📍 Kudus, Indonesia    🔔 (bell)    │
│ 29 Rajab 1446 AH                    │
└─────────────────────────────────────┘
```

**Components:**
- Left: Location icon + text (Kudus, Indonesia)
- Subtitle: Hijri date + Gregorian date
- Right: Notification bell icon
- Background: Transparent (gradient visible)

### B. Prayer Countdown Card (Overlapping)
```
┌──────────────────────────────────┐
│  Next Prayer: ASHAR              │
│                                  │
│  ⏱️  02:45:32  (Countdown)      │
│                                  │
│  Background: White gradient      │
└──────────────────────────────────┘
```

**Components:**
- Prayer name (Ashar, Maghrib, etc.)
- Large countdown timer (HH:MM:SS)
- Updates every second
- Glassmorphism effect or clean white card

### C. Search Bar
```
┌────────────────────────────────────┐
│ 🔍  Cari Surah, Wirid, Doa...      │
└────────────────────────────────────┘
```

**Components:**
- White background
- Border radius: 30 px
- Search icon + placeholder text
- Tappable for navigation

### D. Menu Grid (7 items)
```
[Icon] [Icon] [Icon]
Menu1  Menu2  Menu3

[Icon] [Icon] [Icon]
Menu4  Menu5  Menu6

  [Full Width Item]
      Menu7 (Notes)
```

**Menu Items:**
1. Aurad Shalat
2. Doa & Tawasul
3. Ratib
4. Khutbah
5. Maulid
6. Tahlil & Ziarah
7. Notes (full width)

**Card Style:**
- White background
- Border radius: 16 px
- Centered icon (32x32)
- Text below icon
- Shadow: subtle
- Tap animation: scale 0.95

### E. Bottom Navigation Bar (5 items)
```
[Quran] [Adzkar] [🏠 Beranda] [Prayer Times] [Settings]
```

**Items:**
1. Al-Quran (book icon)
2. Adzkar (hands icon)
3. **Beranda** (home icon) - Active/highlighted
4. Waktu Shalat (clock icon)
5. Pengaturan (settings icon)

**Style:**
- Fixed at bottom
- Active color: Teal Green (#00897B)
- Inactive color: Grey (#CCCCCC)
- Background: White
- No floating button

---

## 3. USER INTERACTIONS

### Prayer Card
- [ ] Timer updates every second
- [ ] Shows next prayer name
- [ ] Countdown in HH:MM:SS format
- [ ] No tap action (informational)

### Menu Items
- [ ] Tap = Navigate to respective screen
- [ ] Visual feedback: Scale animation
- [ ] Ripple effect on tap
- [ ] No disable state (all enabled)

### Search Bar
- [ ] Tap = Navigate to search screen
- [ ] Clear visual feedback
- [ ] Focus state styling

### Bottom Navigation
- [ ] Tap item = Switch screen
- [ ] Active item highlighted (teal)
- [ ] No animation between pages
- [ ] Current item: Beranda (index 2)

---

## 4. DATA REQUIREMENTS

### Header Data
- [ ] Location: "Kudus, Indonesia" (or fallback "Gresik, Indonesia")
- [ ] Hijri date: From API or calculations
- [ ] Gregorian date: System date

### Prayer Card
- [ ] Next prayer name: From PrayerTimingsCubit
- [ ] Countdown time: Calculate from prayer time
- [ ] Update interval: Every second

### Menu Items
- [ ] Item names (hardcoded or from JSON)
- [ ] Item icons (Material icons or SVG)
- [ ] Item colors (optional, use default theme)

---

## 5. RESPONSIVE DESIGN

- [ ] Mobile (320px - 480px): Single column grid
- [ ] Tablet (600px - 900px): Multi-column grid with adjustments
- [ ] Large screen: Centered content with max-width

---

## 6. ACCEPTANCE CRITERIA

### Visual
- [ ] Gradient matches reference exactly
- [ ] Colors match specification
- [ ] Typography hierarchy clear
- [ ] Cards styled correctly
- [ ] Spacing consistent with design

### Functional
- [ ] Header displays location + date
- [ ] Prayer timer updates every second
- [ ] Search bar navigates correctly
- [ ] Menu items tap to navigate
- [ ] Bottom nav switches screens
- [ ] All items visible & clickable

### Technical
- [ ] 100% test coverage (TDD)
- [ ] Zero analyzer issues
- [ ] Responsive layout
- [ ] No memory leaks
- [ ] Performance acceptable (60+ fps)

---

## 7. IMPLEMENTATION ORDER

### Phase 1: Setup & Theme
1. Define AppColors for gradient
2. Define typography in theme
3. Create color constants

### Phase 2: Components
4. HomeHeader widget
5. PrayerCountdownCard widget
6. SearchBar widget
7. MenuGrid widget
8. BottomNavigationBar widget

### Phase 3: Integration
9. Assemble HomeDashboardScreen
10. Connect navigation
11. Implement prayer timer logic
12. Test all interactions

### Phase 4: Verification
13. Manual testing
14. Performance check
15. Responsive testing
16. Visual verification

---

## 8. DESIGN NOTES

- Gradient runs top-to-bottom full screen
- All cards have white background for contrast
- Icons use teal green color for visibility
- Padding/margin follows 8px grid system
- No animations (keep it simple initially)
- Focus on readability & usability

---

**This specification is APPROVED for implementation. Ready for Phase 2: TDD Implementation.**
