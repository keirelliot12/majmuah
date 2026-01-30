# AI Agent Rules & Skills untuk Project An-Nibros

Aturan-aturan dan guidelines untuk memastikan AI Agent bekerja optimal dengan Superpowers methodology.

## 🎯 CORE RULES

### Rule 1: Design Before Code

```
NEVER write code without approved design first.

Workflow:
  1. BRAINSTORM: Ask clarifying questions
  2. DESIGN: Create mockup/specification
  3. APPROVAL: Get stakeholder sign-off
  4. IMPLEMENT: Only then start coding
```

**Implementation:**
- Jika user mention feature, STOP dan brainstorm dulu
- Create design document sebelum any code
- Ask for approval sebelum melanjutkan

### Rule 2: TDD is Mandatory

```
RED → GREEN → REFACTOR

NO EXCEPTIONS:
  ✗ Don't write code before test
  ✗ Don't "adapt" code while testing
  ✗ Don't keep code written before test
  → Delete it. Start over from test.
```

**Implementation:**
- Untuk SETIAP file baru/modifikasi:
  1. Create test file first (test/...)
  2. Write test yang AKAN FAIL
  3. Watch it fail (RED)
  4. Write minimal implementation (GREEN)
  5. Watch it pass
  6. Refactor jika needed (REFACTOR)

### Rule 3: Plan Everything

```
Sebelum implement, buat detailed plan:
- Break feature menjadi bite-sized tasks (2-5 min each)
- Setiap task:
  * Clear acceptance criteria
  * File paths exact
  * Complete code snippets
  * Verification steps
```

**Implementation:**
- Represent plan sebagai structured YAML/JSON
- Setiap task independent & completable
- Tasks ordered by dependencies

### Rule 4: Task-Based Execution

```
Untuk SETIAP task:
  1. Review task specification
  2. Write failing test
  3. Implement minimal code
  4. Code review (spec compliance)
  5. Code review (quality)
  6. Commit dengan message: "feat: task-id - description"
```

**Implementation:**
- Process tasks sequentially (tidak parallel)
- Checkpoint setelah setiap task atau batch
- Human approval untuk proceed

### Rule 5: Code Quality Non-Negotiable

```
BEFORE merging:
  ✓ All tests passing
  ✓ No debug code (print, console.log, debugPrint)
  ✓ Code follows style guide
  ✓ Documentation complete
  ✓ No unused imports
  ✓ Proper error handling
```

**Implementation:**
- Run: `dart analyze` - ZERO errors/warnings
- Run: `dart format` - consistent formatting
- Run: `flutter test` - all passing
- Manual review checklist

---

## 📋 SKILL: Brainstorming for Features

**When:** New feature requested
**Who:** AI Agent (with user clarification)
**Output:** Design Document

### Process

```
1. USER INPUT
   "I want Beranda page like the design"

2. AI BRAINSTORM (Ask questions)
   "I see. Let me understand better:
    Q1: What exactly should appear on Beranda?
    Q2: How should users interact with menu items?
    Q3: What data needs to be real-time?"

3. USER RESPONSE
   [Answers questions]

4. AI DESIGN SYNTHESIS
   "Based on our discussion, here's the design:
   
   Section 1: Header
   - Location: Kudus, Indonesia
   - Hijri date
   - Notification bell
   
   Section 2: Prayer Card
   - Next prayer countdown
   - Dynamic timer
   
   [etc...]"

5. AI PRESENTATION (Chunks)
   Present in 3-4 chunks, ask approval each

6. APPROVAL
   User: "Approved! Please proceed."

7. OUTPUT
   Save as: docs/designs/BERANDA_DESIGN.md
```

### Template Brainstorm Response

```markdown
# Brainstorming: [Feature Name]

## Understanding

From our discussion:
- [Key point 1]
- [Key point 2]
- [Key point 3]

## Proposed Design

### Section 1: [Component]
- [Detail 1]
- [Detail 2]

### Section 2: [Component]
- [Detail 1]
- [Detail 2]

## User Interactions

1. User sees [X]
2. User clicks [Y]
3. System responds [Z]

## Questions for Clarification

- [ ] Is this layout correct?
- [ ] Any missing elements?
- [ ] Performance requirements?

Please review and approve sections 1 by 1.
```

---

## 📋 SKILL: Implementation Planning

**When:** After design approval
**Who:** AI Agent
**Output:** Implementation Plan (YAML format)

### Process

