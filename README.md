# Git From Scratch -- Zero to Hero

A hands-on, interactive course for learning Git and GitHub from the ground up. Each module has a short explanation, curated video/doc links, and a lab exercise you practice immediately.

## Prerequisites

- A terminal (bash/zsh)
- Git installed (`git --version`)
- A GitHub account
- GitHub CLI installed (`gh --version`)
- Claude Code (for guided lab walkthroughs)

## How to Use This Course

1. **Read the lesson** -- each module's `lesson.md` gives you the concept in plain language
2. **Watch the video** -- short, visual explanations reinforce what you read
3. **Do the lab** -- run `bash setup.sh` to create a practice scenario, then follow the exercises
4. **Use `/lab`** -- run the slash command in Claude Code for interactive, guided walkthroughs
5. **Track progress** -- check off modules in `progress.md` as you complete them

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
