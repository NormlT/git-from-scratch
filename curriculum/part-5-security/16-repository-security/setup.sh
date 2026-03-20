#!/usr/bin/env bash
# Setup script for Lab 16: Repository Security
set -euo pipefail

LAB_DIR="/tmp/git-lab-16"
REPO_NAME="git-lab-16-practice"

# Clean up any previous run
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
