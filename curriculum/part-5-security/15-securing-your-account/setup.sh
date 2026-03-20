#!/usr/bin/env bash
# Setup script for Lab 15: Securing Your Account
set -euo pipefail

LAB_DIR="/tmp/git-lab-15"

# Clean up any previous run
rm -rf "$LAB_DIR"

# Create lab directory
mkdir -p "$LAB_DIR"

echo ""
echo "========================================="
echo "  Lab 15 setup complete!"
echo "========================================="
echo ""
echo "  Lab directory:  $LAB_DIR"
echo ""
echo "  This module is a security audit checklist --"
echo "  no practice repo needed."
echo ""
echo "  Open GitHub Settings in your browser to"
echo "  follow the exercises:"
echo "    https://github.com/settings/security"
echo ""
echo "  Quick checks you can run now:"
echo "    gh auth status"
echo "    gh ssh-key list"
echo ""
