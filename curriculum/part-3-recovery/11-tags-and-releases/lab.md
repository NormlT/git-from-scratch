# Lab 11: Tags & Releases

## Goal

Create tags, understand the difference between lightweight and annotated tags, push them to GitHub, and create a GitHub Release.

## Prerequisites

Modules 01-05 (you should be comfortable with commits and remotes).

> **Note:** This lab requires a GitHub account and the `gh` CLI. The setup script creates a temporary GitHub repository.

## Setup

```bash
bash setup.sh
cd /tmp/git-lab-11
```

## Exercises

### 1. Review the commit history

These commits represent the evolution of a small project. Each one is a candidate for tagging.

```bash
git log --oneline
```

### 2. Create a lightweight tag on the first commit

Find the hash of the first commit and tag it as an early prototype version.

```bash
git log --oneline | tail -1
git tag v0.1.0 <first-commit-hash>
```

### 3. Create an annotated tag on the latest commit

Annotated tags include a message, tagger info, and date. Use these for real releases.

```bash
git tag -a v1.0.0 -m "First stable release"
```

### 4. List and inspect tags

```bash
git tag
git show v0.1.0
git show v1.0.0
```

Notice the difference: `git show v0.1.0` (lightweight) jumps straight to the commit. `git show v1.0.0` (annotated) shows the tag metadata first, then the commit.

### 5. Push tags to GitHub

Tags are not pushed by `git push` alone. You must push them explicitly.

```bash
git push origin --tags
```

### 6. Create a GitHub Release

Use the `gh` CLI to create a release from the v1.0.0 tag.

```bash
gh release create v1.0.0 --title "v1.0.0" --notes "First stable release with core features"
```

### 7. View the release

```bash
gh release view v1.0.0
```

You can also visit the URL printed in the output to see the release page on GitHub.

### 8. Ship a patch release

Make a small change, commit it, tag it as a patch release, and create another GitHub Release.

```bash
cat >> app.py << 'PATCH'

def version():
    """Return the current version."""
    return "1.0.1"
PATCH

git add app.py
git commit -m "Add version endpoint"
git tag -a v1.0.1 -m "Patch: add version endpoint"
git push origin main --tags
gh release create v1.0.1 --title "v1.0.1" --notes "Patch release: added version endpoint"
```

### 9. List all releases

```bash
gh release list
```

You should see both v1.0.0 and v1.0.1.

## Verify

- `git tag` shows `v0.1.0`, `v1.0.0`, and `v1.0.1`.
- `gh release list` shows both releases on GitHub.
- `git show v1.0.0` displays the annotated tag metadata (tagger, date, message).

## Bonus

- **Delete a tag locally and remotely:**
  ```bash
  git tag -d v0.1.0
  git push origin --delete v0.1.0
  ```
- **Create a release with auto-generated notes** (GitHub compiles notes from merged PRs and commits since the last release):
  ```bash
  gh release create v1.1.0 --generate-notes
  ```
- **Clean up:** When you are done with this lab, delete the practice repository:
  ```bash
  gh repo delete git-lab-11-practice --yes
  ```
