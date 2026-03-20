# Module 08: Stashing

## TL;DR

Stashing saves your uncommitted changes temporarily so you can switch contexts without committing half-done work.

## The Concept

Picture this: you are in the middle of building a feature, files are changed, nothing is ready to commit. Then your teammate messages you -- there is an urgent bug on `main` that needs fixing right now. You cannot switch branches with a messy working directory (sometimes git will refuse, sometimes it will carry the changes over, neither is what you want). And you do not want to commit half-finished work that does not even compile.

This is where `git stash` saves the day. Think of it like **putting your papers in a drawer**. Your desk is clean, you can switch to another task, and when you come back, you pull the papers out of the drawer and pick up exactly where you left off. Your work is not lost -- it is just set aside temporarily.

Stash works as a **stack** (last in, first out). Every time you run `git stash`, git pushes your changes onto the top of the stack. You can stash multiple times -- maybe you were interrupted twice. `git stash list` shows everything in the stack. `git stash pop` takes the most recent stash off the top and applies it to your working directory. If you want to apply a stash but keep it in the stack (in case you want to apply it elsewhere too), use `git stash apply` instead.

A good habit is to use `git stash push -m "description"` so you can tell your stashes apart. Without a message, they all show up as "WIP on branch-name" which is not very helpful when you have three of them stacked up.

## Key Commands

| Command | What It Does |
|---|---|
| `git stash` | Saves all uncommitted changes (staged and unstaged) and gives you a clean working directory. |
| `git stash push -m "description"` | Stashes changes with a descriptive message so you can identify them later. |
| `git stash pop` | Applies the most recent stash and removes it from the stack. |
| `git stash apply` | Applies the most recent stash but keeps it in the stack. |
| `git stash list` | Shows all stashed entries with their index and description. |
| `git stash show` | Shows a summary of what changed in the most recent stash. |
| `git stash drop` | Removes the most recent stash without applying it. |

## Watch

- [Git Stash -- The Net Ninja](https://www.youtube.com/watch?v=DeU6opFU_zw) -- practical walkthrough of stashing, listing, and popping in a real workflow.
- [Git stash in 5 minutes -- Colt Steele](https://www.youtube.com/watch?v=lH3GkMoQ2gM) -- concise tutorial covering the most common stash operations.

## Read More

- [Pro Git -- Stashing and Cleaning](https://git-scm.com/book/en/v2/Git-Tools-Stashing-and-Cleaning) -- the definitive guide to stashing, including advanced options.
- [Atlassian -- Git Stash](https://www.atlassian.com/git/tutorials/saving-changes/git-stash) -- clear explanations with examples of when and how to use stash.
