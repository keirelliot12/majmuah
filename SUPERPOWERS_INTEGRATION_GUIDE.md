# Superpowers Integration Guide untuk AI Agent

Panduan lengkap untuk mengintegrasikan Superpowers skills dan rules ke dalam project An-Nibros agar AI Agent dapat bekerja dengan metodologi yang terstruktur dan efisien.

## 📋 Daftar Isi

1. [Pengenalan Superpowers](#pengenalan-superpowers)
2. [Skills yang Tersedia](#skills-yang-tersedia)
3. [Workflow Development](#workflow-development)
4. [Setup untuk Project Ini](#setup-untuk-project-ini)
5. [Best Practices](#best-practices)

---

## 🚀 Pengenalan Superpowers

**Superpowers** adalah sistem workflow lengkap untuk coding agents yang memastikan:

- ✅ Desain disetujui sebelum coding
- ✅ Rencana implementasi yang detail
- ✅ Development terstruktur dengan TDD
- ✅ Review otomatis setiap task
- ✅ Kualitas kode konsisten

### Core Principle

```
SPEC → DESIGN → PLAN → IMPLEMENT → REVIEW → MERGE
```

Setiap tahap mandatory, bukan optional.

---

## 📚 Skills yang Tersedia

### 1. **Brainstorming** (`brainstorming`)

**Kapan digunakan:** Sebelum menulis code, ketika ada requirement baru

**Workflow:**
- Agent mengajukan pertanyaan Socratic untuk memahami kebutuhan
- Mengeksplorasi alternatif desain
- Mempresentasikan design dalam chunks yang dapat dibaca
- Menyimpan design document untuk referensi

**Contoh kasus:**
```
AI: "Anda ingin membuat 'Beranda' page. Mari kita jelas requirements-nya.
    1. Apa yang harus tampil di halaman utama?
    2. Bagaimana interaksi user dengan menu?
    3. Data apa yang perlu di-fetch?"
```

### 2. **Using Git Worktrees** (`using-git-worktrees`)

**Kapan digunakan:** Setelah design disetujui

**Workflow:**
- Membuat isolated workspace di branch baru
- Menjalankan project setup
- Memverifikasi baseline test
- Menghindari konflik dengan main branch

**Command:**
```bash
git worktree add development/feature-x main
```

### 3. **Writing Plans** (`writing-plans`)

**Kapan digunakan:** Dengan design yang sudah approved

**Output:**
- Rencana implementasi bite-sized (2-5 menit per task)
- Setiap task memiliki: file paths, complete code, verification steps
- Format: YAML atau Markdown terstruktur

**Contoh:**
```yaml
tasks:
  - id: 1
    name: "Create Beranda header component"
    files:
      - lib/presentation/home/widgets/home_header.dart
    acceptance_criteria:
      - Displays location (Kudus, Indonesia)
      - Shows Hijri date
      - Notification bell icon visible
    verification: "Run widget test for HomeHeader"
```

### 4. **Subagent-Driven Development** (`subagent-driven-development`)

**Kapan digunakan:** Saat eksekusi plan

**Workflow:**
- Dispatch fresh subagent per task
- Two-stage review: spec compliance → code quality
- Subagent bekerja autonomous
- Human checkpoint antar task batch

**Keuntungan:**
- Setiap task independence
- Tidak ada context bloat
- Quality check berlapis

### 5. **Test-Driven Development** (`test-driven-development`)

**Kapan digunakan:** SELALU saat implementation

**Iron Law:**
```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

**Cycle:**
```
1. RED   → Write failing test
2. GREEN → Write minimal code to pass
3. REFACTOR → Clean up while staying green
```

**Rules (No Exception):**
- ❌ JANGAN: Write code sebelum test
- ❌ JANGAN: Keep code written before test
- ✅ DO: Delete dan mulai ulang dari test

### 6. **Systematic Debugging** (`systematic-debugging`)

**Kapan digunakan:** Saat ada bug atau test gagal

**4-Phase Process:**
1. **Reproduce** - Pahami exact condition bug
2. **Hypothesize** - Identify root cause (gunakan techniques: root-cause-tracing, defense-in-depth)
3. **Test** - Isolate dengan minimal example
4. **Fix** - Fix minimal, verify tidak break yang lain

### 7. **Requesting Code Review** (`requesting-code-review`)

**Kapan digunakan:** Sebelum merge

**Checklist:**
- ✓ Semua test passing
- ✓ Code follows project style
- ✓ No debug code/console.log
- ✓ Documentation updated
- ✓ Performance reviewed

### 8. **Executing Plans** (`executing-plans`)

**Workflow:**
- Batch execution dengan human checkpoints
- Progress tracking per task
- Rollback capability

---

## 🔄 Workflow Development Complete

### Tahap 1: Brainstorming

```
INPUT: Rough requirement
↓
AI refines through questions
↓
DESIGN DOCUMENT (approved by human)
```

### Tahap 2: Git Setup

```
INPUT: Approved design
↓
Create worktree + setup
↓
CLEAN BASELINE (tests passing)
```

### Tahap 3: Planning

```
INPUT: Design + baseline
↓
Break into bite-sized tasks
↓
IMPLEMENTATION PLAN (detailed, executable)
```

### Tahap 4: Implementation

```
INPUT: Plan
↓
For each task:
  1. Write failing test (RED)
  2. Write minimal code (GREEN)
  3. Refactor (REFACTOR)
  4. Code review
↓
WORKING FEATURE (fully tested)
```

### Tahap 5: Merge

```
INPUT: Completed feature
↓
Verify tests, present options
↓
MERGED or DISCARDED (clean state)
```

---

## 📱 Setup untuk Project An-Nibros

### Struktur yang Direkomendasikan

```
lib/
├── presentation/
│   └── home/
│       ├── screens/
│       │   └── dashboard/
│       │       ├── view/
│       │       │   └── home_dashboard_screen.dart
│       │       └── widgets/
│       │           ├── home_header.dart
│       │           ├── prayer_countdown_card.dart
│       │           ├── search_bar_widget.dart
│       │           └── menu_grid.dart
│       └── cubit/
│           └── home_cubit.dart
├── domain/
├── data/
└── app/
    └── resources/
        └── theme.dart

test/
├── presentation/
│   └── home/
│       ├── widgets/
│       │   ├── home_header_test.dart
│       │   ├── prayer_countdown_card_test.dart
│       │   ├── search_bar_widget_test.dart
│       │   └── menu_grid_test.dart
│       └── screens/
│           └── home_dashboard_screen_test.dart
└── domain/
```

### Checklist Implementasi

- [ ] **Design Phase**
  - [ ] Brainstorm Beranda requirements
  - [ ] Buat design document
  - [ ] Approve design dengan stakeholder

- [ ] **Git Phase**
  - [ ] Create worktree: `git worktree add dev/beranda-redesign main`
  - [ ] Verify baseline tests passing

- [ ] **Planning Phase**
  - [ ] Break Beranda redesign menjadi tasks
  - [ ] Setiap task: 2-5 minutes work
  - [ ] Generate implementation plan

- [ ] **Implementation Phase**
  - [ ] Para setiap widget:
    - [ ] Write widget test (RED)
    - [ ] Watch test fail
    - [ ] Write minimal implementation (GREEN)
    - [ ] Watch test pass
    - [ ] Refactor jika perlu (REFACTOR)
    - [ ] Code review
  - [ ] All tests passing
  - [ ] No debug code

- [ ] **Review Phase**
  - [ ] Compliance check dengan design
  - [ ] Code quality review
  - [ ] Performance review

- [ ] **Merge Phase**
  - [ ] Final verification
  - [ ] Merge to main
  - [ ] Cleanup worktree

---

## 💡 Best Practices

### 1. **Red-Green-Refactor Cycle**

❌ **WRONG:**
```dart
// Write code first
Widget buildHeader() {
  return Container(
    child: Text("Location: Kudus"),
  );
}

// Then write test
void main() {
  testWidgets('Header shows location', (tester) async {
    await tester.pumpWidget(buildHeader());
    expect(find.text('Location: Kudus'), findsOneWidget);
  });
}
```

✅ **RIGHT:**
```dart
// 1. Write failing test FIRST
void main() {
  testWidgets('Header shows location', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: HomeHeader()),
      ),
    );
    expect(find.text('Location: Kudus'), findsOneWidget);
  });
  // Watch it fail ❌
}

// 2. Write minimal code to make it pass
class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Location: Kudus');
  }
}
// Watch it pass ✅

