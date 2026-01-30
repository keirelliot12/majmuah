# 📖 PRODUCT REQUIREMENTS DOCUMENT (PRD)
# Aplikasi An-Nibros

**Version**: 1.0.0  
**Last Updated**: January 30, 2026  
**Author**: Development Team  
**Status**: Active Development

---

## 1. OVERVIEW

### 1.1 Product Name
**An-Nibros** - Aplikasi resmi An-Nibros, teman mendekatkan diri kepada Allah

### 1.2 Product Vision
Menyediakan platform digital yang komprehensif untuk umat Muslim dalam menjalankan ibadah sehari-hari, termasuk Al-Quran, Hadith, waktu sholat, dzikir, wirid, dan berbagai bacaan islami lainnya.

### 1.3 Target Audience
- Muslim Indonesia yang ingin mendekatkan diri kepada Allah
- Santri dan jamaah An-Nibros
- Pengguna yang membutuhkan panduan ibadah harian

### 1.4 Platform
- **Primary**: Android (Mobile)
- **Secondary**: iOS (Planned)
- **Web**: Progressive Web App (Limited)

---

## 2. PRODUCT GOALS

### 2.1 Business Goals
- Menyediakan akses mudah ke bacaan-bacaan islami
- Meningkatkan engagement jamaah An-Nibros
- Menjadi one-stop solution untuk kebutuhan ibadah harian

### 2.2 User Goals
- Akses cepat ke Al-Quran dan Hadith
- Mengetahui waktu sholat dengan akurat
- Membaca wirid, ratib, dan doa dengan mudah
- Mencatat hal-hal penting terkait ibadah

### 2.3 Success Metrics
| Metric | Target |
|--------|--------|
| Daily Active Users | 1,000+ |
| App Rating | 4.5+ |
| Session Duration | 10+ minutes |
| Retention Rate (D7) | 40%+ |

---

## 3. FEATURES

### 3.1 Core Features

#### 3.1.1 Beranda (Home)
**Priority**: P0 - Critical

**Description**: Halaman utama dengan tampilan glassmorphism yang menampilkan informasi penting dan navigasi cepat ke fitur utama.

**Components**:
| Component | Description |
|-----------|-------------|
| Home Header | Lokasi, tanggal Hijriah, notifikasi |
| Prayer Countdown | Waktu sholat berikutnya + countdown |
| Search Bar | Pencarian konten global |
| Last Read | Konten terakhir dibaca |
| Menu Grid | 8 menu navigasi cepat |
| Wisdom Quote | Mutiara hikmah |

**User Stories**:
- Sebagai pengguna, saya ingin melihat waktu sholat berikutnya agar tidak terlewat
- Sebagai pengguna, saya ingin melanjutkan bacaan terakhir dengan satu tap
- Sebagai pengguna, saya ingin mencari konten dengan cepat

---

#### 3.1.2 Al-Quran
**Priority**: P0 - Critical

**Description**: Membaca Al-Quran dengan tampilan yang nyaman, fitur bookmark, dan pencarian ayat.

**Features**:
- 114 Surah lengkap dengan terjemahan
- Bookmark halaman terakhir
- Pencarian ayat dan surah
- Mode baca malam (dark mode)
- Font Arab (UthmanTN)

**User Stories**:
- Sebagai pengguna, saya ingin melanjutkan bacaan dari halaman terakhir
- Sebagai pengguna, saya ingin mencari ayat tertentu

---

#### 3.1.3 Waktu Sholat
**Priority**: P0 - Critical

**Description**: Menampilkan waktu sholat berdasarkan lokasi pengguna dengan akurat.

**Features**:
- Deteksi lokasi otomatis
- 6 waktu sholat (Subuh, Terbit, Dzuhur, Ashar, Maghrib, Isya)
- Countdown ke sholat berikutnya
- Fallback lokasi default

**User Stories**:
- Sebagai pengguna, saya ingin mengetahui waktu sholat di lokasi saya saat ini

---

#### 3.1.4 Hadith
**Priority**: P1 - High

**Description**: Koleksi hadith shahih dengan terjemahan Indonesia.

**Features**:
- Hadith dari berbagai kitab
- Kategori per topik
- Pencarian hadith

---

#### 3.1.5 Dzikir & Wirid
**Priority**: P1 - High

