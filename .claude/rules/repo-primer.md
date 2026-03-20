# Repository Primer

## What This Repo Is
An interactive Git/GitHub learning course with 17 modules covering foundations through security. Each module has a lesson, lab exercises, and setup scripts.

## Tech Stack
- Markdown for lessons and labs
- Bash scripts for lab setup (create practice repos in /tmp/)
- Claude Code slash command (`/lab`) for guided walkthroughs

## Structure
- `curriculum/part-N-name/NN-module/` -- lesson.md, lab.md, setup.sh per module
- `progress.md` -- personal checklist tracker
- `.claude/commands/lab.md` -- interactive lab guide slash command

## Key Paths
- Lessons: `curriculum/*/*/lesson.md`
- Labs: `curriculum/*/*/lab.md`
- Setup scripts: `curriculum/*/*/setup.sh`
- Progress: `progress.md`
