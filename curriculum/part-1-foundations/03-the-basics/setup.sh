#!/usr/bin/env bash
# Setup script for Lab 03: The Basics
set -euo pipefail

LAB_DIR="/tmp/git-lab-03"

# Clean up any previous run
[[ "$LAB_DIR" == /tmp/git-lab-* ]] || { echo "refusing to delete outside /tmp/git-lab-*: $LAB_DIR" >&2; exit 1; }
rm -rf "$LAB_DIR"
mkdir -p "$LAB_DIR"
cd "$LAB_DIR"

# Initialize a new git repo
git init -b main
git config user.name "Lab Author"
git config user.email "lab@example.com"

# Create a simple README and make the initial commit
cat > README.md << 'EOF'
# Practice Project

A small project for practicing the git add-commit workflow.
EOF

git add README.md
git commit -m "Initial commit: add README"

echo ""
echo "========================================="
echo "  Lab 03 setup complete!"
echo "========================================="
echo ""
echo "  Practice repo created at: $LAB_DIR"
echo "  The repo has 1 initial commit with a README."
echo ""
echo "  To get started:"
echo "    cd $LAB_DIR"
echo "    git status"
echo ""

# Create support files for exercises (avoids fragile copy-paste commands)
FILES_DIR="/tmp/git-lab-03-files"
[[ "$FILES_DIR" == /tmp/git-lab-* ]] || { echo "refusing to delete outside /tmp/git-lab-*: $FILES_DIR" >&2; exit 1; }
rm -rf "$FILES_DIR"
mkdir -p "$FILES_DIR"

cat > "$FILES_DIR/app-v1.py" << 'EOF'
def main():
    print("Hello, world!")

if __name__ == "__main__":
    main()
EOF

cat > "$FILES_DIR/app-v2.py" << 'EOF'
def main():
    print("Hello, world!")

def greet(name):
    return f"Hello, {name}!"

if __name__ == "__main__":
    main()
EOF

cat > "$FILES_DIR/utils.py" << 'EOF'
def format_name(first, last):
    return f"{first} {last}"
EOF
