# Git From Scratch -- Zero to Hero

[![Version](https://img.shields.io/badge/version-v2.0.0-blue.svg)](https://github.com/clatter971/git-from-scratch/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Course coverage](https://img.shields.io/badge/modules%20verified-17%2F17-brightgreen.svg)](#what-does-it-cost)

A hands-on Git course with 17 modules -- short lessons followed by labs where you actually practice on real repos. The labs are designed to be guided by an AI instructor running through [OpenRouter](https://openrouter.ai/): run `python lab.py` in your terminal and the model walks you through each exercise, explains commands before you run them, and helps you fix things when you mess up.

You don't need OpenRouter to use this -- every lab is a self-contained markdown file you can follow on your own. But the guided mode is the main way the course works best.

> **Tested end-to-end across all 17 modules** on a flash-lite tier model (the cheapest OpenRouter offers). Total course cost: **$0.40 measured**. See [What does it cost?](#what-does-it-cost) for the full breakdown.

Free, open source, just clone and go.

## Why this exists

I was using Git daily but didn't actually understand what I was doing. I kept Googling the same things and copy-pasting commands. So I built this to force myself to learn it properly.

The AI integration is there because the biggest pain point when learning Git is screwing up a command and ending up in some weird state with no idea how to get out. With OpenRouter you can plug in any model you like (Gemini, Claude, GPT, open-source models, whatever) and have it walk you through fixing it, which removes a lot of the guesswork. You can also ask questions mid-exercise and get answers that reference the actual lab you're working in, not generic explanations.

## Prerequisites

| Tool | Check | Install guide |
|------|-------|---------------|
| **Git** | `git --version` | [git-scm.com/downloads](https://git-scm.com/downloads) |
| **Bash terminal** | `bash --version` | See [terminal setup](#terminal-setup) below |
| **Python 3.9+** | `python --version` | [python.org/downloads](https://www.python.org/downloads/) |
| **GitHub account** | -- | [github.com/signup](https://github.com/signup) |
| **GitHub CLI** | `gh --version` | [cli.github.com](https://cli.github.com/) |
| **OpenRouter API key** | -- | [openrouter.ai/keys](https://openrouter.ai/keys) -- needed for the guided lab experience |

### GitHub connection

Several labs (05, 11, 12, 13, 14, 16) create temporary repositories on GitHub to practice pull requests, issues, actions, and other platform features. These labs require:

1. A **GitHub account** -- [sign up here](https://github.com/signup) if you don't have one
2. The **GitHub CLI (`gh`) installed** -- [cli.github.com](https://cli.github.com/)
3. The **CLI authenticated** to your account -- run `gh auth login` and follow the prompts
4. The **`delete_repo` scope** on your token (needed to clean up practice repos) -- run `gh auth refresh -h github.com -s delete_repo`

You can verify your connection with:

```bash
gh auth status
```

> **No GitHub account?** Modules 01-04, 06-10, 15, and 17 work entirely offline with local Git -- no account needed. You can complete those first and set up GitHub when you're ready.

### Terminal setup

The setup scripts and lab exercises use **bash**. This works out of the box on macOS and Linux. Windows users need one of the following:

- **Git Bash** (recommended) -- included when you install [Git for Windows](https://gitforwindows.org/). Open "Git Bash" from the Start menu.
- **WSL (Windows Subsystem for Linux)** -- run `wsl --install` in PowerShell, then open the Ubuntu terminal. [Microsoft WSL guide](https://learn.microsoft.com/en-us/windows/wsl/install).
- **VS Code terminal** -- if you have Git for Windows installed, configure VS Code to use Git Bash as the default terminal.

> **Note:** PowerShell and cmd.exe are not supported. The setup scripts use bash syntax (heredocs, `/tmp/` paths, `set -euo pipefail`) that requires a bash-compatible shell.

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/clatter971/git-from-scratch.git
cd git-from-scratch
```

### 2. Create your progress tracker

```bash
cp progress.template.md progress.md
```

This file tracks which modules you have completed. It is listed in `.gitignore` so it stays local to your machine.

### 3. (Guided mode) Install Python deps and configure OpenRouter

Skip this step if you only plan to follow the labs as plain markdown.

You need Python 3.9+ and one Python package (`openai`, used for OpenRouter's OpenAI-compatible endpoint). Pick **one** of the install paths below.

**Option A — `uv` (fastest, recommended):**

```bash
uv venv
uv pip install -r requirements.txt
```

Then run the lab with `uv run python lab.py` (or activate the venv: `source .venv/bin/activate` and use plain `python lab.py`).

If you don't have `uv` yet: `curl -LsSf https://astral.sh/uv/install.sh | sh` (macOS/Linux) or see [docs.astral.sh/uv](https://docs.astral.sh/uv/getting-started/installation/).

**Option B — standard venv + pip:**

```bash
python3 -m venv .venv
source .venv/bin/activate     # macOS/Linux/WSL
# or:  .venv\Scripts\activate  # Windows (Git Bash: source .venv/Scripts/activate)
pip install -r requirements.txt
```

> **Why a venv?** On modern Linux (Ubuntu 23.04+, Debian 12+, Fedora 38+) running plain `pip install` outside a venv fails with PEP 668 ("externally-managed environment"). The venv keeps the dependency local to this project and avoids touching system Python.

**Then configure OpenRouter:**

```bash
cp .env.example .env
```

Open `.env` in any text editor and fill in:

```dotenv
OPENROUTER_API_KEY=sk-or-v1-your-key-here
OPENROUTER_MODEL=google/gemini-3-flash-preview
```

`.env` is gitignored, so your key never gets committed. Get a key at [openrouter.ai/keys](https://openrouter.ai/keys). You can pick any model from [openrouter.ai/models](https://openrouter.ai/models) -- always in `provider/model-name` form.

#### Which model should I pick?

Any model that handles long, structured instructions and stays patient across many turns will work. From actually running the course end-to-end, four tiers stand out:

| Tier | Model string | Why pick it |
|------|--------------|-------------|
| **Cheapest *(verified — full course passes)*** | `google/gemini-3.1-flash-lite-preview` | The full 17-module sweep was driven against this model and all 17 modules completed cleanly. ~2s/turn, total course cost **$0.40**. |
| **Cheap & fast** *(recommended for most learners)* | `google/gemini-3-flash-preview` | A small step up. Slightly better instruction-following on edge cases, still very cheap. ~2s/turn. |
| **Premium teaching quality** | `anthropic/claude-haiku-4.5` *or* `claude-sonnet-4.6` | Most patient tone, richest analogies, best at noticing learner confusion. Pricier but smoother. |
| **Free / open-weight** | `meta-llama/llama-3.3-70b-instruct`, `deepseek/deepseek-v3` | Often free or nearly free on some OpenRouter providers. Quality varies; weaker models sometimes drop the canned "ready/skip" prompt or skip the quote-back behavior. Fine if you want zero cost. |

Exact model strings drift over time -- check [openrouter.ai/models](https://openrouter.ai/models) for the current list and switch by editing `OPENROUTER_MODEL` in your `.env`. The teaching rules in `lab.py`'s system prompt have been hardened against the *weakest* tier we test, so stronger models will behave better, not worse.

#### What does it cost?

Measured end-to-end against OpenRouter from real `lab.py` runs. The headline number below is from a complete sweep of **all 17 modules** driven by a cooperative test learner -- the full course experience, start to finish.

| Run | Model | Modules | Turns total | Input tokens | Output tokens | **Total cost** |
|-----|-------|--------:|------------:|------------:|-------------:|---------------:|
| **Full 17-module course** (every lesson summary, every exercise, every Predict, every Verify, every quiz, every wrap-up + completion token) | `google/gemini-3.1-flash-lite-preview` | 17 | ~480 | 3,857,778 | 40,753 | **$0.40** |
| Module 01 spot-check | `google/gemini-3-flash-preview` | 1 | 5 | 22,207 | 661 | ~$0.002 |
| Module 13 spot-check (long, GitHub) | `google/gemini-3-flash-preview` | 1 | 7 | 39,567 | 878 | ~$0.003 |

The system prompt is ~5K tokens and is sent on every turn (no cache), so input dominates. A typical module averages **~225K input + ~2.4K output tokens** with the strict one-command-per-message teaching flow.

| Model | Per module (avg.) | Full 17-module course |
|-------|------------------:|----------------------:|
| `google/gemini-3.1-flash-lite-preview` | ~$0.024 | **$0.40** *(measured)* |
| `google/gemini-3-flash-preview` | ~$0.02-0.05 | ~$0.40-0.80 |
| `anthropic/claude-haiku-4.5` (~$0.25/1M in, $1.25/1M out) | ~$0.06-0.10 | ~$1-2 |
| `anthropic/claude-sonnet-4.6` (~$3/1M in, $15/1M out) | ~$0.70-1.10 | ~$12-18 |

Even the premium tier is cheaper than a paperback book on Git. On the lite tier the entire course costs roughly the same as a single coffee.

> **Pricing changes.** The dollar amounts above are computed from late-2025 OpenRouter rates and are meant to give you a sense of magnitude, not a quote. Click any model on [openrouter.ai/models](https://openrouter.ai/models) for the current per-token price. The `$0.40` headline number is the actual amount we burned running the full 17-module test sweep -- token counts are verbatim from the run.

### 4. Start learning

Pick one of the two paths below and jump into Module 01.

## How to Use This Course

### Guided mode (with OpenRouter)

From the repo root, with your venv activated (`source .venv/bin/activate`) or using `uv run`:

1. Start the guided lab on your next module:

   ```bash
   python lab.py
   ```

   *(Or with uv, no activation needed: `uv run python lab.py`.)*

2. The model walks you through each exercise step by step. Type your answers, predictions, or `ready` / `skip` to move along.
3. Jump to a specific module anytime:

   ```bash
   python lab.py 04
   ```

4. Reset the current lab (removes the lab directory and unchecks the module):

   ```bash
   python lab.py redo
   ```

5. Reset the entire course (asks for confirmation first):

   ```bash
   python lab.py redo course
   ```

When the model decides you've finished a module, the runner automatically checks it off in `progress.md`.

> **Tip — what the lab expects from you:** copy commands one at a time, run them in your shell, and paste the output back into the chat. The model will quote the key line of your output back to you so you know it understood, then move on. If something looks broken, paste the actual error -- don't paraphrase.

### Self-guided mode (no AI)

Each lab is fully self-contained -- you don't need the runner to follow along:

1. **Read the lesson** -- open `curriculum/<part>/<module>/lesson.md` for the concept explanation and video links
2. **Run the setup** -- `bash curriculum/<part>/<module>/setup.sh` creates a practice repo in `/tmp/`
3. **Follow the exercises** -- open `lab.md` in the same folder and work through the numbered steps
4. **Check your work** -- each lab has a "Verify" section telling you how to confirm success
5. **Track progress** -- check off completed modules in `progress.md`

Example for Module 01:

```bash
bash curriculum/part-1-foundations/01-what-is-git/setup.sh
# then open curriculum/part-1-foundations/01-what-is-git/lab.md and follow along
```

## Curriculum

Modules marked *GitHub* require a GitHub account and the `gh` CLI. All other modules work entirely offline with local Git.

### Part 1: Foundations
| # | Module | What You Learn |
|---|--------|----------------|
| 01 | What is Git? | Mental model of version control, repos, commits |
| 02 | Setup & Config | Install, configure identity, SSH keys |
| 03 | The Basics | init, add, commit, status, log, diff |

### Part 2: Branching & Collaboration
| # | Module | What You Learn | |
|---|--------|----------------|-|
| 04 | Branches | Create, switch, delete branches; understand HEAD | |
| 05 | PR Workflow | Fork, clone, branch, push, open PR, review, merge | *GitHub* |
| 06 | Merging & Conflicts | Fast-forward vs 3-way merge, resolving conflicts | |
| 07 | Rebasing | Rebase vs merge, interactive rebase, when to use each | |
| 08 | Stashing | Save work-in-progress, apply later, manage stash stack | |

### Part 3: Recovery & History
| # | Module | What You Learn | |
|---|--------|----------------|-|
| 09 | Undoing Mistakes | reset, revert, checkout, restore, clean | |
| 10 | Cherry-pick & History | Cherry-pick commits, bisect, log filtering | |
| 11 | Tags & Releases | Lightweight vs annotated tags, GitHub releases | *GitHub* |

### Part 4: GitHub Platform
| # | Module | What You Learn | |
|---|--------|----------------|-|
| 12 | Issues & Projects | Issue tracking, labels, milestones, project boards | *GitHub* |
| 13 | GitHub Actions | CI/CD basics, workflow files, common actions | *GitHub* |
| 14 | Branch Protection | Rules, required reviews, status checks | *GitHub* |

### Part 5: Security
| # | Module | What You Learn | |
|---|--------|----------------|-|
| 15 | Securing Your Account | 2FA, SSH keys, PATs, session management | |
| 16 | Repository Security | Dependabot, secret scanning, security policies | *GitHub* |
| 17 | Public Repo Best Practices | .gitignore, secrets hygiene, LICENSE, CODEOWNERS | |

## Philosophy

- **Short explanations, then practice** -- you learn Git by doing, not reading
- **Real scenarios** -- labs simulate actual situations you will encounter at work
- **Safe to experiment** -- everything runs in temporary directories, your real repos are untouched
- **Progressive** -- each module builds on the previous ones

## Versioning

This project follows [Semantic Versioning](https://semver.org/). Version history is documented in [CHANGELOG.md](CHANGELOG.md). The current version is shown in the badge at the top of this file and by `python lab.py --version`.

## Contributing

Found a typo, broken link, or have an idea for a new module? Open an [issue](https://github.com/clatter971/git-from-scratch/issues) or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