**Description**: Koleksi dzikir dan wirid harian dengan counter.

**Features**:
- Dzikir pagi dan petang
- Wirid setelah sholat
- Counter digital
- Custom dzikir

---

#### 3.1.6 Notes (Catatan)
**Priority**: P1 - Important

**Description**: Sistem pencatatan lokal untuk memudahkan pengguna menyimpan refleksi spiritual atau catatan harian.

**Features**:
- Create, Read, Update, Delete (CRUD) catatan
- Pin catatan penting ke atas
- Pencarian dalam catatan
- Penyimpanan lokal (Shared Preferences)

**User Stories**:
- Sebagai pengguna, saya ingin membuat catatan agar tidak lupa hal penting
- Sebagai pengguna, saya ingin menyematkan (pin) catatan agar mudah ditemukan

---

### 3.2 Beranda Menu Features

#### 3.2.1 Aurad Sholat
**Priority**: P1 - High

**Description**: Bacaan-bacaan setelah sholat fardhu.

**Data Source**: `Annibros.json` (filter: "Aurad Sholat")

---

#### 3.2.2 Doa & Tawassul
**Priority**: P1 - High

**Description**: Kumpulan doa dan tawassul.

**Data Source**: `Annibros.json` (filter: "Doa & Tawassul")

---

#### 3.2.3 Ratib
**Priority**: P1 - High

**Description**: Bacaan ratib (Al-Haddad, Al-Attas, dll).

**Data Source**: `Annibros.json` (filter: "Ratib")

---

#### 3.2.4 Khutbah
**Priority**: P2 - Medium

**Description**: Teks khutbah Jumat dan hari raya.

**Data Source**: `Annibros.json` (filter: "Khutbah")

---

#### 3.2.5 Maulid
**Priority**: P1 - High

**Description**: Bacaan maulid Nabi.

**Data Source**: `Annibros.json` (filter: "Maulid")

---

#### 3.2.6 Tahlil & Ziarah
**Priority**: P1 - High

**Description**: Bacaan tahlil dan doa ziarah kubur.

**Data Source**: `Annibros.json` (filter: "Tahlil & Ziarah")

---

#### 3.2.7 Notes
**Priority**: P2 - Medium

**Description**: Catatan pribadi pengguna yang tersimpan secara lokal.

**Features**:
- Tambah, edit, hapus catatan
- Pin catatan penting
- Pencarian catatan
- Warna label (8 pilihan)
- Penyimpanan lokal (SharedPreferences)

**Data Source**: Local Storage

**User Stories**:
- Sebagai pengguna, saya ingin mencatat hal-hal penting terkait ibadah
- Sebagai pengguna, saya ingin catatan saya tersimpan dengan aman di HP

---

#### 3.2.8 Lainnya
**Priority**: P2 - Medium

**Description**: Menampilkan semua kategori dalam bentuk grid.

**Data Source**: `category.json`

---

### 3.3 Search Feature
**Priority**: P1 - High

**Description**: Pencarian global di seluruh konten.

**Search Fields**:
- Title
- Arabic title
- Tags
- Content

---

### 3.4 Last Read Feature
**Priority**: P2 - Medium

**Description**: Menyimpan dan menampilkan konten terakhir yang dibaca.

**Storage**: SharedPreferences

---

## 4. TECHNICAL SPECIFICATIONS

### 4.1 Tech Stack
| Component | Technology |
|-----------|------------|
| Framework | Flutter 3.10+ |
| State Management | flutter_bloc (Cubit) |
| DI | get_it |
| Local Storage | shared_preferences |
| Database | floor (SQLite) |
| Network | dio + retrofit |
| Icons | material_symbols_icons |
| Fonts | Google Fonts, UthmanTN |

### 4.2 Architecture
- **Pattern**: Clean Architecture + MVVM
- **Layers**: Presentation → Domain → Data
- **State**: BLoC/Cubit pattern

### 4.3 Data Sources
| Source | Type | Description |
|--------|------|-------------|
| `category.json` | Local Asset | Daftar kategori |
| `Annibros.json` | Local Asset | Konten bacaan |
| SharedPreferences | Local Storage | Notes, Last Read, Settings |
| Floor DB | Local Database | Quran, Hadith cache |
| Aladhan API | Remote | Waktu sholat |

