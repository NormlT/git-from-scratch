#!/usr/bin/env bash
# Setup script for Lab 07: Rebasing
set -euo pipefail

LAB_DIR="/tmp/git-lab-07"

# Clean up any previous run
rm -rf "$LAB_DIR"
mkdir -p "$LAB_DIR"
cd "$LAB_DIR"

# Initialize a new git repo
git init -b main
git config user.name "Lab Author"
git config user.email "lab@example.com"

# --- Base commits on main ---

cat > app.py << 'EOF'
"""Main application."""

def main():
    print("App started.")

if __name__ == "__main__":
    main()
EOF

git add app.py
git commit -m "Initial app setup"

cat > models.py << 'EOF'
"""Data models."""

class User:
    def __init__(self, name, email):
        self.name = name
        self.email = email
EOF

git add models.py
git commit -m "Add User model"

# --- Create feature-rebase branch from this point ---

git branch feature-rebase

# --- Continue adding commits on main (diverging from feature-rebase) ---

cat > auth.py << 'EOF'
"""Authentication module."""

def authenticate(username, password):
    """Check credentials against the database."""
    return username == "admin" and password == "secret"
EOF

git add auth.py
git commit -m "Add authentication module"

cat > routes.py << 'EOF'
"""URL routes."""

ROUTES = {
    "/": "home",
    "/login": "login",
    "/dashboard": "dashboard",
}
EOF

git add routes.py
git commit -m "Add URL routing"

# --- Add commits on feature-rebase (diverging from main) ---

git switch feature-rebase

cat > api.py << 'EOF'
"""API endpoints."""

def get_users():
    return [{"name": "Alice"}, {"name": "Bob"}]

def get_user(user_id):
    return {"id": user_id, "name": "Alice"}
EOF

git add api.py
git commit -m "Add API endpoints for users"

cat > serializers.py << 'EOF'
"""Data serialization."""

def serialize_user(user):
    return {"name": user.name, "email": user.email}
EOF

git add serializers.py
git commit -m "Add user serializer"

# --- Create feature-cleanup branch from main with messy commits ---

git switch main
git branch feature-cleanup
git switch feature-cleanup

cat > dashboard.py << 'EOF'
"""Dashboard view."""

def render_dashboard(user):
    return f"Dashboard for {user.name}"
EOF

git add dashboard.py
git commit -m "Add dashboard layout"

# Fix a typo
cat > dashboard.py << 'EOF'
"""Dashboard view."""

def render_dashboard(user):
    """Render the main dashboard for a user."""
    return f"Dashboard for {user.name}"
EOF

git add dashboard.py
git commit -m "Fix typo in dashboard"

# WIP styling
cat > dashboard.py << 'EOF'
"""Dashboard view."""

STYLES = {
    "header": "bold",
    "sidebar": "compact",
}

def render_dashboard(user):
    """Render the main dashboard for a user."""
    return f"Dashboard for {user.name}"
EOF

git add dashboard.py
git commit -m "WIP: dashboard styles"

# Finish styling
cat > dashboard.py << 'EOF'
"""Dashboard view."""

STYLES = {
    "header": "bold",
    "sidebar": "compact",
    "content": "wide",
    "footer": "minimal",
}

def render_dashboard(user):
    """Render the main dashboard for a user."""
    header = f"Welcome, {user.name}"
    return f"[{STYLES['header']}] {header}"
EOF

git add dashboard.py
git commit -m "Finish dashboard styling"

# --- Return to main ---

git switch main

echo ""
echo "========================================="
echo "  Lab 07 setup complete!"
echo "========================================="
echo ""
echo "  Practice repo created at: $LAB_DIR"
echo ""
echo "  Branches:"
echo "    main             - base with 4 commits"
echo "    feature-rebase   - diverged from main, 2 commits to rebase"
echo "    feature-cleanup  - 4 messy commits to squash with interactive rebase"
echo ""
echo "  To get started:"
echo "    cd $LAB_DIR"
echo "    git log --oneline --graph --all"
echo ""
