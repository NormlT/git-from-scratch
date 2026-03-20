#!/usr/bin/env bash
# Setup script for Lab 01: Explore a Git Repository
set -euo pipefail

LAB_DIR="/tmp/git-lab-01"

# Clean up any previous run
rm -rf "$LAB_DIR"
mkdir -p "$LAB_DIR"
cd "$LAB_DIR"

# Initialize a new git repo
git init -b main
git config user.name "Lab Author"
git config user.email "lab@example.com"

# Commit 1: Start the story
cat > story.txt << 'STORY'
The Forest Path
===============

Once upon a time, in a forest thick with ancient oaks and winding trails,
a traveler set out on a journey with nothing but a map and a lantern.
The path ahead was unclear, but the traveler was determined.
STORY

git add story.txt
git commit -m "Begin the story: introduce the traveler"

# Commit 2: Add a new paragraph
cat >> story.txt << 'STORY'

As night fell, the traveler came upon a clearing. In the center stood
a stone well, covered in moss and ivy. The water inside shimmered
with a faint blue glow, as if lit from somewhere far below.
STORY

git add story.txt
git commit -m "Add the discovery of the mysterious well"

# Commit 3: Continue the story
cat >> story.txt << 'STORY'

The traveler leaned over the edge and whispered a question into the
darkness. After a long silence, a voice echoed back -- not an answer,
but another question: "What are you willing to leave behind?"
STORY

git add story.txt
git commit -m "The well speaks back to the traveler"

# Commit 4: Add a turning point
cat >> story.txt << 'STORY'

Without hesitation, the traveler placed the lantern on the edge of the
well and stepped back. The glow from the water grew brighter, and the
forest around them began to change. New paths appeared where none had
been before.
STORY

git add story.txt
git commit -m "The traveler makes a choice and new paths appear"

echo ""
echo "========================================="
echo "  Lab 01 setup complete!"
echo "========================================="
echo ""
echo "  Practice repo created at: $LAB_DIR"
echo "  The repo has 4 commits telling a short story."
echo ""
echo "  To get started:"
echo "    cd $LAB_DIR"
echo "    git log --oneline"
echo ""
