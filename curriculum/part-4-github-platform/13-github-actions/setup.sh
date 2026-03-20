#!/usr/bin/env bash
# Setup script for Lab 13: GitHub Actions
set -euo pipefail

LAB_DIR="/tmp/git-lab-13"
REPO_NAME="git-lab-13-practice"

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
