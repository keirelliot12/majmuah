# Implementation Checklist: Beranda Redesign dengan Superpowers

**Practical checklist untuk mengimplementasikan Beranda redesign menggunakan Superpowers methodology**

---

## 📋 PHASE 1: BRAINSTORM & DESIGN

### Step 1: Gather Requirements

- [ ] Review design mockup image
- [ ] Document desired visual elements:
  - [ ] Gradient background (Yellow → Teal)
  - [ ] Header with location + date + bell
  - [ ] Prayer countdown card
  - [ ] Search bar
  - [ ] Menu grid (7-8 items)
  - [ ] Bottom navigation (5 items)

- [ ] List user interactions:
  - [ ] Click menu item → Navigate to section
  - [ ] Prayer timer updates every second
  - [ ] Search functionality
  - [ ] Theme toggle (if applicable)

- [ ] Identify data requirements:
  - [ ] Location (Kudus, Indonesia / fallback Gresik)
  - [ ] Hijri date (real-time)
  - [ ] Prayer times (API)
  - [ ] Menu items (JSON or hardcoded)

### Step 2: Create Design Document

**File:** `docs/designs/BERANDA_REDESIGN_SPEC.md`

```markdown
# Beranda Redesign Specification

## Visual Design
- Gradient: #F4F878 → #00897B
- Cards: White (#FFFFFF), radius 20, shadow 2
- Typography: Poppins or default sans-serif

## Components
### 1. HomeHeader
- Location icon + text (Kudus, Indonesia)
- Hijri date below
- Notification bell right

### 2. PrayerCountdownCard
- Next prayer name (e.g., Ashar)
- Countdown timer (HH:MM:SS)
- Updates every second

### 3. SearchBar
- White background, radius 30
- Search icon + hint text
- Clickable → Navigation to search

### 4. MenuGrid
- 7-8 items in grid
- Each: Icon + text + tap animation
- Items: [List from requirements]

### 5. BottomNavigationBar
- 5 items: Beranda, Quran, Prayer Times, Adzkar, Settings
- Beranda active by default

## Data Flow
- [Describe how data flows]

## Acceptance Criteria
- [ ] Looks exactly like mockup
- [ ] All interactions work
- [ ] Responsive on mobile/tablet
- [ ] Performance acceptable
- [ ] All tests passing
```

### Step 3: Get Approval

- [ ] Review spec with stakeholder/designer
- [ ] Get sign-off: ✅ APPROVED
- [ ] Document approval in spec file

---

## 📋 PHASE 2: GIT SETUP

### Create Feature Branch

```bash
# Ensure you're on main/develop
git checkout develop

# Create feature branch
git checkout -b feature/beranda-redesign develop

# Verify branch created
git branch
# Should show: * feature/beranda-redesign
```

- [ ] Feature branch created
- [ ] On correct branch

### Setup Project

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Verify baseline tests pass
flutter test
# All tests should PASS ✅
```

- [ ] Dependencies resolved
- [ ] Baseline tests passing
- [ ] Ready for implementation

---

## 📋 PHASE 3: IMPLEMENTATION PLAN

**File:** `docs/plans/BERANDA_IMPLEMENTATION_PLAN.yaml`

```yaml
---
feature: beranda-redesign
target_branch: develop
created_date: 2026-01-29
estimated_duration: "4-5 hours"
status: "planned"

components:
  - name: "Theme Setup"
    tasks: 2
    items: [colors, typography]
    
  - name: "HomeHeader"
    tasks: 3
    items: [location display, hijri date, notification icon]
    
  - name: "PrayerCountdownCard"
    tasks: 4
    items: [card layout, prayer name, timer logic, timer update]
    
  - name: "SearchBar"
    tasks: 2
    items: [widget creation, navigation setup]
    
  - name: "MenuGrid"
    tasks: 3
    items: [menu data, grid widget, item styling]
    
  - name: "BottomNavigationBar"
    tasks: 2
    items: [nav bar widget, navigation logic]
    
  - name: "Integration"
    tasks: 3
    items: [layout assembly, styling refinement, verification]

