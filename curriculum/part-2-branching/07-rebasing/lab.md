# Lab 07: Rebasing

## Goal

Practice rebasing a feature branch onto main for a clean history, and use interactive rebase to clean up messy commits.

## Prerequisites

Modules 01-06 (you should understand branches, merging, and why a clean history matters).

## Setup

```bash
bash setup.sh
cd /tmp/git-lab-07
```

## Exercises

### 1. Survey the branches

Look at the branch structure. You should see `main`, `feature-rebase` (diverged from main), and `feature-cleanup` (has messy commits).

```bash
git log --oneline --graph --all
```

### 2. Switch to the feature branch

Move to `feature-rebase` and look at its commits.

```bash
git switch feature-rebase
git log --oneline
```

### 3. Rebase onto main

Rebase your feature branch so its commits sit on top of the latest main. Git will replay your commits one by one on top of main's latest commit.

```bash
git rebase main
```

### 4. See the clean history

Check the graph again. Notice that `feature-rebase` commits now sit in a straight line after main's commits. No merge commit, no diamond shape -- just a clean timeline.

```bash
git log --oneline --graph --all
```

### 5. Fast-forward merge

Now switch to main and merge the rebased feature branch. Since feature-rebase is directly ahead of main, this will be a fast-forward merge -- no merge commit needed.

```bash
git switch main
git merge feature-rebase
git log --oneline --graph
```

### 6. Look at the messy branch

Switch to `feature-cleanup` and examine its commit history. You will see several small, messy commits that should be cleaned up.

```bash
git switch feature-cleanup
git log --oneline
```

### 7. Interactive rebase to clean up

Use interactive rebase to combine and clean up the last 4 commits. Git will open your editor with a list of commits.

```bash
git rebase -i HEAD~4
```

In the editor, you will see something like:

```
pick abc1234 Add dashboard layout
pick def5678 Fix typo in dashboard
pick ghi9012 WIP: dashboard styles
pick jkl3456 Finish dashboard styling
```

Change it to squash the fixup commits into the main one:

```
pick abc1234 Add dashboard layout
squash def5678 Fix typo in dashboard
squash ghi9012 WIP: dashboard styles
squash jkl3456 Finish dashboard styling
```

### 8. Write a clean commit message

After saving the rebase plan, git opens another editor for the combined commit message. Replace all the individual messages with one clean message:

```
Add dashboard with complete styling

Implements the dashboard layout with responsive styles
and proper formatting.
```

### 9. Verify the cleanup

Check the log. Your four messy commits should now be one clean commit.

```bash
git log --oneline
```

## Verify

After completing the exercises:

- `git log --oneline --graph --all` on main shows a clean linear history with the rebased feature commits.
- `git log --oneline` on `feature-cleanup` shows the squashed commits replaced by a single clean commit.
- `git status` is clean on both branches.

## Bonus

- **Rebase with a conflict:** Create a new branch from an earlier commit, change the same line as a later commit on main, and try to rebase. Git will pause and ask you to resolve the conflict. Use `git rebase --continue` after resolving it.
- **Reword a commit:** Use `git rebase -i HEAD~3` and change `pick` to `reword` (or `r`) to just change a commit message without altering the content.
- **Abort a rebase:** Start an interactive rebase, then cancel it with `git rebase --abort`. Everything returns to how it was.
