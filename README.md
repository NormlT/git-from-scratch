# Git From Scratch -- Zero to Hero

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A hands-on, interactive course for learning Git and GitHub from the ground up. Each module has a short explanation, curated video/doc links, and a lab exercise you practice immediately.

## Prerequisites

Before you start, make sure you have the following installed:

| Tool | Check | Install guide |
|------|-------|---------------|
| **Git** | `git --version` | [git-scm.com/downloads](https://git-scm.com/downloads) |
| **A terminal** | bash, zsh, PowerShell, etc. | Included on macOS/Linux; Windows users can use [Git Bash](https://gitforwindows.org/) or WSL |
| **GitHub account** | -- | [github.com/signup](https://github.com/signup) |
| **GitHub CLI** | `gh --version` | [cli.github.com](https://cli.github.com/) |
| **Claude Code** (optional) | `claude --version` | [claude.ai/claude-code](https://claude.ai/claude-code) -- enables interactive guided walkthroughs |

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/NormlT/git-from-scratch.git
cd git-from-scratch
```

### 2. Create your personal progress tracker

This file stays local and is never pushed to the remote:

```bash
cp progress.template.md progress.md
```

### 3. Start learning

Pick one of the two paths below and jump into Module 01.

## How to Use This Course

### With Claude Code (recommended)

1. Open a terminal in the repo directory and run `claude`
2. Type `/lab` to start a guided walkthrough of your next module
3. Claude reads your progress, explains concepts, walks you through exercises step by step, and marks modules complete when you're done
4. Jump to a specific module: `/lab 04`

### Without Claude Code

Each lab is fully self-contained -- you don't need Claude to follow along:

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

### Part 1: Foundations
| # | Module | What You Learn |
|---|--------|----------------|
| 01 | What is Git? | Mental model of version control, repos, commits |
| 02 | Setup & Config | Install, configure identity, SSH keys |
| 03 | The Basics | init, add, commit, status, log, diff |

### Part 2: Branching & Collaboration
| # | Module | What You Learn |
|---|--------|----------------|
| 04 | Branches | Create, switch, delete branches; understand HEAD |
| 05 | PR Workflow | Fork, clone, branch, push, open PR, review, merge |
| 06 | Merging & Conflicts | Fast-forward vs 3-way merge, resolving conflicts |
| 07 | Rebasing | Rebase vs merge, interactive rebase, when to use each |
| 08 | Stashing | Save work-in-progress, apply later, manage stash stack |

### Part 3: Recovery & History
| # | Module | What You Learn |
|---|--------|----------------|
| 09 | Undoing Mistakes | reset, revert, checkout, restore, clean |
| 10 | Cherry-pick & History | Cherry-pick commits, bisect, log filtering |
| 11 | Tags & Releases | Lightweight vs annotated tags, GitHub releases |

### Part 4: GitHub Platform
| # | Module | What You Learn |
|---|--------|----------------|
| 12 | Issues & Projects | Issue tracking, labels, milestones, project boards |
| 13 | GitHub Actions | CI/CD basics, workflow files, common actions |
| 14 | Branch Protection | Rules, required reviews, status checks |

### Part 5: Security
| # | Module | What You Learn |
|---|--------|----------------|
| 15 | Securing Your Account | 2FA, SSH keys, PATs, session management |
| 16 | Repository Security | Dependabot, secret scanning, security policies |
| 17 | Public Repo Best Practices | .gitignore, secrets hygiene, LICENSE, CODEOWNERS |

## Philosophy

- **Short explanations, then practice** -- you learn git by doing, not reading
- **Real scenarios** -- labs simulate actual situations you'll encounter
- **Safe to experiment** -- everything runs in `/tmp/` directories, your real repos are untouched
- **Progressive** -- each module builds on the previous ones

## Contributing

Found a typo, broken link, or have an idea for a new module? Open an [issue](https://github.com/NormlT/git-from-scratch/issues) or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
