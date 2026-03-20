# Module 15: Securing Your Account

## TL;DR

Your GitHub account is the gateway to all your code and your team's code -- lock it down with 2FA, SSH keys, and careful token management.

## The Concept

If someone gets into your GitHub account, they can read your private repos, push malicious code, and access anything your account can reach. Two-Factor Authentication (2FA) is the single most important thing you can do. Even if your password leaks in a data breach, attackers still need your second factor -- a code from your authenticator app or a hardware security key. Think of it like a bank vault that requires both a combination and a physical key: stealing one is useless without the other.

SSH keys are more secure than passwords for git operations because they use public-key cryptography. Your private key never leaves your machine -- GitHub only has your public key. When you push or pull, your machine proves it holds the private key without ever sending it across the network. This is fundamentally different from passwords, which get transmitted (encrypted, but still transmitted) every time you authenticate. If you are still typing your password for git push, switching to SSH keys is a significant security upgrade.

Personal Access Tokens (PATs) are like API passwords that let scripts and tools interact with GitHub on your behalf. The critical rule: scope them as narrowly as possible and set expiration dates. A token with full repo access that never expires is a ticking time bomb. Fine-grained tokens let you limit access to specific repositories and specific permissions (read-only vs. read-write). Rotate them regularly and revoke any you no longer use.

Finally, review your active sessions and authorized OAuth apps periodically. Every third-party app you authorized has some level of access to your account. If you stopped using an app six months ago, revoke its access. Think of it like changing the locks after giving someone a spare key -- once you no longer trust (or need) the access, remove it.

## Key Commands

| Command | What It Does |
|---|---|
| `gh auth status` | Shows your current authentication method, active account, and token scopes. |
| `ssh -T git@github.com` | Tests your SSH connection to GitHub and confirms which account your key is linked to. |
| `gh auth refresh` | Refreshes your GitHub CLI authentication token. |
| `gh ssh-key list` | Lists all SSH keys registered on your GitHub account. |
| GitHub web: Settings > Password and authentication > Two-factor authentication | Enable or manage 2FA on your GitHub account. |
| GitHub web: Settings > Developer settings > Personal access tokens | Create, review, and revoke Personal Access Tokens. |

## Watch

- [GitHub 2FA Setup -- GitHub](https://www.youtube.com/watch?v=hGRlE3z-gN8) -- official walkthrough of enabling two-factor authentication on your GitHub account.
- [SSH Key Authentication -- NetworkChuck](https://www.youtube.com/watch?v=vpk_1gldOAE) -- beginner-friendly explanation of how SSH keys work and how to set them up.

## Read More

- [GitHub Docs -- Securing your account with 2FA](https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa) -- official guide to enabling and managing two-factor authentication.
- [GitHub Docs -- About authentication to GitHub](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/about-authentication-to-github) -- overview of all authentication methods (SSH, PATs, OAuth, SAML).
