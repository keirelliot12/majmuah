# AI Agent Skills Quick Reference

A quick lookup guide for AI agents working on the majmuah project.

## Core Principle

**IF A SKILL APPLIES TO YOUR TASK, YOU MUST USE IT.**

These are mandatory workflows, not suggestions.

## Quick Skill Selector

### Before You Start Any Work
- **Starting a conversation?** → [using-superpowers](skills/using-superpowers/)
- **New feature or modification?** → [brainstorming](skills/brainstorming/)
- **Need to understand the skills system?** → [using-superpowers](skills/using-superpowers/)

### Planning Phase
- **Have a spec/requirements?** → [writing-plans](skills/writing-plans/)
- **Need isolated workspace?** → [using-git-worktrees](skills/using-git-worktrees/)
- **Multiple independent tasks?** → [dispatching-parallel-agents](skills/dispatching-parallel-agents/)

### Implementation Phase
- **Implementing anything?** → [test-driven-development](skills/test-driven-development/)
- **Executing a plan?** → [executing-plans](skills/executing-plans/) OR [subagent-driven-development](skills/subagent-driven-development/)
- **Bug or test failure?** → [systematic-debugging](skills/systematic-debugging/)

### Review Phase
- **Completing a task?** → [requesting-code-review](skills/requesting-code-review/)
- **Received feedback?** → [receiving-code-review](skills/receiving-code-review/)
- **About to claim work complete?** → [verification-before-completion](skills/verification-before-completion/)

### Finishing Phase
- **All tasks done?** → [finishing-a-development-branch](skills/finishing-a-development-branch/)
- **Tests passing?** → [verification-before-completion](skills/verification-before-completion/)

### Meta Tasks
- **Creating a new skill?** → [writing-skills](skills/writing-skills/)

## Mandatory Workflow

```
1. Brainstorming (design)
   ↓
2. Using Git Worktrees (isolation)
   ↓
3. Writing Plans (detailed tasks)
   ↓
4. Subagent-Driven Development OR Executing Plans (implementation)
   ↓
5. Test-Driven Development (RED-GREEN-REFACTOR)
   ↓
6. Requesting Code Review (between tasks)
   ↓
7. Finishing a Development Branch (merge/cleanup)
```

## The Iron Laws

### Test-Driven Development
```
1. Write test FIRST
2. Watch it FAIL (RED)
3. Write MINIMAL code to pass
4. Watch it PASS (GREEN)
5. REFACTOR if needed
6. COMMIT
```

### Code Review
```
1. READ: Complete feedback without reacting
2. UNDERSTAND: Restate requirement
3. VERIFY: Check against codebase
4. EVALUATE: Technically sound?
5. RESPOND: Technical acknowledgment or pushback
6. IMPLEMENT: One item at a time
```

### Debugging
```
1. OBSERVE: What actually happens?
2. HYPOTHESIZE: Why might this happen?
3. TEST: Run experiment
4. VERIFY: Did it work?
```

### Verification
```
NEVER claim work is complete without:
1. Running the actual commands
2. Seeing the actual output
3. Confirming actual success
```

## Common Pitfalls to Avoid

❌ **DON'T:**
- Skip brainstorming and jump into code
- Write code before tests
- Claim work complete without verification
- Test mock behavior instead of real behavior
- Ignore relevant skills
- Add features you weren't asked for (YAGNI)
- Make random fixes without systematic debugging

✅ **DO:**
- Check for relevant skills first
- Load and follow the skill's guidelines
- Write tests before implementation (TDD)
- Verify before claiming completion
- Keep changes minimal (DRY)
- Think systematically about problems
- Ask questions when uncertain

## Project-Specific Context

### Majmuah (Flutter Islamic App)
- **Language**: Dart/Flutter
- **Architecture**: Clean Architecture with Cubit state management
- **Platform**: Android, iOS, Linux Desktop, Web
- **Key Features**: Quran, Prayer Times, Hadith, Azkar
- **Cultural Sensitivity**: Handle Islamic content respectfully

### Build & Test Commands
```bash
# Run the app
./flutter-commands.sh run

# Build for release
./flutter-commands.sh build

# Run tests
./flutter-commands.sh test

# Clean and rebuild
./flutter-commands.sh clean
```

## Emergency Checklist

When stuck or unsure:

1. ☐ Have I checked if a skill applies?
2. ☐ Have I loaded and read the full skill?
3. ☐ Am I following the skill's process?
4. ☐ Have I written tests first? (if implementing)
5. ☐ Have I verified my work? (if claiming completion)
6. ☐ Am I keeping changes minimal?
7. ☐ Have I asked the human if unclear?

## Skill File Structure

Each skill directory contains:
- `SKILL.md` - Main skill documentation (start here)
- Additional reference files (e.g., anti-patterns, templates, examples)

## How to Read a Skill

1. Look for the YAML frontmatter (name, description)
2. Read the Overview section
3. Follow the step-by-step process
4. Check for special notes or warnings
5. Review any referenced files in the skill directory

## Getting Help

- **For skill usage**: Read the full SKILL.md file
- **For project context**: See main README.md
- **For setup issues**: See QUICK_START.md
- **For AI agents**: If uncertain, ask your human partner

---

*Remember: These skills exist to help you work faster and better. Use them!*