total_tasks: 19

tasks:
  - id: beranda-01
    title: "Define AppColors for gradient"
    component: "Theme Setup"
    files:
      create: [lib/app/resources/app_colors.dart]
      modify: [lib/app/resources/theme.dart]
    acceptance_criteria:
      - "Primary gradient color: #F4F878 (yellow)"
      - "Secondary color: #00897B (teal)"
      - "Colors used in theme"
    test_type: "manual"
    estimated_time: "5 min"
    dependencies: []

  - id: beranda-02
    title: "Define typography in theme"
    component: "Theme Setup"
    files:
      modify: [lib/app/resources/theme.dart]
    acceptance_criteria:
      - "Poppins font configured"
      - "Text styles defined"
    test_type: "manual"
    estimated_time: "5 min"
    dependencies: [beranda-01]

  - id: beranda-03
    title: "Create HomeHeader widget"
    component: "HomeHeader"
    files:
      create: [
        lib/presentation/home/widgets/home_header.dart,
        test/presentation/home/widgets/home_header_test.dart
      ]
    acceptance_criteria:
      - "Displays location icon"
      - "Shows location text: 'Kudus, Indonesia'"
      - "Shows Hijri date below location"
      - "Notification bell on right"
      - "Responsive layout"
    test_type: "unit + widget"
    estimated_time: "15 min"
    dependencies: [beranda-01, beranda-02]

  - id: beranda-04
    title: "Create PrayerCountdownCard widget"
    component: "PrayerCountdownCard"
    files:
      create: [
        lib/presentation/home/widgets/prayer_countdown_card.dart,
        test/presentation/home/widgets/prayer_countdown_card_test.dart
      ]
    acceptance_criteria:
      - "Displays prayer name (Ashar)"
      - "Shows countdown timer"
      - "Gradient background"
      - "White text"
      - "Card styling with shadow"
    test_type: "widget"
    estimated_time: "20 min"
    dependencies: [beranda-01, beranda-02]

  - id: beranda-05
    title: "Implement timer logic for countdown"
    component: "PrayerCountdownCard"
    files:
      modify: [
        lib/presentation/home/widgets/prayer_countdown_card.dart,
        test/presentation/home/widgets/prayer_countdown_card_test.dart
      ]
    acceptance_criteria:
      - "Timer updates every second"
      - "Shows HH:MM:SS format"
      - "Updates correctly"
      - "No memory leak (timer disposed)"
    test_type: "integration"
    estimated_time: "15 min"
    dependencies: [beranda-04]

  # ... continue for all 19 tasks

summary:
  total_files_create: 12
  total_files_modify: 5
  estimated_total_time: "4-5 hours"
  difficulty: "Medium"
  risk: "Low"
```

- [ ] Plan created and reviewed
- [ ] All tasks defined
- [ ] Dependencies clear
- [ ] Estimated time realistic

---

## 📋 PHASE 4: IMPLEMENTATION

### Task Execution Template

For **each task** in the plan:

#### Setup

```
Task: [beranda-XX] - [Title]
Status: In Progress
Start Time: [timestamp]
```

#### 1️⃣ RED - Write Failing Test

```
[ ] Test file created at: test/presentation/home/widgets/[name]_test.dart
[ ] Test written to check: [specific behavior]
[ ] Test FAILS when run: flutter test test/...
    Status: ❌ FAIL (expected)
```

**Example:**
```dart
// test/presentation/home/widgets/home_header_test.dart
void main() {
  testWidgets('displays location text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: HomeHeader())),
    );
    expect(find.text('Kudus, Indonesia'), findsOneWidget);
  });
}
```

- [ ] Test written
- [ ] Test fails as expected

#### 2️⃣ GREEN - Write Implementation

```
[ ] Implementation file created: lib/presentation/home/widgets/[name].dart
[ ] Minimal code to pass test
[ ] Test PASSES: flutter test test/...
    Status: ✅ PASS
