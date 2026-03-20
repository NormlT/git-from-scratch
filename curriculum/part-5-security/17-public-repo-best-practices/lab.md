# Lab 17: Public Repo Best Practices

## Goal

Audit a repository for public readiness -- find secrets buried in history, improve .gitignore, and add LICENSE and CODEOWNERS files.

## Prerequisites

Modules 01-05 (you should be comfortable with commits, git log, and working with files).

## Setup

```bash
bash setup.sh
cd /tmp/git-lab-17
```

The setup script creates a local repository with a realistic history -- including a deliberately committed secret that was later "removed."

## Exercises

### 1. Explore the repository

Look at the current state of the repo:

```bash
ls -la
cat app.py
cat config.py
cat .gitignore
git log --oneline
```

Everything looks clean, right? The config file has "REDACTED" values. But let's dig deeper.

### 2. Search history for secrets

Search the entire git history for common secret patterns:

```bash
git log --all -p -S "password"
```

You should find a commit where a real password was added. Note the commit hash.

### 3. Search for more secret patterns

```bash
git log --all -p -S "api_key"
git log --all -p -S "secret"
git log --all -p -S "sk-"
```

You should find an API key that was committed in an early commit.

### 4. Understand the problem

The secrets were "removed" in a later commit -- but they are still in the git history. Run:

```bash
git show <commit-hash-where-secret-was-added>
```

(Use the commit hash you found in step 2.)

Anyone who clones this repo can see the original secrets. **Deleting a file or changing its contents does not erase the old versions from git history.**

### 5. Improve .gitignore

The current `.gitignore` is incomplete. Add patterns for common sensitive files:

```bash
cat >> .gitignore << 'EOF'

# Secrets and credentials
.env
.env.*
*.pem
*.key
config/secrets.yml
credentials.json

# IDE settings
.vscode/
.idea/

# OS files
.DS_Store
Thumbs.db
EOF
```

### 6. Commit the .gitignore improvements

```bash
git add .gitignore
git commit -m "Improve .gitignore with patterns for secrets, IDE, and OS files"
```

### 7. Add a LICENSE file

Choose a license and create the file. Here is MIT as an example:

Use curl to fetch the MIT license text directly (no copy-paste required):

```bash
curl -s https://raw.githubusercontent.com/nicklockwood/MIT-LICENSE/master/MIT-LICENSE \
  | sed "s/Copyright .*/Copyright (c) $(date +%Y) Your Name/" > LICENSE

git add LICENSE
git commit -m "Add MIT license"
```

Alternatively, open `nano LICENSE` and paste the text from [choosealicense.com/licenses/mit](https://choosealicense.com/licenses/mit/) -- click the copy button on that page.

### 8. Add CODEOWNERS

Create a CODEOWNERS file to require reviews for sensitive paths:

```bash
mkdir -p .github
printf '%s\n' '# Default owner for everything' '* @your-username' '' '# Specific owners for sensitive areas' '/config.py @your-username' '/.github/ @your-username' '/.gitignore @your-username' > .github/CODEOWNERS

git add .github/CODEOWNERS
git commit -m "Add CODEOWNERS for review requirements"
```

### 9. Run a final secret audit

Check if the secrets are still in history:

```bash
git log --all -p -S "password"
```

The secret is **still there**. Your `.gitignore` improvements prevent future mistakes, but they cannot erase the past. To truly remove it, you would need to rewrite history with `git filter-repo`.

### 10. Review your public-readiness checklist

```bash
echo "=== Public Readiness Audit ==="
echo ""
echo "LICENSE exists:"
test -f LICENSE && echo "  YES" || echo "  NO -- add one!"
echo ""
echo ".gitignore covers sensitive patterns:"
grep -q "\.env" .gitignore && echo "  YES" || echo "  NO -- update it!"
echo ""
echo "CODEOWNERS exists:"
test -f .github/CODEOWNERS && echo "  YES" || echo "  NO -- add one!"
echo ""
echo "Secrets in history:"
SECRETS_FOUND=$(git log --all -p -S "sk-fake" --oneline | head -1)
if [ -n "$SECRETS_FOUND" ]; then
    echo "  WARNING: Secrets found in history! Must rewrite history before going public."
else
    echo "  Clean -- no secrets detected."
fi
```

## Verify

Confirm the following:

- `.gitignore` includes patterns for `.env`, `*.pem`, `*.key`, and other sensitive files.
- `LICENSE` file exists in the repo root.
- `.github/CODEOWNERS` file exists.
- `git log --all -p -S "password"` still shows the old secret in history (proving that deletion is not enough).

## Bonus

Install `git-filter-repo` and try rewriting history to remove the committed secret:

```bash
# Install git-filter-repo (if not already installed)
# pip install git-filter-repo

# Remove the config.py file from ALL history
git filter-repo --invert-paths --path config.py --force

# Verify the secret is gone
git log --all -p -S "password"
```

**WARNING:** This rewrites all commit hashes. Never do this on a shared repository without coordinating with your team. In a real scenario, you would also rotate the compromised credentials immediately -- even after removing them from history, assume they were seen.
