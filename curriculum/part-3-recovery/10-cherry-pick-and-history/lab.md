# Lab 10: Cherry-pick & History

## Goal

Cherry-pick commits between branches and use git's history tools to investigate code changes.

## Prerequisites

Modules 01-06 (you should be comfortable with branches and merging).

## Setup

```bash
bash setup.sh
cd /tmp/git-lab-10
```

## Exercises

### 1. Survey the branches

Start by understanding the repo structure. There are two branches: `main` and `feature`.

```bash
git log --oneline --graph --all
```

### 2. Find the useful commit on the feature branch

The `feature` branch has a commit that fixes a critical bug. Find it.

```bash
git log --oneline feature
```

Look for the commit message mentioning "Fix critical." Note its hash.

### 3. Cherry-pick the fix onto main

Make sure you are on main, then copy that specific commit over.

```bash
git switch main
git cherry-pick <hash>
```

### 4. Verify the cherry-pick

Check the log. The fix commit is now on main with a new hash. The original commit still exists on the feature branch with its original hash.

```bash
git log --oneline
git log --oneline feature
```

### 5. Use blame to investigate a file

`git blame` shows who changed each line and when. Run it on `app.py`.

```bash
git blame app.py
```

Each line shows the commit hash, author, date, and the line content. This is how you trace the origin of any piece of code.

### 6. Filter the log by date

Find all commits made in the last week.

```bash
git log --since="1 week ago" --oneline
```

Since this is a lab repo, all commits will match. In a real project, this is useful for seeing what changed recently.

### 7. View file history with patches

See how `app.py` evolved over time by viewing the diff for each commit that touched it.

```bash
git log -p app.py
```

Each entry shows the commit message followed by the exact lines that were added or removed.

### 8. Start a bisect session

There is a bug somewhere in history: a file called `bug.py` contains `BUG = True`. Let's use binary search to find which commit introduced it.

```bash
git bisect start
```

### 9. Mark the current state as bad

The bug exists right now, so mark the current commit as bad.

```bash
git bisect bad
```

### 10. Mark the first commit as good

Find the first commit hash and mark it as good (the bug did not exist at the beginning).

```bash
git log --oneline | tail -1
git bisect good <first-commit-hash>
```

Git will check out a commit in the middle of the history for you to test.

### 11. Test and narrow down

Check whether `bug.py` exists and contains the bug at this commit.

```bash
cat bug.py 2>/dev/null || echo "File does not exist -- no bug here"
```

If the file does not exist or does not contain `BUG = True`, mark it as good. If it does, mark it as bad.

```bash
git bisect good   # or: git bisect bad
```

Repeat this step. Git will keep checking out midpoints until it identifies the exact commit that introduced the bug. It will print something like: `<hash> is the first bad commit`.

### 12. End the bisect session

When bisect finds the culprit, reset to return to your original branch.

```bash
git bisect reset
```

## Verify

- `git log --oneline` on main shows the cherry-picked commit.
- You identified the exact commit that introduced `bug.py` using bisect.
- You can explain what `git blame` shows and how log filtering works.

## Bonus

Try searching commit messages for specific keywords:

```bash
git log --all --oneline --grep="fix"
```

This finds all commits whose messages contain "fix" -- useful for tracking down when something was patched.
