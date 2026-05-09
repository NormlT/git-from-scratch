# Lab 04: Working with Branches

## Goal

Create, switch between, and delete branches. Understand how branches diverge and how git keeps track of where you are.

## Prerequisites

Modules 01-03 (you should be comfortable with init, add, commit, and reading `git log`).

## Setup

**Step 1:** Run the setup script (use the full path to the script in your course directory):

```bash
bash setup.sh
```

**Step 2:** Switch to the practice directory:

```bash
cd /tmp/git-lab-04
```

All exercise commands below should be run from `/tmp/git-lab-04`.

## Exercises

### 1. See your current branches

Run `git branch` to list all branches. You should see `* main` -- the `*` tells you which branch HEAD is pointing to.

```bash
git branch
```

### 2. Create a new branch

Create a branch called `feature-login`.

```bash
git branch feature-login
```

**Predict:** Before we run `git branch` to list branches -- will the `*` be on `main` or `feature-login`?

```bash
git branch
```

### 3. Switch to the new branch

Switch to `feature-login`.

```bash
git switch feature-login
```

**Predict:** If we run `git branch` now, where will the `*` be?

```bash
git branch
```

### 4. Make a commit on the feature branch

Create a `login.py` file and commit it. This commit only exists on `feature-login`.

Here is what `login.py` will contain:

```python
def login(username, password):
    """Authenticate a user."""
    if username and password:
        return True
    return False
```

```bash
cp /tmp/git-lab-04-files/login.py login.py
```

```bash
git add login.py
git commit -m "Add login function"
```

### 5. Switch back to main and observe

Switch back to `main`.

```bash
git switch main
```

**Predict:** Before we list the files -- will `login.py` be there? We committed it on `feature-login`, and we just switched away.

```bash
ls
```

### 6. Visualize the branches

Run the graph view to see both branches. You can see where they diverge.

```bash
git log --oneline --graph --all
```

### 7. Create a second feature branch

Create another branch directly from main using the shortcut that creates and switches in one step. Add a file and commit.

```bash
git switch -c feature-signup
```

Here is what `signup.py` will contain:

```python
def signup(username, email, password):
    """Register a new user."""
    return {"username": username, "email": email}
```

```bash
cp /tmp/git-lab-04-files/signup.py signup.py
```

```bash
git add signup.py
git commit -m "Add signup function"
```

### 8. See all three branches diverging

Run the graph view again. You now have three branches, all diverging from the same point on main.

```bash
git log --oneline --graph --all
```

### 9. Delete a branch

Try deleting `feature-signup` with the safe flag. Git will warn you that it has unmerged changes. Use the force flag to delete it anyway.

```bash
git switch main
git branch -d feature-signup
# Git will refuse because the branch has unmerged work.
# Force-delete it:
git branch -D feature-signup
```

## Verify

Run `git log --oneline --graph --all`. You should see:

- `main` with the original commits
- `feature-login` with one extra commit (`Add login function`)
- `feature-signup` is gone (deleted)

Run `git branch` and confirm only `main` and `feature-login` remain.

## Bonus

- **Branch from a specific commit:** Find an older commit hash with `git log --oneline`, then create a branch from it: `git branch old-experiment <hash>`. Check where it points with the graph view.
- **Detached HEAD:** Check out a commit hash directly with `git checkout <hash>`. Read the warning message git gives you. Make a commit in this state. Then switch back to `main` -- what happened to that commit? (Hint: it is an "orphaned" commit. It still exists but no branch points to it.)

## Quick Quiz

1. What is HEAD in git?
2. Does `git branch feature-x` switch you to the new branch, or do you need a separate command?
3. Why is creating a branch in git so fast compared to older version control systems?
