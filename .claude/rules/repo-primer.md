# Repository Primer

## What This Repo Is
An interactive Git/GitHub learning course with 17 modules covering foundations through security. Each module has a lesson, lab exercises, and setup scripts.

## Tech Stack
- Markdown for lessons and labs
- Bash scripts for lab setup (create practice repos in /tmp/)
- Python CLI (`lab.py`) that talks to any OpenRouter model for guided walkthroughs

## Structure
- `curriculum/part-N-name/NN-module/` -- lesson.md, lab.md, setup.sh per module
- `progress.md` -- personal checklist tracker (gitignored, copied from `progress.template.md`)
- `lab.py` -- guided lab runner; embeds lesson + lab content as system prompt and chats via OpenRouter
- `requirements.txt` -- pins `openai` SDK used to talk to OpenRouter
- `.env.example` -- placeholders for `OPENROUTER_API_KEY` and `OPENROUTER_MODEL`

## Key Paths
- Lessons: `curriculum/*/*/lesson.md`
- Labs: `curriculum/*/*/lab.md`
- Setup scripts: `curriculum/*/*/setup.sh`
- Progress: `progress.md`
- Runner: `lab.py`
