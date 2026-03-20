# Module 06: Merging & Conflicts

## TL;DR

Merging combines changes from different branches, and conflicts happen when two branches change the same lines.

## The Concept

When you finish work on a branch, you want to bring those changes back into `main`. That is what merging does. Git is remarkably good at merging -- most of the time, it figures out how to combine changes from two branches automatically. But understanding what happens under the hood helps you handle the cases where it cannot.

There are two types of merges. A **fast-forward merge** happens when the branch you are merging is simply ahead of the target -- there is no divergence. Imagine a straight road: main is at mile 3, your feature branch continued to mile 6. To merge, git just moves the main pointer forward to mile 6. No new commit is created. A **three-way merge** happens when branches have diverged -- both main and the feature branch have new commits since they split. Git looks at three things: the common ancestor (where the branches split), the tip of each branch, and figures out how to combine them. This creates a new **merge commit** with two parents, one from each branch.

Now, **conflicts**. A conflict happens when two branches change the same lines in the same file. Git cannot decide which version to keep -- it needs your help. When this happens, git pauses the merge and marks the conflicted files with special markers:

```
<<<<<<< HEAD
your version of the code
=======
the other branch's version
>>>>>>> feature-branch
```

Everything between `<<<<<<< HEAD` and `=======` is what is on your current branch. Everything between `=======` and `>>>>>>> feature-branch` is what is on the branch you are merging in. Your job is to edit the file to produce the final version you want -- keep one side, keep both, or write something completely new. Then remove the markers, stage the file with `git add`, and run `git commit` to finish the merge.

Conflicts are not errors. They are git asking for your opinion. They happen all the time in collaborative work, and resolving them is a normal part of the workflow.

## Key Commands

| Command | What It Does |
|---|---|
| `git merge <branch>` | Merges the specified branch into your current branch. |
| `git merge --abort` | Cancels a merge in progress and returns to the state before you started. |
| `git log --oneline --graph` | Shows the commit graph so you can see merge commits and branch structure. |
| `git status` | During a conflict, shows which files need to be resolved. |
| `git add <file>` | After resolving a conflict, marks the file as resolved. |
| `git commit` | After resolving all conflicts and staging, completes the merge. |

## Watch

- [Git MERGE vs REBASE -- Fireship](https://www.youtube.com/watch?v=0chZFIZLR_0) (5 min) -- clear visual comparison of merge and rebase strategies.
- [Resolve Merge Conflicts in Git -- The Coding Train](https://www.youtube.com/watch?v=JtIX3HJKwfo) -- hands-on walkthrough of encountering and resolving a real conflict.

## Read More

- [Pro Git -- Basic Branching and Merging](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging) -- covers fast-forward merges, three-way merges, and conflict resolution with diagrams.
- [Atlassian -- Git Merge](https://www.atlassian.com/git/tutorials/using-branches/git-merge) -- practical guide with clear explanations of merge strategies.
