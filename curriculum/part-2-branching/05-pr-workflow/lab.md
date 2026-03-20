# Lab 05: Pull Request Workflow

## Goal

Practice the complete pull request workflow from creating a branch to merging the PR and cleaning up.

## Prerequisites

Modules 01-04 (you should be comfortable with branches and basic git operations).

**Note:** This lab requires a real GitHub account and the `gh` CLI installed and authenticated. The setup script creates a temporary repository on GitHub.

## Setup

```bash
bash setup.sh
cd /tmp/git-lab-05
```

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

```bash
cat > greeting.py << 'EOF'
def greet(name):
    """Return a friendly greeting."""
    return f"Hello, {name}! Welcome aboard."

if __name__ == "__main__":
    print(greet("World"))
EOF

git add greeting.py
git commit -m "Add greeting function"
```

### 4. Push the branch to GitHub

Push your branch and set up upstream tracking. The `-u` flag means future pushes on this branch just need `git push`.

```bash
git push -u origin add-greeting
```

### 5. Create a pull request

Use the GitHub CLI to open a PR. This creates a request to merge `add-greeting` into `main`.

```bash
gh pr create --title "Add greeting function" --body "Adds a simple greeting function that takes a name and returns a welcome message."
```

### 6. View your pull request

See the PR details right from the terminal.

```bash
gh pr view
```

### 7. Update the PR with another commit

Make an improvement to your function. Commit and push -- the PR updates automatically.

```bash
cat > greeting.py << 'EOF'
def greet(name, formal=False):
    """Return a friendly greeting.

    Args:
        name: The person's name.
        formal: If True, use a formal greeting.
    """
    if formal:
        return f"Good day, {name}. It is a pleasure to meet you."
    return f"Hello, {name}! Welcome aboard."

if __name__ == "__main__":
    print(greet("World"))
    print(greet("Professor", formal=True))
EOF

git add greeting.py
git commit -m "Add formal greeting option"
git push
```

### 8. Verify the PR updated

Check the PR again -- it should now show two commits.

```bash
gh pr view
```

### 9. Merge the pull request

Merge the PR using a merge commit.

```bash
gh pr merge --merge
```

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
