# Git From Scratch -- Claude Context

## What This Is

An interactive Git/GitHub learning course. 17 modules organized in 5 parts, each with a lesson, lab exercises, and setup scripts.

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
