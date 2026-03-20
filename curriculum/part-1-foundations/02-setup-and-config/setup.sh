#!/usr/bin/env bash
# Setup script for Lab 02: Setup & Config
# This module works with your real git configuration,
# so there is no practice repo to create.
set -euo pipefail

LAB_DIR="/tmp/git-lab-02"

# Create the directory for consistency with other modules
rm -rf "$LAB_DIR"
mkdir -p "$LAB_DIR"

echo ""
echo "========================================="
echo "  Lab 02 setup complete!"
echo "========================================="
echo ""
echo "  This module does not need a practice repo."
echo "  You will be working with your real git"
echo "  configuration, SSH keys, and GitHub CLI."
echo ""
echo "  An empty working directory was created at:"
echo "    $LAB_DIR"
echo ""
echo "  Start with the exercises in lab.md."
echo ""
