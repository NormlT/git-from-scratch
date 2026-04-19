# Git From Scratch -- Claude Context

## What This Is

An interactive Git/GitHub learning course. 17 modules organized in 5 parts, each with a lesson, lab exercises, and setup scripts.

## Testing & Verification

**Test command**: n/a -- educational content, no code
**Local dev run**: n/a -- no code to run; use Claude Code `/lab` mode to walk through modules
**Served at**: n/a
**Verify instance**: n/a -- not a software project

**Gotchas**: Not a code project -- skip `/build` verification for this repo entirely.

## How to Guide Labs

When guiding a user through labs (via `/lab` or direct requests):

1. **Be patient** -- the user is learning Git concepts for the first time beyond basic push/pull
2. **Explain the "why"** -- don't just say what a command does, explain why it exists and when you'd use it
3. **Use analogies** -- relate Git concepts to things the user already understands (filesystems, save points, etc.)
4. **Check understanding** -- after key concepts, ask the user to predict what a command will do before running it
5. **Celebrate progress** -- acknowledge when exercises are completed correctly
6. **Show the internals** -- when helpful, use `git log --oneline --graph` or `.git/` exploration to show what's happening under the hood

## State Tracking

- `progress.md` tracks which modules are complete (checked boxes)
- Each module lives in `curriculum/part-N-name/NN-module-name/`
- Labs create temporary directories in `/tmp/git-lab-NN/`

## Lab Flow

1. Read the module's `lab.md` for exercise instructions
2. Run `bash setup.sh` to create the practice environment
3. Guide the user through each numbered exercise
4. Verify outcomes match expected results
5. Update `progress.md` when complete

## Important Notes

- Never modify the user's real repositories during labs
- All practice happens in `/tmp/` directories
- Setup scripts are idempotent -- safe to re-run
- GitHub platform labs (Part 4) may use the `gh` CLI or GitHub web UI

## Privacy

This is a public repository. Do not write personal information (real names, emails, usernames, home directory paths) into any tracked file. Use generic placeholders in all examples and documentation.

## Code Quality & Review Requirements

Before ANY commit or push:
1. Use the `compound-engineering:ce-review` skill for review of content changes
2. Use `differential-review:differential-review` for review before pushing

## Mandatory Skills & Agents

### Always Use
- **superpowers:verification-before-completion** -- verify bash scripts run correctly before claiming done
- **compound-engineering:git-commit** -- consistent commit messages

### When Applicable
- **compound-engineering:document-review** -- for educational content quality, coherence, and pedagogical completeness
- **correctness-reviewer** (agent) -- setup scripts must work correctly (create temp repos, git operations)
- **project-standards-reviewer** (agent) -- all 17 modules must follow consistent structure (lesson.md, lab.md, setup.sh)

## Content Rules

- Each module MUST have: lesson.md, lab.md, setup.sh
- Setup scripts create isolated practice repos in /tmp/git-lab-NN/
- Labs must include verification steps and quizzes
- NEVER write personal information (real names, emails, usernames, home directory paths) into tracked files
- Use generic placeholders in all examples and documentation
- GitHub platform labs (05, 11, 12, 13, 14, 16) require gh CLI authentication -- document this clearly

## Project-Specific Conventions

- No build system, no tests, no package manager, no CI
- Content is curriculum, not application code
- Setup scripts are intentionally destructive to lab directories (safe, /tmp/)
- MIT License (Copyright 2026 NormlT)
