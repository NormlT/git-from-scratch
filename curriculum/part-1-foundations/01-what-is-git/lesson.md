# Module 01: What is Git?

## TL;DR

Git tracks every change to your project so you can go back in time, work in parallel, and collaborate without overwriting each other's work.

## The Concept

Think of git like **save points in a video game**. Every time you reach a meaningful milestone, you save your progress. If you mess something up, you can load a previous save and try again. Git works the same way -- except it tracks every save you have ever made, lets you compare any two saves, and even lets multiple people play the same game at the same time without stepping on each other's toes.

Git is a **distributed** version control system. That means every person working on a project has a complete copy of the entire history on their own machine. You do not depend on a central server to look at past changes, create new branches, or make commits. If the server goes down, everyone still has the full project history. When you are ready, you push your changes to a shared location (like GitHub) so others can see them.

The three things you need to understand right now are **repositories**, **commits**, and the **three areas** git uses to manage your work. A **repository** (or "repo") is just a project folder that git is tracking. A **commit** is a snapshot -- a frozen-in-time record of what every file looked like at that moment. Each commit has a unique ID, a message describing what changed, and a pointer to the previous commit, forming a chain of history.

The three areas are where the magic happens. Picture it like packing a box:

- **Working directory** -- this is your desk. It is where you edit files, write code, and do your work. Git can see these changes but has not recorded them yet.
- **Staging area** (also called the "index") -- this is the box you are packing. You choose which changes go into the box with `git add`. You might have changed ten files but only want to commit three of them -- you stage just those three.
- **Repository** (the `.git/` directory) -- this is the sealed, labeled box on the shelf. When you run `git commit`, git takes everything in the staging area, creates a permanent snapshot, and stores it in the repository's history.

## Key Commands

| Command | What It Does |
|---|---|
| `git init` | Creates a new git repository in the current directory. This adds a hidden `.git/` folder that stores all of git's data. |
| `git status` | Shows the current state of your working directory and staging area. Tells you which files are modified, staged, or untracked. |
| `git log` | Shows the commit history. Each entry includes the commit hash, author, date, and message. Add `--oneline` for a compact view. |

## Watch

- [Git Explained in 100 Seconds -- Fireship](https://www.youtube.com/watch?v=hwP7WQkmECE) (2 min) -- fast, visual overview of what git is and why it exists.
- [What is Git? Explained in 2 Minutes! -- Programming with Mosh](https://www.youtube.com/watch?v=2ReR1YJrNOM) (2 min) -- simple explanation with clear visuals.

## Read More

- [Pro Git Book -- Chapter 1: Getting Started](https://git-scm.com/book/en/v2/Getting-Started-About-Version-Control) -- the definitive free book on git. Chapter 1 covers the history and core concepts.
- [GitHub Docs -- About Git](https://docs.github.com/en/get-started/using-git/about-git) -- GitHub's concise introduction to what git is and how it works.