// 3. Refactor while keeping test green
class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.location_on),
          SizedBox(width: 8),
          Text('Location: Kudus'),
        ],
      ),
    );
  }
  // Still green ✅
}
```

### 2. **Bite-Sized Tasks**

Setiap task harusnya completable dalam 2-5 menit:

✅ **Good:**
- "Create HomeHeader widget that displays location"
- "Add notification bell icon to header"
- "Implement Hijri date display"

❌ **Bad:**
- "Implement entire Beranda screen"
- "Add all widgets and data fetching"

### 3. **Task Format**

Setiap task harus complete:

```yaml
task:
  id: beranda-01
  title: "Create HomeHeader widget"
  
  files_to_create:
    - lib/presentation/home/widgets/home_header.dart
  
  files_to_modify: []
  
  acceptance_criteria:
    - Displays location icon + text
    - Shows Hijri date below location
    - Notification bell on right
    - Responsive on mobile/tablet
  
  test_file:
    - test/presentation/home/widgets/home_header_test.dart
  
  verification_steps:
    - "flutter test lib/presentation/home/widgets/home_header_test.dart"
    - "Visual check: matches design mockup"
```

### 4. **Code Review Checklist**

Sebelum merge setiap task, review:

- [ ] **Spec Compliance**
  - Apakah memenuhi acceptance criteria?
  - Apakah semua test passing?

- [ ] **Code Quality**
  - Widget/function names descriptive?
  - Comments untuk logic kompleks?
  - No dead code?
  - No console.log/print statements?

- [ ] **Testing**
  - Semua test passing?
  - Test coverage reasonable?
  - Edge cases tested?

- [ ] **Style**
  - Consistent dengan project style?
  - Proper formatting?
  - Imports organized?

### 5. **Documentation**

Setiap component harus documented:

```dart
/// Displays the home page header with location and date.
/// 
/// Shows:
/// - Location icon + current location
/// - Hijri date
/// - Notification bell
/// 
/// Responds to [LocationCubit] for location updates.
/// Responds to [HomeThemeCubit] for theme changes.
class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ...
  }
}
```

---

## 🎯 Untuk Project Anda: Action Items

### Immediate Actions

1. **Approve Design Dahulu**
   - [ ] Brainstorm Beranda requirements
   - [ ] Create visual mockup/design document
   - [ ] Stakeholder approval

2. **Create Implementation Plan**
   - [ ] Identifikasi widgets: HomeHeader, PrayerCard, SearchBar, MenuGrid
   - [ ] Break menjadi 15-20 bite-sized tasks
   - [ ] Assign order (dependencies first)

3. **Setup Development Environment**
   - [ ] Create feature branch: `git checkout -b feature/beranda-redesign`
   - [ ] Verify existing tests passing
   - [ ] Delete example/test files tidak perlu

4. **Implement dengan TDD**
   - [ ] Untuk setiap widget:
     1. Create test file
     2. Write failing test
     3. Implement widget
     4. Verify test passes
     5. Refactor
     6. Code review

### Tools untuk Accelerate

```bash
# Run tests dengan watch mode
flutter test --watch

