# Lab 06: Merging & Conflicts

## Goal

Practice both clean merges and conflict resolution. Understand the difference between fast-forward and three-way merges.

## Prerequisites

Modules 01-04 (you should be comfortable with branches, commits, and switching between branches).

## Setup

```bash
bash setup.sh
cd /tmp/git-lab-06
```

## Exercises

### 1. Survey the landscape

Look at the branch structure the setup script created. You should see `main`, `feature-clean`, and `feature-conflict`.

```bash
git log --oneline --graph --all
```

### 2. Perform a clean merge (fast-forward)

Make sure you are on `main`, then merge `feature-clean`. Since `feature-clean` is ahead of main with no divergence, this will be a fast-forward merge.

```bash
git switch main
git merge feature-clean
```

### 3. Examine the result

Check the log. Notice there is no merge commit -- the history is a straight line. Git just moved the `main` pointer forward.

```bash
git log --oneline --graph
```

### 4. Start a conflicting merge

Now merge `feature-conflict`. This branch changed the same lines as a commit on main, so git cannot auto-merge. You will see a CONFLICT message.

```bash
git merge feature-conflict
```

### 5. See what is conflicted

Run `git status` to see which files have conflicts. They will be listed as "both modified."

```bash
git status
```

### 6. Examine the conflict markers

Open the conflicted file and find the markers. Everything between `<<<<<<< HEAD` and `=======` is your current branch's version. Everything between `=======` and `>>>>>>> feature-conflict` is the incoming branch's version.

```bash
cat config.py
```

### 7. Resolve the conflict

Edit the file to produce the version you want. Remove the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`), and keep whichever lines you prefer (or combine them). For example:

```bash
printf '%s\n' '"""Application configuration."""' '' 'APP_NAME = "MyApp"' 'VERSION = "2.0.0"' 'DEBUG = False' 'LOG_LEVEL = "INFO"' 'MAX_RETRIES = 5' 'TIMEOUT = 30' > config.py
```

### 8. Mark the conflict as resolved

Stage the resolved file to tell git you have handled the conflict.

```bash
git add config.py
```

### 9. Complete the merge

Run `git commit` to finish the merge. Git provides a default merge message -- you can accept it or customize it.

```bash
git commit -m "Merge feature-conflict: combine config improvements"
```

### 10. Verify the merge commit

Check the log graph. You should see a merge commit with two parents -- the visual "diamond" shape where branches diverged and came back together.

```bash
git log --oneline --graph
```

## Verify

After completing the exercises:

- `git log --oneline --graph` shows the merge commit with two parent lines converging.
- `git status` shows a clean working directory with nothing to commit.
- `cat config.py` shows your resolved version with no conflict markers.

## Bonus

- **Abort a merge:** Create a new branch, make a conflicting change, start a merge, then cancel it with `git merge --abort`. Notice everything goes back to how it was before the merge.
- **Create your own conflict:** Make two branches from the same commit, edit the same line in the same file on each branch, then try to merge them. Practice resolving the conflict yourself.