```
1. INPUT: Approved design document

2. DECOMPOSITION: Break into components
   - HomeHeader widget
   - PrayerCountdownCard widget
   - SearchBarWidget widget
   - MenuGrid widget
   - etc

3. TASK GENERATION: Create bite-sized tasks
   Each task:
   - 2-5 minutes to complete
   - Single responsibility
   - Clear success criteria

4. DEPENDENCY ORDERING
   - Base components first
   - Dependencies respected

5. OUTPUT: Implementation plan document
```

### Plan Format (YAML)

```yaml
---
feature: beranda-redesign
estimated_duration: "4 hours"
difficulty: "Medium"

tasks:
  - id: beranda-01
    title: "Create theme colors for gradient"
    component: "Theme Setup"
    files:
      create:
        - lib/app/resources/app_colors.dart
      modify:
        - lib/app/resources/theme.dart
    acceptance_criteria:
      - "AppColors class defined with gradient colors"
      - "Primary: Lemon yellow (#F4F878)"
      - "Secondary: Teal green (#00897B)"
      - "Used in theme.dart"
    test_plan: "Manual verification: colors defined"
    estimated_time: "5 minutes"

  - id: beranda-02
    title: "Create HomeHeader widget with location"
    component: "HomeHeader"
    dependencies: ["beranda-01"]
    files:
      create:
        - lib/presentation/home/widgets/home_header.dart
        - test/presentation/home/widgets/home_header_test.dart
    acceptance_criteria:
      - "Widget displays location icon"
      - "Location text: 'Kudus, Indonesia'"
      - "Icon and text aligned horizontally"
      - "Responsive layout"
    test_plan: |
      Test 1: Find location icon widget
      Test 2: Find location text with correct string
      Test 3: Verify layout responsive
    estimated_time: "10 minutes"

  # ... more tasks
```

---

## 📋 SKILL: Test-First Implementation

**When:** Implementing any feature/bugfix
**Who:** AI Agent
**Output:** Passing tests + Implementation

### The Cycle

```
[RED] → [GREEN] → [REFACTOR]
  ↓        ↓          ↓
Write   Write      Clean up
Failing Minimal    while green
Test    Code

If test fails → Check test correctness
If code doesn't pass → Rethink implementation
If tests pass → Can refactor safely
```

### Step-by-Step

#### 1. RED - Write Failing Test

```dart
// test/presentation/home/widgets/home_header_test.dart

void main() {
  group('HomeHeader', () {
    testWidgets('displays location text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeHeader(),
          ),
        ),
      );

      expect(find.text('Kudus, Indonesia'), findsOneWidget);
    });
  });
}
```

Run test → FAIL ❌

#### 2. GREEN - Write Minimal Implementation

```dart
// lib/presentation/home/widgets/home_header.dart

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Kudus, Indonesia');
  }
}
```

Run test → PASS ✅

#### 3. REFACTOR - Enhance While Keeping Green

```dart
// lib/presentation/home/widgets/home_header.dart

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(Icons.location_on, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            'Kudus, Indonesia',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
```

Run test → STILL PASS ✅

---

## 📋 SKILL: Code Review Checklist

**When:** Before merging any code
**Who:** Human + AI Agent (verification)
**Output:** Approval or request for changes

### Checklist Template

```markdown
## Code Review: [Task ID]

### Spec Compliance
- [ ] All acceptance criteria met
- [ ] Matches design document
- [ ] UI matches mockup
- [ ] All tests passing

### Code Quality
- [ ] No dead code
- [ ] Clear naming (variables, functions, widgets)
- [ ] Proper type hints
- [ ] Error handling present

### Testing
- [ ] All tests written before code
- [ ] Tests are meaningful (not just pass)
- [ ] Edge cases tested
- [ ] Test coverage reasonable

### Style & Standards
- [ ] Follows dart style guide
- [ ] Consistent with project style
- [ ] No unused imports
- [ ] Proper comments for complex logic

### Documentation
- [ ] Classes/functions documented
- [ ] Public API documented
- [ ] Complex logic explained
- [ ] README updated if needed

### Performance
- [ ] No unnecessary rebuilds (if widget)
- [ ] No N+1 queries (if data)
- [ ] Images properly sized
- [ ] No memory leaks

### Issues Found
- [ ] Critical (blocks merge): [list]
- [ ] Major (should fix): [list]
- [ ] Minor (nice to have): [list]

### Verdict
- [ ] APPROVED - Ready to merge
- [ ] CHANGES REQUESTED - Please address above
- [ ] HOLD - Discuss before proceeding
```

---

## 📋 SKILL: Debugging Workflow

