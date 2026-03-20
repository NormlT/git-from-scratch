# Lab 13: GitHub Actions

## Goal

Create a GitHub Actions workflow that runs automatically on push and pull request, then watch it execute in real time.

## Prerequisites

Modules 01-05 (you should be comfortable with branches, commits, and the PR workflow).

**Note:** This lab requires a real GitHub account and the `gh` CLI installed and authenticated. The setup script creates a temporary repository on GitHub.

## Setup

```bash
bash setup.sh
cd /tmp/git-lab-13
```

## Exercises

### 1. Create the workflow directory

GitHub Actions looks for workflow files in a specific location.

```bash
mkdir -p .github/workflows
```

### 2. Create a CI workflow

Write a workflow file that runs on pushes and PRs to main.

```bash
cat > .github/workflows/ci.yml << 'YAML'
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: |
          echo "Running tests..."
          cat README.md
          echo "All tests passed!"
YAML
```

### 3. Commit and push the workflow

When you push this file, GitHub will detect the workflow and start running it.

```bash
git add .github/workflows/ci.yml
git commit -m "Add CI workflow"
git push
```

### 4. Check workflow runs

Give it a few seconds, then list the workflow runs.

```bash
gh run list
```

You should see a run triggered by your push.

### 5. View the run details

Check the details of the latest run.

```bash
gh run view
```

Select the most recent run if prompted. You should see the "test" job and its steps.

### 6. Wait for completion

If the run is still in progress, watch it live.

```bash
gh run watch
```

It should complete successfully with a green checkmark.

### 7. Trigger the workflow via a pull request

Create a branch, make a change, and open a PR. The workflow should run on the PR.

```bash
git switch -c improve-readme
echo "" >> README.md
echo "## Contributing" >> README.md
echo "Pull requests are welcome." >> README.md
git add README.md
git commit -m "Add contributing section to README"
git push -u origin improve-readme
gh pr create --title "Add contributing section" --body "Adds a contributing section to the README."
```

### 8. Check PR status checks

The workflow should be running against your PR.

```bash
gh pr checks
```

Wait until it shows a passing status.

### 9. Add a second job to the workflow

Switch back to main (or edit on the branch) and add a linting job that runs alongside the test job.

```bash
cat > .github/workflows/ci.yml << 'YAML'
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: |
          echo "Running tests..."
          cat README.md
          echo "All tests passed!"

  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run linter
        run: |
          echo "Linting code..."
          echo "No lint errors found!"
YAML
```

### 10. Push and watch both jobs run

Commit and push the updated workflow, then watch the results.

```bash
git add .github/workflows/ci.yml
git commit -m "Add lint job to CI workflow"
git push
gh run watch
```

You should see both the `test` and `lint` jobs running in parallel.

### 11. Merge the PR and clean up

```bash
git switch main
gh pr merge --merge
git pull
git branch -d improve-readme
```

## Verify

Confirm the lab worked:

```bash
gh run list --limit 5
gh workflow list
```

You should see multiple successful workflow runs and the CI workflow listed.

## Bonus

- **Scheduled workflow:** Try adding a workflow that runs on a schedule. Add `on: schedule: [{cron: '0 0 * * 0'}]` to trigger every Sunday at midnight UTC.
- **Matrix strategy:** Modify the test job to run on multiple operating systems using a matrix:
  ```yaml
  strategy:
    matrix:
      os: [ubuntu-latest, macos-latest]
  runs-on: ${{ matrix.os }}
  ```
- **Status badge:** Add a workflow status badge to your README with `![CI](../../actions/workflows/ci.yml/badge.svg)`.

## Cleanup

When you are done with this lab, delete the temporary GitHub repository:

```bash
gh repo delete git-lab-13-practice --yes
```
