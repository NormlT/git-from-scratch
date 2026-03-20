# Module 16: Repository Security

## TL;DR

GitHub provides tools to automatically find vulnerabilities and leaked secrets in your repositories before attackers do.

## The Concept

Dependabot automatically checks your project's dependencies against a database of known vulnerabilities. When it finds one, it opens a pull request to update the affected package. Think of it as a security guard who watches the CVE databases 24/7 so you don't have to. You declare your dependencies in files like `requirements.txt` or `package.json`, and Dependabot monitors those files, comparing each package version against known vulnerabilities. When a fix is available, it creates a PR with the update -- all you have to do is review and merge.

Secret scanning detects accidentally committed passwords, API keys, and tokens. This is more common than you might think -- a developer hardcodes an AWS key during testing, forgets to remove it, and pushes to GitHub. Secret scanning catches this and flags it. For many providers (AWS, Azure, Slack, etc.), GitHub even notifies the provider so they can revoke the credential automatically. Push protection goes a step further: it blocks the push entirely if a secret is detected, preventing the leak before it hits the repository.

Code scanning (powered by CodeQL) analyzes your actual source code for security bugs like SQL injection, cross-site scripting, and buffer overflows. It runs as a GitHub Action on every push or PR and reports findings as alerts in the Security tab. It's like having a security-focused code reviewer that never gets tired.

SECURITY.md is a simple but important file that tells people how to report vulnerabilities responsibly. Without it, someone who finds a bug might open a public issue, exposing the vulnerability to everyone. With a SECURITY.md, they know to email you privately instead. These features work together as a safety net -- they don't replace good security practices, but they catch the mistakes you will inevitably make.

## Key Commands

| Command | What It Does |
|---|---|
| GitHub web: Settings > Code security and analysis | Central dashboard for enabling Dependabot, secret scanning, and code scanning. |
| `gh api repos/{owner}/{repo}/vulnerability-alerts` | Checks whether Dependabot alerts are enabled for the repository. |
| `gh secret list` | Lists repository secrets (encrypted environment variables for Actions). |
| `gh api repos/{owner}/{repo}/secret-scanning/alerts` | Lists any leaked secrets detected by secret scanning. |
| `SECURITY.md` | A file in your repo root that describes how to report security vulnerabilities. |
| `gh api repos/{owner}/{repo}/code-scanning/alerts` | Lists code scanning (CodeQL) alerts for the repository. |

## Watch

- [GitHub Security Features -- GitHub](https://www.youtube.com/watch?v=5xaGnFGDqPY) -- overview of Dependabot, secret scanning, and code scanning working together.
- [Dependabot Explained -- DevOps Toolkit](https://www.youtube.com/watch?v=BRMIFEaGg-A) -- practical walkthrough of configuring Dependabot for dependency updates.

## Read More

- [GitHub Docs -- About Dependabot alerts](https://docs.github.com/en/code-security/dependabot/dependabot-alerts/about-dependabot-alerts) -- how Dependabot detects and reports vulnerable dependencies.
- [GitHub Docs -- About secret scanning](https://docs.github.com/en/code-security/secret-scanning/about-secret-scanning) -- how GitHub detects leaked credentials in your repositories.