### 4.4 Dependencies
```yaml
dependencies:
  flutter_bloc: ^8.1.6
  get_it: ^9.2.0
  shared_preferences: ^2.5.4
  floor: ^1.5.0
  dio: ^5.9.1
  retrofit: 4.0.1
  material_symbols_icons: ^4.2892.0
  google_fonts: ^8.0.0
  flutter_screenutil: ^5.9.3
  intl: ^0.20.2
```

---

## 5. UI/UX DESIGN

### 5.1 Design System

#### Color Palette
| Name | Hex | Usage |
|------|-----|-------|
| Lemon Yellow | #E8F5A3 | Gradient top |
| Islamic Teal | #26A69A | Primary color |
| Darker Teal | #00695C | Accent |
| White | #FFFFFF | Cards, text |
| Off White | #F5F5F5 | Background |

#### Typography
| Style | Font | Size | Weight |
|-------|------|------|--------|
| Heading | El Messiri | 24sp | Bold |
| Body | System | 14-16sp | Regular |
| Arabic | UthmanTN | 18-24sp | Regular |

#### Glassmorphism
- **Blur**: 10σ
- **Background**: white @ 40% alpha
- **Border**: white @ 20% alpha
- **Border Radius**: 16-24dp

### 5.2 Screens

1. **Beranda** - Main dashboard with glassmorphism
2. **Al-Quran** - Surah list and reader
3. **Waktu Sholat** - Prayer times display
4. **Dzikir** - Dhikr counter
5. **Settings** - App preferences

### 5.3 Navigation
- Bottom Navigation Bar (5 items)
- Named routes with arguments
- Deep linking support (future)

---

## 6. RELEASE PLAN

### Phase 1: MVP (Current) ✅
- [x] Beranda redesign with glassmorphism
- [x] 8 menu items navigation
- [x] Material content display
- [x] Notes feature (local storage)
- [x] Search functionality
- [x] Last read feature

### Phase 2: Enhancement (Planned)
- [ ] Push notifications for prayer times
- [ ] Audio playback for recitations
- [ ] Offline mode improvements
- [ ] Widget for home screen

### Phase 3: Expansion (Future)
- [ ] iOS release
- [ ] Community features
- [ ] Cloud sync
- [ ] Premium features

---

## 7. TESTING REQUIREMENTS

### 7.1 Unit Tests
- Repository tests
- Cubit tests
- Model serialization tests

### 7.2 Widget Tests
- Component rendering
- User interaction
- State changes

### 7.3 Integration Tests
- Navigation flow
- Data loading
- Error handling

### 7.4 Manual Testing
- UI/UX verification
- Device compatibility
- Performance testing

---

## 8. PERFORMANCE REQUIREMENTS

| Metric | Target |
|--------|--------|
| App Launch Time | < 3 seconds |
| Screen Transition | < 300ms |
| APK Size | < 50 MB |
| Memory Usage | < 200 MB |
| Battery Impact | Minimal |

---

## 9. SECURITY & PRIVACY

### 9.1 Data Storage
- All user data stored locally on device
- No personal data sent to servers (except location for prayer times)
- Notes encrypted in local storage (future)

### 9.2 Permissions
| Permission | Reason |
|------------|--------|
| Location | Prayer time calculation |
| Internet | API calls, content updates |
| Storage | Cache and offline data |

---

## 10. SUPPORT & MAINTENANCE

### 10.1 Support Channels
- Email: support@annibros.com
- WhatsApp: TBD
- In-app feedback

### 10.2 Update Frequency
- Bug fixes: Weekly
- Feature updates: Monthly
- Major releases: Quarterly

---

## 11. APPENDIX

### 11.1 Glossary
| Term | Definition |
|------|------------|
| Wirid | Recitations after prayer |
| Ratib | Fixed set of dhikr |
| Tawassul | Supplication through intermediary |
| Maulid | Celebration of Prophet's birth |
| Tahlil | Recitation for deceased |

### 11.2 References
- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Pattern](https://bloclibrary.dev)
- [Material Symbols](https://fonts.google.com/icons)

### 11.3 Version History
| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-30 | Initial PRD |

---

**Document Owner**: Development Team  
**Approvers**: Product Manager, Tech Lead  
**Distribution**: Internal Use Only
