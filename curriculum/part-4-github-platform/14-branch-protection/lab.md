# Lab 14: Branch Protection

## Goal

Set up branch protection rules on a repository and experience the enforced pull request workflow firsthand.

## Prerequisites

Modules 01-05 (you should be comfortable with branches, commits, and the PR workflow). Module 13 is recommended so you have a CI workflow for status checks.

**Note:** This lab uses both the GitHub web UI and the `gh` CLI. The setup script creates a temporary repository on GitHub with a CI workflow already in place. Some steps require a GitHub Pro/Team plan for full branch protection features; GitHub Free accounts can still use basic protection rules on public repositories.

## Setup

```bash
bash setup.sh
cd /tmp/git-lab-14
```

## Exercises

### 1. Open the repository settings

Get the repository URL and open it in your browser.

```bash
gh repo view --web
```

### 2. Navigate to branch protection

In your browser, go to **Settings** > **Branches** > **Add branch protection rule** (classic) or **Settings** > **Rules** > **New ruleset** (newer).

### 3. Configure the protection rule

Set the branch name pattern to `main` and enable the following:

- **Require a pull request before merging** -- set required approvals to 0 (since you are working solo, you cannot approve your own PR)
- **Do not allow force pushes**

Save the rule.

### 4. Try to push directly to main

Make a change and try to push directly. It should be rejected.

```bash
echo "// direct change" >> app.js
git add app.js
git commit -m "Try a direct push"
git push
```

You should see an error like: `protected branch hook declined` or `Changes must be made through a pull request`.

### 5. Reset your local main

Since the push was rejected, the commit only exists locally. Remove it to get back in sync.

```bash
git reset --soft HEAD~1
git restore --staged app.js
git checkout -- app.js
```

### 6. Do it the right way -- create a branch

Create a feature branch and make your change there.

```bash
git switch -c add-footer
```

### 7. Make a change and commit

```bash
cat >> index.html << 'EOF'
    <footer>
        <p>Built with care. Version 1.0</p>
    </footer>
EOF

git add index.html
git commit -m "Add footer to index page"
```

### 8. Push the branch and create a PR

```bash
git push -u origin add-footer
gh pr create --title "Add footer" --body "Adds a footer section to the index page."
```

### 9. Wait for status checks (if configured)

If you enabled "Require status checks to pass" and have a CI workflow, wait for the check to complete.

```bash
gh pr checks
```

### 10. Merge the PR

Since you set required approvals to 0, you can merge once status checks pass.

```bash
gh pr merge --merge
```

### 11. Pull the merged changes

Switch back to main and pull.

```bash
git switch main
git pull
git branch -d add-footer
```

### 12. View protection rules via CLI

Check what protection rules are set using the API.

```bash
gh api repos/{owner}/{repo}/branches/main/protection 2>/dev/null || echo "Use 'gh api repos/YOUR_USERNAME/git-lab-14-practice/branches/main/protection' with your actual username."
```

Replace `{owner}` with your GitHub username and `{repo}` with `git-lab-14-practice`.

## Verify

Confirm the lab worked:

```bash
git log --oneline
gh pr list --state merged
```

You should see the footer commit on main (merged via PR) and the direct push should not appear. The merged PR list should show your "Add footer" PR.

## Bonus

- **Require conversation resolution:** Add a comment to a PR, then enable "Require conversation resolution before merging" in the protection rule. Try to merge -- it will be blocked until you resolve the comment.
- **Require signed commits:** Enable "Require signed commits" and try to push an unsigned commit. See Module 15 for how to set up commit signing.
- **Rulesets:** If your plan supports it, try creating a ruleset instead of a classic rule. Rulesets let you target multiple branches with patterns and have an "evaluate" mode.
- **Status checks:** If you did not do Module 13 yet, go back and add a CI workflow, then enable "Require status checks to pass" in your protection rule.

## Cleanup

When you are done with this lab, delete the temporary GitHub repository:

```bash
gh repo delete git-lab-14-practice --yes
```
