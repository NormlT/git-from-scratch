#!/usr/bin/env bash
# Setup script for Lab 17: Public Repo Best Practices
set -euo pipefail

LAB_DIR="/tmp/git-lab-17"

# Clean up any previous run
rm -rf "$LAB_DIR"

# Create lab directory and initialize repo
mkdir -p "$LAB_DIR"
cd "$LAB_DIR"
git init

# Configure local git identity for the lab
git config user.name "Lab Author"
git config user.email "lab@example.com"

# --- Commit 1: Initial project structure ---
cat > app.py << 'PYEOF'
"""Simple web application."""
from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def index():
    return jsonify({"status": "ok"})


if __name__ == "__main__":
    app.run()
PYEOF

cat > requirements.txt << 'EOF'
flask==3.0.0
requests==2.31.0
EOF

cat > .gitignore << 'EOF'
__pycache__/
*.pyc
venv/
EOF

git add app.py requirements.txt .gitignore
git commit -m "Initial project structure"

# --- Commit 2: Add config with REAL secrets (the mistake) ---
cat > config.py << 'PYEOF'
"""Application configuration."""

# Database settings
DB_HOST = "db.example.com"
DB_USER = "admin"
DB_PASSWORD = "supersecret123"

# External API
API_KEY = "sk-fake-secret-key-12345"
API_URL = "https://api.example.com/v1"

# App settings
DEBUG = True
SECRET_KEY = "my-app-secret-key-do-not-share"
PYEOF

git add config.py
git commit -m "Add application configuration"

# --- Commit 3: Add more features (normal development) ---
cat > utils.py << 'PYEOF'
"""Utility functions."""
import logging

logger = logging.getLogger(__name__)


def sanitize_input(text):
    """Remove potentially dangerous characters."""
    return text.strip().replace("<", "&lt;").replace(">", "&gt;")


def format_response(data, status="success"):
    """Create a standard API response format."""
    return {"status": status, "data": data}
PYEOF

git add utils.py
git commit -m "Add utility functions"

# --- Commit 4: "Fix" the secrets by replacing with REDACTED ---
cat > config.py << 'PYEOF'
"""Application configuration."""
import os

# Database settings
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_USER = os.getenv("DB_USER", "REDACTED")
DB_PASSWORD = os.getenv("DB_PASSWORD", "REDACTED")

# External API
API_KEY = os.getenv("API_KEY", "REDACTED")
API_URL = os.getenv("API_URL", "https://api.example.com/v1")

# App settings
DEBUG = os.getenv("DEBUG", "false").lower() == "true"
SECRET_KEY = os.getenv("SECRET_KEY", "REDACTED")
PYEOF

git add config.py
git commit -m "Move secrets to environment variables"

# --- Commit 5: Add tests (more normal development on top) ---
cat > test_app.py << 'PYEOF'
"""Basic tests for the application."""
import unittest


class TestApp(unittest.TestCase):
    def test_index(self):
        """Test the index endpoint returns ok status."""
        # In a real app, you'd use a test client
        self.assertTrue(True)

    def test_sanitize_input(self):
        """Test that HTML tags are escaped."""
        from utils import sanitize_input
        result = sanitize_input("<script>alert('xss')</script>")
        self.assertNotIn("<script>", result)


if __name__ == "__main__":
    unittest.main()
PYEOF

git add test_app.py
git commit -m "Add basic tests"

# --- Commit 6: Add a README ---
cat > README.md << 'EOF'
# My Application

A simple web application built with Flask.

## Setup

1. Create a virtual environment: `python -m venv venv`
2. Install dependencies: `pip install -r requirements.txt`
3. Set environment variables (see config.py)
4. Run: `python app.py`

## Testing

```bash
python -m pytest test_app.py
```
EOF

git add README.md
git commit -m "Add README"

echo ""
echo "========================================="
echo "  Lab 17 setup complete!"
echo "========================================="
echo ""
echo "  Practice repo:  $LAB_DIR"
echo ""
echo "  This repo has a hidden problem: secrets"
echo "  were committed in an early commit and"
echo "  then 'removed' -- but they are still in"
echo "  the git history."
echo ""
echo "  To get started:"
echo "    cd $LAB_DIR"
echo "    git log --oneline"
echo ""
echo "  Your job: audit this repo as if you were"
echo "  preparing to make it public."
echo ""
