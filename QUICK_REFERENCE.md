# Quick Reference: AI Agent Skills & Rules

**Ringkasan cepat untuk digunakan saat development**

---

## 🎯 THE GOLDEN RULE

```
TEST FIRST. CODE SECOND.
NO EXCEPTIONS.

RED → GREEN → REFACTOR
```

---

## ✅ QUICK CHECKLIST: Before Starting Any Task

- [ ] Task specification clear?
- [ ] Test file created?
- [ ] Ready to write failing test?
- [ ] Understand acceptance criteria?

---

## 📝 TASK EXECUTION FLOW

```
1️⃣ READ SPEC
   └─ Understand what, why, how

2️⃣ WRITE FAILING TEST
   └─ Test what you want to build
   └─ Run it → see FAIL ❌

3️⃣ WRITE MINIMAL CODE
   └─ Minimal to make test pass
   └─ Run test → see PASS ✅

4️⃣ REFACTOR
   └─ Clean up while tests green
   └─ Run tests → still PASS ✅

5️⃣ CODE REVIEW
   └─ Spec compliance? Y/N
   └─ Code quality? Y/N
   └─ Tests meaningful? Y/N

6️⃣ FINAL VERIFICATION
   ✓ dart analyze = ZERO issues
   ✓ flutter test = ALL PASS
   ✓ No debug code
   ✓ Ready to merge
```

---

## 🔴 RED Phase

**Goal:** Write a test that FAILS

```dart
// test/presentation/home/widgets/my_widget_test.dart

void main() {
  testWidgets('describes what widget should do', (tester) async {
    // Setup
    await tester.pumpWidget(MaterialApp(home: MyWidget()));
    
    // Assert the desired behavior
    expect(find.text('Expected Text'), findsOneWidget);
  });
}
```

Run: `flutter test`
Result: ❌ FAILS (as expected!)

---

## 🟢 GREEN Phase

**Goal:** Write minimal code to make test PASS

```dart
// lib/presentation/my_widget.dart

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Expected Text');
  }
}
```

Run: `flutter test`
Result: ✅ PASSES!

---

## 🔵 REFACTOR Phase

**Goal:** Clean up while keeping tests green

```dart
// lib/presentation/my_widget.dart

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text('Expected Text'),
      ),
    );
  }
}
```

Run: `flutter test`
Result: ✅ STILL PASSES!

---

## ❌ ANTI-PATTERNS

```
DON'T:
  ❌ Write code without test first
  ❌ Write implementation then test
  ❌ Use print() for debugging (use logging)
  ❌ Ignore warnings (dart analyze)
  ❌ Skip verification steps
  ❌ Commit failing tests
  ❌ Leave debug code in production

DO:
  ✅ Test first, always
  ✅ Test describes behavior
  ✅ Minimal implementation
  ✅ Refactor with safety net
  ✅ Clean code before commit
  ✅ All tests passing
  ✅ Zero warnings
```

---

## 🧪 Common Test Patterns

### Test Widget Appearance
```dart
testWidgets('displays text', (tester) async {
  await tester.pumpWidget(MaterialApp(home: MyWidget()));
  expect(find.text('My Text'), findsOneWidget);
});
```

### Test User Interaction
```dart
testWidgets('button tap triggers action', (tester) async {
  await tester.pumpWidget(MaterialApp(home: MyWidget()));
  await tester.tap(find.byIcon(Icons.edit));
  expect(find.text('Edited'), findsOneWidget);
});
```

### Test List Items
```dart
testWidgets('shows list items', (tester) async {
  await tester.pumpWidget(MaterialApp(home: MyWidget()));
  expect(find.byType(ListTile), findsNWidgets(3));
});
```

### Test Navigation
```dart
testWidgets('navigates to next screen', (tester) async {
  await tester.pumpWidget(MaterialApp(home: MyWidget()));
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
  expect(find.byType(NextScreen), findsOneWidget);
});
```

---

## 📊 Code Review Checklist

```
☐ All tests passing?
☐ Zero analyzer errors?
☐ Code formatted?
☐ No debug code (print, debugPrint)?
☐ Functions/classes documented?
☐ Clear variable names?
☐ Error handling present?
☐ No unused imports?
☐ Performance reasonable?
☐ Follows project style?
```

---

## 🐛 Debugging Approach

**If something fails:**

```
1. REPRODUCE
   └─ Can you consistently fail the test?
   
2. ISOLATE
   └─ Minimal code that demonstrates problem?
   
3. HYPOTHESIZE
   └─ What do you think is wrong?
   
4. TEST HYPOTHESIS
   └─ Write test that confirms/denies it
   
5. FIX
   └─ Fix minimal change
   └─ Verify tests pass
```

---

## 📋 File Organization

