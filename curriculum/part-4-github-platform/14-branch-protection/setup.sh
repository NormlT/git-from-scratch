#!/usr/bin/env bash
# Setup script for Lab 14: Branch Protection
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

LAB_DIR="/tmp/git-lab-14"
REPO_NAME="git-lab-14-practice"

# Clean up any previous run
[[ "$LAB_DIR" == /tmp/git-lab-* ]] || { echo "refusing to delete outside /tmp/git-lab-*: $LAB_DIR" >&2; exit 1; }
rm -rf "$LAB_DIR"

# Delete the GitHub repo if it already exists (idempotent)
gh repo delete "$REPO_NAME" --yes 2>/dev/null || true

# Create a new GitHub repository
echo "Creating GitHub repository: $REPO_NAME ..."
gh repo create "$REPO_NAME" --public --clone --add-readme

# Move the clone to our lab directory
mv "$REPO_NAME" "$LAB_DIR"
cd "$LAB_DIR"

# Configure local git identity for the lab
git config user.name "Lab Author"
git config user.email "lab@example.com"

# Add application files
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Protected App</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1>Protected App</h1>
    <p>This repository has branch protection enabled.</p>
    <script src="app.js"></script>
</body>
</html>
EOF

cat > style.css << 'EOF'
body {
    font-family: sans-serif;
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
}
EOF

cat > app.js << 'EOF'
// Application entry point
console.log("App loaded.");
EOF

git add index.html style.css app.js
git commit -m "Add initial application files"

# Add a CI workflow so there are status checks available
mkdir -p .github/workflows
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

git add .github/workflows/ci.yml
git commit -m "Add CI workflow for status checks"
git push

REPO_URL=$(gh repo view --json url -q '.url')

echo ""
echo "========================================="
echo "  Lab 14 setup complete!"
echo "========================================="
echo ""
echo "  GitHub repo:  $REPO_URL"
echo "  Local clone:  $LAB_DIR"
echo ""
echo "  Next steps:"
echo "    1. cd $LAB_DIR"
echo "    2. Open the repo in your browser:"
echo "       gh repo view --web"
echo "    3. Go to Settings > Branches to add"
echo "       branch protection rules"
echo ""
echo "  When you are done with the lab, clean up:"
echo "    gh repo delete $REPO_NAME --yes"
echo ""
echo "  (If that gives a 403 error, run:  gh auth refresh -h github.com -s delete_repo)"
echo ""

# Create support files for exercises (avoids fragile copy-paste commands)
FILES_DIR="/tmp/git-lab-14-files"
[[ "$FILES_DIR" == /tmp/git-lab-* ]] || { echo "refusing to delete outside /tmp/git-lab-*: $FILES_DIR" >&2; exit 1; }
rm -rf "$FILES_DIR"
mkdir -p "$FILES_DIR"

cat > "$FILES_DIR/index-with-footer.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Protected App</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1>Protected App</h1>
    <p>This repository has branch protection enabled.</p>
    <script src="app.js"></script>
    <footer>
        <p>Built with care. Version 1.0</p>
    </footer>
</body>
</html>
EOF
