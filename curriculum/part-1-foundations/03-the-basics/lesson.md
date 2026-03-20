# Module 03: The Basics

## TL;DR

The core git workflow is: make changes, stage them, commit them -- rinse and repeat.

## The Concept

Every file in a git repository is in one of **three states**:

- **Modified** -- you have changed the file in your working directory, but have not told git to include it in the next commit.
- **Staged** -- you have marked the changed file to be included in the next commit. It is in the box, but the box is not sealed yet.
- **Committed** -- the change is safely stored as a snapshot in git's history. The box is sealed, labeled, and on the shelf.

Remember the packing box analogy from Module 01. Your **working directory** is your desk where you do the work. The **staging area** is the box you are packing -- you deliberately choose which changes go in. The **commit** is sealing and labeling that box. This two-step process (stage, then commit) is one of git's most important features. It means you can make ten changes but organize them into three clean, logical commits.

The command `git add` does not just "add files to the project" -- it **stages specific changes**. If you modify a file, add some changes, modify it again, and then commit, only the changes you staged with `git add` will be committed. The second round of modifications stays in the working directory. This is a common source of confusion, but it is also what gives you precise control over your history. You can verify what is staged vs. unstaged at any time: `git diff` shows changes in your working directory that are **not** staged, while `git diff --staged` shows changes that **are** staged and will be included in the next commit.

Commits should be **atomic** -- each commit should represent one logical change. Instead of committing "did a bunch of stuff today," break your work into meaningful units: "Add user login form," "Fix email validation bug," "Update README with setup instructions." This makes the history useful. Six months from now, when something breaks, you can look at the log and quickly find the commit that introduced the problem. Good commit messages are a gift to your future self and your teammates.

## Key Commands

| Command | What It Does |
|---|---|
| `git init` | Creates a new repository in the current directory. |
| `git add <file>` | Stages changes in a specific file for the next commit. |
| `git add .` | Stages all changes in the current directory and subdirectories. Use with care. |
| `git commit -m "message"` | Creates a new commit from staged changes with the given message. |
| `git status` | Shows which files are modified, staged, or untracked. |
| `git diff` | Shows unstaged changes -- what you have modified but not yet added. |
| `git diff --staged` | Shows staged changes -- what will be included in the next commit. |
| `git log` | Shows commit history. Use `--oneline` for a compact view. |
| `git rm <file>` | Removes a file from the working directory and stages the removal. |
| `git mv <old> <new>` | Renames/moves a file and stages the change. |

## Watch

- [Git Tutorial for Beginners -- Corey Schafer](https://www.youtube.com/watch?v=HVsySz-h9r4) (30 min) -- detailed walkthrough of the basic git workflow with real examples.
- [Git & GitHub Crash Course -- Traversy Media](https://www.youtube.com/watch?v=SWYqp7iY_Tc) (32 min) -- fast-paced introduction covering all the essentials.

## Read More

- [Pro Git Book -- Chapter 2: Git Basics](https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository) -- covers initializing repos, recording changes, viewing history, and undoing things.
- [Atlassian -- Saving Changes](https://www.atlassian.com/git/tutorials/saving-changes) -- clear tutorial on `git add`, `git commit`, `.gitignore`, and `git stash`.
