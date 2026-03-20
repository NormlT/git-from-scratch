# Lab 08: Stashing

## Goal

Practice stashing changes, switching context to handle an urgent task, and restoring your work afterward.

## Prerequisites

Modules 01-04 (you should be comfortable with branches, commits, and switching between branches).

## Setup

```bash
bash setup.sh
cd /tmp/git-lab-08
```

## Exercises

### 1. Check your current state

You are on the `feature-dashboard` branch with some work in progress. See what has been changed but not committed.

```bash
git status
git diff
```

### 2. Stash your work

An urgent bug just came in. Save your work-in-progress to the stash with a descriptive message.

```bash
git stash push -m "dashboard work in progress"
```

### 3. Confirm your desk is clean

Run `git status` again. Your working directory should be clean -- all the uncommitted changes are safely in the stash.

```bash
git status
```

### 4. Fix the urgent bug

Switch to main and fix the bug. The file `bug.txt` has an error that needs correcting.

```bash
git switch main
```

Edit `bug.txt` to fix the "bug" (change the status from "broken" to "fixed"):

```bash
sed -i 's/status: broken/status: fixed/' bug.txt
git add bug.txt
git commit -m "Fix critical bug in bug.txt"
```

### 5. Return to your feature branch

The bug is fixed. Switch back to your feature branch.

```bash
git switch feature-dashboard
```

### 6. Check your stash

View what is in the stash. You should see your saved work.

```bash
git stash list
```

### 7. Restore your work

Pop the stash to get your work-in-progress changes back.

```bash
git stash pop
```

### 8. Confirm everything is back

Check that your uncommitted changes are restored.

```bash
git status
git diff
```

### 9. Practice multiple stashes

Let's try stacking multiple stashes. Make some changes, stash them, make different changes, stash again.

```bash
# First stash
echo "# Analytics module" > analytics.py
git add analytics.py
git stash push -m "started analytics module"

# Second stash
echo "# Reports module" > reports.py
git add reports.py
git stash push -m "started reports module"

# See both stashes
git stash list
```

### 10. Pop stashes selectively

The most recent stash is at index 0, the older one at index 1. Pop them in order.

```bash
# Pop the most recent (reports)
git stash pop
git status
git stash list

# Pop the next one (analytics)
git stash pop
git status
git stash list
```

## Verify

After completing the exercises:

- `git stash list` is empty -- all stashes have been popped.
- `git status` on `feature-dashboard` shows your restored work-in-progress changes.
- `git log --oneline` on `main` includes the bug fix commit.

## Bonus

- **Preview before applying:** Use `git stash show stash@{0}` to see a summary of what a stash contains before applying it, or `git stash show -p stash@{0}` for the full diff.
- **Apply without removing:** Use `git stash apply` instead of `git stash pop` to apply a stash while keeping it in the stack. Useful if you want to apply the same changes to multiple branches.
- **Branch from a stash:** If you realize a stash should have been on its own branch, use `git stash branch <branch-name>` to create a new branch, check it out, and apply the stash all in one step.
- **Drop a stash:** Use `git stash drop` to discard the most recent stash, or `git stash drop stash@{N}` to discard a specific one.
