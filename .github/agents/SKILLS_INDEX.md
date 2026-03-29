# Skills Index

Complete catalog of all available skills with descriptions and use cases.

## Core Workflow Skills

### brainstorming
**File**: [skills/brainstorming/SKILL.md](skills/brainstorming/SKILL.md)

**Description**: You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation.

**When to Use**:
- Before starting any new feature
- Before modifying existing behavior
- Before building new components
- Any time you need to understand requirements better

**Key Outputs**:
- Refined design document
- Clear requirements
- Validated approach

---

### writing-plans
**File**: [skills/writing-plans/SKILL.md](skills/writing-plans/SKILL.md)

**Description**: Use when you have a spec or requirements for a multi-step task, before touching code.

**When to Use**:
- After brainstorming is complete
- When you have clear requirements
- Before starting implementation

**Key Outputs**:
- Bite-sized tasks (2-5 minutes each)
- Exact file paths for each task
- Complete code snippets
- Verification steps

---

### executing-plans
**File**: [skills/executing-plans/SKILL.md](skills/executing-plans/SKILL.md)

**Description**: Use when you have a written implementation plan to execute in a separate session with review checkpoints.

**When to Use**:
- When you have a completed plan
- Want human review between batches
- Need structured execution

**Key Outputs**:
- Batch execution with checkpoints
- Progress reports between batches

---

### subagent-driven-development
**File**: [skills/subagent-driven-development/SKILL.md](skills/subagent-driven-development/SKILL.md)

**Description**: Use when executing implementation plans with independent tasks in the current session.

**When to Use**:
- When you have a plan with independent tasks
- Want fast iteration with quality
- Need two-stage review (spec + quality)

**Key Outputs**:
- High quality implementation
- Fast iteration
- Automatic review process

---

## Testing & Quality Skills

### test-driven-development
**File**: [skills/test-driven-development/SKILL.md](skills/test-driven-development/SKILL.md)

**Description**: Use when implementing any feature or bugfix, before writing implementation code.

**When to Use**:
- **Always** when implementing features
- **Always** when fixing bugs
- **Always** when refactoring
- **Always** when changing behavior

**Key Process**:
1. Write test FIRST
2. Watch it FAIL (RED)
3. Write MINIMAL code
4. Watch it PASS (GREEN)
5. REFACTOR
6. COMMIT

**Additional Resources**:
- [testing-anti-patterns.md](skills/test-driven-development/testing-anti-patterns.md) - What NOT to do

---

### verification-before-completion
**File**: [skills/verification-before-completion/SKILL.md](skills/verification-before-completion/SKILL.md)

**Description**: Use when about to claim work is complete, fixed, or passing, before committing or creating PRs.

**When to Use**:
- Before claiming work complete
- Before committing changes
- Before creating PRs
- Before reporting success

**Key Principle**: Evidence before assertions, always.

---

## Code Review Skills

### requesting-code-review
**File**: [skills/requesting-code-review/SKILL.md](skills/requesting-code-review/SKILL.md)

**Description**: Use when completing tasks, implementing major features, or before merging to verify work meets requirements.

**When to Use**:
- Between implementation tasks
- After major features
- Before merging
- When uncertain about quality

**Key Outputs**:
- Issues by severity (Critical/Important/Minor)
- Review against plan
- Blockers identified

---

### receiving-code-review
**File**: [skills/receiving-code-review/SKILL.md](skills/receiving-code-review/SKILL.md)

**Description**: Use when receiving code review feedback, before implementing suggestions, especially if feedback seems unclear or technically questionable.

**When to Use**:
- After receiving review feedback
- Before implementing suggestions
- When feedback seems unclear

**Key Process**:
1. READ complete feedback
2. UNDERSTAND requirement
3. VERIFY against codebase
4. EVALUATE technical soundness
5. RESPOND with technical reasoning
6. IMPLEMENT one item at a time

---

## Debugging Skills

### systematic-debugging
**File**: [skills/systematic-debugging/SKILL.md](skills/systematic-debugging/SKILL.md)

**Description**: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes.

**When to Use**:
- Any bug
- Test failures
- Unexpected behavior
- **Before** proposing fixes

**Key Process**:
1. OBSERVE: What actually happens?
2. HYPOTHESIZE: Why might this happen?
3. TEST: Run experiment
4. VERIFY: Did it work?

**Additional Resources**:
- Root-cause-tracing techniques
- Defense-in-depth approaches
- Condition-based-waiting techniques

---

## Collaboration Skills

