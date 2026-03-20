#!/usr/bin/env bash
# Setup script for Lab 10: Cherry-pick & History
set -euo pipefail

LAB_DIR="/tmp/git-lab-10"

# Clean up any previous run
rm -rf "$LAB_DIR"
mkdir -p "$LAB_DIR"
cd "$LAB_DIR"

# Initialize a new git repo
git init -b main
git config user.name "Lab Author"
git config user.email "lab@example.com"

# Commit 1: Initial application
cat > app.py << 'EOF'
"""Simple web application."""

def home():
    """Return the home page content."""
    return "Welcome to the app!"

def about():
    """Return the about page content."""
    return "About this application."

if __name__ == "__main__":
    print(home())
EOF

git add app.py
git commit -m "Initial app with home and about pages"

# Commit 2: Add user module
cat > users.py << 'EOF'
"""User management."""

def create_user(name, email):
    """Create a new user."""
    return {"name": name, "email": email, "active": True}

def list_users():
    """Return all users."""
    return []
EOF

git add users.py
git commit -m "Add user management module"

# Commit 3: Add configuration
cat > config.py << 'EOF'
"""App configuration."""

DEBUG = False
DATABASE = "app.db"
SECRET_KEY = "change-me-in-production"
EOF

git add config.py
git commit -m "Add application configuration"

# Commit 4: Introduce the bug (this is the one bisect should find)
cat > bug.py << 'EOF'
"""This module has a bug."""

BUG = True

def problematic_function():
    """This function does not handle errors."""
    return 1 / 0
EOF

git add bug.py
git commit -m "Add experimental module"

# Commit 5: Update app.py
cat >> app.py << 'EOF'

def health():
    """Health check endpoint."""
    return {"status": "ok"}
EOF

git add app.py
git commit -m "Add health check endpoint"

# Commit 6: Add logging
cat > logging_config.py << 'EOF'
"""Logging configuration."""

import logging

def setup_logging(level="INFO"):
    """Configure application logging."""
    logging.basicConfig(
        level=getattr(logging, level),
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    )
    return logging.getLogger("app")
EOF

git add logging_config.py
git commit -m "Add logging configuration"

# Commit 7: Update users module
cat >> users.py << 'EOF'

def deactivate_user(user):
    """Deactivate a user account."""
    user["active"] = False
    return user
EOF

git add users.py
git commit -m "Add user deactivation function"

# Commit 8: Add tests placeholder
cat > tests.py << 'EOF'
"""Basic tests."""

def test_home():
    from app import home
    assert home() == "Welcome to the app!"

def test_create_user():
    from users import create_user
    user = create_user("Alice", "alice@example.com")
    assert user["name"] == "Alice"
    assert user["active"] is True
EOF

git add tests.py
git commit -m "Add basic test cases"

# Now create the feature branch with a useful fix commit
git switch -c feature

# Feature commit 1: Work in progress
cat > feature_wip.py << 'EOF'
"""Feature work in progress."""

def new_feature():
    """This feature is not ready yet."""
    pass
EOF

git add feature_wip.py
git commit -m "Start working on new feature (WIP)"

# Feature commit 2: The useful fix (this is the one to cherry-pick)
cat >> app.py << 'EOF'

def not_found():
    """Handle 404 errors gracefully."""
    return {"error": "Not found", "status": 404}
EOF

git add app.py
git commit -m "Fix critical: add missing 404 error handler"

# Feature commit 3: More WIP
cat >> feature_wip.py << 'EOF'

def another_incomplete_thing():
    """Still working on this."""
    raise NotImplementedError
EOF

git add feature_wip.py
git commit -m "Continue feature work (still incomplete)"

# Switch back to main so the user starts there
git switch main

# Record the cherry-pick target for the instructions
FIX_HASH=$(git log --oneline feature | grep "Fix critical" | awk '{print $1}')

echo ""
echo "========================================="
echo "  Lab 10 setup complete!"
echo "========================================="
echo ""
echo "  Practice repo created at: $LAB_DIR"
echo "  The repo has 8 commits on main and 3 on feature."
echo ""
echo "  Branches:"
echo "    - main (8 commits, you are here)"
echo "    - feature (3 additional commits)"
echo ""
echo "  Key commits:"
echo "    - Cherry-pick target: $FIX_HASH (Fix critical: add missing 404 error handler)"
echo "    - A bug was introduced somewhere in main's history (use bisect to find it)"
echo ""
echo "  To get started:"
echo "    cd $LAB_DIR"
echo "    git log --oneline --graph --all"
echo ""
