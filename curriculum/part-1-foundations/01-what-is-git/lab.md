# Lab 01: Explore a Git Repository

## Goal

Explore a git repository's internals to build a mental model of how git tracks changes.

## Prerequisites

None -- this is the first module.

## Setup

```bash
bash setup.sh
cd /tmp/git-lab-01
```

## Exercises

### 1. View the commit history (compact)

Run `git log --oneline` in the practice repo. Count how many commits exist. Each line represents one snapshot of the project at a point in time.

```bash
git log --oneline
```

### 2. View the commit history (full details)

Run `git log` (without `--oneline`) to see the full details of each commit. Notice the four pieces of information for each entry:
- **commit hash** -- the long hexadecimal ID that uniquely identifies this snapshot
- **Author** -- who made the commit
- **Date** -- when it was made
- **Message** -- a description of what changed

```bash
git log
```

### 3. Check the current state

Run `git status` to see the current state of the repository. Notice it says "nothing to commit, working tree clean." This means your working directory matches the latest commit exactly -- no changes have been made.

```bash
git status
```

### 4. Make a change and observe

Open the file `story.txt` and add a new line at the end (anything you want). Save the file, then run `git status` again. Notice it now shows `story.txt` as "modified." Git detected that the file in your working directory no longer matches the last commit.

```bash
echo "The sun began to set over the valley." >> story.txt
git status
```

### 5. See exactly what changed

Run `git diff` to see a line-by-line comparison between the working directory and the last commit. Lines starting with `+` are additions. Lines starting with `-` are removals. This is how git tracks changes -- not by saving entire copies of files, but by recording the differences.

```bash
git diff
```

### 6. Peek inside the `.git/` directory

List the contents of the `.git/` directory. This hidden folder is where git stores everything -- the entire history of your project, all branches, all configuration. You do not need to understand it all yet, but notice folders like `objects/` (where snapshots are stored) and `refs/` (where branch pointers live).

```bash
ls .git/
```

## Verify

After completing the exercises, you should be able to answer:

- **What is a commit?** A snapshot of your project at a specific point in time, with a unique hash, author, date, and message.
- **What is the difference between the working directory and the staging area?** The working directory is where you edit files. The staging area is where you place changes you want to include in the next commit.
- **What does `git status` tell you?** It shows which files have been modified, which changes are staged for the next commit, and which files git is not tracking yet.

## Bonus

Run `git log --oneline --graph --all` and try to visualize what the history looks like as a timeline. Right now it is a simple straight line, but later when we learn about branches, this view becomes much more interesting.

```bash
git log --oneline --graph --all
```
