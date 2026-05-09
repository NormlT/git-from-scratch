#!/usr/bin/env bash
# Setup script for Lab 13: GitHub Actions
set -euo pipefail

# --- GitHub CLI preflight check ---
if ! command -v gh &>/dev/null; then
    echo "ERROR: GitHub CLI (gh) is not installed."
    echo "Install it: https://cli.github.com/"
    exit 1
fi
if ! gh auth status &>/dev/null; then
    echo "ERROR: GitHub CLI is not authenticated."
    echo "Run:  gh auth login"
    exit 1
fi
if ! gh auth status 2>&1 | grep -q 'delete_repo'; then
    echo ""
    echo "ERROR: Your GitHub token is missing the 'delete_repo' scope."
    echo "This is needed to clean up practice repos when you're done."
    echo ""
    echo "Fix it by running:"
    echo "  gh auth refresh -h github.com -s delete_repo"
    echo ""
    echo "Then re-run this setup script."
    exit 1
fi

LAB_DIR="/tmp/git-lab-13"
REPO_NAME="git-lab-13-practice"

# Clean up any previous run
[[ "$LAB_DIR" == /tmp/git-lab-* ]] || { echo "refusing to delete outside /tmp/git-lab-*: $LAB_DIR" >&2; exit 1; }
rm -rf "$LAB_DIR"

# Delete the GitHub repo if it already exists (idempotent)
gh repo delete "$REPO_NAME" --yes 2>/dev/null || true

# Create a new GitHub repository
echo "Creating GitHub repository: $REPO_NAME ..."
gh repo create "$REPO_NAME" --private --clone --add-readme

# Move the clone to our lab directory
mv "$REPO_NAME" "$LAB_DIR"
cd "$LAB_DIR"

# Configure local git identity for the lab
git config user.name "Lab Author"
git config user.email "lab@example.com"

# Add a simple script to test against
cat > script.sh << 'EOF'
#!/bin/bash
echo "Hello from the build script!"
echo "Build completed at $(date)"
EOF
chmod +x script.sh

# Add a basic project file
cat > app.py << 'EOF'
"""Simple application for CI testing."""

def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

if __name__ == "__main__":
    print(f"2 + 3 = {add(2, 3)}")
    print(f"5 - 1 = {subtract(5, 1)}")
EOF

git add script.sh app.py
git commit -m "Add application and build script"
git push

REPO_URL=$(gh repo view --json url -q '.url')

echo ""
echo "========================================="
echo "  Lab 13 setup complete!"
echo "========================================="
echo ""
echo "  GitHub repo:  $REPO_URL"
echo "  Local clone:  $LAB_DIR"
echo ""
echo "  To get started:"
echo "    cd $LAB_DIR"
echo "    ls -la"
echo ""
echo "  You will create workflow files in:"
echo "    .github/workflows/"
echo ""
echo "  When you are done with the lab, clean up:"
echo "    gh repo delete $REPO_NAME --yes"
echo ""
echo "  (If that gives a 403 error, run:  gh auth refresh -h github.com -s delete_repo)"
echo ""

# Create support files for exercises (avoids fragile copy-paste commands)
FILES_DIR="/tmp/git-lab-13-files"
[[ "$FILES_DIR" == /tmp/git-lab-* ]] || { echo "refusing to delete outside /tmp/git-lab-*: $FILES_DIR" >&2; exit 1; }
rm -rf "$FILES_DIR"
mkdir -p "$FILES_DIR"

cat > "$FILES_DIR/ci-v1.yml" << 'YAML'
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

cat > "$FILES_DIR/ci-v2.yml" << 'YAML'
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