### dispatching-parallel-agents
**File**: [skills/dispatching-parallel-agents/SKILL.md](skills/dispatching-parallel-agents/SKILL.md)

**Description**: Use when facing 2+ independent tasks that can be worked on without shared state or sequential dependencies.

**When to Use**:
- Multiple unrelated failures
- Different test files
- Different subsystems
- Different bugs

**Key Benefit**: Parallel investigation saves time.

---

### using-git-worktrees
**File**: [skills/using-git-worktrees/SKILL.md](skills/using-git-worktrees/SKILL.md)

**Description**: Use when starting feature work that needs isolation from current workspace or before executing implementation plans.

**When to Use**:
- Starting feature work
- Need isolated workspace
- Before executing plans

**Key Outputs**:
- Isolated git worktree
- New branch
- Clean test baseline

---

### finishing-a-development-branch
**File**: [skills/finishing-a-development-branch/SKILL.md](skills/finishing-a-development-branch/SKILL.md)

**Description**: Use when implementation is complete, all tests pass, and you need to decide how to integrate the work.

**When to Use**:
- Implementation complete
- All tests pass
- Ready to integrate

**Key Outputs**:
- Merge/PR decision
- Cleanup
- Integration plan

---

## Meta Skills

### using-superpowers
**File**: [skills/using-superpowers/SKILL.md](skills/using-superpowers/SKILL.md)

**Description**: Use when starting any conversation - establishes how to find and use skills.

**When to Use**:
- Starting any conversation
- Need to understand skills system
- First time using superpowers

**Key Principle**: If a skill applies, you MUST use it. Not optional.

---

### writing-skills
**File**: [skills/writing-skills/SKILL.md](skills/writing-skills/SKILL.md)

**Description**: Use when creating new skills, editing existing skills, or verifying skills work before deployment.

**When to Use**:
- Creating new skills
- Editing existing skills
- Verifying skills

**Key Principle**: Writing skills IS Test-Driven Development applied to process documentation.

**Additional Resources**:
- [TESTING.md](skills/writing-skills/TESTING.md) - Testing methodology for skills
- [examples/](skills/writing-skills/examples/) - Example skills

---

## Skills by Use Case

### Starting New Work
1. [using-superpowers](skills/using-superpowers/SKILL.md) - Understand the system
2. [brainstorming](skills/brainstorming/SKILL.md) - Refine requirements
3. [writing-plans](skills/writing-plans/SKILL.md) - Create detailed plan
4. [using-git-worktrees](skills/using-git-worktrees/SKILL.md) - Isolated workspace

### Implementation
1. [test-driven-development](skills/test-driven-development/SKILL.md) - TDD cycle
2. [executing-plans](skills/executing-plans/SKILL.md) OR [subagent-driven-development](skills/subagent-driven-development/SKILL.md) - Execute plan
3. [systematic-debugging](skills/systematic-debugging/SKILL.md) - Fix issues

### Quality Assurance
1. [verification-before-completion](skills/verification-before-completion/SKILL.md) - Verify work
2. [requesting-code-review](skills/requesting-code-review/SKILL.md) - Get review
3. [receiving-code-review](skills/receiving-code-review/SKILL.md) - Handle feedback

### Completion
1. [verification-before-completion](skills/verification-before-completion/SKILL.md) - Final check
2. [finishing-a-development-branch](skills/finishing-a-development-branch/SKILL.md) - Merge/cleanup

## Alphabetical Index

- [brainstorming](skills/brainstorming/SKILL.md)
- [dispatching-parallel-agents](skills/dispatching-parallel-agents/SKILL.md)
- [executing-plans](skills/executing-plans/SKILL.md)
- [finishing-a-development-branch](skills/finishing-a-development-branch/SKILL.md)
- [receiving-code-review](skills/receiving-code-review/SKILL.md)
- [requesting-code-review](skills/requesting-code-review/SKILL.md)
- [subagent-driven-development](skills/subagent-driven-development/SKILL.md)
- [systematic-debugging](skills/systematic-debugging/SKILL.md)
- [test-driven-development](skills/test-driven-development/SKILL.md)
- [using-git-worktrees](skills/using-git-worktrees/SKILL.md)
- [using-superpowers](skills/using-superpowers/SKILL.md)
- [verification-before-completion](skills/verification-before-completion/SKILL.md)
- [writing-plans](skills/writing-plans/SKILL.md)
- [writing-skills](skills/writing-skills/SKILL.md)

---

*For quick lookup, see [QUICK_REFERENCE.md](QUICK_REFERENCE.md)*