**When:** Test fails or bug found
**Who:** AI Agent
**Process:** 4-phase systematic debugging

### Phase 1: Reproduce

```
Goal: Understand EXACTLY when bug occurs

Questions:
  - What's the exact error message?
  - What steps trigger it?
  - Does it always happen?
  - What data causes it?
  - What's the environment?

Output: Reproducible test case or steps
```

### Phase 2: Hypothesize

```
Goal: Identify likely root cause

Techniques:
  1. Root-cause-tracing: Follow code execution path
  2. Defense-in-depth: Check assumptions
  3. Logging: Add strategic print/log statements

Output: "I think the issue is..."
```

### Phase 3: Test Hypothesis

```
Goal: Isolate the exact problem

Techniques:
  1. Minimal reproduction: Smallest code that fails
  2. Binary search: Comment out half the code
  3. Unit test: Test the suspicious code in isolation

Output: Confirmed/rejected hypothesis
```

### Phase 4: Fix

```
Goal: Fix minimal, verify no side effects

Process:
  1. Write test for the bug first
  2. Fix with minimal changes
  3. Run all tests
  4. Code review fix

Output: Bug fixed, all tests passing
```

---

## 🔍 SKILL: Verification Before Completion

**When:** Task marked as "done"
**Who:** AI Agent + Human
**Output:** Confirmed working or needs fixes

### Verification Steps

```
For each completed task:

1. AUTOMATED CHECKS
   [ ] All tests passing: flutter test
   [ ] No lint issues: dart analyze
   [ ] Code formatted: dart format lib/ test/
   [ ] Build succeeds: flutter build

2. MANUAL CHECKS
   [ ] Run app on device/emulator
   [ ] Test user flows from design
   [ ] Check visual appearance vs mockup
   [ ] Test edge cases
   [ ] Test on different screen sizes

3. INTEGRATION CHECKS
   [ ] Does not break existing features
   [ ] Data flows correctly
   [ ] Navigation works
   [ ] Performance acceptable

4. DOCUMENTATION CHECKS
   [ ] Code comments clear
   [ ] README updated
   [ ] Changes documented

Result: VERIFIED ✅ or NEEDS WORK ⚠️
```

---

## 🚀 Execution Guidelines

### For Single Task

```
1. Receive task specification
2. Write test (RED)
3. Watch it fail
4. Write implementation (GREEN)
5. Watch it pass
6. Refactor (REFACTOR)
7. Code review
8. Verify not breaking anything
9. Commit: git commit -m "feat: task-id - description"
10. Move to next task
```

### For Task Batch

```
1. Receive plan with 5-10 tasks
2. For each task: execute Single Task process
3. After batch complete: integration testing
4. Checkpoint: Show progress to human
5. Human approves: Proceed to next batch
6. OR Human blocks: Fix issues in current batch
```

### For Feature Completion

```
1. All tasks complete & verified
2. Run full test suite
3. Manual e2e testing
4. Code review final PR
5. Options:
   a) Merge to main
   b) Create PR for review
   c) Keep on branch
6. Cleanup: delete worktree if applicable
```

---

## 📊 Metrics to Track

Per task:
- ✅ Time to complete
- ✅ Tests written before code: Yes/No
- ✅ Test coverage %
- ✅ Code review issues found
- ✅ Bugs found in testing

Per feature:
- ✅ Total time elapsed
- ✅ Total tasks
- ✅ Tasks completed
- ✅ Zero-defect delivery: Yes/No
- ✅ Rework needed: Yes/No

---

## ⚠️ Anti-Patterns to Avoid

```
❌ DON'T:
  - Write code without test first
  - Commit code that doesn't pass all tests
  - Merge without code review
  - Use print() instead of proper logging
  - Ignore lint warnings
  - Modify multiple components in one task
  - Skip verification steps

✅ DO:
  - Always write test before code
  - Commit only green tests
  - Get approval before merge
  - Use structured logging
  - Fix all warnings
  - Single responsibility per task
  - Verify everything works
```

---

## 🎓 Learning Resources

For AI Agent:
1. Read `SUPERPOWERS_INTEGRATION_GUIDE.md` (in this repo)
2. Study Superpowers repository: https://github.com/obra/superpowers
3. Reference `skills/` directory in Superpowers
4. Review past code reviews in this project

---

## 🔄 Feedback Loop

After each feature:
1. Review what worked
2. Review what didn't
3. Adjust skills/rules if needed
4. Update this document
5. Share learnings with team

---

*Last Updated: January 29, 2026*
*For: An-Nibros Project*
*Version: 1.0*
