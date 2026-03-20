#!/usr/bin/env bash
# Setup script for Lab 11: Tags & Releases
set -euo pipefail

LAB_DIR="/tmp/git-lab-11"
REPO_NAME="git-lab-11-practice"

# Clean up any previous run
rm -rf "$LAB_DIR"

# Check for gh CLI
if ! command -v gh &> /dev/null; then
    echo "ERROR: The 'gh' CLI is required for this lab."
    echo "Install it: https://cli.github.com/"
    exit 1
fi

# Check gh authentication
if ! gh auth status &> /dev/null; then
    echo "ERROR: You are not authenticated with gh."
    echo "Run: gh auth login"
    exit 1
fi

# Get the authenticated GitHub username
GH_USER=$(gh api user --jq '.login')

# Delete the repo if it already exists (idempotent)
if gh repo view "$GH_USER/$REPO_NAME" &> /dev/null; then
    echo "Cleaning up existing repo: $GH_USER/$REPO_NAME"
    gh repo delete "$GH_USER/$REPO_NAME" --yes
fi

# Create a new GitHub repo (private)
echo "Creating GitHub repository: $GH_USER/$REPO_NAME"
gh repo create "$REPO_NAME" --private --clone
cd "$LAB_DIR" 2>/dev/null || cd "$REPO_NAME"

# If gh cloned into a named directory instead of LAB_DIR, move it
if [ "$(pwd)" != "$LAB_DIR" ]; then
    cd ..
    mv "$REPO_NAME" "$LAB_DIR"
    cd "$LAB_DIR"
fi

# Configure git for this repo
git config user.name "Lab Author"
git config user.email "lab@example.com"

# Commit 1: Project scaffolding
cat > app.py << 'EOF'
"""Task tracker application."""

def add_task(title):
    """Add a new task."""
    return {"title": title, "done": False}

if __name__ == "__main__":
    print("Task Tracker v0.1")
EOF

cat > README.md << 'EOF'
# Task Tracker

A simple task tracking tool.

## Usage

    python app.py
EOF

git add app.py README.md
git commit -m "Initial project scaffolding"

# Commit 2: Add task management
cat >> app.py << 'EOF'

def complete_task(task):
    """Mark a task as done."""
    task["done"] = True
    return task

def list_tasks(tasks):
    """Display all tasks."""
    for i, task in enumerate(tasks, 1):
        status = "done" if task["done"] else "todo"
        print(f"  {i}. [{status}] {task['title']}")
EOF

git add app.py
git commit -m "Add task completion and listing"

# Commit 3: Add storage
cat > storage.py << 'EOF'
"""Persistent storage for tasks."""

import json
import os

DATA_FILE = "tasks.json"

def save_tasks(tasks):
    """Save tasks to disk."""
    with open(DATA_FILE, "w") as f:
        json.dump(tasks, f, indent=2)

def load_tasks():
    """Load tasks from disk."""
    if not os.path.exists(DATA_FILE):
        return []
    with open(DATA_FILE, "r") as f:
        return json.load(f)
EOF

git add storage.py
git commit -m "Add persistent JSON storage"

# Commit 4: Add filtering
cat >> app.py << 'EOF'

def filter_tasks(tasks, done=None):
    """Filter tasks by completion status."""
    if done is None:
        return tasks
    return [t for t in tasks if t["done"] == done]
EOF

git add app.py
git commit -m "Add task filtering by status"

# Commit 5: Add CLI interface
cat > cli.py << 'EOF'
"""Command-line interface for the task tracker."""

import sys
from app import add_task, complete_task, list_tasks
from storage import save_tasks, load_tasks

def main():
    """Run the CLI."""
    tasks = load_tasks()

    if len(sys.argv) < 2:
        print("Usage: python cli.py [add|list|done] [args...]")
        return

    command = sys.argv[1]

    if command == "add" and len(sys.argv) > 2:
        title = " ".join(sys.argv[2:])
        tasks.append(add_task(title))
        save_tasks(tasks)
        print(f"Added: {title}")
    elif command == "list":
        list_tasks(tasks)
    elif command == "done" and len(sys.argv) > 2:
        index = int(sys.argv[2]) - 1
        if 0 <= index < len(tasks):
            complete_task(tasks[index])
            save_tasks(tasks)
            print(f"Completed: {tasks[index]['title']}")
    else:
        print("Unknown command")

if __name__ == "__main__":
    main()
EOF

git add cli.py
git commit -m "Add command-line interface"

# Push everything to GitHub
git push -u origin main

echo ""
echo "========================================="
echo "  Lab 11 setup complete!"
echo "========================================="
echo ""
echo "  Practice repo created at: $LAB_DIR"
echo "  GitHub repo: $GH_USER/$REPO_NAME (private)"
echo "  The repo has 5 commits on main."
echo ""
echo "  To get started:"
echo "    cd $LAB_DIR"
echo "    git log --oneline"
echo ""
echo "  CLEANUP: When you are done with this lab, delete the GitHub repo:"
echo "    gh repo delete $REPO_NAME --yes"
echo ""
