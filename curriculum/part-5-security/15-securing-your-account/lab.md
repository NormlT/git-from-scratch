# Lab 15: Securing Your Account

## Goal

Audit your GitHub account security settings and ensure you have the basics locked down: 2FA, SSH keys, and clean token management.

## Prerequisites

A GitHub account and the `gh` CLI installed and authenticated.

**Note:** This lab is a security checklist -- no practice repo is needed. You will be reviewing your real GitHub account settings.

## Setup

```bash
bash setup.sh
```

This just creates a working directory for consistency. The real work happens on GitHub.

## Exercises

### 1. Check your 2FA status

Go to GitHub in your browser: **Settings > Password and authentication**. Is Two-factor authentication enabled?

If not, enable it now using an authenticator app (Authy, 1Password, Google Authenticator). Authenticator apps are more secure than SMS because SIM-swapping attacks can intercept text messages.

Save your recovery codes somewhere safe (password manager, printed and locked away).

### 2. Review your SSH keys

List the SSH keys registered on your GitHub account:

```bash
gh ssh-key list
```

Compare this to the keys on your local machine:

```bash
ls -la ~/.ssh/
```

Remove any GitHub SSH keys you don't recognize. If you see keys for old machines you no longer use, remove them from GitHub: **Settings > SSH and GPG keys**.

### 3. Review your Personal Access Tokens

Go to GitHub: **Settings > Developer settings > Personal access tokens**.

Check both "Fine-grained tokens" and "Tokens (classic)":

- Revoke any tokens you don't recognize or no longer use.
- Check expiration dates -- are any set to "No expiration"? Consider adding an expiration.
- Review scopes -- do any tokens have more access than they need?

### 4. Check active sessions

Go to GitHub: **Settings > Sessions**.

Review the list of active sessions. If you see sessions from devices or locations you don't recognize, click "See more" for details and sign out any suspicious sessions.

### 5. Review authorized OAuth apps

Go to GitHub: **Settings > Applications > Authorized OAuth Apps**.

Revoke access for any apps you no longer use. Each authorized app has some level of access to your account -- old integrations you forgot about are unnecessary risk.

### 6. Review installed GitHub Apps

Go to GitHub: **Settings > Applications > Installed GitHub Apps**.

Remove any apps you don't recognize or no longer need. Check what permissions each app has.

### 7. Check your email settings

Go to GitHub: **Settings > Emails**.

Consider enabling "Keep my email addresses private." This gives you a `@users.noreply.github.com` address for commits, preventing your real email from appearing in public repository histories.

If you enable this, update your local git config:

```bash
git config --global user.email "YOUR-USERNAME@users.noreply.github.com"
```

### 8. Final verification

Confirm your authentication is working as expected:

```bash
gh auth status
ssh -T git@github.com
```

Both commands should succeed and show your expected GitHub username.

## Verify

Confirm the following:

- 2FA is enabled (authenticator app, not SMS).
- Only recognized SSH keys exist on your account.
- No stale or overly-permissive Personal Access Tokens remain.
- No unrecognized sessions are active.
- No unused OAuth or GitHub Apps are authorized.

## Bonus

Set up commit signing with SSH keys so your commits show as "Verified" on GitHub:

```bash
# Tell git to use SSH for signing (instead of GPG)
git config --global gpg.format ssh

# Point to your SSH public key
git config --global user.signingkey ~/.ssh/id_ed25519.pub

# Enable signing for all commits
git config --global commit.gpgsign true
```

After this, every commit you make will be cryptographically signed. Push a test commit and check GitHub -- it should show a green "Verified" badge next to the commit.