```

**Example:**
```dart
// lib/presentation/home/widgets/home_header.dart
class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Kudus, Indonesia');
  }
}
```

- [ ] Implementation written
- [ ] Test passes

#### 3️⃣ REFACTOR - Clean Up

```
[ ] Code refactored while keeping test green
[ ] Added styling/structure
[ ] Test STILL PASSES: flutter test test/...
    Status: ✅ PASS
```

**Example:**
```dart
// lib/presentation/home/widgets/home_header.dart
class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.location_on, color: AppColors.primary),
          const SizedBox(width: 8),
          Text('Kudus, Indonesia'),
        ],
      ),
    );
  }
}
```

- [ ] Refactored
- [ ] Tests still pass

#### 4️⃣ CODE REVIEW

```
Spec Compliance:
  [ ] Meets acceptance criteria
  [ ] Matches design mockup
  [ ] All tests passing

Code Quality:
  [ ] Clear naming
  [ ] No dead code
  [ ] Documented
  [ ] Follows style guide

Testing:
  [ ] Test meaningful (not just passing)
  [ ] Edge cases covered
  [ ] No brittle tests

Style:
  [ ] dart analyze: ZERO issues
  [ ] dart format: Applied
  [ ] No unused imports
```

#### 5️⃣ VERIFICATION

```bash
$ flutter test test/presentation/home/widgets/[name]_test.dart
# Expected: All tests passed ✅

$ dart analyze
# Expected: No issues, no warnings

$ dart format lib/presentation/home/widgets/[name].dart
# Expected: Already formatted

$ flutter build
# Expected: Build successful
```

- [ ] All verifications pass

#### 6️⃣ COMMIT

```bash
git add lib/presentation/home/widgets/[name].dart
git add test/presentation/home/widgets/[name]_test.dart
git commit -m "feat: beranda-XX - [description]"
```

- [ ] Committed

---

## 📋 PHASE 5: INTEGRATION & TESTING

### Component Assembly

- [ ] All components created individually
- [ ] Each component tested in isolation
- [ ] Components work independently ✅

### Integration Testing

```bash
# 1. Assemble all components into HomeDashboardScreen
# 2. Run integrated tests
$ flutter test test/presentation/home/screens/home_dashboard_screen_test.dart

# 3. Manual testing on device/emulator
$ flutter run

# 4. Verify:
# - Layout looks correct
# - Colors match mockup
# - Interactions work
# - No console errors
# - No visual glitches
```

- [ ] All components integrated
- [ ] Manual testing passed
- [ ] Visual appearance matches mockup

### Performance Check

```
[ ] No excessive rebuilds (use Flutter DevTools)
[ ] No memory leaks (check with Observatory)
[ ] Smooth animations (60+ fps)
[ ] App loads quickly
```

- [ ] Performance acceptable

---

## 📋 PHASE 6: FINAL REVIEW & MERGE

### Code Review Checklist

```
COMPLIANCE
  [ ] All acceptance criteria met
  [ ] Matches design document
  [ ] All tests passing
  [ ] No errors in console

QUALITY
  [ ] Zero analyzer issues
  [ ] Code formatted
  [ ] Clear naming
  [ ] Documentation complete
  [ ] No unused code

TESTING
  [ ] All tests present (test-first approach)
  [ ] Edge cases covered
  [ ] Integration tests passing
  [ ] Manual testing passed

PERFORMANCE
  [ ] No memory leaks
  [ ] Smooth animations
  [ ] Quick load times
  [ ] Responsive layout
```

### Final Verification

```bash
# 1. Full test suite
$ flutter test

# 2. Analysis
$ dart analyze

# 3. Build (both debug and release)
$ flutter build apk
$ flutter build ios (if on Mac)

