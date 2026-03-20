#!/usr/bin/env bash
# Setup script for Lab 12: Issues & Projects
set -euo pipefail

LAB_DIR="/tmp/git-lab-12"
REPO_NAME="git-lab-12-practice"

# Clean up any previous run
rm -rf "$LAB_DIR"

# Delete the GitHub repo if it already exists (idempotent)
gh repo delete "$REPO_NAME" --yes 2>/dev/null || true

# Create a new GitHub repository
echo "Creating GitHub repository: $REPO_NAME ..."
gh repo create "$REPO_NAME" --private --clone --add-readme

# Move the clone to our lab directory
mv "$REPO_NAME" "$LAB_DIR"
cd "$LAB_DIR"

# Configure local git identity for the lab
git config user.name "Lab Author"
git config user.email "lab@example.com"

# Add starter files
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My App</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1>Welcome to My App</h1>
    <form id="login-form">
        <input type="text" placeholder="Username">
        <input type="password" placeholder="Password">
        <button class="login-button">Log In</button>
    </form>
    <script src="app.js"></script>
</body>
</html>
EOF

cat > style.css << 'EOF'
body {
    font-family: sans-serif;
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
}

h1 {
    color: #333;
}
EOF

cat > app.js << 'EOF'
// Application entry point
document.addEventListener("DOMContentLoaded", function() {
    console.log("App loaded.");
});
EOF

git add index.html style.css app.js
git commit -m "Add initial application files"
git push

# Create standard labels (GitHub creates some defaults, but we add ours)
gh label create "feature" --color "0E8A16" --description "New feature request" 2>/dev/null || true
gh label create "bug" --color "D73A4A" --description "Something is not working" 2>/dev/null || true
gh label create "documentation" --color "0075CA" --description "Improvements or additions to documentation" 2>/dev/null || true

REPO_URL=$(gh repo view --json url -q '.url')

echo ""
echo "========================================="
echo "  Lab 12 setup complete!"
echo "========================================="
echo ""
echo "  GitHub repo:  $REPO_URL"
echo "  Local clone:  $LAB_DIR"
echo ""
echo "  To get started:"
echo "    cd $LAB_DIR"
echo "    gh issue list"
echo ""
echo "  When you are done with the lab, clean up:"
echo "    gh repo delete $REPO_NAME --yes"
echo ""
