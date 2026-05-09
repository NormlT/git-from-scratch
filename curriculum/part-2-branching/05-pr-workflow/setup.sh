#!/usr/bin/env bash
# Setup script for Lab 05: Pull Request Workflow
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

LAB_DIR="/tmp/git-lab-05"
REPO_NAME="git-lab-05-practice"

# Clean up any previous run
[[ "$LAB_DIR" == /tmp/git-lab-* ]] || { echo "refusing to delete outside /tmp/git-lab-*: $LAB_DIR" >&2; exit 1; }
rm -rf "$LAB_DIR"

# Delete the GitHub repo if it already exists (idempotent)
if gh repo view "$REPO_NAME" &>/dev/null; then
    echo "Deleting existing GitHub repository: $REPO_NAME ..."
    if ! gh repo delete "$REPO_NAME" --yes 2>&1; then
        echo ""
        echo "ERROR: Could not delete existing repo '$REPO_NAME'."
        echo "Either delete it manually from the repo's Settings page on GitHub"
        echo "or run:  gh auth refresh -h github.com -s delete_repo"
        echo "Then re-run this script."
        exit 1
    fi
fi

# Create a new GitHub repository
echo "Creating GitHub repository: $REPO_NAME ..."
gh repo create "$REPO_NAME" --private --clone --add-readme

# Move the clone to our lab directory
mv "$REPO_NAME" "$LAB_DIR"
cd "$LAB_DIR"

# Configure local git identity for the lab
git config user.name "Lab Author"
git config user.email "lab@example.com"

# Add an initial Python file
cat > app.py << 'EOF'
"""Simple application entry point."""

def main():
    print("Application started.")

if __name__ == "__main__":
    main()
EOF

git add app.py
git commit -m "Add application entry point"
git push

REPO_URL=$(gh repo view --json url -q '.url')

echo ""
echo "========================================="
echo "  Lab 05 setup complete!"
echo "========================================="
echo ""
echo "  GitHub repo:  $REPO_URL"
echo "  Local clone:  $LAB_DIR"
echo ""
echo "  To get started:"
echo "    cd $LAB_DIR"
echo "    git log --oneline"
echo ""
echo "  When you are done with the lab, clean up:"
echo "    gh repo delete $REPO_NAME --yes"
echo ""
echo "  (If that gives a 403 error, run:  gh auth refresh -h github.com -s delete_repo)"
echo ""

# Create support files for exercises (avoids fragile copy-paste commands)
FILES_DIR="/tmp/git-lab-05-files"
[[ "$FILES_DIR" == /tmp/git-lab-* ]] || { echo "refusing to delete outside /tmp/git-lab-*: $FILES_DIR" >&2; exit 1; }
rm -rf "$FILES_DIR"
mkdir -p "$FILES_DIR"

cat > "$FILES_DIR/greeting-v1.py" << 'EOF'
def greet(name):
    """Return a friendly greeting."""
    return f"Hello, {name}! Welcome aboard."

if __name__ == "__main__":
    print(greet("World"))
EOF

cat > "$FILES_DIR/greeting-v2.py" << 'EOF'
def greet(name, formal=False):
    """Return a friendly greeting."""
    if formal:
        return f"Good day, {name}. It is a pleasure to meet you."
    return f"Hello, {name}! Welcome aboard."

if __name__ == "__main__":
    print(greet("World"))
    print(greet("Professor", formal=True))
EOF
