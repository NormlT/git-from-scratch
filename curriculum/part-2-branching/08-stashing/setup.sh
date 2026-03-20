#!/usr/bin/env bash
# Setup script for Lab 08: Stashing
set -euo pipefail

LAB_DIR="/tmp/git-lab-08"

# Clean up any previous run
rm -rf "$LAB_DIR"
mkdir -p "$LAB_DIR"
cd "$LAB_DIR"

# Initialize a new git repo
git init -b main
git config user.name "Lab Author"
git config user.email "lab@example.com"

# --- Commits on main ---

cat > app.py << 'EOF'
"""Main application."""

def main():
    print("Application running.")

if __name__ == "__main__":
    main()
EOF

cat > bug.txt << 'EOF'
component: auth
status: broken
description: Login fails for users with special characters in password.
EOF

git add app.py bug.txt
git commit -m "Initial project with app and known bug"

cat > utils.py << 'EOF'
"""Utility helpers."""

def validate(data):
    return bool(data)
EOF

git add utils.py
git commit -m "Add utility helpers"

# --- Create feature-dashboard branch and start working ---

git switch -c feature-dashboard

cat > dashboard.py << 'EOF'
"""Dashboard module."""

def render_dashboard(user):
    """Render the main dashboard."""
    return f"Welcome to your dashboard, {user}!"
EOF

git add dashboard.py
git commit -m "Start dashboard module"

# --- Add uncommitted work-in-progress (this is what the user will stash) ---

cat >> dashboard.py << 'EOF'

def render_sidebar():
    """Render the sidebar navigation."""
    items = ["Home", "Profile", "Settings"]
    return items

def render_notifications():
    """Render notification panel."""
    # TODO: implement notification fetching
    pass
EOF

echo ""
echo "========================================="
echo "  Lab 08 setup complete!"
echo "========================================="
echo ""
echo "  Practice repo created at: $LAB_DIR"
echo ""
echo "  You are on: feature-dashboard"
echo "  Status:     uncommitted work in progress on dashboard.py"
echo ""
echo "  Scenario:   You are mid-feature when an urgent bug comes in."
echo "              You need to stash your work, fix the bug on main,"
echo "              then come back and continue."
echo ""
echo "  To get started:"
echo "    cd $LAB_DIR"
echo "    git status"
echo ""
