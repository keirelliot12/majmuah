# AI Agent Skills and Rules (Superpowers)

This directory contains a comprehensive set of skills and rules that serve as reference guidelines for AI agents working on the majmuah project. These skills are based on the [Superpowers framework](https://github.com/obra/superpowers) by Jesse Vincent (obra).

## What Are Superpowers?

Superpowers is a complete software development workflow for coding agents, built on top of a set of composable "skills" that provide structured guidelines for:

- **Test-Driven Development** - Write tests first, always
- **Systematic Debugging** - Process over guessing  
- **Code Review** - Pre-review checklists and feedback handling
- **Planning & Brainstorming** - Design before implementation
- **Complexity Reduction** - Simplicity as primary goal
- **Evidence-Based Work** - Verify before declaring success

## Available Skills

### Core Development Workflow

1. **[brainstorming](skills/brainstorming/)** - Interactive design refinement before any creative work
   - Explores user intent, requirements and design before implementation
   - Refines rough ideas through questions and alternatives
   - Presents design in sections for validation

2. **[writing-plans](skills/writing-plans/)** - Create detailed implementation plans
   - Breaks work into bite-sized tasks (2-5 minutes each)
   - Every task has exact file paths and verification steps
   - Assumes engineer has zero context for the codebase

3. **[executing-plans](skills/executing-plans/)** - Execute plans in batches with checkpoints
   - Load plan, review critically, execute tasks in batches
   - Report for review between batches

4. **[subagent-driven-development](skills/subagent-driven-development/)** - Fast iteration with two-stage review
   - Dispatches fresh subagent per task
   - Two-stage review: spec compliance first, then code quality
   - High quality, fast iteration

### Testing & Quality

5. **[test-driven-development](skills/test-driven-development/)** - RED-GREEN-REFACTOR cycle
   - Write test first, watch it fail, write minimal code, watch it pass
   - Includes testing anti-patterns reference
   - Enforces TDD discipline

6. **[verification-before-completion](skills/verification-before-completion/)** - Ensure it's actually fixed
   - Run verification commands before claiming success
   - Evidence before assertions, always
   - No claiming work complete without proof

### Code Review

7. **[requesting-code-review](skills/requesting-code-review/)** - Pre-review checklist
   - Reviews against plan, reports issues by severity
   - Critical issues block progress
   - Catch issues before they cascade

8. **[receiving-code-review](skills/receiving-code-review/)** - Responding to feedback
   - Technical evaluation, not emotional performance
   - Verify before implementing
   - Reasoned technical discussion

### Debugging

9. **[systematic-debugging](skills/systematic-debugging/)** - 4-phase root cause process
   - Includes root-cause-tracing techniques
   - Defense-in-depth approaches
   - Condition-based-waiting techniques
   - Random fixes waste time and create new bugs

### Collaboration & Tools

10. **[dispatching-parallel-agents](skills/dispatching-parallel-agents/)** - Concurrent subagent workflows
    - When facing 2+ independent tasks
    - Work without shared state or sequential dependencies

11. **[using-git-worktrees](skills/using-git-worktrees/)** - Parallel development branches
    - Creates isolated workspace on new branch
    - Runs project setup, verifies clean test baseline
    - Smart directory selection and safety verification

12. **[finishing-a-development-branch](skills/finishing-a-development-branch/)** - Merge/PR decision workflow
    - Verifies tests, presents options (merge/PR/keep/discard)
    - Cleans up worktree
    - Guides completion of development work

### Meta

13. **[using-superpowers](skills/using-superpowers/)** - Introduction to the skills system
    - Establishes how to find and use skills
    - Core principles and workflow

14. **[writing-skills](skills/writing-skills/)** - Create new skills following best practices
    - TDD applied to process documentation
    - Includes testing methodology

## How to Use These Skills

### For AI Agents

When working on the majmuah project, AI agents should:

1. **Check for relevant skills before any task** - These are mandatory workflows, not suggestions
2. **Load the appropriate skill** - Read the full SKILL.md file for the relevant skill
3. **Follow the skill's guidelines** - The skills provide step-by-step processes
4. **Verify completion** - Use verification-before-completion skill before claiming work is done

### For Developers

These skills serve as:
- **Reference documentation** for AI-assisted development workflows
- **Process guidelines** to ensure consistent quality
- **Best practices** for Flutter development on the majmuah project
- **Debugging procedures** when things go wrong

## The Basic Workflow

1. **Brainstorming** - Activates before writing code. Refines rough ideas through questions.
2. **Using Git Worktrees** - Activates after design approval. Creates isolated workspace.
3. **Writing Plans** - Activates with approved design. Breaks work into tasks.
4. **Subagent-Driven Development or Executing Plans** - Activates with plan. Executes tasks with review.
5. **Test-Driven Development** - Activates during implementation. Enforces RED-GREEN-REFACTOR.
6. **Requesting Code Review** - Activates between tasks. Reviews against plan.
7. **Finishing a Development Branch** - Activates when tasks complete. Verifies and merges.

## Philosophy

- **Test-Driven Development** - Write tests first, always
- **Systematic over ad-hoc** - Process over guessing
- **Complexity reduction** - Simplicity as primary goal
- **Evidence over claims** - Verify before declaring success
- **YAGNI** (You Aren't Gonna Need It) - Don't add unnecessary features
- **DRY** (Don't Repeat Yourself) - Code reusability and maintainability

## Project Context

The majmuah project is a Flutter Islamic app that includes:
- Complete Quran with search functionality
- Prayer times based on location
- Hadith collection
- Azkar and Duas
- Five Pillars of Islam
- YouTube video integration
- Multiple themes and localization (Arabic/English)

When working with these skills, keep the Islamic app context in mind:
- Respect cultural and religious sensitivity
- Maintain Arabic language support
- Ensure prayer time accuracy
- Keep the UI clean and respectful

## Contributing New Skills

To add new skills to this collection:

1. Follow the `writing-skills` skill for creating and testing new skills
2. Create skill in the `skills/` directory following the standard structure
3. Add entry to this README
4. Test the skill before deployment
5. Update the index as needed

## License

The original Superpowers framework is MIT Licensed.
See the [Superpowers repository](https://github.com/obra/superpowers) for details.

## Credits

Skills framework created by [Jesse Vincent (obra)](https://github.com/obra).
Integrated into majmuah project for AI agent guidance.

## Support & Resources

- **Superpowers Repository**: https://github.com/obra/superpowers
- **Original Blog Post**: https://blog.fsck.com/2025/10/09/superpowers/
- **Majmuah Repository**: https://github.com/keirelliot12/majmuah
