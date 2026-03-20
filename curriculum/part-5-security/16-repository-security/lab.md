# Lab 16: Repository Security

## Goal

Enable and explore GitHub's repository security features: Dependabot, secret scanning, and security policies.

## Prerequisites

Modules 01-05 (you should be comfortable with commits, branches, and pushing to GitHub).

**Note:** This lab requires a real GitHub account and the `gh` CLI installed and authenticated. The setup script creates a temporary repository on GitHub.

## Setup

```bash
bash setup.sh
cd /tmp/git-lab-16
```

## Exercises

### 1. Explore the practice repo

Look at what the setup script created:

```bash
ls -la
cat app.py
cat requirements.txt
```

This is a simple Python project with some dependencies.

### 2. Create a SECURITY.md file

This file tells people how to responsibly report vulnerabilities in your project:

```bash
cat > SECURITY.md << 'EOF'
# Security Policy

## Reporting a Vulnerability

Please email security@example.com to report vulnerabilities.
Do not open a public issue for security bugs.

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.x     | Yes       |

## Response Timeline

We will acknowledge your report within 48 hours and aim to release a fix within 7 days for critical vulnerabilities.
EOF
```

### 3. Commit and push SECURITY.md

```bash
git add SECURITY.md
git commit -m "Add security policy"
git push
```

### 4. Enable Dependabot alerts

Visit your repository on GitHub: **Settings > Code security and analysis**.

- Enable **Dependabot alerts** -- this monitors your dependencies for known vulnerabilities.
- Enable **Dependabot security updates** -- this automatically creates PRs to update vulnerable packages.

### 5. Enable secret scanning

On the same settings page:

- Enable **Secret scanning** -- this detects accidentally committed API keys, tokens, and passwords.
- Enable **Push protection** if available -- this blocks pushes that contain detected secrets.

### 6. Create a Dependabot configuration file

This gives you fine-grained control over how Dependabot checks for updates:

```bash
mkdir -p .github
cat > .github/dependabot.yml << 'EOF'
version: 2
updates:
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
    labels:
      - "dependencies"
EOF
```

### 7. Commit and push the Dependabot config

```bash
git add .github/dependabot.yml
git commit -m "Add Dependabot configuration for weekly pip updates"
git push
```

This tells Dependabot to check Python dependencies weekly and label its PRs with "dependencies."

### 8. Trigger Dependabot with an old dependency

Update `requirements.txt` to include an intentionally old package version with known vulnerabilities:

```bash
cat > requirements.txt << 'EOF'
flask==2.0.0
requests==2.20.0
jinja2==3.0.0
EOF

git add requirements.txt
git commit -m "Pin dependencies to specific versions"
git push
```

Within a few minutes, Dependabot should create alerts (and possibly PRs) for the outdated packages.

### 9. Check for Dependabot alerts

After a few minutes, check for alerts:

```bash
gh api repos/:owner/:repo/dependabot/alerts --jq '.[].security_advisory.summary' 2>/dev/null || echo "No alerts yet -- check back in a few minutes or visit the Security tab on GitHub."
```

You can also check the **Security** tab on your repository's GitHub page.

### 10. Review what you enabled

Summarize the security features now active on this repository:

```bash
echo "Security features enabled:"
echo "  - SECURITY.md: tells people how to report vulnerabilities"
echo "  - Dependabot alerts: monitors dependencies for known CVEs"
echo "  - Dependabot config: checks pip packages weekly"
echo "  - Secret scanning: detects leaked credentials"
```

## Verify

Confirm the following:

```bash
# SECURITY.md exists and is tracked
git log --oneline -- SECURITY.md

# Dependabot config exists
cat .github/dependabot.yml

# Check the Security tab on GitHub for any alerts
```

- SECURITY.md is committed and pushed.
- Dependabot alerts are enabled in repository settings.
- Secret scanning is enabled in repository settings.
- `.github/dependabot.yml` is committed and pushed.

## Bonus

- **CodeQL workflow:** Create a code scanning workflow at `.github/workflows/codeql.yml` to run automated security analysis on every push. Check the **Security > Code scanning** tab for results.
- **Dependabot PRs:** Check if Dependabot created any pull requests for the outdated packages: `gh pr list --label "dependencies"`.
- **Secret scanning test:** Check the secret scanning alerts page on GitHub to see if any false positives were detected in the practice code.

## Cleanup

When you are done with this lab, delete the temporary GitHub repository:

```bash
gh repo delete git-lab-16-practice --yes
```
