# Module 04: Branches

## TL;DR

Branches let you work on different things at the same time without interfering with each other.

## The Concept

Think of branches as **parallel universes**. The main timeline keeps going, but you create a side timeline to try something new. If it works, you merge it back into the main timeline. If it does not work, you delete the side timeline and nothing was harmed. Every repository starts with one branch (usually called `main`), and you can create as many branches as you need.

Here is what makes branches special in git: **creating a branch is instant and cheap**. A branch is not a copy of your files. It is just a pointer -- a small label that says "this branch is at this commit." When you create a new branch, git does not duplicate anything. It just creates a new pointer. This is why git is so fast at branching compared to older version control systems that literally copied entire directories.

When you work on a branch and make commits, only that branch's pointer moves forward. The other branches stay where they are. This is how branches **diverge** -- main might get new commits from someone else while you are working on your feature branch. Both branches have a shared history (the commits before you branched) and then separate histories (the commits made on each branch since).

One more concept to understand: **HEAD**. HEAD is git's "you are here" marker. It points to whatever branch you are currently on. When you switch branches with `git switch`, HEAD moves to point at the new branch. There is a special case called **detached HEAD** -- this happens when HEAD points directly at a commit instead of a branch. It is useful for looking around at old commits, but you generally want HEAD attached to a branch when you are doing real work.

## Key Commands

| Command | What It Does |
|---|---|
| `git branch` | Lists all local branches. The current branch is marked with `*`. |
| `git branch <name>` | Creates a new branch pointing at the current commit. Does not switch to it. |
| `git switch <name>` | Switches to an existing branch. Updates HEAD and your working directory. |
| `git switch -c <name>` | Creates a new branch and switches to it in one step. |
| `git checkout <name>` | Legacy way to switch branches. `git switch` is the modern replacement. |
| `git branch -d <name>` | Deletes a branch safely (refuses if it has unmerged changes). |
| `git branch -D <name>` | Force-deletes a branch even if it has unmerged changes. |
| `git log --oneline --graph --all` | Shows commit history as a visual graph with all branches. |

## Watch

- [Git Branches Tutorial -- Corey Schafer](https://www.youtube.com/watch?v=JTE2Fn_sCZs) -- thorough walkthrough of creating, switching, and managing branches with real examples.
- [Learn Git Branching -- The Coding Train](https://www.youtube.com/watch?v=oPpnCh7InLY) -- visual, beginner-friendly explanation of how branching works.

## Read More

- [Pro Git -- Branches in a Nutshell](https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell) -- the definitive explanation of what branches are and how git implements them.
- [Atlassian -- Using Branches](https://www.atlassian.com/git/tutorials/using-branches) -- practical guide with diagrams showing branch workflows.

## Interactive Practice

- [Learn Git Branching](https://learngitbranching.js.org/) -- a visual, interactive tutorial that lets you practice branching and merging in your browser. Highly recommended alongside the lab exercises.