# Format code sebelum commit
dart format lib/ test/

# Analyze code quality
dart analyze

# Generate coverage report
flutter test --coverage
```

---

## 📖 Referensi Eksternal

- **Superpowers Repository**: https://github.com/obra/superpowers
- **Blog Post**: https://blog.fsck.com/2025/10/09/superpowers/
- **TDD Best Practices**: docs/test-driven-development/SKILL.md
- **Systematic Debugging**: docs/systematic-debugging/SKILL.md

---

## ❓ FAQ

**Q: Apakah TDD akan membuat development lebih lambat?**
A: Tidak. Awalnya terasa lambat, tapi mengehemat waktu debugging & rework.

**Q: Bagaimana jika test sulit ditulis?**
A: Itu signal bahwa design tidak good. Redesign untuk testability.

**Q: Boleh skip TDD untuk "simple" code?**
A: Tidak. Simple code adalah yang paling perlu ditest karena paling sering di-refactor.

**Q: Bagaimana dengan UI components?**
A: Use flutter_test dengan tester.pumpWidget, tester.tap, find.byType, etc.

---

## 🔗 Next Steps

1. Baca complete Superpowers documentation
2. Setup project dengan struktur yang direkomendasikan
3. Approval design bersama stakeholder
4. Mulai implementation dengan TDD
5. Regular code review checkpoints

**Target**: Autonomous development cycles 2-3 jam per feature dengan zero defects.

---

*Last Updated: January 29, 2026*
