#!/usr/bin/env bash
# Setup script for Lab 04: Working with Branches
set -euo pipefail

LAB_DIR="/tmp/git-lab-04"

# Clean up any previous run
rm -rf "$LAB_DIR"
mkdir -p "$LAB_DIR"
cd "$LAB_DIR"

# Initialize a new git repo
git init -b main
git config user.name "Lab Author"
git config user.email "lab@example.com"

# Commit 1: Project scaffolding
cat > app.py << 'EOF'
"""Simple web application."""

def home():
    return "Welcome to the app!"

if __name__ == "__main__":
    print(home())
EOF

cat > README.md << 'EOF'
# My App

A simple Python application for learning git branches.

## Usage

    python app.py
EOF

git add app.py README.md
git commit -m "Initial project setup with app.py and README"

# Commit 2: Add configuration
cat > config.py << 'EOF'
"""Application configuration."""

APP_NAME = "MyApp"
VERSION = "0.1.0"
DEBUG = True
EOF

git add config.py
git commit -m "Add application configuration"

# Commit 3: Add a utility module
cat > utils.py << 'EOF'
"""Utility functions."""

def format_name(first, last):
    return f"{first} {last}"

def validate_email(email):
    return "@" in email and "." in email
EOF

git add utils.py
git commit -m "Add utility functions for name and email"

echo ""
echo "========================================="
echo "  Lab 04 setup complete!"
echo "========================================="
echo ""
echo "  Practice repo created at: $LAB_DIR"
echo "  The repo has 3 commits on main."
echo "  You are on the main branch."
echo ""
echo "  To get started:"
echo "    cd $LAB_DIR"
echo "    git log --oneline"
echo "    git branch"
echo ""
