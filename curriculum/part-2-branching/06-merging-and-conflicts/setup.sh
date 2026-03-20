#!/usr/bin/env bash
# Setup script for Lab 06: Merging & Conflicts
set -euo pipefail

LAB_DIR="/tmp/git-lab-06"

# Clean up any previous run
rm -rf "$LAB_DIR"
mkdir -p "$LAB_DIR"
cd "$LAB_DIR"

# Initialize a new git repo
git init -b main
git config user.name "Lab Author"
git config user.email "lab@example.com"

# --- Base commits on main ---

cat > config.py << 'EOF'
"""Application configuration."""

APP_NAME = "MyApp"
VERSION = "1.0.0"
DEBUG = True
LOG_LEVEL = "WARNING"
EOF

cat > app.py << 'EOF'
"""Main application."""

def run():
    print("App is running.")

if __name__ == "__main__":
    run()
EOF

git add config.py app.py
git commit -m "Initial project with config and app"

cat > config.py << 'EOF'
"""Application configuration."""

APP_NAME = "MyApp"
VERSION = "1.1.0"
DEBUG = False
LOG_LEVEL = "WARNING"
MAX_RETRIES = 3
EOF

git add config.py
git commit -m "Update config: disable debug, add retries"

# --- Create feature-conflict branch HERE (before main diverges further) ---

git branch feature-conflict

# --- Add one more commit on main that changes config.py ---

cat > config.py << 'EOF'
"""Application configuration."""

APP_NAME = "MyApp"
VERSION = "1.2.0"
DEBUG = False
LOG_LEVEL = "INFO"
MAX_RETRIES = 3
TIMEOUT = 30
EOF

git add config.py
git commit -m "Update config: change log level, add timeout"

# --- Create feature-clean branch from HERE (tip of main) ---
# This ensures merging feature-clean back is a fast-forward

git branch feature-clean
git switch feature-clean

cat > helpers.py << 'EOF'
"""Helper utilities."""

def format_output(message):
    return f"[LOG] {message}"

def sanitize_input(text):
    return text.strip().lower()
EOF

git add helpers.py
git commit -m "Add helper utilities"

# --- Go to feature-conflict and change config.py (same lines as main) ---

git switch feature-conflict

cat > config.py << 'EOF'
"""Application configuration."""

APP_NAME = "MyApp"
VERSION = "2.0.0"
DEBUG = True
LOG_LEVEL = "DEBUG"
MAX_RETRIES = 5
EOF

git add config.py
git commit -m "Config overhaul: bump version, enable debug, increase retries"

# --- Return to main ---

git switch main

echo ""
echo "========================================="
echo "  Lab 06 setup complete!"
echo "========================================="
echo ""
echo "  Practice repo created at: $LAB_DIR"
echo ""
echo "  Branches:"
echo "    main             - has config changes (debug off, log=INFO, timeout)"
echo "    feature-clean    - adds helpers.py (fast-forward merge, no conflict)"
echo "    feature-conflict - changes config.py (will conflict with main)"
echo ""
echo "  To get started:"
echo "    cd $LAB_DIR"
echo "    git log --oneline --graph --all"
echo ""
