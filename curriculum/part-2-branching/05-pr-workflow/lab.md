# Lab 05: Pull Request Workflow

## Goal

Practice the complete pull request workflow from creating a branch to merging the PR and cleaning up.

## Prerequisites

Modules 01-04 (you should be comfortable with branches and basic git operations).

**Note:** This lab requires a real GitHub account and the `gh` CLI installed and authenticated. The setup script creates a temporary repository on GitHub.

## Setup

**Step 1:** Run the setup script (use the full path to the script in your course directory):

```bash
bash setup.sh
```

**Step 2:** Switch to the practice directory:

```bash
cd /tmp/git-lab-05
```

All exercise commands below should be run from `/tmp/git-lab-05`.

> **Follow along on GitHub:** Open your repository page in a browser (`gh repo view --web`) and keep it open throughout this lab. After each command that pushes to GitHub, refresh the page to see the change. Connecting the CLI commands to what you see in the GitHub UI makes the whole workflow click.

## Exercises

### 1. Explore the repo

The setup script created a GitHub repository and cloned it locally. Check what you are working with.

```bash
git log --oneline
git remote -v
```

### 2. Create a feature branch

Create a new branch for your feature and switch to it.

```bash
git switch -c add-greeting
```

### 3. Add a new file and commit

Create a `greeting.py` file with a simple function. Stage and commit it.

```python
def greet(name):
    """Return a friendly greeting."""
    return f"Hello, {name}! Welcome aboard."

if __name__ == "__main__":
    print(greet("World"))
```

```bash
cp /tmp/git-lab-05-files/greeting-v1.py greeting.py
```

```bash
git add greeting.py
git commit -m "Add greeting function"
```

### 4. Push the branch to GitHub

Push your branch and set up upstream tracking. The `-u` flag means future pushes on this branch just need `git push`.

```bash
git push -u origin add-greeting
```

> **Check GitHub:** Refresh your repo page -- you should see a banner saying your branch was recently pushed, with a "Compare & pull request" button.

### 5. Create a pull request

Use the GitHub CLI to open a PR. This creates a request to merge `add-greeting` into `main`.

```bash
gh pr create --title "Add greeting function" --body "Adds a simple greeting function that takes a name and returns a welcome message."
```

### 6. View your pull request

See the PR details right from the terminal.

```bash
gh pr view --json title,state,commits,url
```

### 7. Update the PR with another commit

Make an improvement to your function. Commit and push -- the PR updates automatically.

```python
def greet(name, formal=False):
    """Return a friendly greeting."""
    if formal:
        return f"Good day, {name}. It is a pleasure to meet you."
    return f"Hello, {name}! Welcome aboard."

if __name__ == "__main__":
    print(greet("World"))
    print(greet("Professor", formal=True))
```

```bash
cp /tmp/git-lab-05-files/greeting-v2.py greeting.py
```

```bash
git add greeting.py
git commit -m "Add formal greeting option"
git push
```

> **Check GitHub:** Open the PR page in your browser -- you should see both commits listed, and the diff now includes the `formal` parameter.

### 8. Verify the PR updated

Check the PR again -- it should now show two commits.

```bash
gh pr view --json title,state,commits,url
```

### 9. Merge the pull request

Merge the PR using a merge commit.

```bash
gh pr merge --merge
```

> **Check GitHub:** Refresh the PR page -- it should now show a purple "Merged" badge. The `add-greeting` branch label will say "deleted."

### 10. Pull the merged changes to main

Switch back to main and pull the merged changes.

```bash
git switch main
git pull
```

### 11. Clean up the feature branch

The feature branch has been merged, so you can safely delete it.

```bash
git branch -d add-greeting
```

## Verify

Confirm the PR was merged and your changes are on main:

```bash
gh pr list --state merged
git log --oneline
```

You should see your merged PR in the list and the greeting commits in the main branch history.

## Bonus

- **Draft PR:** Create another branch, push it, and open a draft PR with `gh pr create --draft`. Convert it to ready with `gh pr ready`.
- **PR from the web:** Visit the repository URL that the setup script printed. Try creating a PR through the GitHub web interface instead of the CLI.

## Cleanup

When you are done with this lab, delete the temporary GitHub repository:

```bash
gh repo delete git-lab-05-practice --yes
```

> **Got a 403 error?** Your GitHub token needs the `delete_repo` scope.
> Run `gh auth refresh -h github.com -s delete_repo` to add it, then retry.
> Or delete the repo from its **Settings** page on GitHub.

## Quick Quiz

1. What does the `-u` flag do in `git push -u origin <branch>`?
2. What is the difference between a branch-based and a fork-based PR workflow?
3. Why is code review through PRs valuable, even if you are confident in your changes?
