#!/usr/bin/env bash
# Setup script for Lab 09: Undoing Mistakes
set -euo pipefail

LAB_DIR="/tmp/git-lab-09"

# Clean up any previous run
rm -rf "$LAB_DIR"
mkdir -p "$LAB_DIR"
cd "$LAB_DIR"

# Initialize a new git repo
git init -b main
git config user.name "Lab Author"
git config user.email "lab@example.com"

# Commit 1: Initial project
cat > main.py << 'EOF'
"""Data processing application."""

def load_data(filepath):
    """Load data from a file."""
    with open(filepath, "r") as f:
        return f.readlines()

def clean_data(lines):
    """Remove empty lines and strip whitespace."""
    return [line.strip() for line in lines if line.strip()]

if __name__ == "__main__":
    print("Data processor ready.")
EOF

cat > README.md << 'EOF'
# Data Processor

A simple data processing tool for learning git undo operations.

## Usage

    python main.py
EOF

git add main.py README.md
git commit -m "Initial project setup"

# Commit 2: Add configuration
cat > config.py << 'EOF'
"""Application configuration."""

INPUT_DIR = "./data"
OUTPUT_DIR = "./output"
LOG_LEVEL = "INFO"
EOF

git add config.py
git commit -m "Add application configuration"

# Commit 3: The buggy commit (this is the one to revert later)
cat > buggy_feature.py << 'EOF'
"""A feature with a critical bug."""

def calculate_average(numbers):
    # BUG: divides by zero when list is empty
    return sum(numbers) / len(numbers)

def format_output(result):
    # BUG: crashes on None input
    return f"Result: {result.upper()}"
EOF

git add buggy_feature.py
git commit -m "Add buggy feature that crashes on edge cases"

# Commit 4: Add utilities
cat > utils.py << 'EOF'
"""Utility functions."""

def validate_input(data):
    """Check that input data is valid."""
    if not data:
        raise ValueError("Input data cannot be empty")
    return True

def format_timestamp(ts):
    """Format a Unix timestamp."""
    from datetime import datetime
    return datetime.fromtimestamp(ts).isoformat()
EOF

git add utils.py
git commit -m "Add input validation and timestamp formatting"

# Commit 5: This one has a bad message (the user will soft-reset it)
cat > helpers.py << 'EOF'
"""Helper functions for data transformation."""

def normalize(values):
    """Normalize a list of numbers to 0-1 range."""
    min_val = min(values)
    max_val = max(values)
    if max_val == min_val:
        return [0.0] * len(values)
    return [(v - min_val) / (max_val - min_val) for v in values]

def chunk_list(lst, size):
    """Split a list into chunks of the given size."""
    return [lst[i:i + size] for i in range(0, len(lst), size)]
EOF

git add helpers.py
git commit -m "wip stuff idk"

# Now set up the working directory state for the exercises:

# Stage oops.txt (the user will practice unstaging it)
cat > oops.txt << 'EOF'
This file was staged by accident.
It should not be committed.
EOF
git add oops.txt

# Modify main.py in the working directory (the user will practice discarding changes)
cat >> main.py << 'EOF'

# TODO: this was a bad idea, need to undo this
def broken_function():
    raise NotImplementedError("This should not be here")
EOF

echo ""
echo "========================================="
echo "  Lab 09 setup complete!"
echo "========================================="
echo ""
echo "  Practice repo created at: $LAB_DIR"
echo "  The repo has 5 commits on main."
echo ""
echo "  Current state:"
echo "    - oops.txt is staged (practice unstaging)"
echo "    - main.py has working directory changes (practice discarding)"
echo "    - Last commit has a bad message (practice soft reset)"
echo "    - One commit introduced a bug (practice revert)"
echo ""
echo "  To get started:"
echo "    cd $LAB_DIR"
echo "    git status"
echo "    git log --oneline"
echo ""
