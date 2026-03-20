# Lab 12: Issues & Projects

## Goal

Create and manage GitHub Issues, link them to pull requests, and see how merging a PR can automatically close an issue.

## Prerequisites

Modules 01-05 (you should be comfortable with branches, commits, and the PR workflow).

**Note:** This lab requires a real GitHub account and the `gh` CLI installed and authenticated. The setup script creates a temporary repository on GitHub.

## Setup

```bash
bash setup.sh
cd /tmp/git-lab-12
```

## Exercises

### 1. Create three issues

Create issues to represent different types of work.

```bash
gh issue create --title "Add user authentication" --label "feature" --body "Users should be able to log in with a username and password."
gh issue create --title "Fix login page layout" --label "bug" --body "The login button is misaligned on mobile screens."
gh issue create --title "Write API documentation" --label "documentation" --body "Document all REST endpoints in a docs file."
```

### 2. List open issues

See all the issues you just created. Note the issue numbers -- you will need them.

```bash
gh issue list
```

### 3. Create a custom label

Add a priority label to help triage bugs.

```bash
gh label create "priority:high" --color "FF0000" --description "Must fix before release"
```

### 4. Label the bug as high priority

Apply your custom label to the layout bug.

```bash
gh issue edit 2 --add-label "priority:high"
```

### 5. View issue details

Check that the label was added.

```bash
gh issue view 2
```

### 6. Create a branch to fix the bug

Start work on issue #2 by creating a feature branch.

```bash
git switch -c fix-login-layout
```

### 7. Make a fix and commit with an issue reference

Make a change and include "Fixes #2" in the commit message. This tells GitHub to close the issue when the PR merges.

```bash
cat >> style.css << 'EOF'

/* Fix login button alignment on mobile */
.login-button {
    display: block;
    margin: 0 auto;
    width: 100%;
    max-width: 300px;
}
EOF

git add style.css
git commit -m "Fix login button alignment on mobile

Fixes #2"
```

### 8. Push and create a pull request

Push the branch and open a PR. The PR body also references the issue.

```bash
git push -u origin fix-login-layout
gh pr create --title "Fix login page layout" --body "Fixes #2 -- centers the login button on mobile screens."
```

### 9. Merge the pull request

Merge the PR. This should automatically close issue #2.

```bash
gh pr merge --merge
```

### 10. Verify the issue closed

Check that issue #2 is now closed.

```bash
gh issue view 2
```

The status should show "CLOSED".

### 11. View remaining open issues

See what work is still outstanding.

```bash
gh issue list
```

You should see two open issues remaining (authentication and documentation).

## Verify

Confirm the lab worked:

```bash
gh issue list --state closed
gh issue list --state open
```

You should see one closed issue (#2) and two open issues (#1 and #3). The merged PR is linked to the closed issue.

## Bonus

- **Project board:** Visit your repository on GitHub, go to the Projects tab, and create a new project. Add your remaining open issues to it and organize them into columns.
- **Milestones:** Create a milestone with `gh api repos/{owner}/{repo}/milestones -f title="v1.0" -f description="First release"` and assign issues to it.
- **Issue templates:** Look into creating `.github/ISSUE_TEMPLATE/` files to standardize how people report bugs and request features.

## Cleanup

When you are done with this lab, delete the temporary GitHub repository:

```bash
gh repo delete git-lab-12-practice --yes
```
