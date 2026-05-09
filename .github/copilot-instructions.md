# Copilot Instructions for git-from-scratch

## What this repository does
- This is a hands-on Git and GitHub course, not a general application codebase.
- The course has 17 modules across five parts. Each module combines a short lesson, a lab, and a setup script that creates a disposable practice repository.
- The main guided experience is the Python CLI `lab.py`, which talks to any model on OpenRouter to walk the learner through each lab. Every lab also works as plain markdown without the CLI.

## Architecture hotspots
- `README.md` -- public course overview, prerequisites, and supported workflows.
- `lab.py` -- guided lab runner. Loads `progress.md`, picks the next module, and chats with an OpenRouter model that has the lesson + lab content embedded in its system prompt.
- `requirements.txt` -- pins the `openai` SDK that `lab.py` uses (OpenRouter is OpenAI-compatible).
- `.env.example` -- placeholder file for `OPENROUTER_API_KEY` and `OPENROUTER_MODEL`. Learners copy it to `.env`, which is gitignored.
- `curriculum/part-*/NN-*/lesson.md` -- concept explanation for each module.
- `curriculum/part-*/NN-*/lab.md` -- numbered exercises, verification steps, and quizzes.
- `curriculum/part-*/NN-*/setup.sh` -- bash setup scripts that build the practice repos in `/tmp/git-lab-NN/`.
- `progress.template.md` -- local checklist template; learners copy it to `progress.md` and keep it untracked.

## Commands that exist
Run these from the repository root unless noted otherwise:

```bash
cp progress.template.md progress.md
pip install -r requirements.txt
cp .env.example .env  # then fill in OPENROUTER_API_KEY and OPENROUTER_MODEL
python lab.py
python lab.py 04
python lab.py redo
python lab.py redo course
bash curriculum/part-1-foundations/01-what-is-git/setup.sh
```

There is no build, lint, test, package manager, or CI workflow in this repository.

## Environment and runtime caveats
- Labs require a bash-compatible shell. Git Bash, WSL, or macOS/Linux terminals are supported; PowerShell and `cmd.exe` are not.
- Setup scripts are intentionally destructive to the lab directory and recreate `/tmp/git-lab-NN/` from scratch.
- Modules 05, 11, 12, 13, 14, and 16 require a GitHub account plus `gh auth login`; the rest work offline.
- The guided runner needs Python 3.9+ and an OpenRouter key. The model name follows OpenRouter's `provider/model-name` convention (e.g. `google/gemini-3-flash-preview`).
- This is a public repo. Do not add real names, emails, usernames, or machine-specific paths to tracked files.

## Conventions for future coding agents
- Treat the repo as curriculum content. Prefer changes to lessons, labs, and setup scripts over adding new tooling.
- Keep each module self-contained: `lesson.md`, `lab.md`, and `setup.sh` should still make sense together.
- Preserve the teaching style baked into `lab.py`'s system prompt: explain the why, ask for predictions, and verify outcomes. If you change those rules, change them in `lab.py` too.
- In learner-facing docs, prefer one command per code block and show complete copy-pasteable commands.
- Keep setup scripts idempotent and safe with `set -euo pipefail`.
- Never direct practice work into a learner's real repositories; all exercises should stay in temporary lab directories.
