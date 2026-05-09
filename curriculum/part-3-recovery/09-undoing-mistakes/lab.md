# Lab 09: Undoing Mistakes

## Goal

Practice every level of "undo" so you know which tool to reach for when something goes wrong.

## Prerequisites

Modules 01-04 (you should be comfortable with commits, staging, and branches).

## Setup

**Step 1:** Run the setup script (use the full path to the script in your course directory):

```bash
bash setup.sh
```

**Step 2:** Switch to the practice directory:

```bash
cd /tmp/git-lab-09
```

All exercise commands below should be run from `/tmp/git-lab-09`.

## Exercises

### 1. Survey the scene

The setup created a repo with some history and some pending changes. Start by understanding the current state.

```bash
git status
git log --oneline
```

Notice there is a staged file (`oops.txt`) and a modified file (`main.py`).

### 2. Unstage a file

The file `oops.txt` was staged by accident. Remove it from the staging area without losing the file itself.

```bash
git restore --staged oops.txt
```

**Predict:** Before we run `git status` -- where will `oops.txt` appear now? Will it be gone, untracked, or still staged?

```bash
git status
```

The file still exists on disk -- you just told git not to include it in the next commit.

### 3. Discard working directory changes

You have modifications to `main.py` that you don't want. Throw them away and revert the file to its last committed state.

```bash
git restore main.py
```

**Predict:** Before we run `git diff` -- what do you think it will show?

```bash
git diff
```

### 4. Soft reset -- undo a commit but keep changes staged

The last commit has a bad message. First, check the current log to see what will change:

```bash
git log --oneline
```

Now undo the last commit with a soft reset:

```bash
git reset --soft HEAD~1
```

**Predict:** Before we check -- what happened to the changes from that commit? Are they gone, unstaged, or still staged?

```bash
git status
git log --oneline
```

### 5. Re-commit with a better message

Since the changes are still staged, just commit again with an improved message.

```bash
git commit -m "Add utility functions for data processing"
```

### 6. Mixed reset -- undo a commit and unstage changes

Now undo this commit again, but this time use the default reset (mixed -- no `--soft` flag):

```bash
git reset HEAD~1
```

**Predict:** How is a mixed reset different from the soft reset we just did? What state will the changes be in?

```bash
git status
```

### 7. Re-add and commit

Stage the changes again and commit. Use the specific filename rather than `-A` so you don't accidentally pick up other files (like the `oops.txt` you unstaged earlier).

```bash
git add helpers.py
git commit -m "Add utility functions for data processing"
```

### 8. Revert a bad commit

There is a commit earlier in history that "introduced a bug." Find it and undo it with revert, which is safe for shared branches because it does not rewrite history.

```bash
git log --oneline
```

Look for the commit with the message containing "Add buggy feature." Copy its hash, then:

```bash
git revert <hash>
```

Git will open an editor for the revert commit message. Accept the default and save. A new commit is created that undoes the buggy commit.

### 9. Verify history is preserved

```bash
git log --oneline
```

Notice that both the original "buggy" commit and the revert commit exist in history. Nothing was rewritten -- the mistake was corrected by adding a new commit on top.

### 10. Explore reflog -- your safety net

`git reflog` records everywhere HEAD has been, even operations that don't appear in `git log` (like resets).

```bash
git reflog
```

Scroll through the entries. You can see every reset, commit, and revert you have done in this session. If you ever "lose" a commit after a reset, this is where you find it.

## Verify

- `git log --oneline` shows the revert commit at the top.
- `git status` reports "nothing to commit, working tree clean" (after you clean up `oops.txt` if needed: `rm oops.txt`).
- `git reflog` shows your full history of HEAD movements.

## Bonus

Try a hard reset and then recover from it:

1. Note the current commit hash: `git log --oneline -1`
2. Hard reset back two commits: `git reset --hard HEAD~2`
3. Confirm the commits are "gone": `git log --oneline`
4. Find the lost commit in reflog: `git reflog`
5. Recover it: `git reset --hard <hash-from-reflog>`
6. Confirm everything is back: `git log --oneline`

This is why `git reflog` is your ultimate safety net -- almost nothing in git is truly lost.

## Quick Quiz

1. What is the difference between `git reset --soft` and `git reset --hard`?
2. When should you use `git revert` instead of `git reset`?
3. What is `git reflog` and why is it called your "safety net"?
