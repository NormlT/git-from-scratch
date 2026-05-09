# Git From Scratch -- Claude Context

Project context is in `.claude/rules/repo-primer.md`. Coding best practices are in `~/.claude/CLAUDE.md`.

## What This Is

An interactive Git/GitHub learning course. 17 modules organized in 5 parts, each with a lesson, lab exercises, and setup scripts.

## Testing & Verification

**Test command**: n/a -- educational content, no code
**Local dev run**: `python lab.py` -- guided lab runner that talks to OpenRouter (uses the lesson + lab markdown as system prompt)
**Served at**: n/a -- terminal CLI, no HTTP surface
**Verify instance**: n/a -- not a software project

**Gotchas**:
- Not a code project -- skip `/build` verification for this repo entirely.
- The user-facing app is `lab.py`. It is NOT a Claude Code dependency -- learners run it directly with their own OpenRouter API key. Do not reintroduce `/lab` or `/redo` slash commands as the public interface.
- The teaching rules baked into `lab.py`'s `SYSTEM_PROMPT_TEMPLATE` are load-bearing. If you adjust how labs should be guided, change them there too -- otherwise the prompt and the docs drift.

## How to Guide Labs

The single source of truth for lab teaching rules is `SYSTEM_PROMPT_TEMPLATE` in `lab.py` -- that's what the OpenRouter runner actually sends to the model. If you change how labs should be guided, change it there.

The summary below is for ad-hoc IDE requests ("walk me through module 7") that don't go through `lab.py`. Keep it in sync with the prompt; if they drift, the prompt wins.

1. **Be patient** -- the user is learning Git concepts for the first time beyond basic push/pull
2. **Explain the "why"** -- don't just say what a command does, explain why it exists and when you'd use it
3. **Use analogies** -- relate Git concepts to things the user already understands (filesystems, save points, etc.)
4. **Check understanding** -- after key concepts, ask the user to predict what a command will do before running it
5. **Quote pasted output back** -- when the user pastes terminal output, echo the key line in backticks before explaining. Proves you read it.
6. **One command per code block** -- even when `lab.md` groups several into one fence, split them in chat
7. **Celebrate progress** -- acknowledge when exercises are completed correctly
8. **Show the internals** -- when helpful, use `git log --oneline --graph` or `.git/` exploration to show what's happening under the hood

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

## Security & Privacy Rules

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

- No build system, no tests, no CI
- Single Python dependency (`openai` SDK) for the OpenRouter-driven lab runner; everything else is curriculum content
- Setup scripts are intentionally destructive to lab directories (safe, /tmp/)
- MIT License (Copyright 2026 NormlT)