```
lib/presentation/home/widgets/
  ├─ home_header.dart
  ├─ prayer_countdown_card.dart
  ├─ search_bar_widget.dart
  └─ menu_grid.dart

test/presentation/home/widgets/
  ├─ home_header_test.dart
  ├─ prayer_countdown_card_test.dart
  ├─ search_bar_widget_test.dart
  └─ menu_grid_test.dart
```

**Rule:** Test file path mirrors lib file path, with `_test` suffix

---

## 🏃 Quick Commands

```bash
# Run specific test
flutter test test/presentation/home/widgets/home_header_test.dart

# Run all tests
flutter test

# Run tests with watch mode
flutter test --watch

# Analyze code
dart analyze

# Format code
dart format lib/ test/

# Check for unused code
dart analyze --suggestions

# Build app
flutter build
```

---

## 💾 Git Workflow

```bash
# Create feature branch
git checkout -b feature/beranda-redesign develop

# After each task
git add lib/presentation/home/widgets/my_widget.dart
git add test/presentation/home/widgets/my_widget_test.dart
git commit -m "feat: task-id - Description of what was implemented"

# Push when done
git push origin feature/beranda-redesign

# Create PR for review
# ... review & approve ...

# Merge when approved
git merge feature/beranda-redesign develop
```

---

## 🎯 Task Template

```markdown
# Task: [ID] - [Title]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Files
- Create: [list]
- Modify: [list]

## Verification
- [ ] Test written first
- [ ] Test fails initially
- [ ] Implementation complete
- [ ] Test passes
- [ ] Code review passed
- [ ] dart analyze: ZERO issues
- [ ] Ready to commit
```

---

## 🚀 Priority Order

When multiple issues exist:

1. **CRITICAL** - App doesn't compile/crash
2. **BLOCKING** - Feature doesn't work
3. **MAJOR** - Significant bug/issue
4. **MINOR** - Code style, optimization
5. **NICE-TO-HAVE** - Enhancement

Address in this order.

---

## 📞 When to Ask for Help

Ask when:
- ✅ Spec is unclear
- ✅ Task scope wrong
- ✅ Stuck for > 5 minutes
- ✅ Need design decision
- ✅ Conflicting requirements
- ✅ Technical blocker

Include:
- What you're trying to do
- What you've tried
- Error messages
- Proposed solution

---

## ✨ Success Criteria

**Feature is DONE when:**

```
✅ All tests written before code
✅ All tests passing
✅ Zero analyzer warnings
✅ Code formatted consistently
✅ No debug code
✅ Documentation complete
✅ Code review approved
✅ Merged to main branch
✅ No regressions
✅ Performance acceptable
```

---

## 📚 Reference Files

Located in project root:

- `SUPERPOWERS_INTEGRATION_GUIDE.md` - Full methodology
- `AI_AGENT_RULES_AND_SKILLS.md` - Detailed rules
- `SYSTEM_PROMPT_FOR_AI_AGENT.md` - System instructions
- `QUICK_REFERENCE.md` - This file!

---

## 🎓 Key Principles

| Principle | Application |
|-----------|-------------|
| Test First | Write test before any code |
| Minimal Code | Only what's needed to pass test |
| Atomic Commits | Each commit is one complete task |
| Code Review | Every change reviewed |
| Zero Tolerance | No exceptions to rules |
| Verification | Test before marking done |
| Documentation | Code is self-documenting + comments |
| Simplicity | Choose simple over complex |

---

## 🔄 The Loop

```
TASK SPEC
    ↓
WRITE TEST
    ↓ (FAILS ❌)
IMPLEMENT CODE
    ↓ (PASSES ✅)
REFACTOR
    ↓ (STILL ✅)
CODE REVIEW
    ↓
COMMIT
    ↓
NEXT TASK
```

**Repeat until feature complete.**

---

## 💡 Pro Tips

1. **Read tests like documentation** - They show how to use code
2. **Test edge cases** - Boundary conditions catch bugs
3. **One assertion per test** - Clear what fails
4. **Descriptive test names** - Read like documentation
5. **DRY in tests** - Use setUp, helper functions
6. **Mock external dependencies** - Test in isolation
7. **Verify fixes** - Write test BEFORE fixing bug
8. **Refactor safely** - Tests prove nothing broke

---

## 🚨 SOS

If completely stuck:

```
STOP
├─ Don't panic
├─ Read error message completely
├─ Check specification again
├─ Review this reference
├─ Try systematic debugging
├─ Ask for help if still stuck
└─ Document issue clearly
```

---

**Remember:** 
- ✅ Test first, always
- ✅ Keep it simple
- ✅ Ask questions
- ✅ Verify everything
- ✅ Never compromise quality

**You've got this! 🚀**

Project ini menggunakan dependency MODERN: flutter_bloc v8.1.6, intl v0.20.2, dan wakelock_plus. Gunakan syntax yang kompatibel dengan versi tersebut. JANGAN gunakan syntax lama (deprecated) dari intl v0.18 kebawah.

---

*Quick Reference v1.0*
*Last Updated: January 29, 2026*