# 4. Manual test scenarios:
  [ ] Open app → Beranda loads correctly
  [ ] All menu items clickable
  [ ] Prayer timer updates every second
  [ ] Search bar works
  [ ] Navigation bar switches screens
  [ ] Theme/colors look right
  [ ] Responsive on different screen sizes
```

- [ ] All verifications passed
- [ ] Ready to merge

### Merge Process

```bash
# 1. Ensure main branch is up to date
git checkout develop
git pull origin develop

# 2. Merge feature branch
git merge feature/beranda-redesign develop

# 3. Push to remote
git push origin develop

# 4. Create PR to main (if needed)
git checkout main
git pull origin main
git merge develop main
git push origin main

# 5. Cleanup
git branch -d feature/beranda-redesign
git push origin --delete feature/beranda-redesign
```

- [ ] Merged to develop
- [ ] Merged to main (if applicable)
- [ ] Feature branch cleaned up

---

## 📊 Progress Tracking

### Task Status Template

```
Task: beranda-01 | Create AppColors
├─ Red Phase: ✅ DONE
├─ Green Phase: ✅ DONE
├─ Refactor Phase: ✅ DONE
├─ Code Review: ✅ PASSED
├─ Verification: ✅ PASSED
├─ Commit: ✅ DONE
└─ Status: ✅ COMPLETE

Task: beranda-02 | Define Typography
├─ Red Phase: ⏳ IN PROGRESS
├─ Green Phase: ⏳ PENDING
├─ Refactor Phase: ⏳ PENDING
├─ Code Review: ⏳ PENDING
├─ Verification: ⏳ PENDING
├─ Commit: ⏳ PENDING
└─ Status: ⏳ IN PROGRESS
```

### Overall Progress

```
Total Tasks: 19
Completed: X
In Progress: Y
Remaining: Z

Completion: XX%

Estimated Time Remaining: X hours
```

---

## 🎯 Success Criteria

Feature is SUCCESSFULLY COMPLETE when:

```
✅ All 19 tasks completed
✅ All tests passing (flutter test)
✅ Zero analyzer issues (dart analyze)
✅ Code formatted (dart format)
✅ No debug code
✅ Documentation complete
✅ Visual matches mockup
✅ Interactions work correctly
✅ Performance acceptable
✅ Merged to main branch
✅ No regressions
✅ Zero critical issues
```

---

## 🚨 Troubleshooting

### If Task Takes Too Long

1. Check if scope is correct
2. Break into smaller subtasks
3. Review test for clarity
4. Ask for help if stuck > 5 min

### If Test Keeps Failing

1. Review test specification
2. Check error message carefully
3. Add debug output
4. Verify test is correct
5. Adjust implementation

### If Merge Conflicts

1. Resolve conflicts manually
2. Run tests after resolving
3. Verify functionality still works
4. Commit merge resolution

---

## 📞 Communication Checkpoints

- [ ] **Before Start:** Show this checklist
- [ ] **After Design:** Share approved spec
- [ ] **After Planning:** Share implementation plan
- [ ] **Per 5 Tasks:** Show progress update
- [ ] **After All Tasks:** Request final review
- [ ] **Before Merge:** Show verification results

---

## 📈 Metrics

Track per session:
- Time spent: ___ hours
- Tasks completed: ___ / 19
- Tests written: ___
- Code coverage: ___% 
- Issues found: ___
- Issues fixed: ___
- Zero-defect delivery: Yes / No

---

## ✅ FINAL CHECKLIST

When feature is ready:

- [ ] All tasks completed
- [ ] All tests passing
- [ ] Code quality verified
- [ ] Manual testing done
- [ ] Visual appearance confirmed
- [ ] Performance acceptable
- [ ] Merged to develop
- [ ] Merged to main
- [ ] Feature branch cleaned
- [ ] Documentation updated
- [ ] No regressions
- [ ] Ready for release

---

**🚀 Ready to Start Implementation!**

Follow this checklist step-by-step and maintain quality throughout.

*Implementation Checklist v1.0*
*For: Beranda Redesign Feature*
*Date: January 29, 2026*
