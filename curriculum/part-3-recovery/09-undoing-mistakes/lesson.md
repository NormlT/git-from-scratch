# Module 09: Undoing Mistakes

## TL;DR

Git gives you multiple safety nets for undoing mistakes -- from "oops I didn't mean to stage that" to "I need to undo a commit that's already pushed."

## The Concept

There is a spectrum of "undo" in git, ranging from least destructive to most. Understanding which tool to reach for depends on how far along your mistake has traveled: is it still in your working directory? Already staged? Already committed? Already pushed to a shared branch?

`git restore` handles the lightest undos. It can unstage a file (remove it from the staging area without losing changes) or discard working directory modifications entirely. Think of it like Ctrl+Z for a single file -- you are just rewinding that one file to its last known state.

`git reset` is more powerful. It moves your branch pointer backward in history. The three modes determine what happens to the changes from the "undone" commits. `--soft` keeps everything staged (you just unwound the commit itself). `--mixed` (the default) unstages the changes but keeps them in your working directory. `--hard` throws everything away -- the commit, the staging, and the working directory changes. Think of reset like going back to a save point in a video game: soft keeps your inventory, mixed dumps it on the ground, hard deletes it.

`git revert` takes a completely different approach. Instead of rewriting history, it creates a **new** commit that does the exact opposite of a previous commit. The original mistake is still in history, but it has been corrected going forward. This is the correct tool for shared branches because it does not rewrite history that other people may have already pulled. The safety net underneath all of this is `git reflog` -- a log of everywhere HEAD has pointed, even after resets. If you accidentally lose commits, reflog lets you find and recover them.

## Key Commands

| Command | What It Does |
|---|---|
| `git restore <file>` | Discards changes in the working directory, reverting the file to its last committed state. |
| `git restore --staged <file>` | Unstages a file (removes it from the staging area) but keeps the changes in your working directory. |
| `git reset HEAD~1` | Undoes the last commit. Default mode is `--mixed`: changes are unstaged but still in your files. |
| `git reset --soft HEAD~1` | Undoes the last commit but keeps all changes staged and ready to re-commit. |
| `git reset --mixed HEAD~1` | Undoes the last commit and unstages the changes (same as `git reset HEAD~1`). |
| `git reset --hard HEAD~1` | Undoes the last commit AND discards all changes. Dangerous -- there is no working directory backup. |
| `git revert <commit>` | Creates a new commit that undoes the changes introduced by the given commit. Safe for shared history. |
| `git reflog` | Shows everywhere HEAD has been, including after resets. Your ultimate safety net for recovering lost commits. |

## Watch

- [Git Reset vs Revert -- Fireship](https://www.youtube.com/watch?v=RIYrfkZjWmA) -- short and clear explanation of when to use reset vs. revert.
- [13 Advanced Git Techniques and Shortcuts -- Fireship](https://www.youtube.com/watch?v=ecK3EnyGD8o) -- practical tips including undo workflows.

## Read More

- [Pro Git -- Undoing Things](https://git-scm.com/book/en/v2/Git-Basics-Undoing-Things) -- official coverage of unstaging, unmodifying, and undoing commits.
- [Atlassian -- Undoing Changes](https://www.atlassian.com/git/tutorials/undoing-changes) -- tutorial covering reset, revert, and checkout with clear diagrams.
