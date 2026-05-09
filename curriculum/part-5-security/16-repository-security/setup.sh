#!/usr/bin/env bash
# Setup script for Lab 16: Repository Security
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

LAB_DIR="/tmp/git-lab-16"
REPO_NAME="git-lab-16-practice"

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

# Create a simple Python application
cat > app.py << 'PYEOF'
"""Simple Flask application for lab practice."""
from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def index():
    return jsonify({"status": "ok", "message": "Hello from the lab app"})


@app.route("/health")
def health():
    return jsonify({"healthy": True})


if __name__ == "__main__":
    app.run(debug=True)
PYEOF

# Create requirements.txt with some dependencies
cat > requirements.txt << 'EOF'
flask==2.3.0
requests==2.31.0
EOF

# Create a basic .gitignore
cat > .gitignore << 'EOF'
__pycache__/
*.pyc
.env
venv/
EOF

git add app.py requirements.txt .gitignore
git commit -m "Add initial Python application"
git push

REPO_URL=$(gh repo view --json url -q '.url')

echo ""
echo "========================================="
echo "  Lab 16 setup complete!"
echo "========================================="
echo ""
echo "  GitHub repo:  $REPO_URL"
echo "  Local clone:  $LAB_DIR"
echo ""
echo "  To get started:"
echo "    cd $LAB_DIR"
echo ""
echo "  When you are done with the lab, clean up:"
echo "    gh repo delete $REPO_NAME --yes"
echo ""
echo "  (If that gives a 403 error, run:  gh auth refresh -h github.com -s delete_repo)"
echo ""

# Create support files for exercises (avoids fragile copy-paste commands)
FILES_DIR="/tmp/git-lab-16-files"
[[ "$FILES_DIR" == /tmp/git-lab-* ]] || { echo "refusing to delete outside /tmp/git-lab-*: $FILES_DIR" >&2; exit 1; }
rm -rf "$FILES_DIR"
mkdir -p "$FILES_DIR"

cat > "$FILES_DIR/SECURITY.md" << 'EOF'
# Security Policy

## Reporting a Vulnerability

Please email security@example.com to report vulnerabilities.
Do not open a public issue for security bugs.

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.x     | Yes       |

## Response Timeline

We will acknowledge your report within 48 hours and aim to release a fix within 7 days for critical vulnerabilities.
EOF

cat > "$FILES_DIR/dependabot.yml" << 'EOF'
version: 2
updates:
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
    labels:
      - "dependencies"
EOF

cat > "$FILES_DIR/requirements-old.txt" << 'EOF'
flask==2.0.0
requests==2.20.0
jinja2==3.0.0
EOF
