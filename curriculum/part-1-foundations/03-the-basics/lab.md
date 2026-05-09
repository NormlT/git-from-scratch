# Lab 03: The Add-Commit Workflow

## Goal

Practice the complete add-commit workflow with multiple files and changes. Learn to stage selectively and create atomic commits.

## Prerequisites

Modules 01 and 02 completed.

## Setup

**Step 1:** Run the setup script (use the full path to the script in your course directory):

```bash
bash setup.sh
```

**Step 2:** Switch to the practice directory:

```bash
cd /tmp/git-lab-03
```

All exercise commands below should be run from `/tmp/git-lab-03`.

## Exercises

### 1. Check the starting point

Run `git status` in the practice directory. Notice you have a clean repo with one initial commit and a `README.md` file.

```bash
git status
git log --oneline
```

### 2. Create a new file

Create a file called `app.py` with a simple print statement.

The setup script has prepared the file contents. Here is what `app.py` will contain:

```python
def main():
    print("Hello, world!")

if __name__ == "__main__":
    main()
```

Copy it into your project:

```bash
cp /tmp/git-lab-03-files/app-v1.py app.py
```

**Predict:** Before we run `git status` -- what state will `app.py` show up as? Modified, staged, or something else?

```bash
git status
```

### 3. Stage the file

Put `app.py` into the staging area -- think of it as placing the file into the box, ready to be sealed.

```bash
git add app.py
```

**Predict:** Before we run `git status` -- where will `app.py` appear now? Still untracked, or somewhere else?

```bash
git status
```

### 4. Commit

Seal the box. Create a commit with a clear message describing what you did.

```bash
git commit -m "Add app.py with hello world"
git log --oneline
```

### 5. Make multiple changes

Edit `app.py` to add a second function. Also create a new file `utils.py` with a helper function.

Here is what the updated `app.py` will contain:

```python
def main():
    print("Hello, world!")

def greet(name):
    return f"Hello, {name}!"

if __name__ == "__main__":
    main()
```

```bash
cp /tmp/git-lab-03-files/app-v2.py app.py
```

Here is what `utils.py` will contain:

```python
def format_name(first, last):
    return f"{first} {last}"
```

```bash
cp /tmp/git-lab-03-files/utils.py utils.py
```

### 6. See the unstaged changes

Run `git diff` to see what changed in tracked files. Notice it shows the additions to `app.py`. It does not show `utils.py` because that file is untracked (git diff only shows changes to files git already knows about).

```bash
git diff
```

### 7. Stage selectively

Add only `app.py` -- not `utils.py`. This is selective staging: you choose exactly what goes into each commit.

```bash
git add app.py
```

**Predict:** Before we check the status -- what will the state of each file be? Think about `app.py` (which we just added) vs `utils.py` (which we did not).

```bash
git status
```

### 8. See what would be committed

Run `git diff --staged` to see only the changes that are staged -- this is exactly what will go into the next commit. Compare this with `git diff` (which now shows nothing, because all changes to tracked files are staged).

```bash
git diff --staged
git diff
```

### 9. Commit the staged changes

Commit just the `app.py` changes. The `utils.py` file stays behind -- it is not part of this commit.

```bash
git commit -m "Add greeting function to app.py"
```

### 10. Commit utils.py separately

Now add and commit `utils.py` as its own atomic commit. Two clean, separate commits instead of one big messy one.

```bash
git add utils.py
git commit -m "Add utils.py with name formatting helper"
```

### 11. Review your history

Look at the full history. You should see four commits (the initial one from setup plus your three), each with a clear purpose. This is what clean history looks like.

```bash
git log --oneline
```

## Verify

After completing the exercises:

- `git log --oneline` shows at least 3 commits, each with a clear, descriptive message.
- `git status` shows "nothing to commit, working tree clean."
- You understand the difference between `git diff` (unstaged) and `git diff --staged` (staged).

## Bonus

Try removing and renaming files with git:

```bash
# Remove a file and commit the removal
git rm utils.py
git status
git commit -m "Remove utils.py"

# Rename a file and commit the rename
git mv app.py application.py
git status
git commit -m "Rename app.py to application.py"

# Check the log to see all your commits
git log --oneline
```

Notice that `git rm` and `git mv` both stage the change automatically -- you just need to commit.

## Quick Quiz

1. What is the difference between `git diff` and `git diff --staged`?
2. If you modify a file, stage it with `git add`, then modify it again -- what happens when you commit?
3. Why should commits be "atomic" (one logical change per commit)?
